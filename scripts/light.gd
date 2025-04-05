extends Node2D

var game_manager: GameManager

@export var damage := 0.5

var player: Player = null


func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("game_manager")


func _physics_process(delta: float) -> void:
	if player:
		var ray = PhysicsRayQueryParameters2D.create(position, player.position)
		var result = get_world_2d().direct_space_state.intersect_ray(ray)
		if result and result["collider"] is Player:
			game_manager.add_life(-damage)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player = null
