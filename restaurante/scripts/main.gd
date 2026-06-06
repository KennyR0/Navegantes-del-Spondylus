extends Control

const SAVE_PATH := "user://la_pochita_stone_save.json"
const STARTING_COINS := 30
const BOAT_RENTAL_COST := 10
const DAILY_CASTS := 5
const PERFECT_CATCH_FISH_COUNT := 5
const GOOD_CATCH_FISH_COUNT := 3
const FAILED_CATCH_FISH_COUNT := 1
const PERFECT_CATCH_PREMIUM_CHANCE := 0.60
const GOOD_CATCH_PREMIUM_CHANCE := 0.40
const PERFECT_WINDOW_SECONDS := 0.45
const GOOD_WINDOW_SECONDS := 0.60
const LURE_BREATH_SECONDS := 0.58
const LURE_MIN_FALSE_BREATHS := 0
const LURE_MAX_FALSE_BREATHS := 5
const FISHING_REDRAW_SECONDS := 0.08
const SAVE_SYNC_SECONDS := 1.0
const CUSTOMER_PATIENCE_SECONDS := 22.0
const RENT_BOAT_ANIMATION_PATH := "res://assets/animations/animacion_renta_banco.ogv"
const RENT_BOAT_ANIMATION_FALLBACK_SECONDS := 2.4
const RENT_BOAT_ANIMATION_SAFETY_SECONDS := 8.0
const WATER_SURFACE_TOP := 0.60
const BOAT_ANCHOR := Vector2(0.46, 0.72)
const FISHERMAN_ANCHOR := Vector2(0.455, 0.682)
const FISHERMAN_SCALE := Vector2(1.18, 1.57)
const FISHING_ACTOR_BASE_SIZE := Vector2(160, 120)
const FISHING_ROD_TIP_ANCHOR := Vector2(0.575, 0.645)
const FISHERMAN_FRAME_SECONDS := 0.34
const LURE_SURFACE_ANCHOR := Vector2(0.675, 0.735)
const FISH_ANCHOR := Vector2(0.69, 0.755)
const GULL_FLIGHT_SECONDS := 8.0
const GULL_RESPAWN_SECONDS := 2.0
const GULL_COUNT := 4

const WATER_TEXTURE := preload("res://assets/craftpix/3 Objects/Water.png")
const HUT_TEXTURE := preload("res://assets/craftpix/3 Objects/Fishing_hut.png")
const BOAT_TEXTURE := preload("res://assets/craftpix/3 Objects/Boat.png")
const SHIPYARD_BACKGROUND_TEXTURE := preload("res://assets/pixelart/shipyard_background.png")
const FISHING_BACKGROUND_TEXTURE := preload("res://assets/pixelart/fondo_pesca.jpeg")
const GULL_FLAP_UP_TEXTURE := preload("res://assets/pixelart/gulls/gull_flap_up.png")
const GULL_GLIDE_TEXTURE := preload("res://assets/pixelart/gulls/gull_glide.png")
const GULL_DIVE_TEXTURE := preload("res://assets/pixelart/gulls/gull_dive.png")
const GULL_FLAP_DOWN_TEXTURE := preload("res://assets/pixelart/gulls/gull_flap_down.png")
const FISH_NORMAL_TEXTURE := preload("res://assets/pixelart/fish_normal_pixel.png")
const FISH_PREMIUM_TEXTURE := preload("res://assets/pixelart/fish_premium_pixel.png")
const LURE_TEXTURE := preload("res://assets/pixelart/lure_bobber.png")
const LURE_SINK_TEXTURE := preload("res://assets/pixelart/lure_sink.png")
const BITE_SPLASH_TEXTURE := preload("res://assets/pixelart/bite_splash.png")
const MAIN_MENU_TEXTURE := preload("res://assets/pixelart/main_menu.png")
const DAY_SUMMARY_TEXTURE := preload("res://assets/pixelart/day_summary.png")
const PROTAGONIST_FISHER_TEXTURE := preload("res://assets/protagonist/pescador_front.png")
const PROTAGONIST_COOK_TEXTURE := preload("res://assets/protagonist/cocinero_front.png")
const FISHER_IDLE_1_TEXTURE := preload("res://assets/protagonist/frames/fisher_idle_1.png")
const FISHER_IDLE_2_TEXTURE := preload("res://assets/protagonist/frames/fisher_idle_2.png")
const FISHER_WALK_1_TEXTURE := preload("res://assets/protagonist/frames/fisher_walk_1.png")
const FISHER_WALK_2_TEXTURE := preload("res://assets/protagonist/frames/fisher_walk_2.png")
const COOK_IDLE_1_TEXTURE := preload("res://assets/protagonist/frames/cook_idle_1.png")
const COOK_IDLE_2_TEXTURE := preload("res://assets/protagonist/frames/cook_idle_2.png")
const COOK_WALK_1_TEXTURE := preload("res://assets/protagonist/frames/cook_walk_1.png")
const COOK_WALK_2_TEXTURE := preload("res://assets/protagonist/frames/cook_walk_2.png")
const FISHING_REST_TEXTURE := preload("res://assets/protagonist/frames/fish_reposo.png")
const FISHING_CAST_TEXTURE := preload("res://assets/protagonist/frames/fish_lanzar.png")
const FISHING_WAIT_TEXTURE := preload("res://assets/protagonist/frames/fish_espera.png")
const FISHING_BREATH_1_TEXTURE := preload("res://assets/protagonist/frames/fish_respira_1.png")
const FISHING_BREATH_2_TEXTURE := preload("res://assets/protagonist/frames/fish_respira_2.png")
const FISHING_BREATH_3_TEXTURE := preload("res://assets/protagonist/frames/fish_respira_3.png")
const FISHING_BITE_TEXTURE := preload("res://assets/protagonist/frames/fish_mordida.png")
const FISHING_PULL_TEXTURE := preload("res://assets/protagonist/frames/fish_jalar.png")
const DISH_REFERENCE_TEXTURE := preload("res://assets/protagonist/plato.jpg")
const CEVICHE_RAW_TEXTURE := preload("res://assets/protagonist/ceviche_crudo.png")
const ENCEBOLLADO_RAW_TEXTURE := preload("res://assets/protagonist/encebollado_crudo.png")
const PARGO_RAW_TEXTURE := preload("res://assets/protagonist/pargo_crudo.png")
const RESTAURANT_BASE_TEXTURE := preload("res://assets/restaurant/cocinal1.png")
const RESTAURANT_UPGRADED_TEXTURE := preload("res://assets/restaurant/cocina2.png")
const CLIENT_PLACEHOLDER_1_TEXTURE := preload("res://assets/restaurant/client_placeholder_1.png")
const CLIENT_PLACEHOLDER_2_TEXTURE := preload("res://assets/restaurant/client_placeholder_2.png")
const CLIENT_PLACEHOLDER_3_TEXTURE := preload("res://assets/restaurant/client_placeholder_3.png")
const CLIENT_PLACEHOLDER_4_TEXTURE := preload("res://assets/restaurant/client_placeholder_4.png")
const CEVICHE_MANTA_TEXTURE := preload("res://assets/protagonist/ceviche_manta.png")
const PARGO_PREMIUM_TEXTURE := preload("res://assets/protagonist/pargo_premium.png")
const MAX_DAY_MENU_RECIPES := 3
const DAILY_CUSTOMERS := 4
const FIRST_CUSTOMER_DELAY_SECONDS := 1.4
const MIN_CUSTOMER_ARRIVAL_GAP_SECONDS := 5.0
const MAX_CUSTOMER_ARRIVAL_GAP_SECONDS := 8.0
const CATCH_REACTION_SECONDS := 1.15
const TUTORIAL_STEPS := [
	{
		"title": "Pesca: espera la mordida real",
		"body": "Si el señuelo respira, espera. Jala solo cuando se hunda y aparezca el aviso. Perfecto da 5 pescados; buena pesca da 3."
	},
	{
		"title": "Restaurante: vende lo que puedes cocinar",
		"body": "Elige hasta 3 platos para el menú del día. Los clientes pedirán solo esos platos: cocina, entrega rápido y cierra el día."
	}
]

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
		"ingredients": [{"item": "fish", "quality": "normal", "amount": 2}]
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
var cast_started_at := 0.0
var lure_motion_started_at := 0.0
var lure_breaths_remaining := 0
var lure_breaths_total := 0
var fishing_redraw_elapsed := 0.0
var restaurant_refresh_elapsed := 0.0
var save_sync_elapsed := 0.0
var summary_finalized := false
var selected_day_menu: Array = []
var last_catch_result := ""
var last_catch_started_at := -10.0
var tutorial_step := 0
var rent_boat_animation_overlay: Control
var menu_animation_time := 0.0
var menu_birds: Array = []
var menu_waves: Array = []
var dragged_recipe_id := ""
var restaurant_drag_mouse_was_down := false

var background_layer: Control
var ui_layer: Control
var bite_timer: Timer
var fail_timer: Timer
var rent_boat_animation_timer: Timer


class RecipeDragButton:
	extends Button

	var main
	var recipe_id := ""
	var recipe_texture: Texture2D

	func _get_drag_data(_at_position: Vector2) -> Variant:
		if disabled:
			return null
		var preview := TextureRect.new()
		preview.texture = recipe_texture
		preview.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		preview.custom_minimum_size = Vector2(70, 54)
		preview.modulate.a = 0.92
		set_drag_preview(preview)
		return {"type": "raw_dish", "recipe_id": recipe_id}


class StoveDropSlot:
	extends PanelContainer

	var main
	var stove_id := 0

	func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
		if typeof(data) != TYPE_DICTIONARY:
			return false
		var drag_data: Dictionary = data as Dictionary
		if str(drag_data.get("type", "")) != "raw_dish":
			return false
		return main._can_drop_recipe_on_stove(str(drag_data.get("recipe_id", "")), stove_id)

	func _drop_data(_at_position: Vector2, data: Variant) -> void:
		var drag_data: Dictionary = data as Dictionary
		main.dragged_recipe_id = ""
		main._start_cooking_on_stove(str(drag_data.get("recipe_id", "")), stove_id)


func _ready() -> void:
	rng.randomize()
	_create_layers()
	_create_timers()
	save = _load_save()
	_show_menu()


func _process(delta: float) -> void:
	_tick_save_sync(delta)

	if mode == "menu":
		_animate_menu_scene(delta)
		return

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
		restaurant_drag_mouse_was_down = false
		return

	restaurant_refresh_elapsed += delta
	var stoves_changed := _update_stoves()
	var arrivals_changed := _update_customer_arrivals()
	var customers_changed := _close_late_customers()
	var changed := stoves_changed or arrivals_changed or customers_changed
	var mouse_down := Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	if restaurant_drag_mouse_was_down and not mouse_down and dragged_recipe_id != "":
		_finish_recipe_drag_at_mouse()
		restaurant_drag_mouse_was_down = false
		return
	restaurant_drag_mouse_was_down = mouse_down
	if mouse_down:
		if changed:
			_persist_save()
		return
	if changed or restaurant_refresh_elapsed >= 0.25:
		restaurant_refresh_elapsed = 0.0
		_show_restaurant()
		if changed:
			_persist_save()


func _tick_save_sync(delta: float) -> void:
	if day.is_empty() or mode == "menu":
		return
	save_sync_elapsed += delta
	if save_sync_elapsed >= SAVE_SYNC_SECONDS:
		save_sync_elapsed = 0.0
		_persist_save()


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

	rent_boat_animation_timer = Timer.new()
	rent_boat_animation_timer.one_shot = true
	rent_boat_animation_timer.timeout.connect(_finish_rent_boat_animation)
	add_child(rent_boat_animation_timer)


func _clear_layer(layer: Node) -> void:
	for child in layer.get_children():
		layer.remove_child(child)
		child.queue_free()


func _reset_screen() -> void:
	_clear_layer(background_layer)
	_clear_layer(ui_layer)
	menu_birds.clear()
	menu_waves.clear()


func _create_default_save() -> Dictionary:
	return {
		"coins": STARTING_COINS,
		"stars": 0,
		"upgrade_level": 0,
		"unlocked_recipes": ["ceviche_manta", "encebollado_pochita", "pargo_premium"],
		"best_day": null,
		"tutorial_seen": false
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
	var run_snapshot := _create_run_snapshot()
	if run_snapshot.is_empty():
		save.erase("current_run")
	else:
		save["current_run"] = run_snapshot

	_write_save_file()


func _write_save_file() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save))


func _has_saved_run() -> bool:
	return typeof(save.get("current_run", null)) == TYPE_DICTIONARY and not (save["current_run"] as Dictionary).is_empty()


func _create_run_snapshot() -> Dictionary:
	if day.is_empty():
		return {}

	return {
		"mode": mode,
		"day": day.duplicate(true),
		"restaurant": _serialize_restaurant_state(),
		"selected_day_menu": selected_day_menu.duplicate(),
		"fishing": _serialize_fishing_state(),
		"summary_finalized": summary_finalized,
		"tutorial_step": tutorial_step,
		"message": message
	}


