extends Control

const CARD_UI := preload("res://scenes/CartaUI.tscn")
const ALERT_UI := preload("res://scenes/AlertaEvento.tscn")

var profile_box: VBoxContainer
var resources_box: HBoxContainer
var event_banner: Label
var progress_bar: ProgressBar
var status_label: Label
var log_label: Label
var hand_box: HBoxContainer
var customize_summary: Label
var alert
var expanded_card
var last_alert_event := ""


func _ready() -> void:
	GameState.state_changed.connect(_refresh)
	_build_ui()
	_refresh()


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color("#0b2e44")
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_bottom", 12)
	add_child(margin)

	var root := VBoxContainer.new()
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_theme_constant_override("separation", 10)
	margin.add_child(root)

	var top := HBoxContainer.new()
	top.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.size_flags_vertical = Control.SIZE_EXPAND_FILL
	top.add_theme_constant_override("separation", 12)
	root.add_child(top)

	profile_box = VBoxContainer.new()
	profile_box.custom_minimum_size = Vector2(210, 0)
	profile_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	profile_box.add_theme_constant_override("separation", 8)
	top.add_child(_panel(profile_box))

	var center := VBoxContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	center.add_theme_constant_override("separation", 8)
	top.add_child(center)

	resources_box = HBoxContainer.new()
	resources_box.alignment = BoxContainer.ALIGNMENT_CENTER
	resources_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	resources_box.add_theme_constant_override("separation", 10)
	center.add_child(resources_box)

	event_banner = Label.new()
	event_banner.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	event_banner.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	event_banner.add_theme_font_size_override("font_size", 16)
	event_banner.add_theme_color_override("font_color", Color("#fff8e8"))
	center.add_child(_panel(event_banner, Color("#6b3a2a")))

	var ocean := PanelContainer.new()
	ocean.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ocean.size_flags_vertical = Control.SIZE_EXPAND_FILL
	ocean.add_theme_stylebox_override("panel", _style(Color("#17637a"), Color("#2ebfa5")))
	center.add_child(ocean)

	var ocean_box := VBoxContainer.new()
	ocean_box.alignment = BoxContainer.ALIGNMENT_CENTER
	ocean_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ocean_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	ocean_box.add_theme_constant_override("separation", 12)
	ocean.add_child(ocean_box)

	var ship := Label.new()
	ship.text = "      /|\\\n+====/ | \\====+\n\\___ Navegantes ___/"
	ship.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ship.add_theme_font_size_override("font_size", 28)
	ship.add_theme_color_override("font_color", Color("#fff8e8"))
	ocean_box.add_child(ship)

	progress_bar = ProgressBar.new()
	progress_bar.max_value = GameState.MAX_PROGRESS
	progress_bar.custom_minimum_size = Vector2(0, 28)
	progress_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ocean_box.add_child(progress_bar)

	var actions := VBoxContainer.new()
	actions.custom_minimum_size = Vector2(230, 0)
	actions.size_flags_vertical = Control.SIZE_EXPAND_FILL
	actions.add_theme_constant_override("separation", 10)
	top.add_child(_panel(actions))

	status_label = Label.new()
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_label.add_theme_font_size_override("font_size", 18)
	status_label.add_theme_color_override("font_color", Color("#fff8e8"))
	actions.add_child(status_label)

	var sail_button := Button.new()
	sail_button.text = "Zarpar"
	sail_button.disabled = true
	sail_button.custom_minimum_size = Vector2(0, 48)
	sail_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	actions.add_child(sail_button)

	var customize_button := Button.new()
	customize_button.text = "Personalizar balsa"
	customize_button.custom_minimum_size = Vector2(0, 42)
	customize_button.pressed.connect(func() -> void:
		customize_summary.visible = not customize_summary.visible
	)
	actions.add_child(customize_button)

	customize_summary = Label.new()
	customize_summary.visible = false
	customize_summary.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	customize_summary.add_theme_color_override("font_color", Color("#f0d88a"))
	actions.add_child(customize_summary)

	log_label = Label.new()
	log_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	log_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	log_label.add_theme_font_size_override("font_size", 13)
	log_label.add_theme_color_override("font_color", Color("#d7e8e4"))
	actions.add_child(log_label)

	var hand_panel := PanelContainer.new()
	hand_panel.custom_minimum_size = Vector2(0, 285)
	hand_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hand_panel.add_theme_stylebox_override("panel", _style(Color("#102f3f"), Color("#f0a500")))
	root.add_child(hand_panel)

	var hand_scroll := ScrollContainer.new()
	hand_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	hand_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	hand_panel.add_child(hand_scroll)

	hand_box = HBoxContainer.new()
	hand_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hand_box.alignment = BoxContainer.ALIGNMENT_CENTER
	hand_box.add_theme_constant_override("separation", 14)
	hand_scroll.add_child(hand_box)

	alert = ALERT_UI.instantiate()
	add_child(alert)


