extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var sword_scene : PackedScene
var is_open = false

func _on_body_entered(body: Node2D): 
	if is_open: #se puede abrir solo una vez
		return
	
	if body.is_in_group("player"): #si quien lo abre pertenece a player y contiene una llave, el cofre se abre
		if body.has_key:
			open_chest(body)
		else:
			print("El cofre esta cerrado, necesitas una llaveeee") 

func open_chest(player):
	is_open = true
	
	player.remove_key() #cuando el cofre se abra, se eliminará tanto la llave como su visual feedback que tiene el player sobre su cabeza
	player.clear_object_holder()
	print("OPAA, me abro pa")
	animated_sprite_2d.play("Unlocked") #se ejecuta la animación
	await  animated_sprite_2d.animation_finished
	# y una vez terminada se pasa a la animación de "Open" que se queda asi forever 
	animated_sprite_2d.play("Open")
	
	
	var sword = sword_scene.instantiate() #cuando se abre el cofre, instancia una espada
	sword.position = global_position #la cual tendrá una animación que "sale del cofre" gracias al siguiente tween
	var tween = create_tween()
	tween.tween_property(
		sword, 
		"position", 
		global_position + Vector2(0, -40), 
		0.3
		).set_trans(Tween.TRANS_BOUNCE)
	
	get_parent().add_child(sword)
	
