extends CharacterBody2D

class_name Player

var game_manager: GameManager

@onready var timer_dash: Timer = $Timer_dash
@onready var area_2d: Area2D = $Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animated_sprite_2d_2: AnimatedSprite2D = $AnimatedSprite2D2

@onready var timer_attack: Timer = $Timer_attack
@onready var timer_die: Timer = $Timer_die
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var cpu_particles_2d_2: CPUParticles2D = $CPUParticles2D2
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cpu_particles_2d_3: CPUParticles2D = $CPUParticles2D3

@export var speed := 100
@export var dash_speed := 400
@export var heal_on_kill := 10

var last_direction := Vector2(0, 1)
var can_dash := true
var is_dying := false


func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("game_manager")


func _physics_process(delta: float) -> void:
	if not is_dying:
		var direction = Input.get_vector("left", "right", "up", "down")
		choose_animation(direction)
		velocity = velocity.lerp(direction * speed, 0.1)
		if direction != Vector2.ZERO:
			last_direction = direction
		move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dash") and can_dash:
		can_dash = false
		velocity = last_direction * dash_speed
		timer_dash.start()
	elif event.is_action_pressed("attack"):
		cpu_particles_2d.emitting = true
		animation_player.play("kill")
		timer_attack.start()
		var enemies = area_2d.get_overlapping_bodies().filter(func(x): return x is Enemy)
		for e in enemies:
			(e as Enemy).hit(self)


func _on_timer_dash_timeout() -> void:
	can_dash = true


func choose_animation(direction: Vector2):
	if direction.x > 0:
		animated_sprite_2d.play("right")
		animated_sprite_2d_2.play("right")
	elif direction.x < 0:
		animated_sprite_2d.play("left")
		animated_sprite_2d_2.play("left")
	elif direction.y < 0:
		animated_sprite_2d.play("up")
		animated_sprite_2d_2.play("up")
	elif direction.y > 0:
		animated_sprite_2d.play("down")
		animated_sprite_2d_2.play("down")


func die() -> void:
	if timer_die.is_stopped():
		MusicNode.die()
		timer_attack.stop()
		is_dying = true
		animated_sprite_2d.play("die")
		animated_sprite_2d_2.play("die")
		animation_player.play("die")
		timer_die.start()


func _on_timer_die_timeout() -> void:
	game_manager.game_over()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("artifact"):
		(area as Artifact).collect(self)
		cpu_particles_2d_2.emitting = true
