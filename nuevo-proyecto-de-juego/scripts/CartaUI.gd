extends PanelContainer

signal card_selected(card_id: String)
signal card_expanded(card_ui)

const BASE_CARD_SIZE := Vector2(128, 172)
const ANIMATION_TIME := 0.16

var card: Dictionary = {}
var active_event: Dictionary = {}
var expandida := false
var seleccionada := false
var animation_tween: Tween

var title_label: Label
var category_label: Label
var effect_label: Label
var resolve_label: Label
var play_button: Button


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)
	_build_ui()
	contraer(true)


func setup(new_card: Dictionary, event: Dictionary) -> void:
	card = new_card
	active_event = event
	if title_label == null:
		return
	_refresh()


func set_selected(value: bool) -> void:
	seleccionada = value
	_apply_style()
	if seleccionada:
		expandir()
	else:
		contraer()


func expandir() -> void:
	if expandida:
		return
	expandida = true
	card_expanded.emit(self)
	effect_label.visible = true
	resolve_label.visible = true
	_animate_card(true)


func contraer(force := false) -> void:
	if not expandida and not force:
		return
	expandida = false
	_animate_card(false)
	if effect_label != null:
		effect_label.visible = false
	if resolve_label != null:
		resolve_label.visible = false


func _build_ui() -> void:
	custom_minimum_size = BASE_CARD_SIZE
	size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	size_flags_vertical = Control.SIZE_SHRINK_END

	var box := VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_theme_constant_override("separation", 6)
	add_child(box)

	title_label = Label.new()
	title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title_label.add_theme_font_size_override("font_size", 14)
	title_label.add_theme_color_override("font_color", Color("#fff8e8"))
	box.add_child(title_label)

	category_label = Label.new()
	category_label.add_theme_font_size_override("font_size", 12)
	category_label.add_theme_color_override("font_color", Color("#f0d88a"))
	box.add_child(category_label)

	play_button = Button.new()
	play_button.text = "Jugar"
	play_button.custom_minimum_size = Vector2(0, 34)
	play_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	play_button.mouse_filter = Control.MOUSE_FILTER_STOP
	play_button.pressed.connect(func() -> void:
		card_selected.emit(card["id"])
	)
	box.add_child(play_button)

	effect_label = Label.new()
	effect_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	effect_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	effect_label.add_theme_font_size_override("font_size", 13)
	effect_label.add_theme_color_override("font_color", Color("#fff8e8"))
	box.add_child(effect_label)

	resolve_label = Label.new()
	resolve_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	resolve_label.add_theme_font_size_override("font_size", 12)
	box.add_child(resolve_label)

	_refresh()


func _refresh() -> void:
	if card.is_empty():
		return
	title_label.text = card["title"]
	category_label.text = card["category"].capitalize()
	effect_label.text = "%s\nPreparacion: %s" % [card["text"], _format_preparation()]
	var resolves := CardDatabase.card_resolves_event(card, active_event)
	var value := EventSystem.card_preparation_for_event(card, active_event)
	resolve_label.text = "+%d preparacion util" % value if resolves else "+1 apoyo general"
	resolve_label.add_theme_color_override("font_color", Color("#64d36f") if resolves else Color("#d7c7a1"))
	_apply_style()


func _apply_style() -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = CardDatabase.get_category_color(card.get("category", ""))
	style.border_color = Color("#64d36f") if CardDatabase.card_resolves_event(card, active_event) else Color("#f0a500")
	if seleccionada:
		style.border_color = Color("#fff8e8")
	style.border_width_left = 4
	style.border_width_top = 4
	style.border_width_right = 4
	style.border_width_bottom = 4
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left = 10
	style.content_margin_top = 10
	style.content_margin_right = 10
	style.content_margin_bottom = 10
	add_theme_stylebox_override("panel", style)


func _on_mouse_entered() -> void:
	expandir()


func _on_mouse_exited() -> void:
	if not seleccionada:
		contraer()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			expandir()
		elif not seleccionada:
			contraer()
	elif event is InputEventMouseButton and event.pressed:
		set_selected(true)


func _animate_card(is_hovered: bool) -> void:
	if animation_tween != null:
		animation_tween.kill()
	z_index = 10 if is_hovered else 0
	animation_tween = create_tween()
	animation_tween.set_parallel(true)
	animation_tween.set_trans(Tween.TRANS_QUAD)
	animation_tween.set_ease(Tween.EASE_OUT)
	animation_tween.tween_property(self, "modulate", Color(1.08, 1.08, 1.08, 1.0) if is_hovered else Color.WHITE, ANIMATION_TIME)


func _format_preparation() -> String:
	var parts: Array[String] = []
	var preparation: Dictionary = card.get("preparacion", {})
	for key in preparation.keys():
		parts.append("%s +%d" % [str(key), int(preparation[key])])
	return ", ".join(parts)
