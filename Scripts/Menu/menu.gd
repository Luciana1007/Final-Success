extends Control
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var pirata: AnimatedSprite2D = $AnimatedSprite2D/Pirata
@onready var nine_patch_rect: NinePatchRect = $CanvasLayer/NinePatchRect

func _ready():
	animated_sprite_2d.play("default")
	pirata.play("default")
	
	start_balance()
	start_title_balance()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/Niveles/Nivel1.tscn")


func _on_button_3_pressed() -> void:
	get_tree().quit()

func start_balance():
	var tween := create_tween()
	tween.set_loops() # hace que el movimiento sea infinito
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	var original_pos := animated_sprite_2d.position

	# Baja 10px en 1 segundo
	tween.tween_property(animated_sprite_2d, "position:y", original_pos.y + 10, 1.0)

	# Sube 10px en 1 segundo (vuelve a la posición original)
	tween.tween_property(animated_sprite_2d, "position:y", original_pos.y, 1.0)

func start_title_balance():
	var tween := create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	var original_pos := nine_patch_rect.position

	tween.tween_property(nine_patch_rect, "position:y", original_pos.y - 10, 1.5)
	tween.tween_property(nine_patch_rect, "position:y", original_pos.y, 1.5
	)
