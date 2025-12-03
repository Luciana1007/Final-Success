extends Node2D

func _ready():
	for anim in get_tree().get_nodes_in_group("animacion"):
		anim.play()
