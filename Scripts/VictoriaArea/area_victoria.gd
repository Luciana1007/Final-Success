extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

signal victory

func _ready():
	monitorable = false
	monitoring = false



func activate_area():
	monitorable = true 
	monitoring = true
	animated_sprite_2d.play("Active")

func deactivate_area():
	monitorable = false
	monitoring = false
	animated_sprite_2d.play("Idle")

func _on_body_entered(body: Node2D):
	if self.monitoring and body.is_in_group("player"):
		emit_signal("victory")
