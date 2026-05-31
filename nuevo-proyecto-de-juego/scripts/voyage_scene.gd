extends Control

var stats_label: Label
var log_label: Label
var hand_box: VBoxContainer


func _ready() -> void:
	GameState.state_changed.connect(_refresh)
	_build_ui()
	_refresh()


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color("#0d3b5e")
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 14)
	add_child(margin)

	var root := VBoxContainer.new()
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_theme_constant_override("separation", 14)
	margin.add_child(root)

	stats_label = Label.new()
	stats_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	stats_label.add_theme_font_size_override("font_size", 20)
	stats_label.add_theme_color_override("font_color", Color("#f5f0e8"))
	root.add_child(stats_label)

	var ocean := ColorRect.new()
	ocean.color = Color("#2f6f95")
	ocean.custom_minimum_size = Vector2(0, 96)
	ocean.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.add_child(ocean)

	var help := Label.new()
	help.text = "Elige 1 carta para resolver el turno."
	help.add_theme_font_size_override("font_size", 24)
	help.add_theme_color_override("font_color", Color("#f0a500"))
	root.add_child(help)

	var hand_scroll := ScrollContainer.new()
	hand_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hand_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(hand_scroll)

	hand_box = VBoxContainer.new()
	hand_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hand_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	hand_box.add_theme_constant_override("separation", 10)
	hand_scroll.add_child(hand_box)

	log_label = Label.new()
	log_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	log_label.add_theme_color_override("font_color", Color("#f5f0e8"))
	log_label.custom_minimum_size = Vector2(0, 120)
	log_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.add_child(log_label)


func _refresh() -> void:
	if stats_label == null:
		return
	stats_label.text = GameState.voyage_summary()
	log_label.text = GameState.latest_logs_text()
	for child in hand_box.get_children():
		child.queue_free()
	if GameState.game_over or GameState.victory:
		SceneManager.go_to_results()
		return
	for card in GameState.hand:
		hand_box.add_child(_make_card_row(card))


func _make_card_row(card: Dictionary) -> Control:
	var row := PanelContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.custom_minimum_size = Vector2(0, 126)
	var style := StyleBoxFlat.new()
	style.bg_color = CardDatabase.get_category_color(card["category"])
	style.border_color = Color("#f0a500")
	style.border_width_left = 5
	style.border_width_top = 5
	style.border_width_right = 5
	style.border_width_bottom = 5
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	row.add_theme_stylebox_override("panel", style)

	var box := VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_theme_constant_override("separation", 8)
	row.add_child(box)

	var label := Label.new()
	label.text = "%s\n%s" % [card["title"], card["text"]]
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_color_override("font_color", Color("#f5f0e8"))
	label.add_theme_font_size_override("font_size", 18)
	box.add_child(label)

	var button := Button.new()
	button.text = "Jugar carta"
	button.custom_minimum_size = Vector2(0, 44)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.pressed.connect(func() -> void:
		GameState.play_card(card["id"])
		_refresh()
	)
	box.add_child(button)
	return row