func _refresh() -> void:
	if profile_box == null:
		return
	if GameState.game_over or GameState.victory:
		SceneManager.go_to_results()
		return
	_refresh_profile()
	_refresh_resources()
	_refresh_event()
	_refresh_actions()
	_refresh_hand()


func _refresh_profile() -> void:
	_clear(profile_box)
	_add_heading(profile_box, "Capitan Amaru")
	_add_body(profile_box, "Balsa del Spondylus")
	_add_body(profile_box, "Tripulacion activa: %d" % GameState.active_crew_count())
	var crew_labels := GameState.active_crew_labels()
	_add_body(profile_box, "Habilidades: %s" % ("Ninguna" if crew_labels.is_empty() else ", ".join(crew_labels)))


func _refresh_resources() -> void:
	_clear(resources_box)
	resources_box.add_child(_resource_tile("Balsa", GameState.ship_integrity, GameState.max_ship_integrity))
	resources_box.add_child(_resource_tile("Sumin", GameState.resources.get("suministros", 0), -1))
	resources_box.add_child(_resource_tile("Rep", GameState.reputation, -1))
	resources_box.add_child(_resource_tile("Turno", GameState.turn, GameState.MAX_TURNS))
	progress_bar.value = GameState.progress


func _refresh_event() -> void:
	if GameState.evento_activo.is_empty():
		event_banner.text = "Mar abierto: sin evento activo"
		last_alert_event = ""
		return
	event_banner.text = "%s %s - resuelve con %s" % [
		GameState.evento_activo.get("icono", "!"),
		GameState.evento_activo["nombre"],
		", ".join(GameState.evento_activo.get("evento_compatible", [])),
	]
	if last_alert_event != GameState.evento_activo["nombre"]:
		last_alert_event = GameState.evento_activo["nombre"]
		alert.show_event(GameState.evento_activo)


func _refresh_actions() -> void:
	status_label.text = "Elige una carta.\n%s" % ("Evento activo" if not GameState.evento_activo.is_empty() else "Turno de travesia")
	var improvements := GameState.active_improvement_labels()
	customize_summary.text = "Mejoras activas: %s" % ("Ninguna" if improvements.is_empty() else ", ".join(improvements))
	log_label.text = GameState.latest_logs_text()


func _refresh_hand() -> void:
	_clear(hand_box)
	expanded_card = null
	for card in GameState.hand:
		var card_ui := CARD_UI.instantiate()
		hand_box.add_child(card_ui)
		card_ui.setup(card, GameState.evento_activo)
		card_ui.card_selected.connect(_on_card_selected)
		card_ui.card_expanded.connect(_on_card_expanded)


func _on_card_selected(card_id: String) -> void:
	GameState.play_card(card_id)


func _on_card_expanded(card_ui) -> void:
	if expanded_card != null and expanded_card != card_ui:
		expanded_card.set_selected(false)
		expanded_card.contraer()
	expanded_card = card_ui


func _resource_tile(label_text: String, value: int, max_value: int) -> Control:
	var tile := VBoxContainer.new()
	tile.custom_minimum_size = Vector2(96, 58)
	tile.alignment = BoxContainer.ALIGNMENT_CENTER
	var title := Label.new()
	title.text = label_text
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 13)
	title.add_theme_color_override("font_color", Color("#d7e8e4"))
	tile.add_child(title)
	var value_label := Label.new()
	value_label.text = "%d/%d" % [value, max_value] if max_value > 0 else str(value)
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	value_label.add_theme_font_size_override("font_size", 22)
	value_label.add_theme_color_override("font_color", Color("#ff7070") if value <= 2 else Color("#fff8e8"))
	tile.add_child(value_label)
	return _panel(tile, Color("#12384a"))


func _panel(child: Control, color := Color("#12384a")) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", _style(color, Color("#315d6a")))
	panel.add_child(child)
	return panel


func _style(bg: Color, border: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = border
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left = 12
	style.content_margin_top = 10
	style.content_margin_right = 12
	style.content_margin_bottom = 10
	return style


func _add_heading(parent: Container, text: String) -> void:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", 22)
	label.add_theme_color_override("font_color", Color("#f0a500"))
	parent.add_child(label)


func _add_body(parent: Container, text: String) -> void:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", 15)
	label.add_theme_color_override("font_color", Color("#fff8e8"))
	parent.add_child(label)


func _clear(node: Node) -> void:
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()
