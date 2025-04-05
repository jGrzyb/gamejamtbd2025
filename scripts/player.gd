extends CharacterBody2D

class_name Player

@onready var timer_dash: Timer = $Timer_dash
@onready var area_2d: Area2D = $Area2D

@export var speed := 100
@export var life := 1000
@export var dash_speed := 300

var last_direction := Vector2(0, 1)
var can_dash := true


func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = velocity.lerp(direction * speed, 0.1)
	if direction != Vector2.ZERO:
		last_direction = direction
	move_and_slide()


func hit(damage_per_frame: float):
	life -= damage_per_frame
	print(life)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dash") and can_dash:
		can_dash = false
		velocity = last_direction * dash_speed
		timer_dash.start()
	elif event.is_action_pressed("attack"):
		var enemies = area_2d.get_overlapping_bodies().filter(func(x): return x is Enemy)
		for e in enemies:
			(e as Enemy).start_dying()


func _on_timer_dash_timeout() -> void:
	can_dash = true
