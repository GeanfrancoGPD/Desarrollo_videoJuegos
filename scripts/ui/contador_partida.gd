extends Control

@onready var p1: Label = $Label
@onready var p3: Label = $Label2
@onready var p2: Label = $Label3


func _ready():
	actualizar(1,0)

func actualizar(valor_1: int, valor_2:int):
	p1.text = str(valor_1)
	p2.text = str(valor_2)
	
	# efecto tamaño
	if valor_1 > valor_2:
		p1.scale = Vector2(2, 2)
		p2.scale = Vector2(1, 1)
	elif valor_2 > valor_1:
		p2.scale = Vector2(2, 2)
		p1.scale = Vector2(1, 1)
	else:
		p1.scale = Vector2(1.2, 1.2)
		p2.scale = Vector2(1.2, 1.2)
		
	# Estilos
	p1.add_theme_color_override("font_color", Color.WHITE)
	p1.add_theme_font_size_override("font_size", 45)
	p2.add_theme_color_override("font_color", Color.WHITE)
	p2.add_theme_font_size_override("font_size", 45)
	p3.add_theme_color_override("font_color", Color.BLACK)
	p3.add_theme_font_size_override("font_size", 45)
	
	var style1 = StyleBoxFlat.new()
	style1.bg_color = Color.BLUE
	p1.add_theme_stylebox_override("normal", style1)

	var style2 = StyleBoxFlat.new()
	style2.bg_color = Color.RED
	p2.add_theme_stylebox_override("normal", style2)
		
	
	
	
	
