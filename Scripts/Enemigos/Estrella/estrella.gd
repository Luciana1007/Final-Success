extends Enemigo

@export var jump_force : int = -350 #fuerza de salto
@export var horizontal_push : int = 60 #cada vez que salta se mueve horizontalmente
@export var gravity : int = 900 
@export var jump_interval : float = 1.8 #cada cuantos segundo salta
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_timer: Timer = $JumpTimer

var direction := 1
var state := "idle"

func _ready():
	jump_timer.timeout.connect(_on_jump_timer_timeout)
	

func _physics_process(delta):
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
	velocity.y += gravity * delta
	

func jump_state(delta):
	animated_sprite_2d.play("Attack")
	velocity.y += gravity * delta
	velocity.x = direction * horizontal_push
	
	
func _on_jump_timer_timeout() -> void:
	state = "jump"
	velocity.y = jump_force
	velocity.x = direction * horizontal_push
	
	await get_tree().create_timer(0.4).timeout #esperará unos segundos para volver a saltar
	state = "idle"
