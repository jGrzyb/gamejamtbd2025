extends CharacterBody2D

class_name Enemy

var game_manager: GameManager

var walk_speed := 30
var chase_speed := 60
var is_chasing := false
var is_alive := true

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var player: Node2D = %Player
@onready var timer_path: Timer = $Timer_path
@onready var area_2d: Area2D = $Area2D
@onready var timer_die: Timer = $Timer_die
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var light: Node2D = $Area2D/Light
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var timer_chase: Timer = $Timer_chase
@onready var timer_start: Timer = $Timer_start


@export var push_strength := 300


func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("game_manager")
	timer_start.start()


func _physics_process(delta: float) -> void:
	if is_alive:
		var speed = walk_speed
		if is_chasing:
			navigation_agent_2d.target_position = player.position
			speed = chase_speed

		var direction = (navigation_agent_2d.get_next_path_position() - global_position).normalized()
		choose_animtion(direction.angle())
		if navigation_agent_2d.is_navigation_finished():
			velocity = velocity.lerp(Vector2.ZERO, 0.1)
		else:
			velocity = velocity.lerp(direction * speed, 0.1)

		area_2d.rotation = lerp_angle(area_2d.rotation, direction.angle(), 0.05)
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
		animated_sprite_2d.speed_scale = 2


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		timer_chase.start()


func _on_timer_chase_timeout() -> void:
	is_chasing = false
	var map := get_world_2d().navigation_map
	navigation_agent_2d.target_position = NavigationServer2D.map_get_random_point(map, 1, true)
	animated_sprite_2d.speed_scale = 1


func start_dying():
	is_alive = false
	timer_die.start()
	animated_sprite_2d.speed_scale = 1
	animated_sprite_2d.play("die")
	light.queue_free()
	collision_shape_2d.queue_free()


func _on_timer_die_timeout() -> void:
	game_manager.enemy_killed(self)
	queue_free()
	

func choose_animtion(rot: float):
	if rot > -3*PI/4 and rot < -PI/4:
		animated_sprite_2d.play("up")
	elif rot > -PI/4 and rot < PI/4:
		animated_sprite_2d.play("right")
	elif rot > PI/4 and rot < 3*PI/4:
		animated_sprite_2d.play("down")
	else:
		animated_sprite_2d.play("left")


func hit(player: Player) -> void:
	if not is_chasing:
		game_manager.add_life(10)
		start_dying()
	else:
		velocity = (position - player.position).normalized() * push_strength


func _on_timer_start_timeout() -> void:
	var map := get_world_2d().navigation_map
	navigation_agent_2d.target_position = NavigationServer2D.map_get_random_point(map, 1, true)
