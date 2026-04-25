extends Control

signal direction_changed(dir: Vector2)

const OUTER_R = 65.0
const KNOB_R  = 26.0
const SIZE    = OUTER_R * 2 + 4.0

var knob: Panel
var dragging: bool = false
var center: Vector2

func _ready() -> void:
	# Tamanho real precisa ser definido explicitamente
	size = Vector2(SIZE, SIZE)
	custom_minimum_size = Vector2(SIZE, SIZE)
	mouse_filter = Control.MOUSE_FILTER_STOP
	center = Vector2(SIZE / 2.0, SIZE / 2.0)

	# Anel externo — tamanho explícito, não por âncoras
	var outer = Panel.new()
	outer.position = Vector2(0, 0)
	outer.size = Vector2(SIZE, SIZE)
	outer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var s_outer = StyleBoxFlat.new()
	s_outer.bg_color = Color(0.05, 0.05, 0.12, 0.65)
	s_outer.border_color = Color(0.7, 0.7, 1.0, 0.75)
	s_outer.set_border_width_all(2)
	s_outer.set_corner_radius_all(int(OUTER_R))
	outer.add_theme_stylebox_override("panel", s_outer)
	add_child(outer)

	# Knob
	knob = Panel.new()
	knob.size = Vector2(KNOB_R * 2, KNOB_R * 2)
	knob.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var s_knob = StyleBoxFlat.new()
	s_knob.bg_color = Color(0.72, 0.72, 1.0, 0.90)
	s_knob.set_corner_radius_all(int(KNOB_R))
	knob.add_theme_stylebox_override("panel", s_knob)
	add_child(knob)

	_reset()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			_move(event.position)
		else:
			dragging = false
			_reset()
	elif event is InputEventMouseMotion and dragging:
		_move(event.position)
	elif event is InputEventScreenTouch:
		if event.pressed:
			dragging = true
			_move(event.position)
		else:
			dragging = false
			_reset()
	elif event is InputEventScreenDrag and dragging:
		_move(event.position)

func _move(pos: Vector2) -> void:
	var offset = pos - center
	if offset.length() > OUTER_R:
		offset = offset.normalized() * OUTER_R
	knob.position = center + offset - Vector2(KNOB_R, KNOB_R)
	direction_changed.emit(offset / OUTER_R)

func _reset() -> void:
	knob.position = center - Vector2(KNOB_R, KNOB_R)
	direction_changed.emit(Vector2.ZERO)
