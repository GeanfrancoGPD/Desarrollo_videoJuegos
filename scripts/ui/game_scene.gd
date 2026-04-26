extends Node2D

@onready var world:     Node2D   = $world
@onready var camera:    Camera2D = $ui/Camera2D
@onready var barra_vida: Control = $ui/Camera2D/barra_vida

var player_local: Node2D = null

func _ready() -> void:
	# Cargar mapa
	var mapa = load("res://scenes/mapa/mapa_1.tscn").instantiate()
	world.add_child(mapa, true)

	# Si somos servidor, ya tenemos peer activo → spawneamos al host
	if multiplayer.is_server():
		Multijugador.spawn_player.rpc(multiplayer.get_unique_id())
	else:
		# Cliente: pedimos nuestro spawn al servidor
		Multijugador.spawn_player.rpc_id(1, multiplayer.get_unique_id())

	# Esperar a que nuestro jugador aparezca en el árbol
	await get_tree().process_frame
	_buscar_player_local()

func _buscar_player_local() -> void:
	var my_id = str(multiplayer.get_unique_id())
	player_local = world.get_node_or_null(my_id)
	if player_local:
		camera.make_current()

func _process(_delta: float) -> void:
	if player_local and is_instance_valid(player_local):
		camera.global_position = player_local.global_position
		barra_vida.actualizar(player_local.vida, player_local.vida_maxima)
