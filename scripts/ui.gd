extends CanvasLayer

class_name UI

@onready var color_rect: ColorRect = $Life/ColorRect/ColorRect
@onready var game_over: Control = $GameOver
@onready var success: Control = $Success

@export var life_length := 200

var game_manager: GameManager


func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("game_manager")

func set_life(procent: float):
	color_rect.size.x = procent * life_length


func show_game_over() -> void:
	game_over.visible = true


func show_success() -> void:
	success.visible = true


func _on_button_restart_pressed() -> void:
	get_tree().reload_current_scene()


func _on_button_next_pressed() -> void:
	get_tree().change_scene_to_file(game_manager.next_scene_path)
