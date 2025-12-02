extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		animated_sprite_2d.play("Collected") #se ejecuta la animación de recolectada
		print("Fui recolectada")
		await (animated_sprite_2d.animation_finished)
		body.pick_sword()
		queue_free()

func sword_animation(is_collected := false):
	if is_collected:
		var original_pos_Y = position.y
		var tween = create_tween()
		tween.set_loops()  #el tween se repite infinitoo
			
		tween.tween_property(
			self,
			"position:y",
			original_pos_Y -4,
			0.4
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

		tween.tween_property(
			self,
			"position:y",
			original_pos_Y + 4,
			0.4
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
