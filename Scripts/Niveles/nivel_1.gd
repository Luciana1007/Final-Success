extends Node2D
@onready var level_timer: Timer = $LevelTimer
@onready var time_label: Label = $TimerVisual/TimeLabel
@onready var coin_drain_timer: Timer = $CoinDrainTimer
@onready var area_victoria: Area2D = $AreaVictoria


var objects_to_respawn := []
var draining_coin : bool = false

func _ready():
	level_timer.start()
	update_timer_display()
	
	if has_node("Espada"):
		var sword = get_node("Espada")
		sword.sword_collected.connect(on_sword_collected)

	for item in get_tree().get_nodes_in_group("objetos"):
		objects_to_respawn.append({
			"scene": item.scene_file_path,
			"position": item.position
		})
	
	area_victoria.deactivate_area()
	# Conectar el área de victoria
	area_victoria.victory.connect(on_victory)

func _process(delta):
	if level_timer.time_left <= 0 :
		update_timer_display()
		_on_level_timer_timeout()
	else:
		update_timer_display()

func update_timer_display():
	var time_left = level_timer.time_left
	var minutes = int(time_left) / 60
	var seconds = int(time_left) % 60
	time_label.text = "%02d:%02d" % [minutes, seconds]

func _on_level_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Escenas/Menu/menu.tscn")

func add_time(seconds: float):
	level_timer.start(level_timer.time_left + seconds)

func register_sword(sword):
	sword.sword_collected.connect(on_sword_collected)


func on_sword_collected():
	print("El jugador obtuvo la espada. Time Change!")
	level_timer.start(level_timer.time_left - 20) #se bajan x cantidad de segundos

	respawn_objects()

	draining_coin = true
	coin_drain()

	area_victoria.activate_area()
	print("Area Activada!")

func respawn_objects():
	for data in objects_to_respawn:
		var scene = load(data["scene"])
		var new_object = scene.instantiate()
		new_object.position = data["position"]
		add_child(new_object)

func coin_drain():
	if not draining_coin:
		return
	
	RecolectorMonedas.coins -= 1
	print("Oro Actual:", RecolectorMonedas.coins)
	
	if RecolectorMonedas.coins <= 0:
		RecolectorMonedas.coins = 0
		draining_coin = false
		print("Quedaste seco, no hay más plata")
		return
	
	coin_drain_timer.start() #si todavia hay oro, disminuye

func on_victory():
	print("¡Victoria! El jugador llegó al área de escape.")
	get_tree().change_scene_to_file("res://Escenas/Menu/menu.tscn")
