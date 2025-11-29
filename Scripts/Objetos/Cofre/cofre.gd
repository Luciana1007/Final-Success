extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var is_open = false

func _on_body_entered(body: Node2D):
	if is_open:
		return
	
	if body.is_in_group("player"):
		if body.has_key:
			open_chest(body)
		else:
			print("El cofre esta cerrado, necesitas una llaveeee")

func open_chest(player):
	is_open = true
	player.remove_key()
	animated_sprite_2d.play("Unlocked")
	await  animated_sprite_2d.animation_finished
	
	animated_sprite_2d.play("Open")