func _serialize_fishing_state() -> Dictionary:
	var now := _now_seconds()
	return {
		"phase": fishing_phase,
		"bite_elapsed": maxf(0.0, now - bite_started_at),
		"cast_elapsed": maxf(0.0, now - cast_started_at),
		"lure_motion_elapsed": maxf(0.0, now - lure_motion_started_at),
		"lure_breaths_remaining": lure_breaths_remaining,
		"lure_breaths_total": lure_breaths_total,
		"bite_timer_remaining": bite_timer.time_left if not bite_timer.is_stopped() else 0.0,
		"fail_timer_remaining": fail_timer.time_left if not fail_timer.is_stopped() else 0.0,
		"last_catch_result": last_catch_result,
		"last_catch_elapsed": maxf(0.0, now - last_catch_started_at)
	}


func _serialize_restaurant_state() -> Dictionary:
	if restaurant.is_empty():
		return {}

	var now := _now_seconds()
	var copy := restaurant.duplicate(true)
	for stove_item in copy.get("stoves", []):
		var stove: Dictionary = stove_item as Dictionary
		if stove.get("recipe_id", "") != "" and not bool(stove.get("ready", false)):
			stove["ready_remaining"] = maxf(0.0, float(stove.get("ready_at", now)) - now)

	for customer_item in copy.get("customers", []):
		var customer: Dictionary = customer_item as Dictionary
		match str(customer.get("state", "")):
			"waiting_to_arrive":
				customer["arrival_remaining"] = maxf(0.0, float(customer.get("arrives_at", now)) - now)
			"present":
				customer["waited_seconds"] = maxf(0.0, now - float(customer.get("arrived_at", now)))

	return copy


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
			"premium_fish": 0
		},
		"boat_rented": false,
		"casts_left": _get_daily_casts(),
		"summary": _create_empty_summary()
	}


func _continue_saved_run() -> void:
	var run = save.get("current_run", null)
	if typeof(run) != TYPE_DICTIONARY or (run as Dictionary).is_empty():
		message = "No hay partida en curso para continuar."
		_show_menu()
		return

	var run_data: Dictionary = run as Dictionary
	day = _restore_day_state(run_data.get("day", {}))
	restaurant = _restore_restaurant_state(run_data.get("restaurant", {}))
	selected_day_menu = []
	if typeof(run_data.get("selected_day_menu", null)) == TYPE_ARRAY:
		selected_day_menu = (run_data.get("selected_day_menu", []) as Array).duplicate()
	summary_finalized = bool(run_data.get("summary_finalized", false))
	tutorial_step = int(run_data.get("tutorial_step", 0))
	message = str(run_data.get("message", "Partida recuperada."))
	_restore_fishing_state(run_data.get("fishing", {}))

	match str(run_data.get("mode", "fishing")):
		"tutorial":
			_show_tutorial(tutorial_step)
		"menu_setup":
			_show_menu_setup()
		"restaurant":
			if restaurant.is_empty():
				message = "Partida recuperada; vuelve a elegir el menú del día."
				_show_menu_setup()
			else:
				_show_restaurant()
		"summary":
			_show_summary()
		_:
			_show_fishing()


func _restore_day_state(raw_day) -> Dictionary:
	var restored := _create_new_day()
	if typeof(raw_day) == TYPE_DICTIONARY:
		var raw: Dictionary = raw_day as Dictionary
		for key in raw.keys():
			restored[key] = raw[key]
	if typeof(restored.get("summary", null)) != TYPE_DICTIONARY:
		restored["summary"] = _create_empty_summary()
	return restored


func _restore_fishing_state(raw_fishing) -> void:
	bite_timer.stop()
	fail_timer.stop()

	var fishing := {}
	if typeof(raw_fishing) == TYPE_DICTIONARY:
		fishing = raw_fishing as Dictionary
	var now := _now_seconds()
	fishing_phase = str(fishing.get("phase", "idle"))
	cast_started_at = now - float(fishing.get("cast_elapsed", 0.0))
	lure_motion_started_at = now - float(fishing.get("lure_motion_elapsed", 0.0))
	bite_started_at = now - float(fishing.get("bite_elapsed", 0.0))
	lure_breaths_remaining = int(fishing.get("lure_breaths_remaining", 0))
	lure_breaths_total = int(fishing.get("lure_breaths_total", 0))
	last_catch_result = str(fishing.get("last_catch_result", ""))
	last_catch_started_at = now - float(fishing.get("last_catch_elapsed", CATCH_REACTION_SECONDS + 1.0))

	match fishing_phase:
		"waiting", "breath":
			var bite_remaining := float(fishing.get("bite_timer_remaining", 0.0))
			if bite_remaining > 0.0:
				bite_timer.wait_time = bite_remaining
				bite_timer.start()
			else:
				fishing_phase = "idle"
		"bite":
			var fail_remaining := float(fishing.get("fail_timer_remaining", 0.0))
			if fail_remaining > 0.0:
				fail_timer.wait_time = fail_remaining
				fail_timer.start()
			else:
				fishing_phase = "idle"
		"idle":
			pass
		_:
			fishing_phase = "idle"


func _restore_restaurant_state(raw_restaurant) -> Dictionary:
	if typeof(raw_restaurant) != TYPE_DICTIONARY:
		return {}

	var now := _now_seconds()
	var restored: Dictionary = (raw_restaurant as Dictionary).duplicate(true)
	for stove_item in restored.get("stoves", []):
		var stove: Dictionary = stove_item as Dictionary
		if stove.get("recipe_id", "") != "" and not bool(stove.get("ready", false)):
			stove["ready_at"] = now + float(stove.get("ready_remaining", 0.0))

	for customer_item in restored.get("customers", []):
		var customer: Dictionary = customer_item as Dictionary
		match str(customer.get("state", "")):
			"waiting_to_arrive":
				customer["arrives_at"] = now + float(customer.get("arrival_remaining", 0.0))
				customer["arrived_at"] = 0.0
			"present":
				customer["arrived_at"] = now - float(customer.get("waited_seconds", 0.0))

	return restored


func _start_fresh_run() -> void:
	var tutorial_was_seen := bool(save.get("tutorial_seen", false))
	save = _create_default_save()
	save["tutorial_seen"] = tutorial_was_seen
	day = _create_new_day()
	restaurant = {}
	selected_day_menu = []
	fishing_phase = "idle"
	tutorial_step = 0
	message = "Renta un bote para salir antes de que suba la marea."
	summary_finalized = false
	_show_tutorial(0)
	_persist_save()


func _start_next_day() -> void:
	day = _create_new_day()
	restaurant = {}
	selected_day_menu = []
	fishing_phase = "idle"
	tutorial_step = 0
	message = "Renta un bote para salir antes de que suba la marea."
	summary_finalized = false
	_show_fishing()
	_persist_save()


func _should_show_first_day_tutorial() -> bool:
	return not bool(save.get("tutorial_seen", false))


func _show_tutorial(step := 0) -> void:
	mode = "tutorial"
	tutorial_step = clampi(step, 0, TUTORIAL_STEPS.size() - 1)
	_reset_screen()
	if tutorial_step == 0:
		_draw_fishing_background()
	else:
		_draw_restaurant_background()
	_add_top_bar([
		"Tutorial %s/%s" % [tutorial_step + 1, TUTORIAL_STEPS.size()],
		"Aprende lo esencial y empieza rápido"
	])

	var step_data: Dictionary = TUTORIAL_STEPS[tutorial_step] as Dictionary
	var panel := _bottom_panel(680)
	panel.add_child(_label(str(step_data["title"]), 24, Color("#f6c177"), true))
	panel.add_child(_text_panel(str(step_data["body"]), 16, Color("#e9f7ef"), true))
	panel.add_child(_tutorial_hint_panel())

	var controls := _button_row()
	var next_label := "Empezar a pescar" if tutorial_step >= TUTORIAL_STEPS.size() - 1 else "Siguiente"
	controls.add_child(_button(next_label, Callable(self, "_advance_tutorial")))
	controls.add_child(_button("Saltar", Callable(self, "_skip_tutorial"), false, "secondary"))
	panel.add_child(controls)
	if not day.is_empty():
		_persist_save()


func _tutorial_hint_panel() -> PanelContainer:
	var hint := ""
	if tutorial_step == 0:
		hint = "Clave: la respiración falsa castiga la ansiedad. La mordida real hunde el señuelo."
	else:
		hint = "Clave: el menú filtra los pedidos. No vendas platos que no podrás cocinar."
	return _text_panel(hint, 14, Color("#f6c177"), true)


func _advance_tutorial() -> void:
	if tutorial_step >= TUTORIAL_STEPS.size() - 1:
		_finish_tutorial()
		return
	_show_tutorial(tutorial_step + 1)


func _skip_tutorial() -> void:
	_finish_tutorial()


func _finish_tutorial() -> void:
	save["tutorial_seen"] = true
	tutorial_step = TUTORIAL_STEPS.size() - 1
	message = "Renta un bote, mira el señuelo y jala solo cuando se hunda."
	_show_fishing()
	_persist_save()


func _show_menu() -> void:
	mode = "menu"
	menu_animation_time = 0.0
	_reset_screen()
	_draw_menu_background()

	_add_menu_hotspot(Vector2(0.05, 0.565), Vector2(0.37, 0.635), Callable(self, "_start_fresh_run"))
	_add_menu_hotspot(Vector2(0.05, 0.650), Vector2(0.37, 0.720), Callable(self, "_continue_saved_run"), not _has_saved_run())
	_add_menu_hotspot(Vector2(0.05, 0.775), Vector2(0.37, 0.850), Callable(self, "_quit_game"))

	if message != "":
		_add_menu_notice(message)


func _show_fishing() -> void:
	mode = "fishing"
	if message == "":
		message = "Renta un bote para salir antes de que suba la marea."
	_reset_screen()
	_draw_fishing_background()
	_add_top_bar([
		"$%s" % save["coins"],
		_inventory_chip_text(),
		"Lances %s/%s" % [day["casts_left"], _get_daily_casts()]
	], true)
	_add_toast(message)

	var controls := _bottom_controls()
	controls.add_child(_button("Rentar barco (%s)" % BOAT_RENTAL_COST, Callable(self, "_rent_boat"), day["boat_rented"]))
	controls.add_child(_button("Lanzar caña", Callable(self, "_cast_line"), not day["boat_rented"] or fishing_phase != "idle" or day["casts_left"] <= 0, "cast"))
	controls.add_child(_button("¡Jalar!", Callable(self, "_hook_fish"), fishing_phase == "idle", "danger", true))
	controls.add_child(_button("Ir al restaurante", Callable(self, "_open_restaurant"), day["casts_left"] == _get_daily_casts() or fishing_phase != "idle"))
	_add_top_menu_button()


func _return_to_main_menu() -> void:
	if not day.is_empty():
		_persist_save()
	message = ""
	_show_menu()


func _rent_boat() -> void:
	if day["boat_rented"]:
		return
	if save["coins"] < BOAT_RENTAL_COST:
		message = "No alcanza para rentar bote. El puerto no fía."
		_show_fishing()
		return

	save["coins"] -= BOAT_RENTAL_COST
	day["boat_rented"] = true
	message = "Bote rentado. Busca el ritmo de respiración del señuelo."
	_show_fishing()
	_play_rent_boat_animation()
	_persist_save()


func _play_rent_boat_animation() -> void:
	_finish_rent_boat_animation()

	rent_boat_animation_overlay = Control.new()
	rent_boat_animation_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	rent_boat_animation_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	ui_layer.add_child(rent_boat_animation_overlay)

	var dim := ColorRect.new()
	dim.color = Color(0.02, 0.08, 0.10, 0.78)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	rent_boat_animation_overlay.add_child(dim)

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_top", 28)
	margin.add_theme_constant_override("margin_bottom", 28)
	rent_boat_animation_overlay.add_child(margin)

	var center := CenterContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(center)

	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _panel_style())
	panel.custom_minimum_size = Vector2(minf(640.0, get_viewport_rect().size.x - 36.0), 0)
	center.add_child(panel)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 10)
	panel.add_child(content)

	var title := _label("Bote rentado", 24, Color("#f6c177"), true)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(title)

	var video_stream = load(RENT_BOAT_ANIMATION_PATH) if ResourceLoader.exists(RENT_BOAT_ANIMATION_PATH) else null
	if video_stream is VideoStream:
		var video_frame := Control.new()
		video_frame.custom_minimum_size = Vector2(0, minf(360.0, get_viewport_rect().size.y * 0.48))
		video_frame.clip_contents = true
		video_frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		content.add_child(video_frame)

		var player := VideoStreamPlayer.new()
		player.stream = video_stream
		player.expand = true
		player.set_anchors_preset(Control.PRESET_FULL_RECT)
		player.finished.connect(_finish_rent_boat_animation)
		video_frame.add_child(player)
		_add_rent_boat_skip_button(video_frame)
		player.play()
		rent_boat_animation_timer.wait_time = RENT_BOAT_ANIMATION_SAFETY_SECONDS
	else:
		_add_rent_boat_fallback_animation(content)
		rent_boat_animation_timer.wait_time = RENT_BOAT_ANIMATION_FALLBACK_SECONDS

	var caption := _label("Cuando termine, lanza la caña y espera la mordida real.", 15, Color("#e9f7ef"))
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(caption)

	rent_boat_animation_timer.start()


