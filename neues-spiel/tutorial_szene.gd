extends Control

const SPRITESHEET_PATH = "res://Assets/spritesheet-tutorial.png"
const TILE_SIZE = Vector2(1675, 1625)

var regions: Array[Rect2] = [
	Rect2(0, 0, TILE_SIZE.x, TILE_SIZE.y),                 # Zeile 1, Spalte 1
	Rect2(TILE_SIZE.x, 0, TILE_SIZE.x, TILE_SIZE.y),       # Zeile 1, Spalte 2
	Rect2(0, TILE_SIZE.y, TILE_SIZE.x, TILE_SIZE.y),       # Zeile 2, Spalte 1
	Rect2(TILE_SIZE.x, TILE_SIZE.y, TILE_SIZE.x, TILE_SIZE.y), # Zeile 2, Spalte 2
	Rect2(0, TILE_SIZE.y * 2, TILE_SIZE.x, TILE_SIZE.y)    # Zeile 3, Spalte 1
]

var step_image_indices: Array[int] = [
	-1, 
	0,   
	1,  
	2,  
	3,   
	4,   
	-1,  
	-1,  
	-1,  
	-1   
]

const TUTORIAL_TEXTS = [
	"[color=yellow]Willkommen zum Origami-Tutorial![/color]\nHier lernst du die wichtigsten Faltzeichen kennen.",

	"[color=#66ccff]AUSGANGSBLATT[/color]\nDas flache, ungefaltete Papier.\nVon hier aus beginnst du mit den ersten Falten.",

	"[color=#66ccff]BLAUE GESTRICHELTE LINIE (- - -)[/color]\n→ HILFSFALTE\nDiese Linie zeigt eine Vorfalte, die später benötigt wird.\nFalte und öffne sofort wieder.",

	"[color=#66ccff]BLAUE DURCHGEZOGENE LINIE (──)[/color] und [color=gray]SPIRALFÖRMIGER PFEIL (↻)[/color]\n→ TALFALTE und DREHEN\nFalte nach vorne und drehe das Blatt anschließend.",

	"[color=green]GRÜNE GESTRICHELTE LINIE (- - -)[/color] und [color=gray]NORMALER PFEIL (→)[/color]\n→ BERGFALTE und FALTRICHTUNG\nFalte nach hinten und folge der Pfeilrichtung.",

	"[color=yellow]ENDE DER FALTUNG[/color]\nDu hast die grundlegenden Falttechniken gelernt.\nJetzt kannst du die weiteren Schritte üben.",

	"[color=gray]GEBOGENER PFEIL (↻ / ↺)\n→ DREHEN[/color]\nDrehe das Blatt auf dem Tisch (z.B. um 90°),\nohne es umzudrehen.",

	"[color=gray]OFFENER PFEIL (leere Spitze) oder GABELUNG\n→ ÖFFNEN / ZIEHEN[/color]\nKlappe eine Tasche auf oder ziehe eine Lage auseinander.",

	"[color=yellow]Ende des Tutorials![/color]\nDu kennst jetzt alle wichtigen Origami-Symbole.\nViel Spaß beim Falten!"
]

var step = 0
var text_label: RichTextLabel
var image_rect: TextureRect
var back_btn: Button
var next_btn: Button
var skip_btn: Button

var atlas_textures: Array[AtlasTexture] = []

func _ready():
	var spritesheet = load(SPRITESHEET_PATH)
	for region in regions:
		var atlas = AtlasTexture.new()
		atlas.atlas = spritesheet
		atlas.region = region
		atlas_textures.append(atlas)
	
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_build_ui()
	_update_text()

func _build_ui():
	var bg = TextureRect.new()
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.texture = load("res://Assets/Background/Untergrund.png")
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	add_child(bg)
	move_child(bg, 0)

	var center = CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var main_vbox = VBoxContainer.new()
	main_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	main_vbox.add_theme_constant_override("separation", 40)
	center.add_child(main_vbox)

	var content_hbox = HBoxContainer.new()
	content_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	content_hbox.add_theme_constant_override("separation", 50)
	main_vbox.add_child(content_hbox)

	image_rect = TextureRect.new()
	image_rect.texture = null
	image_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	image_rect.custom_minimum_size = Vector2(175, 175)
	image_rect.size_flags_vertical = Control.PRESET_MODE_KEEP_SIZE
	content_hbox.add_child(image_rect)

	text_label = RichTextLabel.new()
	text_label.bbcode_enabled = true
	text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	text_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	text_label.add_theme_font_size_override("normal_font_size", 50)
	text_label.add_theme_color_override("default_color", Color.WHITE)
	text_label.add_theme_constant_override("outline_size", 3)
	text_label.add_theme_color_override("outline_color", Color.BLACK)
	text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text_label.custom_minimum_size = Vector2(600, 400)
	text_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_hbox.add_child(text_label)

	var btn_hbox = HBoxContainer.new()
	btn_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	btn_hbox.add_theme_constant_override("separation", 60)
	main_vbox.add_child(btn_hbox)

	back_btn = Button.new()
	back_btn.text = "ZURÜCK"
	back_btn.custom_minimum_size = Vector2(320, 140)
	back_btn.pressed.connect(_on_back)
	_style_button(back_btn)
	btn_hbox.add_child(back_btn)

	next_btn = Button.new()
	next_btn.text = "WEITER"
	next_btn.custom_minimum_size = Vector2(320, 140)
	next_btn.pressed.connect(_on_next)
	_style_button(next_btn)
	btn_hbox.add_child(next_btn)

	for btn in [back_btn, next_btn]:
		btn.add_theme_font_size_override("font_size", 38)

func _style_button(btn: Button, custom_color: Color = Color(0.16, 0.16, 0.20)):
	var normal = StyleBoxFlat.new()
	normal.bg_color = custom_color
	normal.corner_radius_top_left = 24
	normal.corner_radius_top_right = 24
	normal.corner_radius_bottom_left = 24
	normal.corner_radius_bottom_right = 24
	normal.content_margin_left = 30
	normal.content_margin_right = 30
	normal.content_margin_top = 18
	normal.content_margin_bottom = 18

	var hover = normal.duplicate()
	hover.bg_color = custom_color.lightened(0.2)

	var pressed = normal.duplicate()
	pressed.bg_color = custom_color.darkened(0.2)

	btn.add_theme_stylebox_override("normal", normal)
	btn.add_theme_stylebox_override("hover", hover)
	btn.add_theme_stylebox_override("pressed", pressed)

func _update_text():
	if step < TUTORIAL_TEXTS.size():
		text_label.text = TUTORIAL_TEXTS[step]
		var idx = step_image_indices[step]
		if idx >= 0 and idx < atlas_textures.size():
			image_rect.texture = atlas_textures[idx]
			image_rect.visible = true
		else:
			image_rect.texture = null
			image_rect.visible = false
	else:
		text_label.text = ""
		image_rect.texture = null
		image_rect.visible = false

func _on_next():
	if step < TUTORIAL_TEXTS.size() - 1:
		step += 1
		_update_text()
	else:
		_on_skip()

func _on_back():
	if step > 0:
		step -= 1
		_update_text()
	else:
		_on_skip()

func _on_skip():
	get_tree().change_scene_to_file("res://origami_wahlen.tscn")
