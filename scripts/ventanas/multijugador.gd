extends Node

var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()

var jugadores: Array = []

signal join_requested(id, name)
signal join_response(accepted)

# ─────────────────────────────────────────
#  HOST
# ─────────────────────────────────────────
func host_game() -> void:
	peer.create_server(3015, 5)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	get_tree().change_scene_to_file("res://scenes/mapa/multijugador.tscn")

# ─────────────────────────────────────────
#  CLIENT
# ─────────────────────────────────────────
func join_game(ip:String) -> void:
	peer.create_client(ip, 3015)
	multiplayer.multiplayer_peer = peer
	await multiplayer.connected_to_server

# ─────────────────────────────────────────
#  PEER CONNECTED  (solo lo llama el servidor)
# ─────────────────────────────────────────
func _on_peer_connected(id: int) -> void:
	# Spawnamos al recién llegado en todos los peers
	spawn_player.rpc(id)

	# Le enviamos al nuevo peer los jugadores que ya existen
	for existing_id in jugadores:
		if existing_id != id:
			spawn_player.rpc_id(id, existing_id)

# ─────────────────────────────────────────
#  SPAWN JUGADOR
# ─────────────────────────────────────────
@rpc("any_peer", "call_local")
func spawn_player(id: int) -> void:
	var world = _get_world()
	if world == null or world.has_node(str(id)):
		return

	var player_instance = load("res://scenes/players/raton_sprite.tscn").instantiate()
	player_instance.name = str(id)
	player_instance.muerto.connect(player_muerto)
	jugadores.append(id)
	world.add_child(player_instance, true)
	player_instance.set_multiplayer_authority(id)

# ─────────────────────────────────────────
#  SPAWN BALA
# ─────────────────────────────────────────
@rpc("any_peer", "call_local")
func spawn_bala(pos: Vector2, dir: Vector2, shooter_id: int) -> void:
	var world = _get_world()
	if world == null:
		return

	var bala = load("res://scenes/armas/balas.tscn").instantiate()
	world.add_child(bala)
	bala.global_position = pos
	bala.direccion = dir

	if world.has_node(str(shooter_id)):
		bala.shooter = world.get_node(str(shooter_id))

# ─────────────────────────────────────────
#  MUERTE / FIN DE PARTIDA
# ─────────────────────────────────────────
func player_muerto(id: int) -> void:
	if !multiplayer.is_server():
		return

	var world = _get_world()
	var nodo_muerto = world.get_node(str(id))
	var data_muerto = nodo_muerto.get_data()
	jugadores.erase(id)

	print("Murió: ", id)

	if jugadores.size() == 1:
		var ganador_id = jugadores[0]
		var data_ganador = world.get_node(str(ganador_id)).get_data()
		terminar_partida.rpc_id(id,        false, data_muerto)
		terminar_partida.rpc_id(ganador_id, true,  data_ganador)
	else:
		terminar_partida.rpc_id(id, false, data_muerto)

@rpc("call_local")
func terminar_partida(es_ganador: bool, data) -> void:
	var escena = load(
		"uid://dw4scvr5vno00" if es_ganador else "uid://hd5whowbygaf"
	).instantiate()
	escena.player_data  = data
	escena.es_ganador   = es_ganador

	get_tree().current_scene.queue_free()
	get_tree().root.add_child(escena)

# ─────────────────────────────────────────
#  JOIN REQUEST / RESPONSE
# ─────────────────────────────────────────
@rpc("any_peer")
func request_join(player_name: String) -> void:
	var id = multiplayer.get_remote_sender_id()
	emit_signal("join_requested", id, player_name)

@rpc("authority")
func response_join(accepted: bool) -> void:
	emit_signal("join_response", accepted)

@rpc("authority", "call_local")
func start_game() -> void:
	get_tree().change_scene_to_file("res://scenes/mapa/multijugador.tscn")

# ─────────────────────────────────────────
#  HELPER
# ─────────────────────────────────────────
func _get_world() -> Node2D:
	var scene = get_tree().current_scene
	if scene == null:
		push_error("No hay escena activa")
		return null
	var world = scene.get_node_or_null("world")
	if world == null:
		push_error("Nodo 'world' no encontrado en la escena actual")
	return world
	
