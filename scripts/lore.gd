extends Control

@onready var label: Label = $VBoxContainer/Label

@export var path := "res://scenes/tutorial.tscn"

func _ready() -> void:
	label.visible_characters = 0

func _physics_process(delta: float) -> void:
	label.visible_characters = clamp(label.visible_characters+1, 0, len(label.text))


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(path)
	
