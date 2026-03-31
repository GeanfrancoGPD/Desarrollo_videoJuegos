extends CharacterBody2D

@onready var animate_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var position_bala: Marker2D = $bala  # Aquí sí funciona
var movimiento = Movimiento.new()

func _physics_process(delta: float) -> void:
	velocity = movimiento.move_character(animate_sprite, delta, position_bala)
	move_and_slide()
