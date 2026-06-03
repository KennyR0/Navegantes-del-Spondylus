extends Control

const SAVE_PATH := "user://la_pochita_stone_save.json"
const STARTING_COINS := 30
const BOAT_RENTAL_COST := 10
const DAILY_CASTS := 5
const PLACEHOLDER_INGREDIENTS_PER_DAY := 2
const PERFECT_WINDOW_SECONDS := 0.45
const GOOD_WINDOW_SECONDS := 0.60
const LURE_BREATH_SECONDS := 0.58
const FISHING_REDRAW_SECONDS := 0.08
const CUSTOMER_PATIENCE_SECONDS := 22.0
const WATER_SURFACE_TOP := 0.615
const BOAT_ANCHOR := Vector2(0.46, 0.72)
const FISHERMAN_ANCHOR := Vector2(0.458, 0.665)
const ROD_BUTT_ANCHOR := Vector2(0.472, 0.705)
const ROD_TIP_IDLE := Vector2(0.515, 0.686)
const ROD_TIP_CAST := Vector2(0.565, 0.662)
const LURE_SURFACE_ANCHOR := Vector2(0.60, 0.665)
const FISH_ANCHOR := Vector2(0.66, 0.66)

const WATER_TEXTURE := preload("res://assets/craftpix/3 Objects/Water.png")
const HUT_TEXTURE := preload("res://assets/craftpix/3 Objects/Fishing_hut.png")
const BOAT_TEXTURE := preload("res://assets/craftpix/3 Objects/Boat.png")
const FISHING_SEASCAPE_TEXTURE := preload("res://assets/pixelart/fishing_seascape_pixel.png")
const FISH_NORMAL_TEXTURE := preload("res://assets/pixelart/fish_normal_pixel.png")
const FISH_PREMIUM_TEXTURE := preload("res://assets/pixelart/fish_premium_pixel.png")
const LURE_TEXTURE := preload("res://assets/pixelart/lure_bobber.png")
const LURE_SINK_TEXTURE := preload("res://assets/pixelart/lure_sink.png")
const BITE_SPLASH_TEXTURE := preload("res://assets/pixelart/bite_splash.png")
const FISHERMAN_IDLE_TEXTURE := preload("res://assets/craftpix/1 Fisherman/Fisherman_idle.png")
const FISHERMAN_HOOK_TEXTURE := preload("res://assets/craftpix/1 Fisherman/Fisherman_hook.png")
const FISHERMAN_FRAME_SIZE := Vector2(48, 48)

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
var lure_motion_started_at := 0.0
var lure_breaths_remaining := 0
var lure_breaths_total := 0
var fishing_redraw_elapsed := 0.0
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
	if mode == "fishing":
		fishing_redraw_elapsed += delta
		if fishing_redraw_elapsed >= FISHING_REDRAW_SECONDS:
			fishing_redraw_elapsed = 0.0
			if fishing_phase == "idle":
				_clear_layer(background_layer)
				_draw_fishing_background()
			else:
				_show_fishing()
		return

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
	bite_timer.timeout.connect(_advance_lure_sequence)
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
	_add_fishing_meter()

	var controls := _bottom_controls()
	controls.add_child(_button("Rentar barco (%s)" % BOAT_RENTAL_COST, Callable(self, "_rent_boat"), day["boat_rented"]))
	controls.add_child(_button("Lanzar caña", Callable(self, "_cast_line"), not day["boat_rented"] or fishing_phase != "idle" or day["casts_left"] <= 0, "secondary"))
	controls.add_child(_button("¡Jalar!", Callable(self, "_hook_fish"), fishing_phase == "idle", "danger", true))
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
	lure_breaths_total = rng.randi_range(2, 4)
	lure_breaths_remaining = lure_breaths_total
	lure_motion_started_at = _now_seconds()
	fishing_redraw_elapsed = 0.0
	message = "El señuelo respira... espera que se hunda."
	bite_timer.wait_time = rng.randf_range(1.15, 1.85)
	bite_timer.start()
	_show_fishing()


func _advance_lure_sequence() -> void:
	if fishing_phase != "waiting":
		if fishing_phase == "breath":
			_return_lure_to_surface()
		return

	if lure_breaths_remaining > 0:
		_start_lure_breath()
		return

	_start_bite()


