extends Control


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color("#1a7a4a" if GameState.victory else "#3b1f1b")
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 36)
	margin.add_theme_constant_override("margin_top", 28)
	margin.add_theme_constant_override("margin_right", 36)
	margin.add_theme_constant_override("margin_bottom", 28)
	add_child(margin)

	var center := CenterContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(center)

	var panel := VBoxContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	panel.custom_minimum_size = Vector2(0, 0)
	panel.add_theme_constant_override("separation", 16)
	center.add_child(panel)

	var heading := Label.new()
	heading.text = "Resultado de la Expedicion"
	heading.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.add_theme_font_size_override("font_size", 36)
	heading.add_theme_color_override("font_color", Color("#f0a500"))
	panel.add_child(heading)

	var title := Label.new()
	title.text = GameState.result_title
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 34)
	title.add_theme_color_override("font_color", Color("#f5f0e8"))
	panel.add_child(title)

	var message := Label.new()
	message.text = GameState.result_message
	message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message.add_theme_font_size_override("font_size", 22)
	message.add_theme_color_override("font_color", Color("#f5f0e8"))
	panel.add_child(message)

	var score := Label.new()
	score.text = "Puntaje total: %d\n%s" % [GameState.last_score, GameState.voyage_summary()]
	score.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	score.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	score.add_theme_font_size_override("font_size", 22)
	score.add_theme_color_override("font_color", Color("#f5f0e8"))
	panel.add_child(score)

	var retry := Button.new()
	retry.text = "Intentar otra expedicion"
	retry.custom_minimum_size = Vector2(280, 56)
	retry.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	retry.pressed.connect(_on_retry_pressed)
	panel.add_child(retry)

	var menu := Button.new()
	menu.text = "Volver al inicio"
	menu.custom_minimum_size = Vector2(280, 48)
	menu.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	menu.pressed.connect(_on_menu_pressed)
	panel.add_child(menu)


func _on_retry_pressed() -> void:
	GameState.reset_game()
	SceneManager.go_to_shipyard()


func _on_menu_pressed() -> void:
	GameState.reset_game()
	SceneManager.go_to_start()
