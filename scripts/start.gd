extends Control

@export var game_path := "res://scenes/level1.tscn"


func _ready() -> void:
	MusicNode.menu()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(game_path)
