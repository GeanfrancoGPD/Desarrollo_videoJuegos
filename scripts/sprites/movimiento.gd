extends Node

class_name Movimiento
var velocity : Vector2 = Vector2.ZERO
var shooting_timer : float = 0
const Balas = preload("res://scenes/armas/balas.tscn")

func move_character(animate_sprite: AnimatedSprite2D, delta: float, position_bala: Marker2D, Player_nodo: Node, velocidad: float) -> Vector2:
	var direction = Vector2.ZERO

	# MOVIMIENTO
	if Input.is_action_pressed("right"): direction.x += 1
	if Input.is_action_pressed("left"): direction.x -= 1
	if Input.is_action_pressed("down"): direction.y += 1
	if Input.is_action_pressed("up"): direction.y -= 1

	if Input.is_action_just_pressed("disparo"):
		Disparar(Player_nodo, animate_sprite, delta)
		
	# TIMER DISPARO
	if shooting_timer > 0:
		shooting_timer -= delta
		if direction.x != 0:
			animate_sprite.play("Disparar")
			animate_sprite.flip_h = direction.x < 0
		else:
			animate_sprite.play("Disparar")
			
		
		velocity = Vector2.ZERO
		return velocity
		
	
	# ANIMACIONES DE MOVIMIENTO
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * velocidad
		if direction.x != 0:
			animate_sprite.play("Correr")
			animate_sprite.flip_h = direction.x < 0
		elif direction.y < 0:
			animate_sprite.play("Caminar_arriba")
		elif direction.y > 0:
			animate_sprite.play("Bajar")
		else:
			animate_sprite.play("Normal")
	else:
		velocity = Vector2.ZERO
		animate_sprite.play("Normal")
	
	return velocity

func Disparar(Player_nodo: Node, animate_sprite: AnimatedSprite2D, delta:float):
	shooting_timer = 0.2
	velocity = Vector2.ZERO
	

	var shoot = Balas.instantiate()
	Player_nodo.get_tree().current_scene.add_child(shoot)

	# 🎯 Dirección real 360°
	
	var direccion = (Player_nodo.get_global_mouse_position() - Player_nodo.global_position).normalized()
	shoot.shooter = Player_nodo
	shoot.direccion = direccion

	# Spawn delante del player
	var offset = direccion * 20
	shoot.global_position = Player_nodo.global_position + offset
	
