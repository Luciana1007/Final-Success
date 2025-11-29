extends Enemigo

@export var speed := 60
@export var run_duration : float = 1.0 #cuanto tiempo va a caminar
@export var idle_duration : float = 2.0 #cuanto tiempo va a estar quieto entre caminata y caminata
@export var attack_duration : float = 4.0 
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var attack_timer: Timer = $AttackTimer

var direction := 1
var state := "walk"

func _ready():
	timer.wait_time = run_duration
	attack_timer.wait_time = attack_duration
	
	attack_timer.start()
	timer.start()

func _on_timer_timeout() -> void:
	state = "walk"

func _physics_process(delta):
	match state:
		"walk":
			walk_state(delta)
			
		"attack":
			attack_state(delta)
		"idle":
			idle_state(delta)
			

func walk_state(delta):
	velocity.x = direction * speed
	move_and_slide()
	
	if is_on_wall():
		direction *= -1
		
	animated_sprite_2d.play("Run")

func attack_state(delta):
	velocity = Vector2.ZERO
	move_and_slide()
	animated_sprite_2d.play("Attack")
	
# func _on_take_damage_body_entered(body: Node2D) -> void: 
#	if body.is_in_group("player"):
#		take_damage(5, 2)

func idle_state(delta):
	velocity = Vector2.ZERO
	move_and_slide()
	animated_sprite_2d.play("Idle")
	
func _on_attack_timer_timeout() -> void: #Cada cierto tiempo se ejecuta la animación de ataca y cuando esto sucede, el enemigo se queda quieto
	state = "attack"
	animated_sprite_2d.play("Attack")
	
