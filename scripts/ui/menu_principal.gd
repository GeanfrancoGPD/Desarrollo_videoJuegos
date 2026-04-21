extends Control
@export var opciones: CanvasLayer


func _on_button_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mapa/multijugador.tscn")


func _on_button_salir_pressed() -> void:
	get_tree().quit()

func _on_button_creditos_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/Creditos.tscn")


func _on_button_opciones_pressed() -> void:
	opciones.visible = true