func _start_lure_breath() -> void:
	fishing_phase = "breath"
	lure_motion_started_at = _now_seconds()
	message = "Respiración falsa... no jales todavía."
	bite_timer.wait_time = LURE_BREATH_SECONDS
	bite_timer.start()
	_show_fishing()


func _return_lure_to_surface() -> void:
	lure_breaths_remaining = max(0, lure_breaths_remaining - 1)
	fishing_phase = "waiting"
	lure_motion_started_at = _now_seconds()
	message = "El señuelo vuelve a flotar. Mantén el pulso."
	bite_timer.wait_time = rng.randf_range(0.85, 1.45)
	bite_timer.start()
	_show_fishing()


func _start_bite() -> void:
	if fishing_phase != "waiting":
		return

	fishing_phase = "bite"
	bite_started_at = _now_seconds()
	lure_motion_started_at = bite_started_at
	message = "¡Se hundió! Jala antes de 0.45s para pesca perfecta."
	fail_timer.wait_time = GOOD_WINDOW_SECONDS
	fail_timer.start()
	_show_fishing()


func _hook_fish() -> void:
	if fishing_phase == "idle":
		return

	if fishing_phase != "bite":
		_finish_catch("early")
		return

	var elapsed := _now_seconds() - bite_started_at
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
	lure_breaths_remaining = 0
	lure_breaths_total = 0
	fishing_redraw_elapsed = 0.0
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
			return "Pesca fallida: jalaste antes de que se hundiera el señuelo."
		_:
			return "La pesca se escapó."


func _now_seconds() -> float:
	return Time.get_ticks_msec() / 1000.0


func _bite_elapsed() -> float:
	if fishing_phase != "bite":
		return 0.0
	return maxf(0.0, _now_seconds() - bite_started_at)


func _lure_motion_ratio() -> float:
	if fishing_phase != "breath":
		return 0.0
	return clampf((_now_seconds() - lure_motion_started_at) / LURE_BREATH_SECONDS, 0.0, 1.0)


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
	_add_full_texture(FISHING_SEASCAPE_TEXTURE)
	_draw_animated_water()
	_add_scene_band(Color(0.14, 0.11, 0.16, 0.42), 0.84, 1.0)
	_add_texture(BOAT_TEXTURE, BOAT_ANCHOR, Vector2(2.0, 2.0), 1.0)
	_draw_fisherman()
	var fish_texture: Texture2D = FISH_PREMIUM_TEXTURE if fishing_phase == "bite" else FISH_NORMAL_TEXTURE
	var fish_alpha := 0.9 if fishing_phase == "bite" else 0.34
	var fish_bob := sin(_now_seconds() * 3.4) * 0.006
	_add_texture(fish_texture, FISH_ANCHOR + Vector2(0.0, fish_bob), Vector2(0.78, 0.78), fish_alpha)
	_draw_fishing_lure()


func _draw_fisherman() -> void:
	var texture := FISHERMAN_IDLE_TEXTURE
	var frame := 1
	if fishing_phase == "bite":
		texture = FISHERMAN_HOOK_TEXTURE
		frame = 3
	elif fishing_phase == "breath" or fishing_phase == "waiting":
		texture = FISHERMAN_HOOK_TEXTURE
		frame = 1 if int(_now_seconds() * 8.0) % 2 == 0 else 2

	if fishing_phase != "idle":
		_add_rod_line(ROD_BUTT_ANCHOR, _rod_tip_anchor())
	_add_sprite_frame(texture, frame, FISHERMAN_ANCHOR, Vector2(0.92, 0.92), 1.0)


