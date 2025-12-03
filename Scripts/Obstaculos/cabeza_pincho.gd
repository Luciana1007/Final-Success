extends Area2D

@export_enum("Horizontal", "Vertical") var move_type := "Horizontal"
@export var distance : float = 150.0
@export var speed : float = 80.0
@onready var wait_timer: Timer = $WaitTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var start_position : Vector2
var end_position : Vector2
var direction := 1
var waiting := false

func _ready():
	start_position = global_position
	animated_sprite_2d.play("Idle")

	if move_type == "Horizontal":
		end_position = start_position + Vector2(distance, 0)
	else:
		end_position = start_position + Vector2(0, distance)


func _process(delta):
	if waiting:
		return

	# Movimiento manual sin físicas
	var move_vec := Vector2.ZERO

	if move_type == "Horizontal":
		move_vec.x = speed * direction * delta
	else:
		move_vec.y = speed * direction * delta

	global_position += move_vec

	_check_bounds()


func _check_bounds():
	if move_type == "Horizontal":
		if direction == 1 and global_position.x >= end_position.x:
			_reach_end()
		elif direction == -1 and global_position.x <= start_position.x:
			_reach_end()
	else:
		if direction == 1 and global_position.y >= end_position.y:
			_reach_end()
		elif direction == -1 and global_position.y <= start_position.y:
			_reach_end()


func _reach_end():
	waiting = true
	wait_timer.start()
	direction *= -1


func _on_wait_timer_timeout() -> void:
	waiting = false 
