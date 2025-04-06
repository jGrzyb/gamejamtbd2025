extends Area2D

class_name Artifact

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer

var collected := false
var player: Player
var game_manager: GameManager


func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("game_manager")


func _physics_process(delta: float) -> void:
	if collected and player:
		position = position.lerp(player.position, 0.1)


func collect(player: Player) -> void:
	collision_shape_2d.queue_free()
	self.player = player
	collected = true
	timer.start()


func _on_timer_timeout() -> void:
	game_manager.collect()
	queue_free()
