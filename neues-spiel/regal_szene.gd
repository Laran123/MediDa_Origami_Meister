extends Node2D

const TestScene = preload("res://test.tscn")

func _ready() -> void:
	var character = TestScene.instantiate()
	character.position = Vector2(500, 300)
	add_child(character)
	print("Regal bereit, Character geladen")

func _on_zuruck_pressed():
	get_tree().change_scene_to_file("res://start_menu.tscn")
