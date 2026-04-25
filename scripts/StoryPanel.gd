extends Control

signal fechou

const CARD_W   = 680.0
const CARD_H   = 1050.0
const MAP_W    = 720.0
const MAP_H    = 1280.0
const CENTER_X = (MAP_W - CARD_W) / 2.0
const CENTER_Y = (MAP_H - CARD_H) / 2.0

var _slides: Array = []
var _idx: int = 0
var _busy: bool = false

var _card: Control
var _band: ColorRect
var _emoji_lbl: Label
var _titulo_lbl: Label
var _texto_lbl: Label
var _hint_lbl: Label
var _tween: Tween

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	z_index = 100
	mouse_filter = Control.MOUSE_FILTER_STOP

	# Full-screen dim
	var dim = ColorRect.new()
	dim.color = Color(0, 0, 0, 0.82)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(dim)

	# Sliding card
	_card = Control.new()
	_card.size = Vector2(CARD_W, CARD_H)
	_card.position = Vector2(MAP_W + 20, CENTER_Y)
	add_child(_card)

	# Card background
	var panel = PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	var sty = StyleBoxFlat.new()
	sty.bg_color = Color(0.07, 0.07, 0.12)
	sty.set_corner_radius_all(20)
	sty.set_border_width_all(2)
	sty.border_color = Color(0.28, 0.28, 0.45, 0.8)
	panel.add_theme_stylebox_override("panel", sty)
	_card.add_child(panel)

	var outer = VBoxContainer.new()
	outer.set_anchors_preset(Control.PRESET_FULL_RECT)
	outer.add_theme_constant_override("separation", 0)
	panel.add_child(outer)

	# Colored band — top ~38% acts as the "image" area
	_band = ColorRect.new()
	_band.custom_minimum_size = Vector2(0, CARD_H * 0.38)
	_band.color = Color(0.15, 0.08, 0.25)
	_band.mouse_filter = Control.MOUSE_FILTER_IGNORE
	outer.add_child(_band)

	_emoji_lbl = Label.new()
	_emoji_lbl.text = "⭐"
	_emoji_lbl.add_theme_font_size_override("font_size", 100)
	_emoji_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_emoji_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_emoji_lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	_emoji_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_band.add_child(_emoji_lbl)

	# Text area
	var tm = MarginContainer.new()
	tm.add_theme_constant_override("margin_left", 34)
	tm.add_theme_constant_override("margin_right", 34)
	tm.add_theme_constant_override("margin_top", 30)
	tm.add_theme_constant_override("margin_bottom", 26)
	tm.size_flags_vertical = Control.SIZE_EXPAND_FILL
	outer.add_child(tm)

	var tv = VBoxContainer.new()
	tv.add_theme_constant_override("separation", 14)
	tm.add_child(tv)

	_titulo_lbl = Label.new()
	_titulo_lbl.add_theme_font_size_override("font_size", 26)
	_titulo_lbl.add_theme_color_override("font_color", Color.WHITE)
	_titulo_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	tv.add_child(_titulo_lbl)

	_texto_lbl = Label.new()
	_texto_lbl.add_theme_font_size_override("font_size", 16)
	_texto_lbl.add_theme_color_override("font_color", Color(0.78, 0.78, 0.88))
	_texto_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	tv.add_child(_texto_lbl)

	var sp = Control.new()
	sp.size_flags_vertical = Control.SIZE_EXPAND_FILL
	tv.add_child(sp)

	var sep = ColorRect.new()
	sep.color = Color(0.3, 0.3, 0.42, 0.5)
	sep.custom_minimum_size = Vector2(0, 1)
	sep.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tv.add_child(sep)

	_hint_lbl = Label.new()
	_hint_lbl.add_theme_font_size_override("font_size", 13)
	_hint_lbl.add_theme_color_override("font_color", Color(0.50, 0.50, 0.65))
	_hint_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tv.add_child(_hint_lbl)

func iniciar(slides: Array) -> void:
	_slides = slides
	_idx = 0
	visible = true
	_mostrar_slide(0)

func _mostrar_slide(idx: int) -> void:
	_busy = true
	var s = _slides[idx]

	_band.color = s.get("cor", Color(0.12, 0.08, 0.22))
	_emoji_lbl.text = s.get("emoji", "⭐")
	_titulo_lbl.text = s.get("titulo", "")
	_texto_lbl.text = s.get("texto", "")

	var total = _slides.size()
	if total == 1:
		_hint_lbl.text = "Toque para fechar  ✓"
	elif idx < total - 1:
		_hint_lbl.text = "Toque para continuar   %d / %d" % [idx + 1, total]
	else:
		_hint_lbl.text = "Toque para começar  ✓"

	# Slide in from right
	_card.position.x = MAP_W + 20
	if _tween:
		_tween.kill()
	_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	_tween.tween_property(_card, "position:x", CENTER_X, 0.4)
	_tween.tween_callback(func(): _busy = false)

func _input(event: InputEvent) -> void:
	if not visible or _busy or _slides.is_empty():
		return
	var pressed = false
	if event is InputEventMouseButton:
		pressed = event.pressed and event.button_index == MOUSE_BUTTON_LEFT
	elif event is InputEventScreenTouch:
		pressed = event.pressed
	if pressed:
		get_viewport().set_input_as_handled()
		_avancar()

func _avancar() -> void:
	_busy = true
	if _tween:
		_tween.kill()
	_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	_tween.tween_property(_card, "position:x", -(CARD_W + 20), 0.28)
	_tween.tween_callback(_proximo)

func _proximo() -> void:
	_idx += 1
	if _idx >= _slides.size():
		visible = false
		fechou.emit()
		queue_free()
	else:
		_mostrar_slide(_idx)
