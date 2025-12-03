extends CharacterBody2D
class_name Enemigo

@export var max_health : int = 5
@export var damage : int = 5
@export var knockback = 150 #al recibir daño, realiza un empujon hacia atras antes de morirse.
@onready var pacman_sign: AnimatedSprite2D = $PacmanSign


var health: int
var is_pacman_mode : bool = false

func _ready():
	health = max_health
	pacman_sign.visible = false

func take_damage(amount: int, source:):
	health -= amount
	if health <= 0:
		die()
	
	if source !=null:
		apply_knockback(source.global_position)

func apply_knockback(source_position: Vector2):
	var direction := (global_position - source_position).normalized()
	velocity = direction * knockback

func die():
	queue_free()

func enter_pacman_mode():
	is_pacman_mode = true
	pacman_sign.visible = true
	pacman_sign.play("default")

func exit_pacman_mode():
	is_pacman_mode = false
	pacman_sign.visible = false
	pacman_sign.stop()
