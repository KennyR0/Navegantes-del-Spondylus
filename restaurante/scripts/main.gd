extends Control

const SAVE_PATH := "user://la_pochita_stone_save.json"
const STARTING_COINS := 30
const BOAT_RENTAL_COST := 10
const DAILY_CASTS := 5
const PLACEHOLDER_INGREDIENTS_PER_DAY := 2
const PERFECT_WINDOW_SECONDS := 0.45
const GOOD_WINDOW_SECONDS := 0.60
const CUSTOMER_PATIENCE_SECONDS := 22.0

const WATER_TEXTURE := preload("res://assets/craftpix/3 Objects/Water.png")
const HUT_TEXTURE := preload("res://assets/craftpix/3 Objects/Fishing_hut.png")
const BOAT_TEXTURE := preload("res://assets/craftpix/3 Objects/Boat.png")
const FISH_NORMAL_TEXTURE := preload("res://assets/craftpix/3 Objects/Catch/2.png")
const FISH_PREMIUM_TEXTURE := preload("res://assets/craftpix/3 Objects/Catch/6.png")
const ROD_TEXTURE := preload("res://assets/craftpix/3 Objects/Fish-rod.png")

const RECIPES := [
	{
		"id": "ceviche_manta",
		"name": "Ceviche Manta",
		"short_name": "Ceviche",
		"cook_seconds": 4.0,
		"ingredients": [{"item": "fish", "quality": "normal", "amount": 1}]
	},
	{
		"id": "encebollado_pochita",
		"name": "Encebollado Pochita",
		"short_name": "Encebollado",
		"cook_seconds": 5.0,
		"ingredients": [
			{"item": "fish", "quality": "normal", "amount": 1},
			{"item": "placeholder_spice", "amount": 1}
		]
	},
	{
		"id": "pargo_premium",
		"name": "Pargo Premium",
		"short_name": "Pargo",
		"cook_seconds": 6.0,
		"ingredients": [{"item": "fish", "quality": "premium", "amount": 1}]
	}
]

const DISH_PRICES := {
	"ceviche_manta": 18,
	"encebollado_pochita": 24,
	"pargo_premium": 34
}

var rng := RandomNumberGenerator.new()
var save := {}
var day := {}
var restaurant := {}
var mode := "menu"
var fishing_phase := "idle"
var message := ""
var bite_started_at := 0.0
var restaurant_refresh_elapsed := 0.0
var summary_finalized := false

var background_layer: Control
var ui_layer: Control
var bite_timer: Timer
var fail_timer: Timer


func _ready() -> void:
	rng.randomize()
	_create_layers()
	_create_timers()
	save = _load_save()
	_show_menu()


func _process(delta: float) -> void:
	if mode != "restaurant":
		return

	restaurant_refresh_elapsed += delta
	var stoves_changed := _update_stoves()
	var customers_changed := _close_late_customers()
	var changed := stoves_changed or customers_changed
	if changed or restaurant_refresh_elapsed >= 0.25:
		restaurant_refresh_elapsed = 0.0
		_show_restaurant()


func _create_layers() -> void:
	background_layer = Control.new()
	background_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background_layer)

	ui_layer = Control.new()
	ui_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(ui_layer)


func _create_timers() -> void:
	bite_timer = Timer.new()
	bite_timer.one_shot = true
	bite_timer.timeout.connect(_start_bite)
	add_child(bite_timer)

	fail_timer = Timer.new()
	fail_timer.one_shot = true
	fail_timer.timeout.connect(func(): _finish_catch("fail"))
	add_child(fail_timer)


func _clear_layer(layer: Node) -> void:
	for child in layer.get_children():
		layer.remove_child(child)
		child.queue_free()


func _reset_screen() -> void:
	_clear_layer(background_layer)
	_clear_layer(ui_layer)


func _create_default_save() -> Dictionary:
	return {
		"coins": STARTING_COINS,
		"stars": 0,
		"upgrade_level": 0,
		"unlocked_recipes": ["ceviche_manta", "encebollado_pochita", "pargo_premium"],
		"best_day": null
	}


func _load_save() -> Dictionary:
	var base := _create_default_save()
	if not FileAccess.file_exists(SAVE_PATH):
		return base

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return base

	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return base

	for key in parsed.keys():
		base[key] = parsed[key]
	return base


func _persist_save() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save))


