extends Control

const TUTORIAL_TEXTS = [
	"[color=yellow]Willkommen zum Origami-Tutorial![/color]\nHier lernst du die wichtigsten Faltzeichen kennen.",
	"[color=#66ccff]BLAUE LINIE (---)\n→ TALFALTE[/color]\nFalte das Papier nach vorne (zu dir hin).\nDie Falte liegt flach auf dem Tisch auf.",
	"[color=green]GRÜNE LINIE (───)\n→ BERGFALTE[/color]\nFalte das Papier nach hinten (von dir weg).\nDie Falte ragt nach oben (wie ein Berg).",
	"[color=gray]GESTRICHELTE LINIE (---) oder (-·-)\n→ HILFSFALTE / VORFALTE[/color]\nFalte und klappe sofort zurück.\nSie dient nur als Orientierung für spätere Schritte.",
	"[color=gray]SPIRALFÖRMIGER PFEIL (Kreis mit Pfeil)\n→ UMDREHEN[/color]\nDrehe das gesamte Blatt um.\n(Vorder- und Rückseite tauschen.)",
	"[color=gray]NORMALER PFEIL (→)\n→ FALTRICHTUNG / BEWEGUNG[/color]\nZeigt, wohin du falten, drücken oder schieben musst.",
	"[color=gray]GEBOGENER PFEIL (↻ / ↺)\n→ DREHEN[/color]\nDrehe das Blatt auf dem Tisch (z.B. um 90°),\nohne es umzudrehen.",
	"[color=#66ccff]Kreis (∘)\n→ HALTE-/FIXPUNKT[/color]\nHier musst du das Papier festhalten,\nwährend du an anderer Stelle faltest oder ziehst.",
	"[color=gray]OFFENER PFEIL (leere Spitze) oder GABELUNG\n→ ÖFFNEN / ZIEHEN[/color]\nKlappe eine Tasche auf oder ziehe eine Lage auseinander.",
	"[color=yellow]Ende des Tutorials![/color]\nDu kennst jetzt alle wichtigen Origami-Symbole.\nViel Spaß beim Falten!"
]

var step = 0
var text_label: RichTextLabel
var back_btn: Button
var next_btn: Button
var skip_btn: Button

func _ready():
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

	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 60)
	center.add_child(vbox)

	text_label = RichTextLabel.new()
	text_label.bbcode_enabled = true
	text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	text_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	text_label.add_theme_font_size_override("normal_font_size", 70)
	text_label.add_theme_color_override("default_color", Color.WHITE)
	text_label.add_theme_constant_override("outline_size", 3)
	text_label.add_theme_color_override("outline_color", Color.BLACK)
	text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text_label.custom_minimum_size = Vector2(1300, 600)
	text_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_child(text_label)

	var hbox = HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 60)
	vbox.add_child(hbox)

	back_btn = Button.new()
	back_btn.text = "ZURÜCK"
	back_btn.custom_minimum_size = Vector2(400, 160)
	back_btn.pressed.connect(_on_back)
	_style_button(back_btn)
	hbox.add_child(back_btn)

	next_btn = Button.new()
	next_btn.text = "WEITER"
	next_btn.custom_minimum_size = Vector2(400, 160)
	next_btn.pressed.connect(_on_next)
	_style_button(next_btn)
	hbox.add_child(next_btn)

	skip_btn = Button.new()
	skip_btn.text = "SKIP"
	skip_btn.custom_minimum_size = Vector2(280, 160)
	skip_btn.pressed.connect(_on_skip)
	_style_button(skip_btn, Color(0.5, 0.15, 0.1))
	hbox.add_child(skip_btn)

	for btn in [back_btn, next_btn, skip_btn]:
		btn.add_theme_font_size_override("font_size", 42)

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
	else:
		text_label.text = ""

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
