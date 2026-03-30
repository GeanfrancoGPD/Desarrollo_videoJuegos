extends Area2D

var velocidad_bala = 200
var direccion = Vector2.RIGHT  # Se puede setear al instanciar
@onready var bala: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	bala.play("bala_azul")  # Solo una vez

func _process(delta: float) -> void:
	global_position += direccion * velocidad_bala * delta
	
	# Destruir bala si sale de la pantalla
	var viewport = get_viewport_rect()
	if not viewport.has_point(global_position):
		queue_free()
