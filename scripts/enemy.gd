extends CharacterBody2D

class_name Enemy

var walk_speed := 30
var chase_speed := 60
var is_chasing := false

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var player: Node2D = %Player
@onready var timer_path: Timer = $Timer_path
@onready var area_2d: Area2D = $Area2D
@onready var timer_chase: Timer = $Timer_chase
@onready var timer_die: Timer = $Timer_die


func _physics_process(delta: float) -> void:
	var speed = walk_speed
	if is_chasing:
		navigation_agent_2d.target_position = player.position
		speed = chase_speed

	var direction = (navigation_agent_2d.get_next_path_position() - global_position).normalized()
	if navigation_agent_2d.is_navigation_finished():
		velocity = velocity.lerp(Vector2.ZERO, 0.1)
	else:
		velocity = velocity.lerp(direction * speed, 0.1)

	area_2d.rotation = lerp_angle(area_2d.rotation, direction.angle(), 0.1)
	move_and_slide()
	

func _on_timer_path_timeout() -> void:
	var map := get_world_2d().navigation_map
	navigation_agent_2d.target_position = NavigationServer2D.map_get_random_point(map, 1, true)
	timer_path.wait_time = randf_range(3, 6)
	timer_path.start()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		timer_chase.stop()
		is_chasing = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		timer_chase.start()


func _on_timer_chase_timeout() -> void:
	is_chasing = false
	var map := get_world_2d().navigation_map
	navigation_agent_2d.target_position = NavigationServer2D.map_get_random_point(map, 1, true)


func start_dying():
	timer_die.start()


func _on_timer_die_timeout() -> void:
	queue_free()
