extends Control


func _on_button_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mapa/mapa_1.tscn")


func _on_button_salir_pressed() -> void:
	get_tree().quit()
