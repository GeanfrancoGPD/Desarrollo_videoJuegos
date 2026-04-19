extends Personaje

@onready var animate_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var position_bala: Marker2D = $bala  # Aquí sí funciona

var movimiento = Movimiento.new()
var vida_maxima = vida

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready():
	add_to_group("player")
	#var ip = IP.get_local_addresses()
	## print(ip[6])
	

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority():
		return
	
	velocity = movimiento.move_character(animate_sprite, delta, position_bala, self, velocidad)
	
	move_and_slide()
	
func efecto_dano():
	for i in range(6):
		animate_sprite.modulate.a = 0.3
		await get_tree().create_timer(0.1).timeout
		animate_sprite.modulate.a = 1.0
		await get_tree().create_timer(0.1).timeout
		
func extend_data(data: Dictionary) -> void:
	data["animacion"] = animate_sprite.animation
	data["flip_h"] = animate_sprite.flip_h
