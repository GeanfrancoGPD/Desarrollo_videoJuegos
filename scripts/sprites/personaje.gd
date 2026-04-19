extends CharacterBody2D
class_name Personaje

@export var vida: float = 100.0
@export var velocidad: float = 300
@export var player_id: int

signal muerto(player_id)

func recibir_dano(cantidad: float):
	vida -= cantidad
	print("Vida restante:", vida)
	
	efecto_dano()
	
	if vida <= 0:
		morir()

func morir():
	muerto.emit(name.to_int())
	queue_free()
	
func efecto_dano():
	pass
	
func get_data() -> Dictionary:
	var data = {}
	
	data["vida"] = vida
	data["velocidad"] = velocidad
	data["player_id"] = player_id
	data["scene"] = scene_file_path 
	extend_data(data)
	return data

# Esta función puede ser sobrescrita en los hijos
func extend_data(data: Dictionary) -> void:
	# Los hijos pueden añadir información adicional aquí
	pass
