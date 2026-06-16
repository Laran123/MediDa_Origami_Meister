extends Control

const FIGUREN = [
	"Kranich"
]

const FIGURENNICHTVORHANDEN = [
	"wird noch hinzugefügt:","Frosch", "Boot", "Pelikan", "Papagei",
	"Schmetterling", "Schlange", "Huhn", "Katze",
	"Dinosaurier", "Baer", "Drache", "Loewe"
]

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
	overlay.color = Color(0, 0, 0, 0.25)
	add_child(overlay)

	var center = CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 40)
	center.add_child(vbox)
	
	var title = Label.new()
	title.text = "ORIGAMI WÄHLEN"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 120)
	vbox.add_child(title)
	
	var tutorial_btn = Button.new()
	tutorial_btn.text = "Tutorial"
	tutorial_btn.custom_minimum_size = Vector2(0, 110)
	_style_button(tutorial_btn)
	tutorial_btn.add_theme_font_size_override("font_size", 36)
	tutorial_btn.pressed.connect(_on_tutorial_pressed)
	vbox.add_child(tutorial_btn)
	
	var scroll = ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(1100, 650)
	vbox.add_child(scroll)

	var list = VBoxContainer.new()
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list.add_theme_constant_override("separation", 20)
	scroll.add_child(list)

	for figur in FIGUREN:
		var btn = Button.new()
		btn.text = figur

		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.custom_minimum_size = Vector2(0, 130)

		_style_button(btn)
		btn.add_theme_font_size_override("font_size", 36)

		btn.pressed.connect(func(f = figur): _on_figur_pressed(f))
		list.add_child(btn)
		
	for figur in FIGURENNICHTVORHANDEN:
		var btn = Button.new()
		btn.text = figur
		
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.custom_minimum_size = Vector2(0, 130)
		
		_style_button(btn)
		btn.add_theme_font_size_override("font_size", 36)
		btn.disabled = true
		list.add_child(btn)

	var back = Button.new()
	back.text = "ZURÜCK"
	back.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	back.custom_minimum_size = Vector2(0, 110)
	_style_button(back)
	back.add_theme_font_size_override("font_size", 32)
	back.pressed.connect(_on_zuruck_pressed)
	vbox.add_child(back)

	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 20)
	vbox.add_child(spacer)

func _style_button(btn: Button):

	var normal = StyleBoxFlat.new()
	normal.bg_color = Color(0.20, 0.20, 0.26)
	normal.corner_radius_top_left = 18
	normal.corner_radius_top_right = 18
	normal.corner_radius_bottom_left = 18
	normal.corner_radius_bottom_right = 18
	normal.content_margin_left = 30
	normal.content_margin_right = 30
	normal.content_margin_top = 18
	normal.content_margin_bottom = 18

	var hover = normal.duplicate()
	hover.bg_color = Color(0.28, 0.28, 0.36)

	var pressed = normal.duplicate()
	pressed.bg_color = Color(0.14, 0.14, 0.18)

	btn.add_theme_stylebox_override("normal", normal)
	btn.add_theme_stylebox_override("hover", hover)
	btn.add_theme_stylebox_override("pressed", pressed)

func _animate_in():
	modulate.a = 0
	scale = Vector2(1.03, 1.03)

	var t = create_tween()
	t.tween_property(self, "modulate:a", 1.0, 0.5)
	t.parallel().tween_property(self, "scale", Vector2(1, 1), 0.5)

func _on_figur_pressed(figur: String):

	var scene = load("res://GameScreen.tscn").instantiate()
	scene.set_figur(figur)

	get_tree().root.add_child(scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = scene

func _on_zuruck_pressed():
	get_tree().change_scene_to_file("res://start_menu.tscn")

func _on_tutorial_pressed():
	var scene = load("res://tutorial_szene.tscn").instantiate()
	get_tree().root.add_child(scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = scene
