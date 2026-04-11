extends CharacterBody2D
class_name Personaje

@export var vida: float = 100.0
@export var velocidad: float = 200
@export var player_id: int

signal muerto(id)

func recibir_dano(cantidad: float):
	vida -= cantidad
	print("Vida restante:", vida)
	
	efecto_dano()
	
	if vida <= 0:
		morir()

func morir():
	muerto.emit(multiplayer.get_unique_id())
	queue_free()
	
func efecto_dano():
	
	pass
	
