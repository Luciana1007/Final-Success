extends Enemigo

@export var jump_force : int = -350
@export var horizontal_push : int = 60
@export var gravity : int = 900 
@export var jump_interval : float = 1.8

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_timer: Timer = $JumpTimer

var direction := 1
var state := "idle"


func _physics_process(delta):
	velocity.y += gravity * delta

	match state:
		"idle":
			idle_state(delta)
		"jump":
			jump_state(delta)

	move_and_slide()

	if is_on_wall():
		direction *= -1


func idle_state(delta):
	animated_sprite_2d.play("Idle")
	velocity.x = 0


func jump_state(delta):
	animated_sprite_2d.play("Attack")
	await animated_sprite_2d.animation_finished
	velocity.x = direction * horizontal_push
	
	# cuando toca el piso, vuelve a estado idle
	if is_on_floor():
		state = "idle"


func _on_jump_timer_timeout() -> void:
	# aplica el salto UNA sola vez
	velocity.y = jump_force
	velocity.x = direction * horizontal_push
	state = "jump"
