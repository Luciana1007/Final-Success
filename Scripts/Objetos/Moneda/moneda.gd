extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		animated_sprite_2d.play("Collected")
		queue_free()
