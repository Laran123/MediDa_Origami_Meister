extends Control

const FIGUREN = ["Kranich", "Frosch", "Boot", "Pelikan", "Papagei",
	"Schmetterlng", "Schlange", "Huhn", "Katze",
	"Dinosaur", "Bar", "Drache", "Lowe"]

func _ready():
	for figur in FIGUREN:
		var btn = Button.new()
		btn.text = figur
		btn.pressed.connect(func(): _on_figur_pressed(figur))
		$VBoxContainer.add_child(btn)

func _on_figur_pressed(figur: String):
	print("Origami gewahlt: " + figur)

func _on_zuruck_pressed():
	get_tree().change_scene_to_file("res://start_menu.tscn")
