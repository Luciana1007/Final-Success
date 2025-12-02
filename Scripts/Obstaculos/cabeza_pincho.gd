extends CharacterBody2D

@export_enum("Horizontal", "Vertical") var move_type := "Horizontal"
@export var distance : float = 150.0
@export var speed : float = 80.0
@onready var wait_timer: Timer = $WaitTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var start_position : Vector2
var end_position : Vector2
var direction : = 1
var wainting := false

func _ready():
	start_position = position
	animated_sprite_2d.play("Idle")
	
	if move_type == "Horizontal":
		end_position = start_position + Vector2(distance, 0)
	else:
		end_position = start_position + Vector2(0, distance)
	
	
func _physics_process(delta):
	if wainting:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	if move_type == "Horizontal":
		velocity.x = speed * direction
		velocity.y = 0
	else:
		velocity.x = 0
		velocity.y = speed * direction
	move_and_slide()
	
	if move_type == "Horizontal":
		if direction == 1 and position.x >= end_position.x:
			reach_end()
		elif direction == -1 and position.x <= start_position.x:
			reach_end()
	else:
		if direction == 1 and position.y >= end_position.y:
			reach_end()
		elif direction == -1 and position.y <= start_position.y:
			reach_end()

func reach_end():
	wainting = true
	velocity = Vector2.ZERO
	wait_timer.start()
	direction *= -1

func _on_wait_timer_timeout() -> void:
	wainting = false 
