extends CharacterBody2D

@export var move_speed : float #el export permite observar y cambiar variables en el inspector
@export var jump_speed : float
@export var health : int = 5
@export var damage : int = 5
@export var key_scene : PackedScene
@export var sword_scene : PackedScene
@onready var animated_sprite = $AnimatedSprite2D #onready sirve para obtener la referencia antes de que empiece el juego, por lo tanto no es nula
@onready var object_holder: Node2D = $ObjectHolder
@onready var run_particles: GPUParticles2D = $RunParticles



var is_facing_right = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") #obtenemos la gravedad desde la configuración del proyecto
var has_key = false
var is_dead = false
var has_sword = false

func _physics_process(delta):
	if is_dead:
		return
	
	jump(delta)
	move_x()
	flip()
	update_animations()

	var is_running = abs(velocity.x) > 10 and is_on_floor()
	run_particles.emitting = is_running

	move_and_slide()


func update_animations():
	if health <= 0:
		animated_sprite.play("Dead")
		return
		
	if not is_on_floor():
		if velocity.y < 0:
			animated_sprite.play("Jump")
		else:
			animated_sprite.play("Fall")
		return

	if abs(velocity.x) > 0:
		animated_sprite.play("Run")
	else:
		animated_sprite.play("Idle")

func move_x():
	var input_axis = Input.get_axis("move_left","move_right")
	velocity.x = input_axis * move_speed


func flip():
	#movimiento de los nodos del sprite si se mueve izquierda o derecha
	if (is_facing_right and velocity.x < 0) or (not is_facing_right and velocity.x >0 ):
		scale.x *= -1
		is_facing_right = not is_facing_right #se indica correctamente para que dirección observa


func jump(delta):
	if Input.is_action_just_pressed("jump") and is_on_floor(): #si el boton que se presiona es para saltar y si el jugador esta en el suelo
		velocity.y = -jump_speed
	
	if not is_on_floor(): 
		velocity.y += gravity * delta

func take_damage(amount: int): #si recibe daño la vida baja y si la vida es igual o menor a 0, muere
	health -= amount
	print("Recibi daño")
	if health <= 0:
		die()

func die():
	if is_dead:
		return
	
	is_dead = true
	velocity = Vector2.ZERO
	animated_sprite.play("Dead")
	await animated_sprite.animation_finished
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void: #si dentro de su area entra un enemigo, recibe daño
	if body.is_in_group("enemigo"):
		if has_sword and body.has_method("take_damage"):
			body.take_damage(5, self)
		else:
			take_damage(5)

	if body.is_in_group("proyectil") or body.is_in_group("obstaculo"):
		take_damage(5)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemigo"):
		if has_sword and area.has_method("take_damage"):
			area.take_damage(5, self)
		else:
			take_damage(5)

	if area.is_in_group("proyectil") or area.is_in_group("obstaculo"):
		take_damage(5)


func add_key():
	if has_key:
		return
	
	has_key = true
	var key_ins = key_scene.instantiate()
	object_holder.add_child(key_ins)
	key_ins.key_animation(true)
	key_ins.get_node("CollisionShape2D").disabled = true #desactiva la colisión de la llave ya que sin esto, si el player saltaba volvía a colisionar con la llave y se ejecutaba la animación "Collected"
	
	


func remove_key():
	has_key = false

func pick_sword():
	if has_sword:
		return
	
	has_sword = true
	var sword_ins = sword_scene.instantiate()
	object_holder.add_child(sword_ins)
	sword_ins.sword_animation(true)
	sword_ins.get_node("CollisionShape2D").disabled = true
	
	notify_pacman_mode()
	print("El jugador recogió la espada")

func clear_object_holder():  #elimina lo que esta en el object holder
	var holder = get_node("ObjectHolder")
	for child in holder.get_children():
		child.queue_free()

func notify_pacman_mode():
	print("Atención a todas las unidades, llamado de emergencia") #Daddy Yankee referencia
	var enemies = get_tree().get_nodes_in_group("enemigos")
	for e in enemies:
		if e is Enemigo:
			e.enter_pacman_mode()