func _draw_fishing_lure() -> void:
	var lure_anchor := LURE_SURFACE_ANCHOR
	var lure_texture := LURE_TEXTURE
	var lure_scale := Vector2(0.34, 0.34)
	var ripple_alpha := 0.35

	if fishing_phase == "waiting":
		var bob := sin((_now_seconds() - lure_motion_started_at) * 8.0) * 0.008
		lure_anchor.y += bob
	elif fishing_phase == "breath":
		var ratio := _lure_motion_ratio()
		lure_anchor.y += sin(ratio * PI) * 0.045
		lure_scale = Vector2(0.38, 0.38)
		ripple_alpha = 0.75
	elif fishing_phase == "bite":
		lure_anchor.y += 0.055
		lure_texture = LURE_SINK_TEXTURE
		lure_scale = Vector2(0.42, 0.42)
		ripple_alpha = 1.0

	if fishing_phase != "idle":
		_add_lure_line(_rod_tip_anchor(), lure_anchor)
		_add_ripple(lure_anchor + Vector2(0.0, 0.018), ripple_alpha)
		_add_texture(lure_texture, lure_anchor, lure_scale, 1.0)
		if fishing_phase == "bite":
			_add_texture(BITE_SPLASH_TEXTURE, lure_anchor + Vector2(0.0, -0.018), Vector2(0.58, 0.58), 1.0)


func _draw_animated_water() -> void:
	var viewport_size := get_viewport_rect().size
	var time := _now_seconds()
	var water_tint := ColorRect.new()
	water_tint.color = Color(0.15, 0.36, 0.58, 0.12)
	water_tint.anchor_left = 0.0
	water_tint.anchor_right = 1.0
	water_tint.anchor_top = WATER_SURFACE_TOP
	water_tint.anchor_bottom = 1.0
	background_layer.add_child(water_tint)

	for index in range(9):
		var line := Line2D.new()
		line.width = 2.0 if index % 3 == 0 else 1.0
		line.default_color = Color(0.78, 0.88, 0.84, 0.22 if index % 2 == 0 else 0.14)
		var y := viewport_size.y * (WATER_SURFACE_TOP + 0.025 + float(index) * 0.038)
		var x_offset := fmod(time * (18.0 + index * 2.5) + index * 43.0, 96.0) - 96.0
		for point_index in range(9):
			var x := x_offset + point_index * (viewport_size.x / 7.0)
			var wave := sin(time * 2.4 + point_index * 0.9 + index) * (2.0 + index * 0.15)
			line.add_point(Vector2(x, y + wave))
		background_layer.add_child(line)


func _rod_tip_anchor() -> Vector2:
	if fishing_phase == "bite":
		return ROD_TIP_CAST + Vector2(0.008, 0.016)
	if fishing_phase == "waiting" or fishing_phase == "breath":
		var lift := sin((_now_seconds() - lure_motion_started_at) * 6.0) * 0.004
		return ROD_TIP_CAST + Vector2(0.0, lift)
	return ROD_TIP_IDLE


func _add_rod_line(from_anchor: Vector2, to_anchor: Vector2) -> void:
	var viewport_size := get_viewport_rect().size
	var rod := Line2D.new()
	rod.width = 3.0
	rod.default_color = Color(0.16, 0.07, 0.04, 0.95)
	rod.add_point(Vector2(from_anchor.x * viewport_size.x, from_anchor.y * viewport_size.y))
	rod.add_point(Vector2(to_anchor.x * viewport_size.x, to_anchor.y * viewport_size.y))
	background_layer.add_child(rod)


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
		var card_content := card.get_node("Content") as VBoxContainer
		var recipe: Dictionary = _get_recipe(customer["order_recipe_id"])
		var face: String = "?" if not customer["served"] else _face_for(customer["satisfaction"])
		card_content.add_child(_label(face, 22, Color("#1d1b1b"), true))
		card_content.add_child(_label(recipe["short_name"], 13, Color("#08303b"), true))
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


func _add_lure_line(from_anchor: Vector2, to_anchor: Vector2) -> void:
	var viewport_size := get_viewport_rect().size
	var line := Line2D.new()
	line.width = 2.0
	line.default_color = Color(0.92, 0.97, 0.94, 0.78)
	line.add_point(Vector2(from_anchor.x * viewport_size.x, from_anchor.y * viewport_size.y))
	line.add_point(Vector2(to_anchor.x * viewport_size.x, to_anchor.y * viewport_size.y))
	background_layer.add_child(line)


func _add_ripple(anchor: Vector2, alpha: float) -> void:
	var viewport_size := get_viewport_rect().size
	var ring := Line2D.new()
	ring.width = 3.0
	ring.default_color = Color(0.92, 1.0, 0.96, alpha)
	var center := Vector2(anchor.x * viewport_size.x, anchor.y * viewport_size.y)
	var radius := 22.0 + (alpha * 18.0)
	for index in range(18):
		var angle := (TAU / 17.0) * index
		ring.add_point(center + Vector2(cos(angle) * radius, sin(angle) * radius * 0.36))
	background_layer.add_child(ring)