func _create_empty_summary() -> Dictionary:
	return {
		"revenue": 0,
		"served": 0,
		"happy": 0,
		"neutral": 0,
		"unhappy": 0,
		"perfect_catches": 0,
		"good_catches": 0,
		"failed_catches": 0,
		"stars_earned": 0
	}


func _create_new_day() -> Dictionary:
	return {
		"inventory": {
			"normal_fish": 0,
			"premium_fish": 0,
			"placeholder_spice": PLACEHOLDER_INGREDIENTS_PER_DAY
		},
		"boat_rented": false,
		"casts_left": DAILY_CASTS,
		"summary": _create_empty_summary()
	}


func _start_fresh_run() -> void:
	save = _create_default_save()
	day = _create_new_day()
	fishing_phase = "idle"
	message = "Renta un bote para salir antes de que suba la marea."
	summary_finalized = false
	_persist_save()
	_show_fishing()


func _start_next_day() -> void:
	day = _create_new_day()
	fishing_phase = "idle"
	message = "Renta un bote para salir antes de que suba la marea."
	summary_finalized = false
	_show_fishing()


func _show_menu() -> void:
	mode = "menu"
	_reset_screen()
	_draw_menu_background()

	var panel := _bottom_panel()
	var title := _label("La Pochita Stone", 34, Color("#f6c177"), true)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel.add_child(title)

	var copy := _label("Un restaurante heredado en el puerto de Manta. Pesca al amanecer, cocina con lo que consigas y demuestra que el nuevo también puede levantar el puesto.", 18, Color("#e9f7ef"))
	copy.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(copy)

	var controls := _button_row()
	controls.add_child(_button("Nuevo día", Callable(self, "_start_fresh_run")))
	controls.add_child(_button("Continuar", Callable(self, "_start_next_day"), not FileAccess.file_exists(SAVE_PATH), "secondary"))
	panel.add_child(controls)


func _show_fishing() -> void:
	mode = "fishing"
	if message == "":
		message = "Renta un bote para salir antes de que suba la marea."
	_reset_screen()
	_draw_fishing_background()
	_add_top_bar([
		"Monedas %s" % save["coins"],
		"Normal %s · Premium %s" % [day["inventory"]["normal_fish"], day["inventory"]["premium_fish"]],
		"Lances %s/%s" % [day["casts_left"], DAILY_CASTS]
	])
	_add_toast(message)

	var controls := _bottom_controls()
	controls.add_child(_button("Rentar barco (%s)" % BOAT_RENTAL_COST, Callable(self, "_rent_boat"), day["boat_rented"]))
	controls.add_child(_button("Lanzar caña", Callable(self, "_cast_line"), not day["boat_rented"] or fishing_phase != "idle" or day["casts_left"] <= 0, "secondary"))
	controls.add_child(_button("¡Jalar!", Callable(self, "_hook_fish"), fishing_phase != "bite", "danger"))
	controls.add_child(_button("Ir al restaurante", Callable(self, "_open_restaurant"), day["casts_left"] == DAILY_CASTS or fishing_phase != "idle"))


func _rent_boat() -> void:
	if day["boat_rented"]:
		return
	if save["coins"] < BOAT_RENTAL_COST:
		message = "No alcanza para rentar bote. El puerto no fía."
		_show_fishing()
		return

	save["coins"] -= BOAT_RENTAL_COST
	day["boat_rented"] = true
	_persist_save()
	message = "Bote rentado. Busca el ritmo de respiración del señuelo."
	_show_fishing()


func _cast_line() -> void:
	if not day["boat_rented"] or day["casts_left"] <= 0 or fishing_phase != "idle":
		return

	fishing_phase = "waiting"
	message = "El señuelo respira... espera que se hunda."
	bite_timer.wait_time = rng.randf_range(0.85, 1.65)
	bite_timer.start()
	_show_fishing()


func _start_bite() -> void:
	if fishing_phase != "waiting":
		return

	fishing_phase = "bite"
	bite_started_at = Time.get_ticks_msec() / 1000.0
	message = "¡Se hundió! Tienes menos de 0.45s para pesca perfecta."
	fail_timer.wait_time = 0.65
	fail_timer.start()
	_show_fishing()


