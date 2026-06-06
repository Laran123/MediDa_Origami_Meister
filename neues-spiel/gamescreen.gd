extends Control

var figur = ""
var step = 0

func set_figur(f):
	figur = f

func _ready():
	_build_ui()

func _build_ui():

	var bg = TextureRect.new()
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.texture = load("res://Assets/Background/Untergrund.png")
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	add_child(bg)

	var title = Label.new()
	title.text = figur
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 140)
	title.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	title.offset_top = 60
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
	next.text = "WEITER"
	next.custom_minimum_size = Vector2(460, 180)
	_style_button(next)
	next.add_theme_font_size_override("font_size", 38)
	next.pressed.connect(_on_next)
	add_child(next)

	next.anchor_left = 1
	next.anchor_top = 1
	next.anchor_right = 1
	next.anchor_bottom = 1
	next.offset_left = -520
	next.offset_top = -260
	next.offset_right = -40
	next.offset_bottom = -40

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

func _on_next():
	step += 1
	print("Step:", step, " Figur:", figur)

func _on_back():
	get_tree().change_scene_to_file("res://origami_wahlen.tscn")
