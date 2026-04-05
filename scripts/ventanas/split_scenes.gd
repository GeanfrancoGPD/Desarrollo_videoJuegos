extends Node

@onready var scene_continer: GridContainer = $CenterContainer/GridContainer

const player_carama = preload("res://scenes/players/raton_sprite.tscn")

var level_to_load: String = "res://scenes/mapa/mapa_1.tscn"
var primera_subvieport: SubViewport = null
var level_node: Node2D = null

func _ready() -> void:
	_add_new_player_viewport(null)
	_update_viewport_size()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var new_player: CharacterBody2D = load("res://scenes/players/raton_sprite.tscn").instantiate()
		new_player.player_id = scene_continer.get_child_count()
		level_node.add_child(new_player)
		_add_new_player_viewport(new_player)
		_update_viewport_size()
	
	if Input.is_action_just_pressed("ui_cancel"):
		var scene_to_remove: SubViewportContainer = scene_continer.get_child(scene_continer.get_child_count() -1)
		var player_remove: CharacterBody2D
		for i in level_node.get_tree().get_nodes_in_group("player"):
			if i.player_id == scene_continer.get_child_count() -1:
				player_remove = i
		
		scene_to_remove.free()
		player_remove.free()
		_update_viewport_size()
	
func _add_new_player_viewport(new_player_node: CharacterBody2D) -> void:
	var Contenedor: SubViewportContainer = SubViewportContainer.new() 
	var subContenedor: SubViewport = SubViewport.new()
	
	Contenedor.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	subContenedor.disable_3d = true
	
	var player_instance = player_carama.instantiate()
	var new_camara: Camera2D = player_instance.get_node("Camera2D")
	
	scene_continer.add_child(Contenedor)
	Contenedor.add_child(subContenedor)
	
	if primera_subvieport:
		# 🔹 Ya existe un viewport previo
		subContenedor.world_2d = primera_subvieport.world_2d
		
		if new_player_node:
			new_player_node.get_node("RemoteTransform2D").remote_path = new_camara.get_path()
	else:
		# 🔹 Primer viewport
		level_node = load(level_to_load).instantiate()
		subContenedor.add_child(level_node)
		
		primera_subvieport = subContenedor
		
		var players = level_node.get_tree().get_nodes_in_group("player")

		if players.size() > 0:
			players[0].get_node("RemoteTransform2D").remote_path = new_camara.get_path()
		else:
			print("⚠️ Aún no hay players")
			
func _update_viewport_size() -> void:
	scene_continer.columns = ceil(scene_continer.get_child_count() / 2.0)
	for ventana in scene_continer.get_children():
		var ventana_nodo: SubViewport = ventana.get_child(0)
		var game_size: Vector2 = get_viewport().get_visible_rect().size
		ventana_nodo.size.x = game_size.x / float(scene_continer.columns)
		ventana_nodo.size.y = game_size.y / ceil(float(scene_continer.get_child_count() / float(scene_continer.columns)))