func _hook_fish() -> void:
	if fishing_phase == "idle":
		return

	if fishing_phase != "bite":
		_finish_catch("early")
		return

	var elapsed := (Time.get_ticks_msec() / 1000.0) - bite_started_at
	if elapsed <= PERFECT_WINDOW_SECONDS:
		_finish_catch("perfect")
	elif elapsed <= GOOD_WINDOW_SECONDS:
		_finish_catch("good")
	else:
		_finish_catch("fail")


func _finish_catch(result: String) -> void:
	if fishing_phase == "idle":
		return

	bite_timer.stop()
	fail_timer.stop()
	fishing_phase = "idle"
	day["casts_left"] = max(0, day["casts_left"] - 1)

	if result == "perfect":
		day["inventory"]["premium_fish"] += 1
		day["summary"]["perfect_catches"] += 1
	elif result == "good":
		day["inventory"]["normal_fish"] += 1
		day["summary"]["good_catches"] += 1
	else:
		day["summary"]["failed_catches"] += 1

	message = _catch_result_label(result)
	if day["casts_left"] <= 0:
		message += " Último lance del día."
	_show_fishing()


func _catch_result_label(result: String) -> String:
	match result:
		"perfect":
			return "Pesca perfecta: pescado premium."
		"good":
			return "Buena pesca: pescado normal."
		"early":
			return "Te adelantaste y espantaste la pesca."
		_:
			return "La pesca se escapó."


func _open_restaurant() -> void:
	restaurant = _create_restaurant_state()
	message = "Abre las hornillas y sirve antes de que se cansen."
	_show_restaurant()


func _create_restaurant_state() -> Dictionary:
	var orders: Array = _pick_order_recipes()
	var stoves: Array = []
	for index in range(4):
		stoves.append({
			"id": index,
			"recipe_id": "",
			"started_at": 0.0,
			"ready_at": 0.0,
			"ready": false
		})

	var customers: Array = []
	var now: float = Time.get_ticks_msec() / 1000.0
	for index in range(4):
		var recipe: Dictionary = orders[index % orders.size()] as Dictionary
		customers.append({
			"id": index + 1,
			"order_recipe_id": recipe["id"],
			"arrived_at": now + index * 1.2,
			"patience_seconds": CUSTOMER_PATIENCE_SECONDS + index * 2.5,
			"satisfaction": "",
			"served": false
		})

	return {"stoves": stoves, "customers": customers}


func _show_restaurant() -> void:
	mode = "restaurant"
	_reset_screen()
	_draw_restaurant_background()
	_add_top_bar([
		"Monedas %s" % save["coins"],
		"Normal %s · Premium %s · Aliño %s" % [day["inventory"]["normal_fish"], day["inventory"]["premium_fish"], day["inventory"]["placeholder_spice"]],
		"Atendidos %s/4" % day["summary"]["served"]
	])
	_add_toast(message)
	_draw_restaurant_status()

	var panel := _bottom_panel(500)
	panel.add_child(_label("Cocina del puesto", 22, Color("#f6c177"), true))
	panel.add_child(_small_stat("Hornillas", _stove_summary()))
	panel.add_child(_small_stat("Pedidos", _customer_summary()))

	var cook_row := _button_row()
	for recipe_item in RECIPES:
		var recipe_data: Dictionary = recipe_item as Dictionary
		if save["unlocked_recipes"].has(recipe_data["id"]):
			cook_row.add_child(_button(recipe_data["short_name"], Callable(self, "_start_cooking").bind(recipe_data["id"]), not _can_cook(recipe_data)))
	panel.add_child(cook_row)

	var deliver_row := _button_row()
	var has_pending := false
	for customer_item in restaurant["customers"]:
		var customer_data: Dictionary = customer_item as Dictionary
		if not customer_data["served"]:
			has_pending = true
			deliver_row.add_child(_button("Cliente %s" % customer_data["id"], Callable(self, "_deliver_to_customer").bind(customer_data["id"]), false, "secondary"))
	if not has_pending:
		deliver_row.add_child(_button("Clientes atendidos", Callable(self, "_show_summary"), true, "secondary"))
	panel.add_child(deliver_row)

	var close_row := _button_row()
	close_row.add_child(_button("Cerrar día", Callable(self, "_show_summary"), false, "danger"))
	panel.add_child(close_row)


