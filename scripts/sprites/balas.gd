extends Area2D

@onready var bala: AnimatedSprite2D = $AnimatedSprite2D

var velocidad_bala = 200
var direccion = Vector2.RIGHT
var life_time := 2.0
var shooter: Node = null  # cambiado

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	bala.play("bala_azul")
	var mouse_position := get_local_mouse_position()

	bala.look_at(mouse_position)
	if mouse_position.x > 0:
		bala.scale.y *= -1

func _process(delta):
	life_time -= delta
	global_position += direccion * velocidad_bala * delta

	if life_time <= 0:
		queue_free()
		
func _on_body_entered(body):
	if body == shooter:
		return  # ignorar al que disparó
	
	if body.has_method("recibir_dano"):
		body.recibir_dano(10)
		
	print("Colisionó con:", body.name)
	queue_free()
