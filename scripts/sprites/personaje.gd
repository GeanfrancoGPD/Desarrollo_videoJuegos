extends CharacterBody2D
class_name Personaje

@export var vida: int = 100
@export var velocidad: float = 200

func recibir_dano(cantidad: int):
	vida -= cantidad
	print("Vida restante:", vida)
	
	if vida <= 0:
		morir()

func morir():
	queue_free()