func _start_cooking(recipe_id: String) -> void:
	var recipe: Dictionary = _get_recipe(recipe_id)
	var stove: Dictionary = _first_free_stove()
	if stove.is_empty():
		message = "Las 4 hornillas están ocupadas."
		_show_restaurant()
		return
	if not _consume_recipe(recipe):
		message = "Faltan ingredientes para ese plato."
		_show_restaurant()
		return

	var now: float = Time.get_ticks_msec() / 1000.0
	stove["recipe_id"] = recipe["id"]
	stove["started_at"] = now
	stove["ready_at"] = now + recipe["cook_seconds"]
	stove["ready"] = false
	message = "%s en la hornilla %s." % [recipe["short_name"], stove["id"] + 1]
	_show_restaurant()


func _deliver_to_customer(customer_id: int) -> void:
	var customer: Dictionary = _find_customer(customer_id)
	if customer.is_empty() or customer["served"]:
		message = "Ese cliente ya fue atendido."
		_show_restaurant()
		return

	var stove: Dictionary = _find_ready_stove(customer["order_recipe_id"])
	if stove.is_empty():
		stove = _find_any_ready_stove()
	if stove.is_empty():
		message = "Todavía no hay platos listos."
		_show_restaurant()
		return

	var correct_dish: bool = stove["recipe_id"] == customer["order_recipe_id"]
	var satisfaction: String = _score_satisfaction(customer, correct_dish)
	var recipe: Dictionary = _get_recipe(stove["recipe_id"])
	var full_price: int = int(DISH_PRICES[recipe["id"]])
	var price: int = full_price if correct_dish else floori(full_price * 0.25)
	var final_price: int = floori(price * 0.5) if satisfaction == "unhappy" else price

	customer["served"] = true
	customer["satisfaction"] = satisfaction
	_clear_stove(stove)

	day["summary"]["served"] += 1
	day["summary"][satisfaction] += 1
	day["summary"]["revenue"] += final_price
	save["coins"] += final_price
	_persist_save()

	message = "%s entregado: +%s monedas." % [recipe["short_name"], final_price] if correct_dish else "Plato equivocado: el cliente dejó %s monedas." % final_price
	_show_restaurant()


func _update_stoves() -> bool:
	var now: float = Time.get_ticks_msec() / 1000.0
	var changed := false
	for stove_item in restaurant.get("stoves", []):
		var stove: Dictionary = stove_item as Dictionary
		if stove["recipe_id"] != "" and not stove["ready"] and now >= stove["ready_at"]:
			stove["ready"] = true
			changed = true
	return changed


func _close_late_customers() -> bool:
	var now: float = Time.get_ticks_msec() / 1000.0
	var changed := false
	for customer_item in restaurant.get("customers", []):
		var customer: Dictionary = customer_item as Dictionary
		if not customer["served"] and now - customer["arrived_at"] > customer["patience_seconds"]:
			customer["served"] = true
			customer["satisfaction"] = "unhappy"
			day["summary"]["served"] += 1
			day["summary"]["unhappy"] += 1
			changed = true
	return changed


func _show_summary() -> void:
	mode = "summary"
	_finalize_day()
	_reset_screen()
	_draw_summary_background()
	_add_top_bar([
		"Monedas %s" % save["coins"],
		"Estrellas %s" % save["stars"],
		"Mejora %s" % save["upgrade_level"]
	])
	_add_toast(message)

	var panel := _bottom_panel()
	panel.add_child(_label("Resumen del día", 24, Color("#f6c177"), true))
	panel.add_child(_small_stat("Ventas", "%s monedas" % day["summary"]["revenue"]))
	panel.add_child(_small_stat("Clientes", "%s atendidos" % day["summary"]["served"]))
	panel.add_child(_small_stat("Caritas", "%s felices · %s neutras · %s molestas" % [day["summary"]["happy"], day["summary"]["neutral"], day["summary"]["unhappy"]]))
	panel.add_child(_small_stat("Pesca", "%s perfectas · %s buenas · %s fallidas" % [day["summary"]["perfect_catches"], day["summary"]["good_catches"], day["summary"]["failed_catches"]]))

	var controls := _button_row()
	var upgrade_cost := _get_upgrade_cost()
	controls.add_child(_button("Mejorar puesto (%s)" % upgrade_cost, Callable(self, "_upgrade_restaurant"), save["coins"] < upgrade_cost))
	controls.add_child(_button("Siguiente día", Callable(self, "_start_next_day"), false, "secondary"))
	panel.add_child(controls)


