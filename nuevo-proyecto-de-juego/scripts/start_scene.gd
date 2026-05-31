extends Control


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color("#0d3b5e")
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 40)
	margin.add_theme_constant_override("margin_top", 32)
	margin.add_theme_constant_override("margin_right", 40)
	margin.add_theme_constant_override("margin_bottom", 32)
	add_child(margin)

	var center := CenterContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(center)

	var panel := VBoxContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	panel.custom_minimum_size = Vector2(0, 0)
	panel.add_theme_constant_override("separation", 18)
	center.add_child(panel)

	var title := Label.new()
	title.text = "Navegantes del Spondylus"
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 42)
	title.add_theme_color_override("font_color", Color("#f0a500"))
	panel.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "El Astillero Ancestral"
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 28)
	subtitle.add_theme_color_override("font_color", Color("#2ebfa5"))
	panel.add_child(subtitle)

	var intro := Label.new()
	intro.text = "Ano 900 d.C., costas del Pacifico Sur. El astillero de Manta es el corazon del mundo manteno. Eres Amaru, maestro artesano naval. Una expedicion sagrada debe llevar las conchas Spondylus al norte antes de que la alianza entre pueblos se rompa."
	intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	intro.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	intro.add_theme_font_size_override("font_size", 22)
	intro.add_theme_color_override("font_color", Color("#f5f0e8"))
	panel.add_child(intro)

	var start_button := Button.new()
	start_button.text = "Iniciar expedicion"
	start_button.custom_minimum_size = Vector2(280, 64)
	start_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	start_button.pressed.connect(_on_start_pressed)
	panel.add_child(start_button)


func _on_start_pressed() -> void:
	GameState.reset_game()
	SceneManager.go_to_shipyard()