func _add_rent_boat_fallback_animation(content: VBoxContainer) -> void:
	var area := Control.new()
	area.custom_minimum_size = Vector2(0, 190)
	area.clip_contents = true
	content.add_child(area)

	var sky := ColorRect.new()
	sky.color = Color("#79c7d9")
	sky.set_anchors_preset(Control.PRESET_FULL_RECT)
	sky.anchor_bottom = 0.58
	area.add_child(sky)

	var sea := ColorRect.new()
	sea.color = Color("#176f89")
	sea.set_anchors_preset(Control.PRESET_FULL_RECT)
	sea.anchor_top = 0.52
	area.add_child(sea)

	var boat := TextureRect.new()
	boat.texture = BOAT_TEXTURE
	boat.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	boat.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	boat.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	boat.custom_minimum_size = Vector2(180, 120)
	boat.size = Vector2(180, 120)
	boat.position = Vector2(-140, 54)
	boat.pivot_offset = Vector2(90, 70)
	area.add_child(boat)

	var splash := _label("Preparando salida al mar", 18, Color("#e9f7ef"), true)
	splash.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	splash.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	splash.set_anchors_preset(Control.PRESET_FULL_RECT)
	splash.anchor_top = 0.62
	area.add_child(splash)
	_add_rent_boat_skip_button(area)

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(boat, "position", Vector2(500, 46), 2.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(boat, "rotation_degrees", 4.0, 1.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.chain().tween_property(boat, "rotation_degrees", -2.5, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _add_rent_boat_skip_button(parent: Control) -> void:
	var skip_button := Button.new()
	skip_button.text = "Saltar"
	skip_button.custom_minimum_size = Vector2(84, 34)
	skip_button.mouse_filter = Control.MOUSE_FILTER_STOP
	skip_button.add_theme_stylebox_override("normal", _button_style("secondary", false, 0.92))
	skip_button.add_theme_stylebox_override("hover", _button_style("secondary", false, 1.08))
	skip_button.add_theme_stylebox_override("pressed", _button_style("secondary", false, 0.78))
	skip_button.add_theme_color_override("font_color", Color("#e9f7ef"))
	skip_button.add_theme_font_size_override("font_size", 13)
	skip_button.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	skip_button.offset_left = -96
	skip_button.offset_top = -54
	skip_button.offset_right = -12
	skip_button.offset_bottom = -20
	skip_button.pressed.connect(_finish_rent_boat_animation)
	parent.add_child(skip_button)


func _finish_rent_boat_animation() -> void:
	if rent_boat_animation_timer != null and not rent_boat_animation_timer.is_stopped():
		rent_boat_animation_timer.stop()
	if rent_boat_animation_overlay != null and is_instance_valid(rent_boat_animation_overlay):
		rent_boat_animation_overlay.queue_free()
	rent_boat_animation_overlay = null


func _cast_line() -> void:
	if not day["boat_rented"] or day["casts_left"] <= 0 or fishing_phase != "idle":
		return

	fishing_phase = "waiting"
	cast_started_at = _now_seconds()
	lure_breaths_total = rng.randi_range(LURE_MIN_FALSE_BREATHS, LURE_MAX_FALSE_BREATHS)
	lure_breaths_remaining = lure_breaths_total
	lure_motion_started_at = _now_seconds()
	fishing_redraw_elapsed = 0.0
	message = "El señuelo respira... espera que se hunda."
	bite_timer.wait_time = rng.randf_range(1.15, 1.85)
	bite_timer.start()
	_show_fishing()
	_persist_save()


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
	_persist_save()


func _return_lure_to_surface() -> void:
	lure_breaths_remaining = max(0, lure_breaths_remaining - 1)
	fishing_phase = "waiting"
	lure_motion_started_at = _now_seconds()
	message = "El señuelo vuelve a flotar. Mantén el pulso."
	bite_timer.wait_time = rng.randf_range(0.85, 1.45)
	bite_timer.start()
	_show_fishing()
	_persist_save()


func _start_bite() -> void:
	if fishing_phase != "waiting":
		return

	fishing_phase = "bite"
	bite_started_at = _now_seconds()
	lure_motion_started_at = bite_started_at
	message = "¡Se hundió! Jala antes de %.2fs para pesca perfecta." % _get_perfect_window_seconds()
	fail_timer.wait_time = _get_good_window_seconds()
	fail_timer.start()
	_show_fishing()
	_persist_save()


func _hook_fish() -> void:
	if fishing_phase == "idle":
		return

	if fishing_phase != "bite":
		_finish_catch("early")
		return

	var elapsed := _now_seconds() - bite_started_at
	if elapsed <= _get_perfect_window_seconds():
		_finish_catch("perfect")
	elif elapsed <= _get_good_window_seconds():
		_finish_catch("good")
	else:
		_finish_catch("fail")


func _finish_catch(result: String) -> void:
	if fishing_phase == "idle":
		return

	bite_timer.stop()
	fail_timer.stop()
	last_catch_result = result
	last_catch_started_at = _now_seconds()
	fishing_phase = "idle"
	lure_breaths_remaining = 0
	lure_breaths_total = 0
	fishing_redraw_elapsed = 0.0
	day["casts_left"] = max(0, day["casts_left"] - 1)

	var catch_loot := _grant_catch_loot(result)
	if result == "perfect":
		day["summary"]["perfect_catches"] += 1
	elif result == "good":
		day["summary"]["good_catches"] += 1
	else:
		day["summary"]["failed_catches"] += 1

	message = _catch_result_label(result, catch_loot)
	if day["casts_left"] <= 0:
		message = "%s Último lance del día." % message
	_show_fishing()
	_persist_save()


func _grant_catch_loot(result: String) -> Dictionary:
	var total_fish := FAILED_CATCH_FISH_COUNT
	var premium_chance := 0.0
	if result == "perfect":
		total_fish = PERFECT_CATCH_FISH_COUNT
		premium_chance = PERFECT_CATCH_PREMIUM_CHANCE
	elif result == "good":
		total_fish = GOOD_CATCH_FISH_COUNT
		premium_chance = GOOD_CATCH_PREMIUM_CHANCE

	var normal_count := 0
	var premium_count := 0
	for index in range(total_fish):
		if premium_chance > 0.0 and rng.randf() < premium_chance:
			premium_count += 1
		else:
			normal_count += 1

	day["inventory"]["normal_fish"] += normal_count
	day["inventory"]["premium_fish"] += premium_count
	return {"normal": normal_count, "premium": premium_count}


func _catch_result_label(result: String, catch_loot: Dictionary) -> String:
	var loot_text := _catch_loot_text(catch_loot)
	match result:
		"perfect":
			return "Pesca perfecta: %s." % loot_text
		"good":
			return "Buena pesca: %s." % loot_text
		"early":
			return "Pesca fallida: jalaste antes de que se hundiera el señuelo. %s." % loot_text
		_:
			return "La pesca se escapó, pero rescatas %s." % loot_text


func _catch_loot_text(catch_loot: Dictionary) -> String:
	var parts: Array = []
	var premium_count := int(catch_loot.get("premium", 0))
	var normal_count := int(catch_loot.get("normal", 0))
	if premium_count > 0:
		parts.append("+%s premium" % premium_count)
	if normal_count > 0:
		parts.append("+%s normal" % normal_count)
	if parts.is_empty():
		return "sin pesca"
	return ", ".join(parts)


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
	restaurant = {}
	selected_day_menu = _default_day_menu_recipe_ids()
	message = "Elige hasta 3 platos para vender hoy."
	_show_menu_setup()
	_persist_save()


func _show_menu_setup() -> void:
	mode = "menu_setup"
	_reset_screen()
	_draw_restaurant_background()
	_add_top_bar([
		"$%s" % save["coins"],
		_inventory_chip_text(),
		"Menú %s/%s" % [selected_day_menu.size(), MAX_DAY_MENU_RECIPES]
	])
	_add_toast(message)

	var panel := _day_menu_panel()
	var port_label := _label("Puerto de Manta", 13, Color("#f4d58d"), true)
	port_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel.add_child(port_label)

	var title := _label("Carta del muelle", 30, Color("#fff7db"), true)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel.add_child(title)
	panel.add_child(_day_menu_rule())

	for recipe_item in RECIPES:
		var recipe_data: Dictionary = recipe_item as Dictionary
		if save["unlocked_recipes"].has(recipe_data["id"]):
			panel.add_child(_recipe_menu_card(recipe_data))

	var hint := _label("Elige hasta 3 platos con la pesca fresca del día", 14, Color("#d8f3dc"), true)
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel.add_child(hint)

	var start_row := _button_row()
	start_row.add_child(_button("Abrir cocina", Callable(self, "_start_restaurant_day"), selected_day_menu.is_empty()))
	start_row.add_child(_button("Volver a pescar", Callable(self, "_show_fishing"), false, "secondary"))
	panel.add_child(start_row)


func _recipe_menu_card(recipe: Dictionary) -> Button:
	var recipe_id := str(recipe["id"])
	var selected := selected_day_menu.has(recipe_id)
	var can_cook := _can_cook(recipe)
	var status_text := _recipe_availability_text(recipe, selected)

	var button := Button.new()
	button.text = ""
	button.custom_minimum_size = Vector2(0, 108)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_stylebox_override("normal", _day_menu_choice_style(selected, not can_cook and not selected, 1.0))
	button.add_theme_stylebox_override("hover", _day_menu_choice_style(selected, not can_cook and not selected, 1.06))
	button.add_theme_stylebox_override("pressed", _day_menu_choice_style(selected, not can_cook and not selected, 0.92))
	button.pressed.connect(Callable(self, "_toggle_day_menu_recipe").bind(recipe_id))

	var content_margin := MarginContainer.new()
	content_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	content_margin.add_theme_constant_override("margin_left", 10)
	content_margin.add_theme_constant_override("margin_top", 8)
	content_margin.add_theme_constant_override("margin_right", 10)
	content_margin.add_theme_constant_override("margin_bottom", 8)
	content_margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(content_margin)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	content_margin.add_child(row)

	var icon_slot := PanelContainer.new()
	icon_slot.custom_minimum_size = Vector2(58, 58)
	icon_slot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	icon_slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon_slot.add_theme_stylebox_override("panel", _day_menu_icon_slot_style(selected))
	row.add_child(icon_slot)

	if recipe_id == "ceviche_manta":
		var ceviche_texture := TextureRect.new()
		ceviche_texture.texture = CEVICHE_MANTA_TEXTURE
		ceviche_texture.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		ceviche_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		ceviche_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		ceviche_texture.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		ceviche_texture.size_flags_vertical = Control.SIZE_EXPAND_FILL
		ceviche_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
		icon_slot.add_child(ceviche_texture)
	elif recipe_id == "encebollado_pochita":
		var encebollado_texture := TextureRect.new()
		encebollado_texture.texture = DISH_REFERENCE_TEXTURE
		encebollado_texture.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		encebollado_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		encebollado_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		encebollado_texture.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		encebollado_texture.size_flags_vertical = Control.SIZE_EXPAND_FILL
		encebollado_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
		icon_slot.add_child(encebollado_texture)
	elif recipe_id == "pargo_premium":
		var pargo_texture := TextureRect.new()
		pargo_texture.texture = PARGO_PREMIUM_TEXTURE
		pargo_texture.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		pargo_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		pargo_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		pargo_texture.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		pargo_texture.size_flags_vertical = Control.SIZE_EXPAND_FILL
		pargo_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
		icon_slot.add_child(pargo_texture)
	else:
		var icon_label := _label("PLATO", 10, Color("#fff7db"), true)
		icon_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		icon_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		icon_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		icon_slot.add_child(icon_label)

	var text_column := VBoxContainer.new()
	text_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_column.size_flags_vertical = Control.SIZE_EXPAND_FILL
	text_column.alignment = BoxContainer.ALIGNMENT_CENTER
	text_column.add_theme_constant_override("separation", 4)
	text_column.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(text_column)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	header.mouse_filter = Control.MOUSE_FILTER_IGNORE
	text_column.add_child(header)

	var name_label := _label(str(recipe["name"]), 15, Color("#f9f5eb"), true)
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	name_label.clip_text = true
	name_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	header.add_child(name_label)

	var price_label := _label("$%s" % _get_dish_price(recipe_id), 15, Color("#f9f5eb"), true)
	price_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	price_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	header.add_child(price_label)

	var cost_label := _label(_recipe_cost_text(recipe), 13, Color("#f9f5eb"))
	cost_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	text_column.add_child(cost_label)

	var status_label := _label(status_text, 13, Color("#f6c177") if selected else Color("#f9f5eb"), true)
	status_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	text_column.add_child(status_label)
	return button


func _raw_dish_drag_card(recipe: Dictionary) -> Button:
	var recipe_id := str(recipe["id"])
	var disabled := not _can_cook(recipe)
	var card := RecipeDragButton.new()
	card.main = self
	card.recipe_id = recipe_id
	card.recipe_texture = _raw_dish_texture(recipe_id)
	card.disabled = disabled
	card.text = ""
	card.tooltip_text = "Arrastra a una hornilla"
	card.custom_minimum_size = Vector2(146, 58)
	card.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	card.add_theme_stylebox_override("normal", _raw_dish_card_style(disabled, 1.0))
	card.add_theme_stylebox_override("hover", _raw_dish_card_style(disabled, 1.06))
	card.add_theme_stylebox_override("pressed", _raw_dish_card_style(disabled, 0.92))
	if not disabled:
		card.button_down.connect(Callable(self, "_begin_recipe_drag").bind(recipe_id))

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 6)
	margin.add_theme_constant_override("margin_top", 5)
	margin.add_theme_constant_override("margin_right", 6)
	margin.add_theme_constant_override("margin_bottom", 5)
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(margin)

	var content := HBoxContainer.new()
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	content.add_theme_constant_override("separation", 6)
	content.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_child(content)

	var plate := TextureRect.new()
	plate.texture = card.recipe_texture
	plate.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	plate.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	plate.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	plate.custom_minimum_size = Vector2(42, 38)
	plate.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	content.add_child(plate)

	var text_column := VBoxContainer.new()
	text_column.alignment = BoxContainer.ALIGNMENT_CENTER
	text_column.add_theme_constant_override("separation", 0)
	text_column.mouse_filter = Control.MOUSE_FILTER_IGNORE
	content.add_child(text_column)

	var name_label := _label(str(recipe["short_name"]), 12, Color("#fff7db"), true)
	name_label.custom_minimum_size = Vector2(82, 0)
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	name_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	name_label.clip_text = true
	name_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	text_column.add_child(name_label)

	var status_text := "Crudo" if not disabled else "Sin pesca"
	var status_label := _label(status_text, 10, Color("#f6c177"), true)
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	status_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	status_label.clip_text = true
	status_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	status_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	text_column.add_child(status_label)
	return card


func _raw_dish_texture(recipe_id: String) -> Texture2D:
	match recipe_id:
		"ceviche_manta":
			return CEVICHE_RAW_TEXTURE
		"encebollado_pochita":
			return ENCEBOLLADO_RAW_TEXTURE
		"pargo_premium":
			return PARGO_RAW_TEXTURE
		_:
			return DISH_REFERENCE_TEXTURE


func _begin_recipe_drag(recipe_id: String) -> void:
	dragged_recipe_id = recipe_id
	restaurant_drag_mouse_was_down = true


func _finish_recipe_drag_at_mouse() -> void:
	var recipe_id := dragged_recipe_id
	dragged_recipe_id = ""
	if recipe_id == "":
		return

	var stove_id := _stove_id_at_global_position(get_global_mouse_position())
	if stove_id < 0:
		message = "Suelta el plato sobre una hornilla libre."
		_show_restaurant()
		return
	_start_cooking_on_stove(recipe_id, stove_id)


func _stove_id_at_global_position(global_position: Vector2) -> int:
	return _stove_id_at_global_position_in_node(ui_layer, global_position)


func _stove_id_at_global_position_in_node(node: Node, global_position: Vector2) -> int:
	if node is StoveDropSlot:
		var slot := node as StoveDropSlot
		if slot.get_global_rect().has_point(global_position):
			return slot.stove_id
	for child in node.get_children():
		var found := _stove_id_at_global_position_in_node(child, global_position)
		if found >= 0:
			return found
	return -1


func _recipe_cost_text(recipe: Dictionary) -> String:
	var parts: Array = []
	for ingredient_item in recipe["ingredients"]:
		var ingredient: Dictionary = ingredient_item as Dictionary
		var amount := int(ingredient["amount"])
		if ingredient.get("quality", "normal") == "premium":
			parts.append("%s pescado premium" % amount)
		else:
			parts.append("%s pescado normal" % amount)
	return " + ".join(parts)


func _recipe_availability_text(recipe: Dictionary, selected: bool) -> String:
	if not _can_cook(recipe):
		return "Seleccionado · falta inventario" if selected else "No alcanza inventario"
	return "Seleccionado" if selected else "Disponible"


func _toggle_day_menu_recipe(recipe_id: String) -> void:
	if selected_day_menu.has(recipe_id):
		selected_day_menu.erase(recipe_id)
	elif selected_day_menu.size() < MAX_DAY_MENU_RECIPES:
		selected_day_menu.append(recipe_id)
	else:
		message = "El menú del día solo permite 3 platos."
		_show_menu_setup()
		return

	message = "Menú listo: %s/%s platos." % [selected_day_menu.size(), MAX_DAY_MENU_RECIPES]
	_show_menu_setup()
	_persist_save()


func _start_restaurant_day() -> void:
	if selected_day_menu.is_empty():
		message = "Elige al menos un plato para abrir la cocina."
		_show_menu_setup()
		return

	restaurant = _create_restaurant_state(selected_day_menu)
	message = "Cocina lo elegido y atiende cuando los clientes lleguen."
	_show_restaurant()
	_persist_save()


func _default_day_menu_recipe_ids() -> Array:
	var ids: Array = []
	for recipe_item in RECIPES:
		var recipe_data: Dictionary = recipe_item as Dictionary
		if save["unlocked_recipes"].has(recipe_data["id"]):
			ids.append(recipe_data["id"])
		if ids.size() >= MAX_DAY_MENU_RECIPES:
			break
	return ids


func _create_restaurant_state(day_menu: Array) -> Dictionary:
	var orders: Array = _pick_order_recipes(day_menu)
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
	var next_arrival := now + FIRST_CUSTOMER_DELAY_SECONDS
	for index in range(DAILY_CUSTOMERS):
		var recipe: Dictionary = orders[index % orders.size()] as Dictionary
		customers.append({
			"id": index + 1,
			"order_recipe_id": recipe["id"],
			"arrives_at": next_arrival,
			"arrived_at": 0.0,
			"patience_seconds": CUSTOMER_PATIENCE_SECONDS + index * 2.5 + _get_customer_patience_bonus_seconds(),
			"satisfaction": "",
			"served": false,
			"state": "waiting_to_arrive"
		})
		next_arrival += rng.randf_range(MIN_CUSTOMER_ARRIVAL_GAP_SECONDS, MAX_CUSTOMER_ARRIVAL_GAP_SECONDS)

	return {"stoves": stoves, "customers": customers, "day_menu": day_menu.duplicate()}


func _show_restaurant() -> void:
	_show_restaurant_v2()


func _show_restaurant_v2() -> void:
	mode = "restaurant"
	_update_customer_arrivals()
	_reset_screen()
	_draw_restaurant_background()
	_add_top_bar([
		"$%s" % save["coins"],
		_inventory_chip_text(),
		"Atendidos %s/%s" % [day["summary"]["served"], DAILY_CUSTOMERS]
	])
	_add_toast(message)
	_draw_restaurant_status()
	_draw_stove_status()

	var panel := _bottom_panel(600)
	panel.add_child(_label("Cocina del puesto", 18, Color("#f6c177"), true))
	panel.add_child(_small_stat("Pedidos", _customer_summary()))

	var cook_row := HFlowContainer.new()
	cook_row.add_theme_constant_override("h_separation", 6)
	cook_row.add_theme_constant_override("v_separation", 4)
	cook_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for recipe_id in restaurant.get("day_menu", []):
		var recipe_data: Dictionary = _get_recipe(str(recipe_id))
		cook_row.add_child(_raw_dish_drag_card(recipe_data))
	panel.add_child(cook_row)

	var deliver_row := _button_row()
	var has_pending := false
	for customer_item in restaurant["customers"]:
		var customer_data: Dictionary = customer_item as Dictionary
		if _is_customer_present(customer_data) and not customer_data["served"]:
			has_pending = true
			deliver_row.add_child(_button("Servir C%s" % customer_data["id"], Callable(self, "_deliver_to_customer").bind(customer_data["id"]), false, "secondary"))
	if not has_pending:
		deliver_row.add_child(_button(_next_customer_label(), Callable(self, "_show_summary"), true, "secondary"))
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
	stove["ready_at"] = now + _get_cook_seconds(recipe)
	stove["ready"] = false
	message = "%s en la hornilla %s." % [recipe["short_name"], stove["id"] + 1]
	_show_restaurant()
	_persist_save()


func _start_cooking_on_stove(recipe_id: String, stove_id: int) -> void:
	var recipe: Dictionary = _get_recipe(recipe_id)
	var stove: Dictionary = _find_stove(stove_id)
	if stove.is_empty():
		message = "Esa hornilla no estÃ¡ disponible."
		_show_restaurant()
		return
	if stove["recipe_id"] != "":
		message = "La hornilla %s estÃ¡ ocupada." % (stove_id + 1)
		_show_restaurant()
		return
	if not _consume_recipe(recipe):
		message = "Faltan ingredientes para ese plato."
		_show_restaurant()
		return

	var now: float = Time.get_ticks_msec() / 1000.0
	stove["recipe_id"] = recipe["id"]
	stove["started_at"] = now
	stove["ready_at"] = now + _get_cook_seconds(recipe)
	stove["ready"] = false
	message = "%s en la hornilla %s." % [recipe["short_name"], stove["id"] + 1]
	_show_restaurant()
	_persist_save()


func _can_drop_recipe_on_stove(recipe_id: String, stove_id: int) -> bool:
	var recipe: Dictionary = _get_recipe(recipe_id)
	var stove: Dictionary = _find_stove(stove_id)
	return not stove.is_empty() and stove["recipe_id"] == "" and _can_cook(recipe)


func _deliver_to_customer(customer_id: int) -> void:
	var customer: Dictionary = _find_customer(customer_id)
	if customer.is_empty() or customer["served"]:
		message = "Ese cliente ya fue atendido."
		_show_restaurant()
		return
	if not _is_customer_present(customer):
		message = "Ese cliente todavía no ha llegado."
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
	var full_price: int = _get_dish_price(recipe["id"])
	var price: int = full_price if correct_dish else floori(full_price * 0.25)
	var final_price: int = floori(price * 0.5) if satisfaction == "unhappy" else price

	customer["served"] = true
	customer["satisfaction"] = satisfaction
	customer["state"] = "served"
	_clear_stove(stove)

	day["summary"]["served"] += 1
	day["summary"][satisfaction] += 1
	day["summary"]["revenue"] += final_price
	save["coins"] += final_price

	message = "%s entregado: +%s monedas." % [recipe["short_name"], final_price] if correct_dish else "Plato equivocado: el cliente dejó %s monedas." % final_price
	_show_restaurant()
	_persist_save()


func _update_stoves() -> bool:
	var now: float = Time.get_ticks_msec() / 1000.0
	var changed := false
	for stove_item in restaurant.get("stoves", []):
		var stove: Dictionary = stove_item as Dictionary
		if stove["recipe_id"] != "" and not stove["ready"] and now >= stove["ready_at"]:
			stove["ready"] = true
			changed = true
	return changed


func _update_customer_arrivals() -> bool:
	var now: float = Time.get_ticks_msec() / 1000.0
	var changed := false
	for customer_item in restaurant.get("customers", []):
		var customer: Dictionary = customer_item as Dictionary
		if customer["state"] == "waiting_to_arrive" and now >= customer["arrives_at"]:
			customer["state"] = "present"
			customer["arrived_at"] = now
			changed = true
	return changed


func _is_customer_present(customer: Dictionary) -> bool:
	return customer.get("state", "") == "present" or customer.get("state", "") == "served"


func _next_customer_label() -> String:
	var eta := _next_customer_eta_seconds()
	if eta >= 0:
		return "Próximo cliente %ss" % eta
	if day["summary"]["served"] >= DAILY_CUSTOMERS:
		return "Clientes atendidos"
	return "Esperando clientes"


func _next_customer_eta_seconds() -> int:
	var now: float = Time.get_ticks_msec() / 1000.0
	var best := -1.0
	for customer_item in restaurant.get("customers", []):
		var customer: Dictionary = customer_item as Dictionary
		if customer["state"] == "waiting_to_arrive":
			var eta: float = maxf(0.0, customer["arrives_at"] - now)
			if best < 0.0 or eta < best:
				best = eta
	if best < 0.0:
		return -1
	return ceili(best)


func _close_late_customers() -> bool:
	var now: float = Time.get_ticks_msec() / 1000.0
	var changed := false
	for customer_item in restaurant.get("customers", []):
		var customer: Dictionary = customer_item as Dictionary
		if customer["state"] == "present" and not customer["served"] and now - customer["arrived_at"] > customer["patience_seconds"]:
			customer["served"] = true
			customer["satisfaction"] = "unhappy"
			customer["state"] = "served"
			day["summary"]["served"] += 1
			day["summary"]["unhappy"] += 1
			changed = true
	return changed


func _show_summary() -> void:
	mode = "summary"
	_finalize_day()
	_reset_screen()
	_draw_summary_background()
	_add_day_summary_sheet()


func _finalize_day() -> void:
	if summary_finalized:
		return

	var summary: Dictionary = day["summary"] as Dictionary
	var earned_stars: int = 1 if summary["happy"] >= 3 or summary["revenue"] >= 70 else 0
	summary["stars_earned"] = earned_stars
	save["stars"] = min(5, save["stars"] + earned_stars)
	if save["best_day"] == null or summary["revenue"] > save["best_day"]["revenue"]:
		save["best_day"] = summary.duplicate(true)
	summary_finalized = true
	message = "El puerto empieza a hablar bien de tu sazón." if earned_stars > 0 else "El puesto sobrevivió, pero falta ganarse a Manta."
	_persist_save()


func _upgrade_restaurant() -> void:
	var cost := _get_upgrade_cost()
	if save["coins"] < cost:
		message = "Todavía no alcanza para mejorar el puesto."
		_show_summary()
		return

	save["coins"] -= cost
	save["upgrade_level"] += 1
	save["stars"] = min(5, max(save["stars"], save["upgrade_level"]))
	message = "Mejora %s lista: %s" % [save["upgrade_level"], _upgrade_effect_summary()]
	_show_summary()
	_persist_save()


func _get_upgrade_cost() -> int:
	var level := _get_upgrade_level()
	return 50 + level * 30 + max(0, level - 2) * 15


func _get_upgrade_level() -> int:
	return max(0, int(save.get("upgrade_level", 0)))


func _get_daily_casts() -> int:
	var level := _get_upgrade_level()
	return DAILY_CASTS + min(2, floori(float(level) / 2.0))


func _get_cook_seconds(recipe: Dictionary) -> float:
	var level := _get_upgrade_level()
	var multiplier: float = 1.0 - min(3, level) * 0.10
	return maxf(2.5, float(recipe["cook_seconds"]) * multiplier)


func _get_customer_patience_bonus_seconds() -> float:
	return float(min(3, _get_upgrade_level())) * 2.5


func _get_perfect_window_seconds() -> float:
	var level := _get_upgrade_level()
	return PERFECT_WINDOW_SECONDS + float(min(2, floori(float(level) / 2.0))) * 0.07


func _get_good_window_seconds() -> float:
	var level := _get_upgrade_level()
	return GOOD_WINDOW_SECONDS + float(min(2, floori(float(level) / 2.0))) * 0.08


func _get_dish_price(recipe_id: String) -> int:
	var level := _get_upgrade_level()
	var fame_bonus: float = float(min(3, max(0, level - 2))) * 0.08
	return int(round(float(DISH_PRICES[recipe_id]) * (1.0 + fame_bonus)))


func _inventory_chip_text() -> String:
	return "N %s | P %s" % [day["inventory"].get("normal_fish", 0), day["inventory"].get("premium_fish", 0)]


func _upgrade_effect_summary() -> String:
	var level := _get_upgrade_level()
	if level <= 0:
		return "Sin mejoras: cocina base, 5 lances y precios normales."

	var effects: Array = []
	effects.append("cocina %s%% más rápida" % int(min(3, level) * 10))
	effects.append("+%ss paciencia" % int(_get_customer_patience_bonus_seconds()))
	if _get_daily_casts() > DAILY_CASTS:
		var extra_casts := _get_daily_casts() - DAILY_CASTS
		effects.append("+%s lance%s" % [extra_casts, "" if extra_casts == 1 else "s"])
	if _get_perfect_window_seconds() > PERFECT_WINDOW_SECONDS:
		effects.append("pesca más estable")
	var price_bonus := int(round((float(_get_dish_price("ceviche_manta")) / float(DISH_PRICES["ceviche_manta"]) - 1.0) * 100.0))
	if price_bonus > 0:
		effects.append("+%s%% precios" % price_bonus)
	return "L%s: %s." % [level, " · ".join(effects)]


func _get_recipe(recipe_id: String) -> Dictionary:
	for recipe_item in RECIPES:
		var recipe: Dictionary = recipe_item as Dictionary
		if recipe["id"] == recipe_id:
			return recipe
	return RECIPES[0] as Dictionary


func _can_cook(recipe: Dictionary) -> bool:
	for ingredient_item in recipe["ingredients"]:
		var ingredient: Dictionary = ingredient_item as Dictionary
		if ingredient.get("quality", "normal") == "premium":
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
		if ingredient.get("quality", "normal") == "premium":
			day["inventory"]["premium_fish"] -= ingredient["amount"]
		else:
			day["inventory"]["normal_fish"] -= ingredient["amount"]
	return true


func _pick_order_recipes(day_menu: Array) -> Array:
	var cookable: Array = []
	for recipe_id in day_menu:
		var recipe_data: Dictionary = _get_recipe(str(recipe_id))
		if save["unlocked_recipes"].has(recipe_data["id"]) and _can_cook(recipe_data):
			cookable.append(recipe_data)
	if cookable.size() > 0:
		return cookable

	var unlocked: Array = []
	for recipe_id in day_menu:
		var unlocked_recipe: Dictionary = _get_recipe(str(recipe_id))
		if save["unlocked_recipes"].has(unlocked_recipe["id"]):
			unlocked.append(unlocked_recipe)
	if unlocked.is_empty():
		unlocked.append(RECIPES[0] as Dictionary)
	return unlocked


func _first_free_stove() -> Dictionary:
	for stove_item in restaurant["stoves"]:
		var stove: Dictionary = stove_item as Dictionary
		if stove["recipe_id"] == "":
			return stove
	return {}


func _find_stove(stove_id: int) -> Dictionary:
	for stove_item in restaurant["stoves"]:
		var stove: Dictionary = stove_item as Dictionary
		if int(stove["id"]) == stove_id:
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
	return _stove_summary_v2()


func _customer_summary() -> String:
	return _customer_summary_v2()


func _stove_summary_v2() -> String:
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


func _customer_summary_v2() -> String:
	var parts: Array = []
	for customer_item in restaurant["customers"]:
		var customer: Dictionary = customer_item as Dictionary
		if customer["state"] == "waiting_to_arrive":
			continue
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
	if parts.is_empty():
		return _next_customer_label()
	return " · ".join(parts)


func _draw_menu_background() -> void:
	_add_full_texture(MAIN_MENU_TEXTURE)
	_add_menu_ocean_shimmers()
	_add_menu_birds()


func _add_menu_birds() -> void:
	var viewport_size := get_viewport_rect().size
	var bird_specs := [
		{"height": 0.105, "scale": 0.052, "duration": 8.0, "delay": 0.0, "alpha": 0.92},
		{"height": 0.145, "scale": 0.059, "duration": 8.8, "delay": 2.7, "alpha": 0.94},
		{"height": 0.185, "scale": 0.066, "duration": 9.6, "delay": 5.4, "alpha": 0.90}
	]

	for spec in bird_specs:
		var base := Vector2(-viewport_size.x * 0.18, viewport_size.y * float(spec["height"]))
		var bird := _create_gull_sprite(base, float(spec["scale"]), float(spec["alpha"]), true)
		background_layer.add_child(bird)

		menu_birds.append({
			"node": bird,
			"base": base,
			"duration": float(spec["duration"]),
			"delay": float(spec["delay"]),
			"height": float(spec["height"])
		})


func _add_menu_ocean_shimmers() -> void:
	var viewport_size := get_viewport_rect().size
	var wave_specs := [
		{"anchor": Vector2(0.64, 0.520), "length": 118.0, "speed": 0.70, "phase": 0.0, "alpha": 0.17},
		{"anchor": Vector2(0.78, 0.565), "length": 152.0, "speed": 0.86, "phase": 1.2, "alpha": 0.20},
		{"anchor": Vector2(0.59, 0.660), "length": 108.0, "speed": 0.64, "phase": 2.0, "alpha": 0.12},
		{"anchor": Vector2(0.82, 0.735), "length": 170.0, "speed": 0.74, "phase": 3.4, "alpha": 0.16},
		{"anchor": Vector2(0.72, 0.890), "length": 126.0, "speed": 0.92, "phase": 4.1, "alpha": 0.11}
	]

	for spec in wave_specs:
		var wave := Line2D.new()
		wave.width = 3.0
		wave.default_color = Color(1.0, 0.78, 0.45, float(spec["alpha"]))
		var anchor: Vector2 = spec["anchor"] as Vector2
		wave.position = Vector2(anchor.x * viewport_size.x, anchor.y * viewport_size.y)
		var length := float(spec["length"])
		wave.add_point(Vector2(-length * 0.5, 0.0))
		wave.add_point(Vector2(-length * 0.12, -3.0))
		wave.add_point(Vector2(length * 0.18, 2.0))
		wave.add_point(Vector2(length * 0.5, 0.0))
		background_layer.add_child(wave)

		menu_waves.append({
			"node": wave,
			"base": wave.position,
			"speed": float(spec["speed"]),
			"phase": float(spec["phase"]),
			"alpha": float(spec["alpha"])
		})


func _animate_menu_scene(delta: float) -> void:
	menu_animation_time += delta
	for bird_data in menu_birds:
		var bird: Sprite2D = bird_data["node"] as Sprite2D
		if not is_instance_valid(bird):
			continue
		var viewport_size := get_viewport_rect().size
		var duration := float(bird_data["duration"])
		var cycle := duration + 2.0
		var elapsed := fmod(menu_animation_time + float(bird_data["delay"]), cycle)
		if elapsed > duration:
			bird.visible = false
			continue

		bird.visible = true
		var progress := elapsed / duration
		var phase := progress * TAU
		_set_gull_flight_frame(bird, menu_animation_time * 2.4 + float(bird_data["delay"]), true)
		bird.position = Vector2(
			lerpf(-0.18, 1.18, progress) * viewport_size.x,
			(float(bird_data["height"]) + sin(phase * 1.25) * 0.010) * viewport_size.y
		)
		bird.rotation_degrees = sin(phase * 0.9) * 1.6

	for wave_data in menu_waves:
		var wave: Line2D = wave_data["node"] as Line2D
		if not is_instance_valid(wave):
			continue
		var phase := menu_animation_time * float(wave_data["speed"]) + float(wave_data["phase"])
		var base: Vector2 = wave_data["base"] as Vector2
		wave.position = base + Vector2(sin(phase) * 16.0, sin(phase * 1.7) * 2.0)
		var wave_color := wave.default_color
		wave_color.a = float(wave_data["alpha"]) * (0.65 + 0.35 * sin(phase + 1.0))
		wave.default_color = wave_color


func _add_menu_hotspot(top_left: Vector2, bottom_right: Vector2, action: Callable, disabled := false) -> void:
	var button := Button.new()
	button.flat = true
	button.disabled = disabled
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_filter = Control.MOUSE_FILTER_STOP
	button.anchor_left = top_left.x
	button.anchor_right = bottom_right.x
	button.anchor_top = top_left.y
	button.anchor_bottom = bottom_right.y
	button.add_theme_stylebox_override("normal", _menu_hotspot_style(Color(1, 1, 1, 0.0)))
	button.add_theme_stylebox_override("hover", _menu_hotspot_style(Color(1.0, 0.88, 0.48, 0.16)))
	button.add_theme_stylebox_override("pressed", _menu_hotspot_style(Color(0.20, 0.08, 0.03, 0.20)))
	button.add_theme_stylebox_override("disabled", _menu_hotspot_style(Color(0, 0, 0, 0.0)))
	button.pressed.connect(action)
	ui_layer.add_child(button)


func _add_menu_notice(text: String) -> void:
	var container := CenterContainer.new()
	container.anchor_left = 0.08
	container.anchor_right = 0.92
	container.anchor_top = 0.49
	container.anchor_bottom = 0.55
	ui_layer.add_child(container)

	var notice := _text_panel(text, 14, Color("#e9f7ef"), true)
	notice.custom_minimum_size = Vector2(0, 42)
	container.add_child(notice)


func _quit_game() -> void:
	get_tree().quit()


func _draw_fishing_background() -> void:
	if not day.get("boat_rented", false):
		_add_full_texture(SHIPYARD_BACKGROUND_TEXTURE)
		_add_scene_band(Color(0.14, 0.11, 0.16, 0.34), 0.84, 1.0)
		return

	_add_full_texture(FISHING_BACKGROUND_TEXTURE)
	_draw_flying_gulls()
	_draw_animated_water()
	_add_scene_band(Color(0.14, 0.11, 0.16, 0.42), 0.84, 1.0)
	var boat_anchor := BOAT_ANCHOR
	var boat_scale := Vector2(2.28, 2.28)
	_add_texture(BOAT_TEXTURE, boat_anchor, boat_scale, 1.0, 0.0)
	_draw_fisherman()
	var fish_texture: Texture2D = FISH_PREMIUM_TEXTURE if fishing_phase == "bite" else FISH_NORMAL_TEXTURE
	var fish_alpha: float = 0.9 if fishing_phase == "bite" else 0.34
	var fish_bob := sin(_now_seconds() * 3.4) * 0.006
	_add_texture(fish_texture, FISH_ANCHOR + Vector2(0.0, fish_bob), Vector2(0.78, 0.78), fish_alpha)
	if not _fishing_actor_frame_has_tackle():
		_draw_fishing_lure()


func _draw_flying_gulls() -> void:
	var viewport_size := get_viewport_rect().size
	var time := _now_seconds()
	var cycle_seconds := GULL_FLIGHT_SECONDS + GULL_RESPAWN_SECONDS

	for index in range(GULL_COUNT):
		var phase := fmod(time + float(index) * 1.65, cycle_seconds)
		if phase >= GULL_FLIGHT_SECONDS:
			continue

		var progress := phase / GULL_FLIGHT_SECONDS
		var x := lerpf(-0.16, 1.16, progress) * viewport_size.x
		var sky_y := 0.15 + float(index % 3) * 0.055 + sin(time * 0.75 + float(index)) * 0.012
		var y := sky_y * viewport_size.y
		var scale := 0.052 + float(index) * 0.007
		var gull := _create_gull_sprite(Vector2(x, y), scale, 0.92, true)
		var flap_time := time + float(index) * 0.9
		_set_gull_flight_frame(gull, flap_time * 2.4, true)
		gull.rotation_degrees = sin(flap_time * 0.55) * 2.0
		background_layer.add_child(gull)


func _create_gull_sprite(position: Vector2, sprite_scale: float, alpha: float, fly_right := true) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.texture = GULL_GLIDE_TEXTURE
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.centered = true
	sprite.position = position
	sprite.scale = Vector2.ONE * sprite_scale
	sprite.flip_h = fly_right
	sprite.modulate.a = alpha
	return sprite


func _set_gull_flight_frame(sprite: Sprite2D, phase: float, fly_right := true, allow_dive := true) -> void:
	var frame_count := 4 if allow_dive else 3
	var frame := int(floor(phase * 2.0)) % frame_count
	var native_faces_right := false
	if frame == 0:
		sprite.texture = GULL_FLAP_UP_TEXTURE
	elif frame == 1:
		sprite.texture = GULL_GLIDE_TEXTURE
	elif frame == 2:
		sprite.texture = GULL_FLAP_DOWN_TEXTURE
	else:
		sprite.texture = GULL_DIVE_TEXTURE
		native_faces_right = true
	if fly_right:
		sprite.flip_h = not native_faces_right
	else:
		sprite.flip_h = native_faces_right


func _draw_fisherman() -> void:
	var fisher_texture: Texture2D = _current_fishing_actor_texture()
	var anchor := FISHERMAN_ANCHOR
	var actor_rotation := 0.0
	if fishing_phase == "bite" or (_now_seconds() - last_catch_started_at <= CATCH_REACTION_SECONDS and (last_catch_result == "perfect" or last_catch_result == "good")):
		var shake := sin(_now_seconds() * 38.0)
		anchor += Vector2(shake * 0.004, sin(_now_seconds() * 52.0) * 0.003)
		actor_rotation = shake * 2.4
	_add_fishing_actor_texture(fisher_texture, anchor, FISHERMAN_SCALE * _fishing_actor_frame_scale(fisher_texture), 1.0, actor_rotation)


func _add_fishing_actor_texture(texture: Texture2D, anchor: Vector2, texture_scale: Vector2, alpha: float, rotation_degrees_value := 0.0) -> void:
	var rect := TextureRect.new()
	rect.texture = texture
	rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	rect.modulate.a = alpha
	rect.rotation_degrees = rotation_degrees_value
	rect.anchor_left = anchor.x
	rect.anchor_right = anchor.x
	rect.anchor_top = anchor.y
	rect.anchor_bottom = anchor.y
	rect.custom_minimum_size = FISHING_ACTOR_BASE_SIZE * texture_scale
	rect.pivot_offset = rect.custom_minimum_size * 0.5
	rect.offset_left = -rect.custom_minimum_size.x / 2.0
	rect.offset_right = rect.custom_minimum_size.x / 2.0
	rect.offset_top = -rect.custom_minimum_size.y / 2.0
	rect.offset_bottom = rect.custom_minimum_size.y / 2.0
	background_layer.add_child(rect)


func _fishing_actor_frame_scale(texture: Texture2D) -> Vector2:
	if texture == FISHING_CAST_TEXTURE:
		return Vector2(1.28, 1.0)
	if texture == FISHING_WAIT_TEXTURE:
		return Vector2(1.32, 1.0)
	if texture == FISHING_BREATH_1_TEXTURE or texture == FISHING_BREATH_2_TEXTURE or texture == FISHING_BREATH_3_TEXTURE:
		return Vector2(1.22, 1.0)
	if texture == FISHING_BITE_TEXTURE:
		return Vector2(1.12, 1.0)
	if texture == FISHING_PULL_TEXTURE:
		return Vector2(1.20, 1.0)
	return Vector2.ONE


func _current_fishing_actor_texture() -> Texture2D:
	if fishing_phase == "waiting":
		if _now_seconds() - cast_started_at < 0.65:
			return FISHING_CAST_TEXTURE
		return _animated_waiting_fishing_texture()
	if fishing_phase == "breath":
		return _animated_breath_fishing_texture()
	if fishing_phase == "bite":
		return FISHING_BITE_TEXTURE
	if _now_seconds() - last_catch_started_at <= CATCH_REACTION_SECONDS and (last_catch_result == "perfect" or last_catch_result == "good"):
		return FISHING_PULL_TEXTURE
	return FISHING_REST_TEXTURE


func _animated_waiting_fishing_texture() -> Texture2D:
	var frame := int(floor((_now_seconds() - cast_started_at) / FISHERMAN_FRAME_SECONDS)) % 4
	if frame == 0:
		return FISHING_WAIT_TEXTURE
	if frame == 1:
		return FISHING_BREATH_1_TEXTURE
	if frame == 2:
		return FISHING_BREATH_2_TEXTURE
	return FISHING_BREATH_3_TEXTURE


func _animated_breath_fishing_texture() -> Texture2D:
	var frame := int(floor(_now_seconds() / (FISHERMAN_FRAME_SECONDS * 0.72))) % 3
	if frame == 0:
		return FISHING_BREATH_1_TEXTURE
	if frame == 1:
		return FISHING_BREATH_2_TEXTURE
	return FISHING_BREATH_3_TEXTURE


func _fishing_actor_frame_has_tackle() -> bool:
	return true


func _draw_fishing_lure() -> void:
	var lure_anchor := LURE_SURFACE_ANCHOR
	var lure_texture := LURE_TEXTURE
	var lure_scale: Vector2 = Vector2(0.34, 0.34)
	var ripple_alpha: float = 0.35
	var lure_rotation: float = 0.0

	if fishing_phase == "waiting":
		var bob := sin((_now_seconds() - lure_motion_started_at) * 8.0) * 0.008
		lure_anchor.y += bob
		lure_rotation = sin(_now_seconds() * 5.0) * 3.0
	elif fishing_phase == "breath":
		var ratio := _lure_motion_ratio()
		lure_anchor.y += sin(ratio * PI) * 0.045
		lure_anchor.x += sin(ratio * PI * 2.0) * 0.008
		lure_scale = Vector2(0.38, 0.38) + Vector2.ONE * sin(ratio * PI) * 0.05
		ripple_alpha = 0.75
		lure_rotation = sin(ratio * PI * 2.0) * 10.0
	elif fishing_phase == "bite":
		var bite_pulse: float = sin(_now_seconds() * 32.0)
		lure_anchor.y += 0.055 + bite_pulse * 0.004
		lure_anchor.x += bite_pulse * 0.004
		lure_texture = LURE_SINK_TEXTURE
		lure_scale = Vector2(0.42, 0.42) + Vector2.ONE * absf(bite_pulse) * 0.045
		ripple_alpha = 1.0
		lure_rotation = bite_pulse * 12.0

	if fishing_phase != "idle":
		_draw_fishing_line(lure_anchor)
		_add_ripple(lure_anchor + Vector2(0.0, 0.018), ripple_alpha)
		_add_texture(lure_texture, lure_anchor, lure_scale, 1.0, lure_rotation)
		if fishing_phase == "bite":
			var splash_scale: Vector2 = Vector2(0.58, 0.58) + Vector2.ONE * absf(sin(_now_seconds() * 20.0)) * 0.1
			_add_texture(BITE_SPLASH_TEXTURE, lure_anchor + Vector2(0.0, -0.018), splash_scale, 1.0, sin(_now_seconds() * 12.0) * 6.0)


func _draw_fishing_line(lure_anchor: Vector2) -> void:
	var viewport_size := get_viewport_rect().size
	var start := FISHING_ROD_TIP_ANCHOR * viewport_size
	var end := lure_anchor * viewport_size
	var mid: Vector2 = (start + end) * 0.5
	var sag: float = 34.0
	var jitter: float = 0.0
	if fishing_phase == "bite":
		sag = 8.0
		jitter = sin(_now_seconds() * 42.0) * 8.0
	elif fishing_phase == "breath":
		sag = 18.0 + sin(_now_seconds() * 18.0) * 5.0
	mid += Vector2(jitter, sag)
	_add_pixel_line([start, mid, end], Color("#1d1b1b"), 1.8)


func _add_pixel_line(points: Array, color: Color, width: float) -> void:
	var line := Line2D.new()
	line.width = width
	line.default_color = color
	line.antialiased = false
	line.joint_mode = Line2D.LINE_JOINT_SHARP
	line.begin_cap_mode = Line2D.LINE_CAP_BOX
	line.end_cap_mode = Line2D.LINE_CAP_BOX
	for point in points:
		line.add_point(point)
	background_layer.add_child(line)


func _draw_animated_water() -> void:
	var viewport_size := get_viewport_rect().size
	var time := _now_seconds()
	var water_tint := ColorRect.new()
	water_tint.color = Color(0.03, 0.36, 0.56, 0.16)
	water_tint.anchor_left = 0.0
	water_tint.anchor_right = 1.0
	water_tint.anchor_top = WATER_SURFACE_TOP
	water_tint.anchor_bottom = 1.0
	background_layer.add_child(water_tint)

	for index in range(18):
		var line := Line2D.new()
		line.width = 3.0 if index % 4 == 0 else 2.0
		line.default_color = Color(0.68, 0.94, 1.0, 0.42 if index % 2 == 0 else 0.25)
		var depth_ratio := float(index) / 17.0
		var y := viewport_size.y * (WATER_SURFACE_TOP + 0.018 + depth_ratio * 0.42)
		var segment_width := viewport_size.x / 6.0
		var x_offset := fmod(time * (34.0 + index * 3.4) + index * 47.0, segment_width * 2.0) - segment_width * 2.0
		for point_index in range(12):
			var x := x_offset + point_index * segment_width
			var wave := sin(time * (3.6 + depth_ratio * 1.8) + point_index * 0.95 + index) * (3.0 + depth_ratio * 5.5)
			line.add_point(Vector2(x, y + wave))
		background_layer.add_child(line)

	for index in range(14):
		var glint := ColorRect.new()
		var pulse := 0.5 + sin(time * 4.8 + index * 1.7) * 0.5
		glint.color = Color(1.0, 0.96, 0.72, (0.22 + pulse * 0.34) if index % 2 == 0 else (0.13 + pulse * 0.24))
		glint.anchor_left = 0.0
		glint.anchor_right = 0.0
		glint.anchor_top = 0.0
		glint.anchor_bottom = 0.0
		var drift := fmod(time * (48.0 + index * 5.5) + index * 73.0, viewport_size.x + 180.0) - 90.0
		var center_x := drift
		var center_y := viewport_size.y * (WATER_SURFACE_TOP + 0.045 + float(index % 7) * 0.058)
		var width := 34.0 + pulse * 58.0
		glint.offset_left = center_x - width * 0.5
		glint.offset_right = center_x + width * 0.5
		glint.offset_top = center_y
		glint.offset_bottom = center_y + (2.0 if index % 3 == 0 else 1.0)
		background_layer.add_child(glint)

	var boat_center := BOAT_ANCHOR * viewport_size
	for index in range(7):
		var wake := Line2D.new()
		wake.width = 3.0 if index < 2 else 2.0
		wake.default_color = Color(0.88, 0.98, 1.0, 0.42 - float(index) * 0.035)
		var side := -1.0 if index % 2 == 0 else 1.0
		var start := boat_center + Vector2(side * (42.0 + index * 7.0), 8.0 + index * 5.0)
		for point_index in range(6):
			var x := side * (point_index * 20.0 + sin(time * 5.5 + index + point_index) * 5.0)
			var y := sin(time * 5.0 + point_index * 1.4 + index) * 4.0 + point_index * 2.0
			wake.add_point(start + Vector2(x, y))
		background_layer.add_child(wake)

	for index in range(8):
		var sparkle := ColorRect.new()
		var flash := 0.5 + sin(time * 6.5 + index * 2.1) * 0.5
		sparkle.color = Color(1.0, 1.0, 0.88, 0.24 + flash * 0.48)
		sparkle.anchor_left = 0.0
		sparkle.anchor_right = 0.0
		sparkle.anchor_top = 0.0
		sparkle.anchor_bottom = 0.0
		var sparkle_x := fmod(time * (58.0 + index * 8.0) + index * 91.0, viewport_size.x + 80.0) - 40.0
		var sparkle_y := viewport_size.y * (WATER_SURFACE_TOP + 0.08 + float(index % 5) * 0.075)
		var sparkle_size := 3.0 + flash * 4.0
		sparkle.offset_left = sparkle_x - sparkle_size * 0.5
		sparkle.offset_right = sparkle_x + sparkle_size * 0.5
		sparkle.offset_top = sparkle_y - sparkle_size * 0.5
		sparkle.offset_bottom = sparkle_y + sparkle_size * 0.5
		background_layer.add_child(sparkle)


func _draw_restaurant_background() -> void:
	_add_full_texture(_current_restaurant_texture())
	_add_scene_band(Color(0.02, 0.05, 0.06, 0.24), 0.0, 0.18)
	_add_scene_band(Color(0.02, 0.05, 0.06, 0.18), 0.82, 1.0)
	var cook_time: float = _now_seconds()
	var cook_anchor: Vector2 = _restaurant_cook_anchor() + Vector2(sin(cook_time * 1.6) * 0.003, sin(cook_time * 2.1) * 0.004)
	var cook_scale: Vector2 = Vector2(1.25, 2.45) + Vector2(0.025, -0.035) * sin(cook_time * 2.1)
	var cook_rotation: float = sin(cook_time * 1.35) * 1.1
	_add_texture(_current_cook_texture(), cook_anchor, cook_scale, 1.0, cook_rotation)
	_draw_seated_customers()


func _current_restaurant_texture() -> Texture2D:
	if int(save.get("upgrade_level", 0)) >= 1:
		return RESTAURANT_UPGRADED_TEXTURE
	return RESTAURANT_BASE_TEXTURE


func _restaurant_is_upgraded() -> bool:
	return int(save.get("upgrade_level", 0)) >= 1


func _restaurant_cook_anchor() -> Vector2:
	if _restaurant_is_upgraded():
		return Vector2(0.27, 0.69)
	return Vector2(0.33, 0.66)


func _restaurant_table_positions() -> Array:
	if _restaurant_is_upgraded():
		return [
			Vector2(0.26, 0.38),
			Vector2(0.42, 0.39),
			Vector2(0.62, 0.39),
			Vector2(0.78, 0.39)
		]
	return [
		Vector2(0.38, 0.42),
		Vector2(0.67, 0.42),
		Vector2(0.34, 0.49),
		Vector2(0.72, 0.49)
	]


func _client_placeholder_texture(customer_id: int) -> Texture2D:
	match ((customer_id - 1) % 4) + 1:
		1:
			return CLIENT_PLACEHOLDER_1_TEXTURE
		2:
			return CLIENT_PLACEHOLDER_2_TEXTURE
		3:
			return CLIENT_PLACEHOLDER_3_TEXTURE
		_:
			return CLIENT_PLACEHOLDER_4_TEXTURE


func _draw_seated_customers() -> void:
	var positions: Array = _restaurant_table_positions()
	var seated_index := 0
	var now: float = Time.get_ticks_msec() / 1000.0
	for customer_item in restaurant.get("customers", []):
		var customer: Dictionary = customer_item as Dictionary
		if customer["state"] == "waiting_to_arrive":
			continue
		var base_position: Vector2 = positions[seated_index % positions.size()]
		var offset: Vector2 = Vector2(0.018 * (float(seated_index) / float(positions.size())), 0.0)
		var customer_position: Vector2 = base_position + offset
		var customer_id: int = int(customer["id"])
		_add_texture(_client_placeholder_texture(customer_id), customer_position, Vector2(0.42, 0.62), 1.0)
		_add_customer_table_label(customer, customer_position + Vector2(0.0, -0.055), now)
		seated_index += 1


func _add_customer_table_label(customer: Dictionary, anchor: Vector2, now: float) -> void:
	var recipe: Dictionary = _get_recipe(customer["order_recipe_id"])
	var status_text := ""
	if customer["served"]:
		status_text = "%s %s" % [recipe["short_name"], _face_for(customer["satisfaction"])]
	else:
		var patience_left: int = max(0, ceili(customer["patience_seconds"] - (now - customer["arrived_at"])))
		status_text = "%s · %ss" % [recipe["short_name"], patience_left]

	var container := CenterContainer.new()
	container.anchor_left = anchor.x
	container.anchor_right = anchor.x
	container.anchor_top = anchor.y
	container.anchor_bottom = anchor.y
	container.offset_left = -58
	container.offset_right = 58
	container.offset_top = -22
	container.offset_bottom = 22
	background_layer.add_child(container)

	var chip := _text_panel(status_text, 11, Color("#e9f7ef"), true)
	chip.custom_minimum_size = Vector2(108, 32)
	container.add_child(chip)


func _draw_summary_background() -> void:
	_add_full_texture(DAY_SUMMARY_TEXTURE)


func _add_day_summary_sheet() -> void:
	var sheet := MarginContainer.new()
	sheet.anchor_left = 0.12
	sheet.anchor_right = 0.88
	sheet.anchor_top = 0.435
	sheet.anchor_bottom = 0.845
	sheet.add_theme_constant_override("margin_left", 10)
	sheet.add_theme_constant_override("margin_right", 10)
	sheet.add_theme_constant_override("margin_top", 8)
	sheet.add_theme_constant_override("margin_bottom", 8)
	ui_layer.add_child(sheet)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 6)
	sheet.add_child(content)

	var title := _summary_text("Resumen del dia", 23, true)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(title)

	content.add_child(_summary_money_banner("Caja actual", "$%s" % save["coins"]))
	content.add_child(_summary_line("Ventas", "%s monedas" % day["summary"]["revenue"]))
	content.add_child(_summary_line("Clientes", "%s atendidos" % day["summary"]["served"]))
	content.add_child(_summary_line("Animo", "%s felices / %s neutras / %s molestas" % [day["summary"]["happy"], day["summary"]["neutral"], day["summary"]["unhappy"]]))
	content.add_child(_summary_line("Pesca", "%s perfectas / %s buenas / %s fallidas" % [day["summary"]["perfect_catches"], day["summary"]["good_catches"], day["summary"]["failed_catches"]]))
	content.add_child(_summary_line("Estrellas", "%s / 5" % save["stars"]))
	content.add_child(_summary_upgrade_card("Mejora %s" % save["upgrade_level"], _upgrade_effect_summary()))

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_child(spacer)

	if message != "":
		var note := _summary_text(message, 14, false)
		note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		content.add_child(note)

	var controls := _button_row()
	var upgrade_cost := _get_upgrade_cost()
	controls.add_child(_button("Mejorar (%s)" % upgrade_cost, Callable(self, "_upgrade_restaurant"), save["coins"] < upgrade_cost, "upgrade"))
	controls.add_child(_button("Siguiente dia", Callable(self, "_start_next_day"), false, "secondary"))
	content.add_child(controls)


func _summary_line(label_text: String, value_text: String) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	row.custom_minimum_size = Vector2(0, 31)

	var label := _summary_text(label_text, 14, true)
	label.custom_minimum_size = Vector2(104, 0)
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.clip_text = true
	row.add_child(label)

	var value := _summary_text(value_text, 14, false)
	value.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	value.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	row.add_child(value)
	return row


func _summary_money_banner(label_text: String, value_text: String) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", _summary_money_style())

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	panel.add_child(row)

	var label := _label(label_text, 14, Color("#e9f7ef"), true)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	row.add_child(label)

	var value := _label(value_text, 22, Color("#ffe08a"), true)
	value.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	value.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	value.custom_minimum_size = Vector2(126, 0)
	value.autowrap_mode = TextServer.AUTOWRAP_OFF
	value.clip_text = true
	row.add_child(value)
	return panel


func _summary_upgrade_card(label_text: String, value_text: String) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", _summary_upgrade_style())

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 2)
	panel.add_child(content)

	var label := _summary_text(label_text, 13, true)
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.clip_text = true
	content.add_child(label)

	var value := _summary_text(value_text, 13, false)
	value.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	value.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(value)
	return panel


