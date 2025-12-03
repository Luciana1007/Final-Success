extends Panel

@onready var segundos_label: Label = $SegundosLabel
var tween: Tween

func show_amount(amount: int) -> void:
	segundos_label.text = "%+ds" % amount
	
	if amount < 0:
		segundos_label.modulate = Color.RED
	
	visible = true
	modulate.a = 0   # empieza invisible
	run_tween()    # llama a la animación


func run_tween():
	# Si ya hay tween corriendo, detenerlo
	if tween and tween.is_running():
		tween.kill()

	tween = create_tween()

	tween.tween_property(self, "modulate:a", 1.0, 0.25)  # fade in
	tween.tween_interval(0.5)                            # pausa
	tween.tween_property(self, "modulate:a", 0.0, 0.3)   # fade out
	tween.tween_callback(Callable(self, "_on_tween_finished"))

func on_tween_finished():
	visible = false