func _finalize_day() -> void:
	if summary_finalized:
		return

	var summary: Dictionary = day["summary"] as Dictionary
	var earned_stars: int = 1 if summary["happy"] >= 3 or summary["revenue"] >= 70 else 0
	summary["stars_earned"] = earned_stars
	save["stars"] = min(5, save["stars"] + earned_stars)
	if save["best_day"] == null or summary["revenue"] > save["best_day"]["revenue"]:
		save["best_day"] = summary.duplicate(true)
	_persist_save()
	summary_finalized = true
	message = "El puerto empieza a hablar bien de tu sazón." if earned_stars > 0 else "El puesto sobrevivió, pero falta ganarse a Manta."


func _upgrade_restaurant() -> void:
	var cost := _get_upgrade_cost()
	if save["coins"] < cost:
		message = "Todavía no alcanza para mejorar el puesto."
		_show_summary()
		return

	save["coins"] -= cost
	save["upgrade_level"] += 1
	save["stars"] = min(5, max(save["stars"], save["upgrade_level"]))
	_persist_save()
	message = "Nueva mesa, pintura fresca y más respeto en el puerto."
	_show_summary()


func _get_upgrade_cost() -> int:
	return 50 + int(save["upgrade_level"]) * 25


func _get_recipe(recipe_id: String) -> Dictionary:
	for recipe_item in RECIPES:
		var recipe: Dictionary = recipe_item as Dictionary
		if recipe["id"] == recipe_id:
			return recipe
	return RECIPES[0] as Dictionary


func _can_cook(recipe: Dictionary) -> bool:
	for ingredient_item in recipe["ingredients"]:
		var ingredient: Dictionary = ingredient_item as Dictionary
		if ingredient["item"] == "placeholder_spice":
			if day["inventory"]["placeholder_spice"] < ingredient["amount"]:
				return false
		elif ingredient.get("quality", "normal") == "premium":
			if day["inventory"]["premium_fish"] < ingredient["amount"]:
				return false
		elif day["inventory"]["normal_fish"] < ingredient["amount"]:
			return false
	return true


func _consume_recipe(recipe: Dictionary) -> bool:
	if not _can_cook(recipe):
		return false

	for ingredient_item in recipe["ingredients"]:
		var ingredient: Dictionary = ingredient_item as Dictionary
		if ingredient["item"] == "placeholder_spice":
			day["inventory"]["placeholder_spice"] -= ingredient["amount"]
		elif ingredient.get("quality", "normal") == "premium":
			day["inventory"]["premium_fish"] -= ingredient["amount"]
		else:
			day["inventory"]["normal_fish"] -= ingredient["amount"]
	return true


func _pick_order_recipes() -> Array:
	var cookable: Array = []
	for recipe_item in RECIPES:
		var recipe_data: Dictionary = recipe_item as Dictionary
		if save["unlocked_recipes"].has(recipe_data["id"]) and _can_cook(recipe_data):
			cookable.append(recipe_data)
	if cookable.size() > 0:
		return cookable

	var unlocked: Array = []
	for recipe_item in RECIPES:
		var unlocked_recipe: Dictionary = recipe_item as Dictionary
		if save["unlocked_recipes"].has(unlocked_recipe["id"]):
			unlocked.append(unlocked_recipe)
	return unlocked


func _first_free_stove() -> Dictionary:
	for stove_item in restaurant["stoves"]:
		var stove: Dictionary = stove_item as Dictionary
		if stove["recipe_id"] == "":
			return stove
	return {}


func _find_ready_stove(recipe_id: String) -> Dictionary:
	for stove_item in restaurant["stoves"]:
		var stove: Dictionary = stove_item as Dictionary
		if stove["ready"] and stove["recipe_id"] == recipe_id:
			return stove
	return {}


func _find_any_ready_stove() -> Dictionary:
	for stove_item in restaurant["stoves"]:
		var stove: Dictionary = stove_item as Dictionary
		if stove["ready"]:
			return stove
	return {}


func _find_customer(customer_id: int) -> Dictionary:
	for customer_item in restaurant["customers"]:
		var customer: Dictionary = customer_item as Dictionary
		if customer["id"] == customer_id:
			return customer
	return {}


func _clear_stove(stove: Dictionary) -> void:
	stove["recipe_id"] = ""
	stove["started_at"] = 0.0
	stove["ready_at"] = 0.0
	stove["ready"] = false


