extends Node2D

@export var damage := 1

var player: Player = null
var light: PointLight2D


func _ready() -> void:
	var lights = get_children().filter(func(x): x is PointLight2D)
	if lights.is_empty():
		push_warning("Light has no PointLight2D node")
	else:
		light = lights[0]


func _physics_process(delta: float) -> void:
	if player:
		var ray = PhysicsRayQueryParameters2D.create(position, player.position)
		var result = get_world_2d().direct_space_state.intersect_ray(ray)
		if result and result["collider"] is Player:
			(result["collider"] as Player).hit(damage)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player = null
