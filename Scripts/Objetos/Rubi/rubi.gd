extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		animated_sprite_2d.play("Collected") #se ejecuta la animación de recolectada
		print("Fui recolectada")
		get_tree().current_scene.add_time(5)
		await (animated_sprite_2d.animation_finished) #cuando se termina dicha animación se elimina la moneda
		queue_free()
