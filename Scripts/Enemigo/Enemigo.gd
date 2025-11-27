extends CharacterBody2D
class_name Enemigo

@export var max_health : int = 5
var health: int 
@export var damage : int = 5
@export var knockback = 150 #al recibir daño, realiza un empujon hacia atras antes de morirse.

func _ready():
	health = max_health

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
