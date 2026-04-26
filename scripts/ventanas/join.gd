extends Control

@onready var ip: LineEdit = $TextureRect/TextureRect/Ip
@onready var nombre: LineEdit = $TextureRect/TextureRect3/Nombre
@onready var volver: Button = $TextureRect/Volver
@onready var unirse: Button = $TextureRect/Unirse

func _ready() -> void:
	Multijugador.join_response.connect(_on_response)
	ip.text = "Ingrese la Ip"
	nombre.text = "Ingrese su nombre .."

func _on_response(accepted: bool) -> void:
	if accepted:
		ip.text = "¡Aceptado! Entrando..."
	else:
		ip.text = "Rechazado por el host"
		Multijugador.peer.close()             # desconectar si fue rechazado


func _on_unirse_pressed() -> void:
	var ip_text   = ip.text.strip_edges()
	var name = nombre.text.strip_edges()

	if ip_text == "":
		ip_text.text = "Escribe una IP"
		return
	if name == "":
		name.text = "Escribe tu nombre"
		return

	await Multijugador.join_game(ip_text)          # espera conexión
	Multijugador.request_join.rpc_id(1, name) # pide permiso al servidor


func _on_volver_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/Menu_Principal.tscn")
	pass # Replace with function body.