func _summary_text(text: String, font_size: int, bold := false) -> Label:
	var label := _label(text, font_size, Color("#533219"), bold)
	label.add_theme_color_override("font_shadow_color", Color(1.0, 0.88, 0.56, 0.35))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)
	return label


func _summary_rule() -> ColorRect:
	var rule := ColorRect.new()
	rule.color = Color("#bf7a3c")
	rule.custom_minimum_size = Vector2(0, 2)
	return rule


func _draw_restaurant_status() -> void:
	if _has_visible_restaurant_customers():
		return
	_draw_waiting_customer_hint()


func _has_visible_restaurant_customers() -> bool:
	for customer_item in restaurant.get("customers", []):
		var customer: Dictionary = customer_item as Dictionary
		if customer["state"] != "waiting_to_arrive":
			return true
	return false


func _draw_waiting_customer_hint() -> void:
	var container := CenterContainer.new()
	container.anchor_left = 0.0
	container.anchor_right = 1.0
	container.anchor_top = 0.38
	container.anchor_bottom = 0.38
	container.offset_left = 18
	container.offset_right = -18
	background_layer.add_child(container)

	var waiting := _text_panel(_next_customer_label(), 16, Color("#e9f7ef"), true)
	waiting.custom_minimum_size = Vector2(280, 58)
	container.add_child(waiting)


