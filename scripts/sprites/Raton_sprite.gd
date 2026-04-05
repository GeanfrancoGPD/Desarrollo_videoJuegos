extends Personaje

@onready var animate_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var position_bala: Marker2D = $bala  # Aquí sí funciona

@export var player_id: int = 1

var movimiento = Movimiento.new()
var vida_maxima = vida

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready():
	add_to_group("player")
	var ip = IP.get_local_addresses()
	print(ip[6])
	

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority():
		return
	
	velocity = movimiento.move_character(animate_sprite, delta, position_bala, self, velocidad)
	
	move_and_slide()
