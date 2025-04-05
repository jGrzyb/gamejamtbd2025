extends Node

class_name GameManager

@onready var ui: UI;
@onready var player: Player = %Player

@export var max_life := 100.0
@export var life_leaking := 0.02
@export var next_scene_path := "res://scenes/start.tscn"

var life := max_life


func _ready() -> void:
	ui = get_tree().get_first_node_in_group("ui") as UI
	get_tree().paused = false


func _physics_process(delta: float) -> void:
	add_life(-life_leaking)


func add_life(amount: float) -> void:
	life = clamp(life + amount, 0, 100)
	ui.set_life(life / max_life)
	if life == 0:
		player.die()


func game_over() -> void:
	ui.show_game_over()
	get_tree().paused = true


func enemy_killed(enemy: Enemy) -> void:
	if get_tree().get_nodes_in_group("enemy").filter(func(x): return x != enemy).is_empty():
		await get_tree().get_frame()
		ui.show_success()
		get_tree().paused = true
		
