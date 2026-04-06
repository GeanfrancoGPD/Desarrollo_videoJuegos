extends Node2D

var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
@onready var center_container: CenterContainer = $Menu
@onready var join_button: Button = $Menu/VBoxContainer/join


var spawn_points: Array[Marker2D] = []
var player_local: Node2D
var jugadores: Array =[]

# Elementos UI
@onready var world: Node2D = $world
@onready var camera_2d: Camera2D = $ui/Camera2D
@onready var barra_vida: Control = $ui/Camera2D/barra_vida


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#join_button.pressed.connect(_on_join_pressed)
	#pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player_local:
		camera_2d.global_position = player_local.global_position
		barra_vida.actualizar(player_local.vida, player_local.vida_maxima)

func _on_host_pressed() -> void:
	peer.create_server(3015, 2)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_peer_conneted)
	
	#cargar mapa 
	var leven = load("res://scenes/mapa/mapa_1.tscn").instantiate()
	world.add_child(leven, true)
	
	_on_peer_conneted()
	center_container.hide()

func _on_join_pressed() -> void:
	peer.create_client("localhost", 3015)
	multiplayer.multiplayer_peer = peer
	center_container.hide()
	  
	# esperar conexión real
	await multiplayer.connected_to_server
	
	# cargar mapa también en cliente
	var leven = load("res://scenes/mapa/mapa_1.tscn").instantiate()
	world.add_child(leven, true)
	
	# crear jugador local
	spawn_player.rpc(multiplayer.get_unique_id())
		

func _on_peer_conneted(id: int = 1):
	if id == multiplayer.get_unique_id():
		spawn_player(id) # solo el host se crea a sí mismo aquí
	else:
		spawn_player.rpc(id) # avisamos a los clientes
		
	for existing_id in world.get_children():
		var existing_player_id = existing_id.name.to_int()
		if existing_player_id != id:
			spawn_player.rpc_id(id, existing_player_id)

@rpc("any_peer")
func spawn_player(id):
	if world.has_node(str(id)):
		return
		
	var player_scene = load("res://scenes/players/raton_sprite.tscn")
	var player_instance = player_scene.instantiate()
	
	player_instance.name = str(id)
	player_instance.muerto.connect(player_muerto)
	jugadores.append(id)
	world.add_child(player_instance, true)
	
	player_instance.set_multiplayer_authority(id)
	
	# asignar cámara si es tu player
	if id == multiplayer.get_unique_id():
		camera_2d.make_current()
		player_local = player_instance
		
		
@rpc("any_peer","call_local")
func spawn_bala(pos: Vector2, dir: Vector2, shooter_id: int):
	var bala_scene = load("res://scenes/armas/balas.tscn")
	var bala = bala_scene.instantiate()
	
	world.add_child(bala)
	
	bala.global_position = pos
	bala.direccion = dir
	
	# asignar shooter correctamente
	if world.has_node(str(shooter_id)):
		bala.shooter = world.get_node(str(shooter_id))
		
		
func player_muerto(id:int):
	if !multiplayer.is_server():
		return
		
	jugadores.erase(id)
	
	if jugadores.size() == 1:
		var ganador = jugadores[0]
		game_over(ganador)
	
	
@rpc("any_peer", "call_local")
func game_over(ganador):
	print("GANADOR:", ganador)
	
#func get_spawn_position(player_id: int) -> Vector2:
	#if spawn_points.size() == 0:
		#return Vector2.ZERO
	## por ejemplo, asigna spawn según el ID modulo la cantidad de spawn points
	#var index = player_id % spawn_points.size()
	#return spawn_points[index].global_position