func _score_satisfaction(customer: Dictionary, correct_dish: bool) -> String:
	if not correct_dish:
		return "unhappy"

	var now: float = Time.get_ticks_msec() / 1000.0
	var waited_ratio: float = (now - customer["arrived_at"]) / customer["patience_seconds"]
	if waited_ratio <= 0.5:
		return "happy"
	if waited_ratio <= 0.9:
		return "neutral"
	return "unhappy"


func _stove_summary() -> String:
	var parts: Array = []
	var now: float = Time.get_ticks_msec() / 1000.0
	for stove_item in restaurant["stoves"]:
		var stove: Dictionary = stove_item as Dictionary
		if stove["recipe_id"] == "":
			parts.append("%s: libre" % (stove["id"] + 1))
		else:
			var recipe: Dictionary = _get_recipe(stove["recipe_id"])
			var state: String = " listo" if stove["ready"] else " %ss" % max(0, ceili(stove["ready_at"] - now))
			parts.append("%s: %s%s" % [stove["id"] + 1, recipe["short_name"], state])
	return " · ".join(parts)


func _customer_summary() -> String:
	var parts: Array = []
	for customer_item in restaurant["customers"]:
		var customer: Dictionary = customer_item as Dictionary
		var recipe: Dictionary = _get_recipe(customer["order_recipe_id"])
		var face := ""
		match customer["satisfaction"]:
			"happy":
				face = " :)"
			"neutral":
				face = " :|"
			"unhappy":
				face = " :("
		parts.append("%s: %s%s" % [customer["id"], recipe["short_name"], face])
	return " · ".join(parts)


func _draw_menu_background() -> void:
	_add_color_bg(Color("#0f4c5c"))
	_add_texture(WATER_TEXTURE, Vector2(0.5, 0.78), Vector2(3.5, 1.1), 0.45)
	_add_texture(HUT_TEXTURE, Vector2(0.5, 0.62), Vector2(4.0, 4.0), 0.95)


func _draw_fishing_background() -> void:
	_add_color_bg(Color("#83c5be"))
	_add_texture(WATER_TEXTURE, Vector2(0.5, 0.45), Vector2(4.0, 3.2), 0.28)
	_add_scene_band(Color("#66aeb8"), 0.34, 0.48)
	_add_scene_band(Color("#6bb7b0"), 0.48, 0.62)
	_add_bottom_band(Color("#6a4a2f"), 170)
	_add_scene_band(Color("#8b5a33"), 0.82, 0.87)
	_add_texture(BOAT_TEXTURE, Vector2(0.5, 0.64), Vector2(2.0, 2.0), 1.0)
	_add_texture(ROD_TEXTURE, Vector2(0.55, 0.58), Vector2(1.15, 1.15), 0.95, 28.0)
	var fish_texture: Texture2D = FISH_PREMIUM_TEXTURE if fishing_phase == "bite" else FISH_NORMAL_TEXTURE
	_add_texture(fish_texture, Vector2(0.64, 0.46), Vector2(0.9, 0.9), 0.92 if fishing_phase == "bite" else 0.25)


func _draw_restaurant_background() -> void:
	_add_color_bg(Color("#21413f"))
	_add_bottom_band(Color("#9b5f37"), 190)
	var sign := _center_text("La Pochita Stone", 32, Color("#f6c177"), Vector2(0.5, 0.14))
	background_layer.add_child(sign)


func _draw_summary_background() -> void:
	_add_color_bg(Color("#08303b"))
	_add_texture(HUT_TEXTURE, Vector2(0.5, 0.55), Vector2(4.0, 4.0), 0.8)
	var title := _center_text("Cierre de La Pochita", 32, Color("#f6c177"), Vector2(0.5, 0.14))
	background_layer.add_child(title)


func _draw_restaurant_status() -> void:
	var overlay := HBoxContainer.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.alignment = BoxContainer.ALIGNMENT_CENTER
	overlay.add_theme_constant_override("separation", 28)
	background_layer.add_child(overlay)

	for customer_item in restaurant.get("customers", []):
		var customer: Dictionary = customer_item as Dictionary
		var card := _status_card()
		var recipe: Dictionary = _get_recipe(customer["order_recipe_id"])
		var face: String = "?" if not customer["served"] else _face_for(customer["satisfaction"])
		card.add_child(_label(face, 22, Color("#1d1b1b"), true))
		card.add_child(_label(recipe["short_name"], 13, Color("#08303b"), true))
		overlay.add_child(card)


