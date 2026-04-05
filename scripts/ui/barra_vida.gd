extends Control

@onready var bar: ProgressBar = $ProgressBar

func actualizar(vida_actual, vida_maxima):
	var porcentaje = vida_actual * 100.0 / vida_maxima
	
	bar.value = porcentaje
	
	var style = bar.get_theme_stylebox("fill").duplicate()
	
	if porcentaje <= 20:
		style.bg_color = Color.RED
	elif porcentaje <= 75:
		style.bg_color = Color.ORANGE
	else:
		style.bg_color = Color.GREEN
		
	style.border_width_left = 4
	style.border_width_top = 4
	style.border_width_right = 4
	style.border_width_bottom = 4
	style.border_color = Color(0, 0, 0)
	
	
	bar.add_theme_stylebox_override("fill", style)