func _draw_stove_status() -> void:
	var shelf := HBoxContainer.new()
	shelf.anchor_left = 0.26
	shelf.anchor_right = 0.98
	shelf.anchor_top = 0.61
	shelf.anchor_bottom = 0.72
	shelf.alignment = BoxContainer.ALIGNMENT_CENTER
	shelf.add_theme_constant_override("separation", 6)
	ui_layer.add_child(shelf)

	var now: float = Time.get_ticks_msec() / 1000.0
	for stove_item in restaurant.get("stoves", []):
		var stove: Dictionary = stove_item as Dictionary
		var card := StoveDropSlot.new()
		card.main = self
		card.stove_id = int(stove["id"])
		card.custom_minimum_size = Vector2(72, 72)
		card.add_theme_stylebox_override("panel", _stove_drop_slot_style(stove))
		var content := VBoxContainer.new()
		content.name = "Content"
		content.alignment = BoxContainer.ALIGNMENT_CENTER
		content.add_theme_constant_override("separation", 1)
		content.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_child(content)
		var stove_label := _label("H%s" % (stove["id"] + 1), 11, Color("#e9f7ef"), true)
		stove_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		stove_label.autowrap_mode = TextServer.AUTOWRAP_OFF
		content.add_child(stove_label)
		if stove["recipe_id"] == "":
			var free_label := _label("Libre", 11, Color("#67d391"), true)
			free_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			free_label.autowrap_mode = TextServer.AUTOWRAP_OFF
			content.add_child(free_label)
		else:
			var recipe: Dictionary = _get_recipe(stove["recipe_id"])
			var plate := TextureRect.new()
			plate.texture = _raw_dish_texture(str(recipe["id"]))
			plate.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			plate.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			plate.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			plate.custom_minimum_size = Vector2(44, 28)
			plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
			content.add_child(plate)
			var state: String = "Listo" if stove["ready"] else "%ss" % max(0, ceili(stove["ready_at"] - now))
			var state_label := _label(state, 11, Color("#f6c177") if stove["ready"] else Color("#e9f7ef"), true)
			state_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			state_label.autowrap_mode = TextServer.AUTOWRAP_OFF
			content.add_child(state_label)
		shelf.add_child(card)


