extends Area2D

@onready var bala: AnimatedSprite2D = $AnimatedSprite2D

var velocidad_bala = 200
var direccion = Vector2.RIGHT  # Se puede setear al instanciar
var life_time := 2.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	bala.play("bala_azul")

func _process(delta):
	life_time -= delta
	global_position += direccion * velocidad_bala * delta

	if life_time <= 0:
		queue_free()
		
func _on_body_entered(body):
	print("Colisionó con:", body.name)
	queue_free()
