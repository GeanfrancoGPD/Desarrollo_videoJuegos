extends CanvasLayer

@export var pause_menu : CanvasLayer

@export var volumen_general: HSlider
@export var volumen_musica: HSlider
@export var volumen_sfx: HSlider

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Inicializar sliders con volumen actual
	volumen_general.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	volumen_musica.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	volumen_sfx.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))

# BOTON VOLVER
func _on_volver_pressed() -> void:
	if get_tree().paused:
		visible = false
		pause_menu.visible = true
	else:
		visible=false
		#get_tree().change_scene_to_file("res://scenes/ui/Menu_Principal.tscn")

# SLIDERS
func _on_volumen_general_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"),
		linear_to_db(value)
	)

func _on_volumen_musica_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"),
		linear_to_db(value)
	)

func _on_volumen_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("SFX"),
		linear_to_db(value)
	)
