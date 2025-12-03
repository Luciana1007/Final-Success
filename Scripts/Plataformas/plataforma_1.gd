extends CharacterBody2D

@export var speed: float = 100.0
@export var distancia: float = 200.0  # hasta dónde se mueve desde el punto inicial
# Direcciones disponibles: "horizontal", "vertical", "diagonal_1", "diagonal_2"
@export_enum("horizontal", "vertical", "diagonal_1", "diagonal_2") 

var movimiento: String = "horizontal"
var origen: Vector2
var destino: Vector2
var move_to_destiny:= true

func _ready():
	origen = global_position

	match movimiento:
		"horizontal":
			destino = origen + Vector2(distancia, 0)
		"vertical":
			destino = origen + Vector2(0, distancia)
		"diagonal_1":   # ↗ (derecha-arriba)
			destino = origen + Vector2(distancia, -distancia)
		"diagonal_2":   # ↘ (derecha-abajo)
			destino = origen + Vector2(distancia, distancia)

func _physics_process(delta):
		if typeof(destino) != TYPE_VECTOR2:
			print("destino NO es Vector2 sino:", destino, " TYPE=", typeof(destino))
			return

		if typeof(origen) != TYPE_VECTOR2:
			print("origen NO es Vector2 sino:", origen, " TYPE=", typeof(origen))
			return

		var objetivo: Vector2 = destino if move_to_destiny else origen

		var dir := objetivo - global_position

		if dir.length() < 1.0:
			move_to_destiny = !move_to_destiny
			return

		dir = dir.normalized()
		global_position += dir * speed * delta
