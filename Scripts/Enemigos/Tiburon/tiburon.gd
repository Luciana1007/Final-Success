extends Enemigo

@export var piumpium_wait : float = 2.0
@export var proyectil_scene: PackedScene
@export var pium_direction : Vector2 = Vector2.LEFT
@export var pium_velocity : float = 250.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_timer: Timer = $AttackTimer
@onready var marker_2d: Marker2D = $Marker2D

var state = "idle"

func _ready():
	attack_timer.wait_time = piumpium_wait
	attack_timer.start()
	

func _physics_process(delta):
	match state:
		"idle":
			animated_sprite_2d.play("Idle")
		"attack":
			animated_sprite_2d.play("Attack")
			


func _on_attack_timer_timeout() -> void:
	state = "attack"
	shoot()

func shoot():
	print("DISPARANDO...")
	if proyectil_scene == null:
		print("NO HAY PROYECTIL ASIGNADO")
		return
	
	var p = proyectil_scene.instantiate()
	get_parent().add_child(p)
	
	
	p.global_position = marker_2d.global_position
	p.velocity = pium_direction * pium_velocity
	
	attack_timer.start()
