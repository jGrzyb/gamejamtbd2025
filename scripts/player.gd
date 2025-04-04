extends CharacterBody2D

class_name Player

@export var speed := 100
@export var life := 1000


func _physics_process(delta: float) -> void:
	velocity = Input.get_vector("left", "right", "up", "down") * speed
	move_and_slide()


func hit(damage_per_frame: float):
	life -= damage_per_frame
	print(life)
