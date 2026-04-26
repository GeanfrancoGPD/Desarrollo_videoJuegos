extends Control


@onready var jugadores_label: RichTextLabel = $"TextureRect/TextureRect/#_jugadores"
@onready var ip_label:        RichTextLabel = $TextureRect/TextureRect/Ip_address
@onready var nombre_invitado: Label         = $TextureRect/BarraJugador/Label
@onready var check:           Button        = $TextureRect/BarraJugador/Check
@onready var cruz:            Button        = $TextureRect/BarraJugador/Cruz
@onready var volver:          Button        = $TextureRect/Volver
@onready var iniciar_partida: Button        = $TextureRect/Iniciar_partida
@onready var barra_jugador: Sprite2D = $TextureRect/BarraJugador

var pending_id: int = -1

func _ready() -> void:
	Multijugador.join_requested.connect(_on_join_requested)
	barra_jugador.hide()

	ip_label.bbcode_enabled = true
	ip_label.text = "[color=yellow]%s[/color]" % obtener_ip_local()
	_actualizar_contador()

# ── Llega solicitud → mostrar barra con nombre ──────────
func _on_join_requested(id: int, player_name: String) -> void:
	barra_jugador.show()
	pending_id = id
	nombre_invitado.text = player_name

# ── Aceptar ─────────────────────────────────────────────
func _on_check_pressed() -> void:
	if pending_id == -1:
		return
	Multijugador.response_join.rpc_id(pending_id, true)
	Multijugador.jugadores.append(pending_id)   # agrega al array
	_cerrar_barra()
	_actualizar_contador()

# ── Rechazar ────────────────────────────────────────────
func _on_cruz_pressed() -> void:
	if pending_id == -1:
		return
	Multijugador.response_join.rpc_id(pending_id, false)
	_cerrar_barra()

# ── Iniciar partida ─────────────────────────────────────
func _on_iniciar_partida_pressed() -> void:
	if multiplayer.is_server():
		Multijugador.start_game.rpc()

func _on_volver_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/Menu_Principal.tscn")

# ── Helpers ─────────────────────────────────────────────

func _cerrar_barra() -> void:
	pending_id = -1
	barra_jugador.hide()

func _actualizar_contador() -> void:
	jugadores_label.bbcode_enabled = true
	jugadores_label.text = "[color=yellow]%s/10[/color]" % \
		(Multijugador.jugadores.size() + 1)  # +1 por el host

func obtener_ip_local() -> String:
	for dir in IP.get_local_addresses():
		if "." in dir and not dir.begins_with("127."):
			return dir
	return "No encontrada"
