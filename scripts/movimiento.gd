extends Node

class_name Movimiento
var speed : float = 200
var velocity : Vector2 = Vector2.ZERO
var shooting_timer : float = 0
const Balas = preload("res://scenes/armas/balas.tscn")

func move_character(animate_sprite: AnimatedSprite2D, delta: float, position_bala: Marker2D) -> Vector2:
	var direction = Vector2.ZERO

	# MOVIMIENTO
	if Input.is_action_pressed("right"): direction.x += 1
	if Input.is_action_pressed("left"): direction.x -= 1
	if Input.is_action_pressed("down"): direction.y += 1
	if Input.is_action_pressed("up"): direction.y -= 1

	# DISPARO
	if Input.is_action_just_pressed("disparo"):
		shooting_timer = 0.2
		velocity = Vector2.ZERO
		animate_sprite.play("Disparar")
		var shoot = Balas.instantiate()
		get_tree().current_scene.add_child(shoot)
		shoot.direccion = direction if direction != Vector2.ZERO else Vector2.RIGHT
		if direction == Vector2.RIGHT or direction == Vector2.ZERO:
			shoot.scale.x *= -1
		shoot.global_position = position_bala.global_position

	# TIMER DISPARO
	if shooting_timer > 0:
		shooting_timer -= delta
		animate_sprite.play("Disparar")
		velocity = Vector2.ZERO
		return velocity

	# ANIMACIONES DE MOVIMIENTO
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * speed
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
