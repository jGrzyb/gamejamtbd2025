extends Camera2D

@onready var player: Player = %Player


func _ready() -> void:
	position = player.position


func _physics_process(delta: float) -> void:
	position = position.lerp(player.position, 0.05) 