func _face_for(satisfaction: String) -> String:
	match satisfaction:
		"happy":
			return ":)"
		"neutral":
			return ":|"
		"unhappy":
			return ":("
		_:
			return "?"


func _add_color_bg(color: Color) -> void:
	var rect := ColorRect.new()
	rect.color = color
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	background_layer.add_child(rect)


func _add_bottom_band(color: Color, height: float) -> void:
	var band := ColorRect.new()
	band.color = color
	band.anchor_left = 0.0
	band.anchor_right = 1.0
	band.anchor_top = 1.0
	band.anchor_bottom = 1.0
	band.offset_top = -height
	background_layer.add_child(band)


func _add_scene_band(color: Color, top_ratio: float, bottom_ratio: float) -> void:
	var band := ColorRect.new()
	band.color = color
	band.anchor_left = 0.0
	band.anchor_right = 1.0
	band.anchor_top = top_ratio
	band.anchor_bottom = bottom_ratio
	background_layer.add_child(band)


func _add_texture(texture: Texture2D, anchor: Vector2, scale: Vector2, alpha: float, rotation_degrees_value := 0.0) -> void:
	var rect := TextureRect.new()
	rect.texture = texture
	rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	rect.modulate.a = alpha
	rect.pivot_offset = Vector2(64, 64)
	rect.rotation_degrees = rotation_degrees_value
	rect.anchor_left = anchor.x
	rect.anchor_right = anchor.x
	rect.anchor_top = anchor.y
	rect.anchor_bottom = anchor.y
	rect.custom_minimum_size = Vector2(160, 120) * scale
	rect.offset_left = -rect.custom_minimum_size.x / 2.0
	rect.offset_right = rect.custom_minimum_size.x / 2.0
	rect.offset_top = -rect.custom_minimum_size.y / 2.0
	rect.offset_bottom = rect.custom_minimum_size.y / 2.0
	background_layer.add_child(rect)


func _center_text(text: String, size: int, color: Color, anchor: Vector2) -> Label:
	var label := _label(text, size, color, true)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.anchor_left = anchor.x
	label.anchor_right = anchor.x
	label.anchor_top = anchor.y
	label.anchor_bottom = anchor.y
	label.offset_left = -320
	label.offset_right = 320
	label.offset_top = -40
	label.offset_bottom = 40
	return label


func _add_top_bar(items: Array) -> void:
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_top", 14)
	ui_layer.add_child(margin)

	var column := VBoxContainer.new()
	column.alignment = BoxContainer.ALIGNMENT_BEGIN
	column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	column.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	column.custom_minimum_size = Vector2(maxf(280.0, get_viewport_rect().size.x - 32.0), 0)
	column.add_theme_constant_override("separation", 8)
	margin.add_child(column)

	for item in items:
		var chip := _chip(str(item))
		chip.custom_minimum_size = Vector2(0, 40)
		chip.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		column.add_child(chip)


func _add_toast(text: String) -> void:
	if text == "":
		return

	var container := CenterContainer.new()
	container.anchor_left = 0.0
	container.anchor_right = 1.0
	container.anchor_top = 0.22
	container.anchor_bottom = 0.22
	container.offset_left = 16
	container.offset_right = -16
	ui_layer.add_child(container)

	var toast := _text_panel(text, 15, Color("#e9f7ef"), true)
	toast.custom_minimum_size = Vector2(maxf(280.0, get_viewport_rect().size.x - 32.0), 58)
	container.add_child(toast)


func _bottom_panel(width := 460) -> VBoxContainer:
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_bottom", 14)
	ui_layer.add_child(margin)

	var outer := VBoxContainer.new()
	outer.alignment = BoxContainer.ALIGNMENT_END
	outer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	outer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(outer)

	var center := CenterContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	outer.add_child(center)

	var viewport_width: float = get_viewport_rect().size.x
	var panel_width: float = minf(float(width), maxf(280.0, viewport_width - 28.0))

	var panel := VBoxContainer.new()
	panel.custom_minimum_size = Vector2(panel_width, 0)
	panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	panel.add_theme_constant_override("separation", 10)
	panel.add_theme_stylebox_override("panel", _panel_style())

	var panel_container := PanelContainer.new()
	panel_container.add_theme_stylebox_override("panel", _panel_style())
	panel_container.add_child(panel)
	center.add_child(panel_container)
	return panel


