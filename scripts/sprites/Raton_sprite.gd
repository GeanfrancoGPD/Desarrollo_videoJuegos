extends Personaje

@onready var animate_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var position_bala: Marker2D = $bala  # Aquí sí funciona
@onready var barra_vida: Control = $barra_vida

var movimiento = Movimiento.new()
var vida_maxima = vida
var vida_actual = vida_maxima

func _physics_process(delta: float) -> void:
	velocity = movimiento.move_character(animate_sprite, delta, position_bala, self, velocidad)
	move_and_slide()
	barra_vida.actualizar(vida_actual, vida_maxima)