func _current_cook_texture() -> Texture2D:
	var frame_index: int = int(_now_seconds() * 4.0) % 2
	if _has_active_stoves():
		return COOK_WALK_1_TEXTURE if frame_index == 0 else COOK_WALK_2_TEXTURE
	return COOK_IDLE_1_TEXTURE if frame_index == 0 else COOK_IDLE_2_TEXTURE


func _has_active_stoves() -> bool:
	for stove_item in restaurant.get("stoves", []):
		var stove: Dictionary = stove_item as Dictionary
		if stove["recipe_id"] != "":
			return true
	return false


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


func _add_ripple(anchor: Vector2, alpha: float) -> void:
	var viewport_size := get_viewport_rect().size
	var ring := Line2D.new()
	ring.width = 3.0
	ring.default_color = Color(0.92, 1.0, 0.96, alpha)
	var center: Vector2 = Vector2(anchor.x * viewport_size.x, anchor.y * viewport_size.y)
	var radius := 22.0 + (alpha * 18.0)
	for index in range(18):
		var angle: float = (TAU / 17.0) * index
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


func _add_texture(texture: Texture2D, anchor: Vector2, texture_scale: Vector2, alpha: float, rotation_degrees_value := 0.0) -> void:
	var rect := TextureRect.new()
	rect.texture = texture
	rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	rect.modulate.a = alpha
	rect.rotation_degrees = rotation_degrees_value
	rect.anchor_left = anchor.x
	rect.anchor_right = anchor.x
	rect.anchor_top = anchor.y
	rect.anchor_bottom = anchor.y
	rect.custom_minimum_size = Vector2(160, 120) * texture_scale
	rect.pivot_offset = rect.custom_minimum_size * 0.5
	rect.offset_left = -rect.custom_minimum_size.x / 2.0
	rect.offset_right = rect.custom_minimum_size.x / 2.0
	rect.offset_top = -rect.custom_minimum_size.y / 2.0
	rect.offset_bottom = rect.custom_minimum_size.y / 2.0
	background_layer.add_child(rect)


