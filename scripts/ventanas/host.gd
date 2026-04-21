extends Control

@onready var jugadores: RichTextLabel = $"TextureRect/TextureRect/#_jugadores"
@onready var ip_address: RichTextLabel = $TextureRect/TextureRect/Ip_address

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ip = obtener_ip_local()
	var n_jugadores = 1
	var max_jugadores = 10
	ip_address.bbcode_enabled = true
	jugadores.bbcode_enabled = true
	jugadores.text += "[color=yellow]%s/%s[/color]" % [n_jugadores, max_jugadores]
	ip_address.text += "[color=yellow]%s[/color]" % ip
	print("IP local",obtener_ip_local())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func obtener_ip_local() -> String:
	for direccion in IP.get_local_addresses():
		# Filtra para obtener solo IPv4 (4 octetos) y evitar la dirección de loopback
		if "." in direccion and not direccion.begins_with("127."):
			return direccion
	return "No se encontró IP"
	
