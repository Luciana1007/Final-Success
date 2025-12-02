extends CanvasLayer

@onready var label: Label = $Panel/Label

func _process(delta):
	label.text = str(RecolectorMonedas.coins)