func _add_sprite_frame(texture: Texture2D, frame: int, anchor: Vector2, texture_scale: Vector2, alpha: float) -> void:
	var frame_size: Vector2 = Vector2(48, 48)
	var atlas := AtlasTexture.new()
	atlas.atlas = texture
	atlas.region = Rect2(frame_size.x * frame, 0.0, frame_size.x, frame_size.y)
	_add_texture(atlas, anchor, texture_scale, alpha)


func _center_text(text: String, font_size: int, color: Color, anchor: Vector2) -> Label:
	var label := _label(text, font_size, color, true)
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


func _add_top_bar(items: Array, reserve_right_space := false) -> void:
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_right", 84 if reserve_right_space else 12)
	margin.add_theme_constant_override("margin_top", 10)
	ui_layer.add_child(margin)

	var row := HFlowContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	row.add_theme_constant_override("h_separation", 6)
	row.add_theme_constant_override("v_separation", 6)
	margin.add_child(row)

	for item in items:
		var chip := _chip(str(item))
		chip.custom_minimum_size = Vector2(104, 32)
		chip.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		row.add_child(chip)


func _add_top_menu_button() -> void:
	var button := _button("menu", Callable(self, "_return_to_main_menu"), false, "secondary")
	button.custom_minimum_size = Vector2(68, 36)
	button.z_index = 50
	button.mouse_filter = Control.MOUSE_FILTER_STOP
	button.anchor_left = 1.0
	button.anchor_right = 1.0
	button.anchor_top = 0.0
	button.anchor_bottom = 0.0
	button.offset_left = -80
	button.offset_right = -12
	button.offset_top = 10
	button.offset_bottom = 46
	ui_layer.add_child(button)


