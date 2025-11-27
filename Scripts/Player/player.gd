extends CharacterBody2D

@export var move_speed : float #el export permite observar y cambiar variables en el inspector
@export var jump_speed : float
@export var health : int = 5
@export var damage : int = 5
@onready var animated_sprite = $AnimatedSprite2D #onready sirve para obtener la referencia antes de que empiece el juego, por lo tanto no es nula
var is_facing_right = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") #obtenemos la gravedad desde la configuración del proyecto

func _physics_process(delta):
	jump(delta)
	move_x()
	flip()
	update_animations()
	move_and_slide()

func update_animations():
	if not is_on_floor():
		if velocity.y < 0:
			animated_sprite.play("Jump")
		else:
			animated_sprite.play("Fall")
		return

	if velocity.x: #si me muevo, se ejecuta la animación de correr sino la de idle
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
	if health <= 0:
		die()

func die():
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void: #si dentro de su area entra un enemigo, recibe daño
	if body.is_in_group("enemigo"):
		take_damage(5)
