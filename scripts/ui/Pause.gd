extends CanvasLayer

@onready var pause_menu: CanvasLayer = $"."

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			pause_menu.resume_game()
		else:
			pause_menu.pause_game()

func _ready():
	hide()

func resume_game():
	get_tree().paused = false
	hide()

func pause_game():
	get_tree().paused = true
	show()

func _on_continuar_pressed() -> void:
	resume_game()

func _on_volver_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/Menu_Principal.tscn")
