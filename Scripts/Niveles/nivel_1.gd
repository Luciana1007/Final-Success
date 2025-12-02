extends Node2D
@onready var level_timer: Timer = $LevelTimer
@onready var time_label: Label = $CanvasLayer/TimeLabel


func _ready():
	level_timer.start()
	update_timer_display()
	
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
