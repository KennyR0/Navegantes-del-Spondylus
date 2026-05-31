extends Control

signal alerta_cerrada
signal evento_resuelto(nombre_evento: String)

var current_event: Dictionary = {}
var name_label: Label
var desc_label: Label
var hint_label: Label


func _ready() -> void:
	visible = false
	mouse_filter = Control.MOUSE_FILTER_STOP
	_build_ui()


func show_event(event: Dictionary) -> void:
	current_event = event
	if current_event.is_empty():
		return
	name_label.text = "%s %s" % [current_event.get("icono", "!"), current_event["nombre"]]
	desc_label.text = current_event["descripcion"]
	hint_label.text = "Juega una carta de %s para resolverlo." % ", ".join(current_event.get("evento_compatible", []))
	visible = true
	modulate.a = 1.0
	var tween := create_tween()
	tween.tween_interval(2.6)
	tween.tween_callback(close)


func close() -> void:
	if not visible:
		return
	visible = false
	alerta_cerrada.emit()


func _build_ui() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)

	var shade := ColorRect.new()
	shade.color = Color(0.02, 0.04, 0.06, 0.48)
	shade.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(shade)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(460, 220)
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#163f56")
	style.border_color = Color("#f0a500")
	style.border_width_left = 3
	style.border_width_top = 3
	style.border_width_right = 3
	style.border_width_bottom = 3
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left = 18
	style.content_margin_top = 16
	style.content_margin_right = 18
	style.content_margin_bottom = 16
	panel.add_theme_stylebox_override("panel", style)
	center.add_child(panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	panel.add_child(box)

	name_label = Label.new()
	name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	name_label.add_theme_font_size_override("font_size", 25)
	name_label.add_theme_color_override("font_color", Color("#fff8e8"))
	box.add_child(name_label)

	desc_label = Label.new()
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc_label.add_theme_font_size_override("font_size", 17)
	desc_label.add_theme_color_override("font_color", Color("#fff8e8"))
	box.add_child(desc_label)

	hint_label = Label.new()
	hint_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hint_label.add_theme_font_size_override("font_size", 15)
	hint_label.add_theme_color_override("font_color", Color("#64d36f"))
	box.add_child(hint_label)

	var close_button := Button.new()
	close_button.text = "Cerrar"
	close_button.custom_minimum_size = Vector2(0, 42)
	close_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	close_button.pressed.connect(close)
	box.add_child(close_button)
