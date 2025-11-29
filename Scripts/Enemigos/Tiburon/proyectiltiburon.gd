extends Node2D

var velocity : Vector2 = Vector2.ZERO
@export var duration : float = 3.0

func _ready():
	$Timer.wait_time = duration
	$Timer.start()

func _physics_process(delta):
	global_position += velocity * delta

func _on_timer_timeout() -> void:
	queue_free()