func _bottom_controls() -> GridContainer:
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 14)
	ui_layer.add_child(margin)

	var outer := VBoxContainer.new()
	outer.alignment = BoxContainer.ALIGNMENT_END
	outer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	outer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(outer)

	var grid := GridContainer.new()
	grid.columns = 2
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 8)
	outer.add_child(grid)
	return grid


func _button_row() -> GridContainer:
	var row := GridContainer.new()
	row.columns = 2
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("h_separation", 8)
	row.add_theme_constant_override("v_separation", 8)
	return row


func _button(text: String, action: Callable, disabled := false, variant := "primary") -> Button:
	var button := Button.new()
	button.text = text
	button.disabled = disabled
	button.custom_minimum_size = Vector2(0, 56)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_stylebox_override("normal", _button_style(variant, disabled))
	button.add_theme_stylebox_override("hover", _button_style(variant, disabled, 1.08))
	button.add_theme_stylebox_override("pressed", _button_style(variant, disabled, 0.92))
	button.add_theme_color_override("font_color", Color("#1d1b1b") if variant == "primary" else Color("#e9f7ef"))
	button.add_theme_font_size_override("font_size", 16)
	button.clip_text = true
	button.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	button.pressed.connect(action)
	return button


func _chip(text: String) -> PanelContainer:
	var chip := PanelContainer.new()
	chip.add_theme_stylebox_override("panel", _chip_style())
	var label := _label(text, 15, Color("#e9f7ef"), true)
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.clip_text = true
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	chip.add_child(label)
	return chip


func _status_card() -> VBoxContainer:
	var card := VBoxContainer.new()
	card.custom_minimum_size = Vector2(118, 82)
	card.alignment = BoxContainer.ALIGNMENT_CENTER
	card.add_theme_constant_override("separation", 4)
	card.add_theme_stylebox_override("panel", _light_panel_style())
	return card


func _small_stat(label_text: String, value_text: String) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	var label := _label(label_text, 15, Color("#f6c177"), true)
	label.custom_minimum_size = Vector2(92, 0)
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.clip_text = true
	var value := _label(value_text, 15, Color("#e9f7ef"))
	value.autowrap_mode = TextServer.AUTOWRAP_OFF
	value.clip_text = true
	value.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	value.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(label)
	row.add_child(value)
	return row


func _text_panel(text: String, size: int, color: Color, bold := false) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", _chip_style())

	var label := _label(text, size, color, bold)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_child(label)
	return panel


func _label(text: String, size: int, color: Color, bold := false) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	if bold:
		label.add_theme_color_override("font_shadow_color", Color("#1d1b1b"))
		label.add_theme_constant_override("shadow_offset_x", 1)
		label.add_theme_constant_override("shadow_offset_y", 1)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label


func _panel_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.04, 0.14, 0.17, 0.92)
	style.border_color = Color(0.92, 0.97, 0.94, 0.28)
	style.set_border_width_all(1)
	style.set_corner_radius_all(8)
	_set_style_margins(style, 14)
	return style


func _chip_style() -> StyleBoxFlat:
	var style := _panel_style()
	style.bg_color = Color(0.03, 0.12, 0.15, 0.82)
	_set_style_margins(style, 9)
	return style


func _light_panel_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#e9f7ef")
	style.border_color = Color("#08303b")
	style.set_border_width_all(3)
	style.set_corner_radius_all(8)
	_set_style_margins(style, 8)
	return style


func _button_style(variant: String, disabled: bool, multiplier := 1.0) -> StyleBoxFlat:
	var color := Color("#f6c177")
	if variant == "secondary":
		color = Color("#227c8d")
	elif variant == "danger":
		color = Color("#d84a3a")
	if disabled:
		color = color.darkened(0.45)
	elif multiplier > 1.0:
		color = color.lightened(multiplier - 1.0)
	elif multiplier < 1.0:
		color = color.darkened(1.0 - multiplier)

	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.set_corner_radius_all(8)
	_set_style_margins(style, 10)
	return style


func _set_style_margins(style: StyleBox, margin: float) -> void:
	style.set_content_margin(SIDE_LEFT, margin)
	style.set_content_margin(SIDE_TOP, margin)
	style.set_content_margin(SIDE_RIGHT, margin)
	style.set_content_margin(SIDE_BOTTOM, margin)
