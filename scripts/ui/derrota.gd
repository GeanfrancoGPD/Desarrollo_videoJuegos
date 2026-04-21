extends Control

var es_ganador
var player_data

func _ready():
	var player_scene = load(player_data["scene"])
	var player = player_scene.instantiate()
	add_child(player)

	player.get_data()
	player.position = get_viewport_rect().size / 3
	player.get_node("AnimatedSprite2D").play("Derrota")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/Menu_Principal.tscn")