func _add_full_texture(texture: Texture2D) -> void:
	var rect := TextureRect.new()
	rect.texture = texture
	rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rect.stretch_mode = TextureRect.STRETCH_SCALE
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	background_layer.add_child(rect)


func _add_texture(texture: Texture2D, anchor: Vector2, scale: Vector2, alpha: float, rotation_degrees_value := 0.0) -> void:
	var rect := TextureRect.new()
	rect.texture = texture
	rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
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


func _add_sprite_frame(texture: Texture2D, frame: int, anchor: Vector2, scale: Vector2, alpha: float) -> void:
	var atlas := AtlasTexture.new()
	atlas.atlas = texture
	atlas.region = Rect2(FISHERMAN_FRAME_SIZE.x * frame, 0.0, FISHERMAN_FRAME_SIZE.x, FISHERMAN_FRAME_SIZE.y)
	_add_texture(atlas, anchor, scale, alpha)


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


func _add_fishing_meter() -> void:
	if fishing_phase == "idle":
		return

	var container := CenterContainer.new()
	container.anchor_left = 0.0
	container.anchor_right = 1.0
	container.anchor_top = 0.3
	container.anchor_bottom = 0.3
	container.offset_left = 18
	container.offset_right = -18
	ui_layer.add_child(container)

	var meter := VBoxContainer.new()
	meter.custom_minimum_size = Vector2(minf(420.0, get_viewport_rect().size.x - 36.0), 0)
	meter.add_theme_constant_override("separation", 8)
	container.add_child(meter)

	var caption := "Observa el señuelo"
	if fishing_phase == "breath":
		caption = "Respiración falsa"
	elif fishing_phase == "bite":
		caption = "¡Jala ahora!"
	meter.add_child(_text_panel(caption, 14, Color("#e9f7ef"), true))

	var track := PanelContainer.new()
	track.custom_minimum_size = Vector2(0, 24)
	track.add_theme_stylebox_override("panel", _meter_track_style())
	meter.add_child(track)

	var track_content := Control.new()
	track_content.custom_minimum_size = Vector2(0, 20)
	track.add_child(track_content)

	var fill := ColorRect.new()
	fill.color = Color("#f6c177")
	fill.anchor_left = 0.0
	fill.anchor_right = _fishing_meter_ratio()
	fill.anchor_top = 0.0
	fill.anchor_bottom = 1.0
	track_content.add_child(fill)

	var perfect_mark := ColorRect.new()
	perfect_mark.color = Color(0.92, 1.0, 0.96, 0.8)
	perfect_mark.anchor_left = PERFECT_WINDOW_SECONDS / GOOD_WINDOW_SECONDS
	perfect_mark.anchor_right = perfect_mark.anchor_left
	perfect_mark.anchor_top = 0.0
	perfect_mark.anchor_bottom = 1.0
	perfect_mark.offset_left = -1
	perfect_mark.offset_right = 1
	track_content.add_child(perfect_mark)


func _fishing_meter_ratio() -> float:
	if fishing_phase == "bite":
		return clampf(_bite_elapsed() / GOOD_WINDOW_SECONDS, 0.0, 1.0)
	if fishing_phase == "breath":
		return clampf(_lure_motion_ratio(), 0.0, 1.0)
	var wait_progress := 1.0 - clampf(bite_timer.time_left / maxf(0.001, bite_timer.wait_time), 0.0, 1.0)
	return wait_progress


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


func _button(text: String, action: Callable, disabled := false, variant := "primary", press_on_down := false) -> Button:
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
	if press_on_down:
		button.button_down.connect(action)
	else:
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


func _status_card() -> PanelContainer:
	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(118, 82)
	card.add_theme_stylebox_override("panel", _light_panel_style())

	var content := VBoxContainer.new()
	content.name = "Content"
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	content.add_theme_constant_override("separation", 4)
	card.add_child(content)
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


func _meter_track_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.03, 0.12, 0.15, 0.88)
	style.border_color = Color(0.92, 0.97, 0.94, 0.42)
	style.set_border_width_all(2)
	style.set_corner_radius_all(4)
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
