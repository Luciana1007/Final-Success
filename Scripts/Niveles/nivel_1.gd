extends Node2D
@onready var level_timer: Timer = $LevelTimer
@onready var time_label: Label = $TimerVisual/TimeLabel
@onready var coin_drain_timer: Timer = $CoinDrainTimer
@onready var area_victoria: Area2D = $AreaVictoria
@onready var perdiste_panel: Panel = $Carteles/PerdistePanel
@onready var victoria_panel: Panel = $Carteles/VictoriaPanel
@onready var monedas_label: Label = $Carteles/VictoriaPanel/MonedasLabel
@onready var segundos_panel: Panel = $Carteles/SegundosPanel



var objects_to_respawn := []
var draining_coin : bool = false

func _ready():
	level_timer.start()
	update_timer_display()
	RecolectorMonedas.restart_coins()

	perdiste_panel.visible = false
	victoria_panel.visible = false

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
	time_label.text = "%02d : %02d" % [minutes, seconds]

func _on_level_timer_timeout() -> void:  #mostrar el panel de perdiste si se acaba el tiempo
	show_lose_screen()

func show_lose_screen():
	get_tree().paused = true
	perdiste_panel.visible = true #el panel es visible


func on_player_death():
	get_tree().paused = true
	show_lose_screen() #mostrar el panel de perdiste si el jugador muere

func add_time(seconds: float, world_pos : Vector2 ):
	level_timer.start(level_timer.time_left + seconds)
	
	if world_pos != null:
		show_added_time(int(seconds))
		
func register_sword(sword):
	sword.sword_collected.connect(on_sword_collected)

func show_added_time(amount: int):
	segundos_panel.visible = true
	segundos_panel.show_amount(amount)

func on_sword_collected():
	print("El jugador obtuvo la espada. Time Change!")
	level_timer.start(level_timer.time_left - 20) #se bajan x cantidad de segundos
	segundos_panel.show_amount(-20)
	respawn_objects()

	draining_coin = true
	coin_drain()

	area_victoria.activate_area()
	print("Area Activada!")
	
	var enemies = get_tree().get_nodes_in_group("enemigo")
	for enemy in enemies:
		enemy.enter_pacman_mode()
		print("Pacman Mode Activado en:", enemy)

func respawn_objects():
	for data in objects_to_respawn:
		var position = data["position"]

		# Verificar si YA EXISTE un objeto en esa posición
		var exists = false
		for obj in get_tree().get_nodes_in_group("objetos"):
			if obj.position == position:
				exists = true
				break

		if exists:
			continue  # Ya hay un objeto aquí → NO respawnear

		# Crear el objeto porque no existe ninguno en ese lugar
		var scene = load(data["scene"])
		var new_object = scene.instantiate()
		new_object.position = position
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
	get_tree().paused = true
	victoria_panel.visible = true
	monedas_label.text = "Ganaste! 
	Monedas: " + str(RecolectorMonedas.coins)


func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/Menu/menu.tscn")
