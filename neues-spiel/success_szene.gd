extends Control

var figur = ""
var step = 0
var total_frames = 0
var frame_display: TextureRect

func set_figur(f):
	figur = f

func _ready():
	_build_ui()
	total_frames = _count_frames()
	call_deferred("_init_frame_display")

func _build_ui():

	var bg = TextureRect.new()
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.texture = load("res://Assets/Background/Untergrund.png")
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	add_child(bg)
	move_child(bg, 0)

	frame_display = TextureRect.new()
	frame_display.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	frame_display.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	add_child(frame_display)

	var title = Label.new()
	title.text = "FERTIG!"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	title.offset_top = 40
	title.add_theme_font_size_override("font_size", 110)
	add_child(title)

	var back = Button.new()
	back.text = "ZURÜCK"
	back.custom_minimum_size = Vector2(360, 130)
	back.position = Vector2(40, 40)
	_style_button(back)
	back.add_theme_font_size_override("font_size", 32)
	back.pressed.connect(_on_back)
	add_child(back)

	var next = Button.new()
	next.text = "WEITER ZUM REGAL"
	next.custom_minimum_size = Vector2(460, 180)
	_style_button(next)
	next.add_theme_font_size_override("font_size", 38)
	next.pressed.connect(_go_regal)
	add_child(next)

	next.anchor_left = 1
	next.anchor_top = 1
	next.anchor_right = 1
	next.anchor_bottom = 1
	next.offset_left = -520
	next.offset_top = -260
	next.offset_right = -40
	next.offset_bottom = -40

func _init_frame_display():

	var sz = min(get_viewport_rect().size.x, get_viewport_rect().size.y) * 0.35

	frame_display.anchor_left = 0.5
	frame_display.anchor_top = 0.5
	frame_display.anchor_right = 0.5
	frame_display.anchor_bottom = 0.5

	frame_display.offset_left = -sz / 2.0
	frame_display.offset_right = sz / 2.0
	frame_display.offset_top = -sz / 2.0 + 90
	frame_display.offset_bottom = sz / 2.0 + 90

	if total_frames > 0:
		_update_frame()
	else:
		frame_display.visible = false

func _count_frames() -> int:
	var i = 1
	while ResourceLoader.exists("res://Assets/%s/%s_%d.png" % [figur, figur.to_lower(), i]):
		i += 1
	return i - 1

func _update_frame():
	var path = "res://Assets/%s/%s_%d.png" % [figur, figur.to_lower(), total_frames]
	frame_display.texture = load(path)

func _style_button(btn: Button):

	var normal = StyleBoxFlat.new()
	normal.bg_color = Color(0.16, 0.16, 0.20)
	normal.corner_radius_top_left = 24
	normal.corner_radius_top_right = 24
	normal.corner_radius_bottom_left = 24
	normal.corner_radius_bottom_right = 24
	normal.content_margin_left = 30
	normal.content_margin_right = 30
	normal.content_margin_top = 18
	normal.content_margin_bottom = 18

	var hover = normal.duplicate()
	hover.bg_color = Color(0.24, 0.24, 0.32)

	var pressed = normal.duplicate()
	pressed.bg_color = Color(0.10, 0.10, 0.14)

	btn.add_theme_stylebox_override("normal", normal)
	btn.add_theme_stylebox_override("hover", hover)
	btn.add_theme_stylebox_override("pressed", pressed)

func _go_regal():
	get_tree().change_scene_to_file("res://regal_szene.tscn")

func _on_back():
	get_tree().change_scene_to_file("res://origami_wahlen.tscn")
