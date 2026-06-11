extends Control

var btn_origami
var btn_regal

func _ready():
	_build_ui()
	_animate_in()

func _build_ui():

	var bg = TextureRect.new()
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.texture = load("res://Assets/Background/Untergrund.png")
	add_child(bg)

	var overlay = ColorRect.new()
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.color = Color(0, 0, 0, 0.35)
	add_child(overlay)

	var center = CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 70)
	center.add_child(vbox)

	var title = Label.new()
	title.text = "ORIGAMI"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 180)
	vbox.add_child(title)

	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 40)
	vbox.add_child(spacer)

	btn_origami = Button.new()
	btn_origami.text = "ORIGAMI WÄHLEN"
	btn_origami.custom_minimum_size = Vector2(650, 160)
	_style_button(btn_origami)
	btn_origami.add_theme_font_size_override("font_size", 42)
	btn_origami.pressed.connect(_on_origami_wahlen_pressed)
	vbox.add_child(btn_origami)

	btn_regal = Button.new()
	btn_regal.text = "REGAL"
	btn_regal.custom_minimum_size = Vector2(650, 160)
	_style_button(btn_regal)
	btn_regal.add_theme_font_size_override("font_size", 42)
	btn_regal.pressed.connect(_on_regal_pressed)
	vbox.add_child(btn_regal)

func _style_button(btn: Button):

	var normal = StyleBoxFlat.new()
	normal.bg_color = Color(0.18, 0.18, 0.24)
	normal.corner_radius_top_left = 22
	normal.corner_radius_top_right = 22
	normal.corner_radius_bottom_left = 22
	normal.corner_radius_bottom_right = 22
	normal.content_margin_left = 30
	normal.content_margin_right = 30
	normal.content_margin_top = 20
	normal.content_margin_bottom = 20

	var hover = normal.duplicate()
	hover.bg_color = Color(0.26, 0.26, 0.34)

	var pressed = normal.duplicate()
	pressed.bg_color = Color(0.12, 0.12, 0.16)

	btn.add_theme_stylebox_override("normal", normal)
	btn.add_theme_stylebox_override("hover", hover)
	btn.add_theme_stylebox_override("pressed", pressed)

func _animate_in():

	modulate.a = 0
	scale = Vector2(1.03, 1.03)

	var t = create_tween()
	t.tween_property(self, "modulate:a", 1.0, 0.6)
	t.parallel().tween_property(self, "scale", Vector2(1, 1), 0.6)

func _on_regal_pressed():
	get_tree().change_scene_to_file("res://regal_szene.tscn")

func _on_origami_wahlen_pressed():
	get_tree().change_scene_to_file("res://origami_wahlen.tscn")