func _add_toast(text: String) -> void:
	if text == "":
		return

	var container := CenterContainer.new()
	container.anchor_left = 0.0
	container.anchor_right = 1.0
	container.anchor_top = 0.18
	container.anchor_bottom = 0.18
	container.offset_left = 16
	container.offset_right = -16
	ui_layer.add_child(container)

	var toast := _text_panel(text, 14, Color("#e9f7ef"), true)
	toast.custom_minimum_size = Vector2(maxf(260.0, get_viewport_rect().size.x - 32.0), 48)
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
	perfect_mark.anchor_left = _get_perfect_window_seconds() / _get_good_window_seconds()
	perfect_mark.anchor_right = perfect_mark.anchor_left
	perfect_mark.anchor_top = 0.0
	perfect_mark.anchor_bottom = 1.0
	perfect_mark.offset_left = -1
	perfect_mark.offset_right = 1
	track_content.add_child(perfect_mark)


func _fishing_meter_ratio() -> float:
	if fishing_phase == "bite":
		return clampf(_bite_elapsed() / _get_good_window_seconds(), 0.0, 1.0)
	if fishing_phase == "breath":
		return clampf(_lure_motion_ratio(), 0.0, 1.0)
	var wait_progress := 1.0 - clampf(bite_timer.time_left / maxf(0.001, bite_timer.wait_time), 0.0, 1.0)
	return wait_progress


func _bottom_panel(width := 460) -> VBoxContainer:
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 10)
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
	var panel_width: float = minf(float(width), maxf(280.0, viewport_width - 24.0))

	var panel := VBoxContainer.new()
	panel.custom_minimum_size = Vector2(panel_width, 0)
	panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	panel.add_theme_constant_override("separation", 8)
	panel.add_theme_stylebox_override("panel", _panel_style())

	var panel_container := PanelContainer.new()
	panel_container.add_theme_stylebox_override("panel", _panel_style())
	panel_container.add_child(panel)
	center.add_child(panel_container)
	return panel


func _day_menu_panel() -> VBoxContainer:
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_top", 78)
	margin.add_theme_constant_override("margin_bottom", 22)
	ui_layer.add_child(margin)

	var center := CenterContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(center)

	var viewport_width: float = get_viewport_rect().size.x
	var panel_width: float = minf(520.0, maxf(300.0, viewport_width - 24.0))

	var panel_container := PanelContainer.new()
	panel_container.custom_minimum_size = Vector2(panel_width, 0)
	panel_container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	panel_container.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	panel_container.add_theme_stylebox_override("panel", _day_menu_panel_style())
	center.add_child(panel_container)

	var panel := VBoxContainer.new()
	panel.add_theme_constant_override("separation", 8)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel_container.add_child(panel)
	return panel


func _day_menu_rule() -> ColorRect:
	var rule := ColorRect.new()
	rule.color = Color("#f4d58d")
	rule.custom_minimum_size = Vector2(0, 2)
	rule.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return rule


func _bottom_controls() -> GridContainer:
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_bottom", 10)
	ui_layer.add_child(margin)

	var outer := VBoxContainer.new()
	outer.alignment = BoxContainer.ALIGNMENT_END
	outer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	outer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(outer)

	var grid := GridContainer.new()
	grid.columns = 2
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_theme_constant_override("h_separation", 6)
	grid.add_theme_constant_override("v_separation", 6)
	outer.add_child(grid)
	return grid


func _button_row() -> GridContainer:
	var row := GridContainer.new()
	row.columns = 2
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("h_separation", 6)
	row.add_theme_constant_override("v_separation", 6)
	return row


func _button(text: String, action: Callable, disabled := false, variant := "primary", press_on_down := false) -> Button:
	var button := Button.new()
	button.text = text
	button.disabled = disabled
	button.custom_minimum_size = Vector2(0, 48)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_stylebox_override("normal", _button_style(variant, disabled))
	button.add_theme_stylebox_override("hover", _button_style(variant, disabled, 1.08))
	button.add_theme_stylebox_override("pressed", _button_style(variant, disabled, 0.92))
	var font_color := Color("#1d1b1b") if variant == "primary" else Color("#e9f7ef")
	if variant == "upgrade" and not disabled:
		font_color = Color("#fff3bf")
	button.add_theme_color_override("font_color", font_color)
	button.add_theme_font_size_override("font_size", 15)
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
	var label := _label(text, 13, Color("#e9f7ef"), true)
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
	card.custom_minimum_size = Vector2(126, 104)
	card.add_theme_stylebox_override("panel", _light_panel_style())

	var content := VBoxContainer.new()
	content.name = "Content"
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	content.add_theme_constant_override("separation", 4)
	card.add_child(content)
	return card


func _stove_card() -> PanelContainer:
	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(112, 88)
	card.add_theme_stylebox_override("panel", _chip_style())

	var content := VBoxContainer.new()
	content.name = "Content"
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	content.add_theme_constant_override("separation", 4)
	card.add_child(content)
	return card


func _raw_dish_card_style(disabled: bool, multiplier := 1.0) -> StyleBoxFlat:
	var color := Color("#123d46")
	if disabled:
		color = Color("#1d2525")
	elif multiplier > 1.0:
		color = color.lightened(multiplier - 1.0)
	elif multiplier < 1.0:
		color = color.darkened(1.0 - multiplier)

	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = Color("#f4d58d") if not disabled else Color(0.92, 0.97, 0.94, 0.18)
	style.set_border_width_all(1)
	style.set_corner_radius_all(6)
	_set_style_margins(style, 4)
	return style


func _stove_drop_slot_style(stove: Dictionary) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	if stove["recipe_id"] == "":
		style.bg_color = Color(0.03, 0.18, 0.15, 0.84)
		style.border_color = Color("#67d391")
	elif bool(stove["ready"]):
		style.bg_color = Color(0.24, 0.20, 0.06, 0.88)
		style.border_color = Color("#f6c177")
	else:
		style.bg_color = Color(0.10, 0.07, 0.04, 0.88)
		style.border_color = Color("#d84a3a")
	style.set_border_width_all(1)
	style.set_corner_radius_all(5)
	_set_style_margins(style, 4)
	return style


func _small_stat(label_text: String, value_text: String) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	var label := _label(label_text, 13, Color("#f6c177"), true)
	label.custom_minimum_size = Vector2(76, 0)
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.clip_text = true
	var value := _label(value_text, 13, Color("#e9f7ef"))
	value.autowrap_mode = TextServer.AUTOWRAP_OFF
	value.clip_text = true
	value.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	value.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(label)
	row.add_child(value)
	return row


func _text_panel(text: String, font_size: int, color: Color, bold := false) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", _chip_style())

	var label := _label(text, font_size, color, bold)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_child(label)
	return panel


func _label(text: String, font_size: int, color: Color, bold := false) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
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
	_set_style_margins(style, 12)
	return style


func _chip_style() -> StyleBoxFlat:
	var style := _panel_style()
	style.bg_color = Color(0.03, 0.12, 0.15, 0.82)
	_set_style_margins(style, 7)
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
	_set_style_margins(style, 7)
	return style


func _day_menu_panel_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#123d46")
	style.border_color = Color("#f4d58d")
	style.set_border_width_all(3)
	style.set_corner_radius_all(2)
	_set_style_margins(style, 10)
	return style


func _day_menu_choice_style(selected: bool, muted: bool, multiplier := 1.0) -> StyleBoxFlat:
	var color := Color("#8f9f91")
	if selected:
		color = Color("#2f7f73")
	if muted:
		color = Color("#687a73")
	if multiplier > 1.0:
		color = color.lightened(multiplier - 1.0)
	elif multiplier < 1.0:
		color = color.darkened(1.0 - multiplier)

	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = Color("#f4d58d") if selected else Color("#b98b4b")
	style.set_border_width_all(2)
	style.set_corner_radius_all(2)
	_set_style_margins(style, 0)
	return style


func _day_menu_icon_slot_style(selected: bool) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#06252d")
	style.border_color = Color("#f4d58d") if selected else Color("#d8f3dc")
	style.set_border_width_all(2)
	style.set_corner_radius_all(2)
	_set_style_margins(style, 4)
	return style


func _summary_money_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#153d2f")
	style.border_color = Color("#f4d58d")
	style.set_border_width_all(2)
	style.set_corner_radius_all(6)
	_set_style_margins(style, 8)
	return style


func _summary_upgrade_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(1.0, 0.91, 0.63, 0.42)
	style.border_color = Color("#bf7a3c")
	style.set_border_width_all(1)
	style.set_corner_radius_all(6)
	_set_style_margins(style, 7)
	return style


func _button_style(variant: String, disabled: bool, multiplier := 1.0) -> StyleBoxFlat:
	var color := Color("#f6c177")
	if variant == "secondary":
		color = Color("#227c8d")
	elif variant == "danger":
		color = Color("#d84a3a")
	elif variant == "upgrade":
		color = Color("#2f7f43")
	elif variant == "cast":
		color = Color("#0f6f7d")
	if disabled:
		color = color.darkened(0.45)
	elif multiplier > 1.0:
		color = color.lightened(multiplier - 1.0)
	elif multiplier < 1.0:
		color = color.darkened(1.0 - multiplier)

	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.set_corner_radius_all(8)
	_set_style_margins(style, 8)
	return style


func _menu_hotspot_style(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = Color(1.0, 0.92, 0.62, color.a * 0.85)
	style.set_border_width_all(2 if color.a > 0.0 else 0)
	style.set_corner_radius_all(8)
	return style


func _set_style_margins(style: StyleBox, margin: float) -> void:
	style.set_content_margin(SIDE_LEFT, margin)
	style.set_content_margin(SIDE_TOP, margin)
	style.set_content_margin(SIDE_RIGHT, margin)
	style.set_content_margin(SIDE_BOTTOM, margin)
