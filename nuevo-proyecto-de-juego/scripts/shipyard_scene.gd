extends Control

var status_label: Label
var message_label: Label
var options_box: VBoxContainer
var sail_button: Button


func _ready() -> void:
	GameState.state_changed.connect(_refresh)
	_build_ui()
	_refresh()


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color("#6b3a2a")
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 24)
	margin.add_theme_constant_override("margin_top", 18)
	margin.add_theme_constant_override("margin_right", 24)
	margin.add_theme_constant_override("margin_bottom", 18)
	add_child(margin)

	var root := VBoxContainer.new()
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_theme_constant_override("separation", 12)
	margin.add_child(root)

	var title := Label.new()
	title.text = "Astillero de Manta"
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title.add_theme_font_size_override("font_size", 34)
	title.add_theme_color_override("font_color", Color("#f0a500"))
	root.add_child(title)

	status_label = Label.new()
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_label.add_theme_color_override("font_color", Color("#f5f0e8"))
	root.add_child(status_label)

	message_label = Label.new()
	message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	message_label.add_theme_color_override("font_color", Color("#2ebfa5"))
	root.add_child(message_label)

	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(scroll)

	options_box = VBoxContainer.new()
	options_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	options_box.add_theme_constant_override("separation", 10)
	scroll.add_child(options_box)

	sail_button = Button.new()
	sail_button.text = "Zarpar hacia la Ruta del Spondylus"
	sail_button.custom_minimum_size = Vector2(0, 58)
	sail_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sail_button.pressed.connect(_on_sail_pressed)
	root.add_child(sail_button)


func _refresh() -> void:
	if status_label == null:
		return
	status_label.text = "%s\nAcciones de preparacion restantes: %d\nBalsa: %d/%d | Reputacion: %d" % [
		GameState.resource_summary(),
		GameState.actions_remaining,
		GameState.ship_integrity,
		GameState.max_ship_integrity,
		GameState.reputation,
	]
	sail_button.text = "Zarpar hacia la Ruta del Spondylus (%d acciones restantes)" % GameState.actions_remaining
	for child in options_box.get_children():
		child.queue_free()
	var current_group := ""
	for option in GameState.get_shipyard_options():
		if option["group"] != current_group:
			current_group = option["group"]
			var heading := Label.new()
			heading.text = current_group
			heading.add_theme_font_size_override("font_size", 24)
			heading.add_theme_color_override("font_color", Color("#f0a500"))
			options_box.add_child(heading)
		options_box.add_child(_make_option_row(option))


func _make_option_row(option: Dictionary) -> Control:
	var row := PanelContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#0d3b5e")
	style.border_color = Color("#f0a500")
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	row.add_theme_stylebox_override("panel", style)

	var box := VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_theme_constant_override("separation", 6)
	row.add_child(box)

	var label := Label.new()
	label.text = "%s\n%s\nCosto: %s" % [option["title"], option["desc"], _format_cost(option["cost"])]
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_color_override("font_color", Color("#f5f0e8"))
	box.add_child(label)

	var button := Button.new()
	button.text = "Elegir"
	button.custom_minimum_size = Vector2(0, 46)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.disabled = GameState.actions_remaining <= 0 or GameState._is_unique_option_taken(option["id"]) or not _can_afford(option["cost"])
	button.pressed.connect(func() -> void:
		message_label.text = GameState.apply_shipyard_option(option["id"])
		_refresh()
	)
	box.add_child(button)
	return row


func _format_cost(cost: Dictionary) -> String:
	var parts: Array[String] = []
	for key in cost.keys():
		parts.append("%s %d" % [key, cost[key]])
	return ", ".join(parts)


func _can_afford(cost: Dictionary) -> bool:
	for key in cost.keys():
		if GameState.resources.get(key, 0) < int(cost[key]):
			return false
	return true


func _on_sail_pressed() -> void:
	GameState.start_voyage()
	SceneManager.go_to_voyage()
