extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_toast("hola mi brodi")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
	
func show_toast(mensaje: String) -> void:
	var label = Label.new()
	label.text = mensaje
	
	# 1. Configuración inicial
	label.modulate.a = 0.0  # Empezamos invisible
	label.position = Vector2(500, 20) # O la posición que prefieras
	add_child(label)
	
	# 2. Crear el Tween vinculado al label
	var tween = create_tween()

	# 1. APARECER Y BAJAR (Dura 0.5s)
	tween.set_parallel(true)
	tween.tween_property(label, "modulate:a", 1.0, 0.5)
	# Usamos as_relative() para que sume 80 a la posición actual
	tween.tween_property(label, "position:y", 80, 0.5).as_relative()

	# 2. ESPERA (Aquí es donde se detiene 8 segundos)
	tween.set_parallel(false) # IMPORTANTE: Volver a secuencial para que el intervalo cuente
	tween.tween_interval(8.0) 

	# 3. DESVANECER Y SUBIR (Después de los 8s)
	#tween.set_parallel(true)
	#tween.tween_property(label, "modulate:a", 0.0, 0.5)
	## Usamos as_relative() para que reste 60 desde donde se quedó
	#tween.tween_property(label, "position:y", -60, 1.0).as_relative()
#
	## 4. LIMPIEZA
	#tween.set_parallel(false)
	#tween.tween_callback(label.queue_free)
