extends SceneTree

var _failures: int = 0

func _initialize() -> void:
	call_deferred("_run")

func _check(condition: bool, message: String) -> void:
	if condition:
		print("PASS: ", message)
	else:
		_failures += 1
		push_error(message)

func _run() -> void:
	var world = load("res://mundo.tscn").instantiate()
	root.add_child(world)
	current_scene = world
	await physics_frame
	var player = world.get_node("ZorVaK")
	var enemy = world.get_node("Enemy_budy")
	var guard = world.get_node("Enemy_guard")
	var door = world.get_node("Puerta")
	guard.chase_speed = 0.0
	_check(world.remaining_enemies == 2 and not door.is_open, "Dos enemigos mantienen cerrada la puerta")
	var crossing := Transform2D(0, Vector2(372, -192))
	_check(player.test_move(crossing, Vector2(0, -96)), "La puerta cerrada bloquea fisicamente la salida")
	world.get_node("Salida")._on_body_entered(player)
	_check(not player.is_complete, "La salida no completa el nivel mientras esta cerrada")
	player.global_position = Vector2(150, -150)
	enemy.global_position = Vector2(220, -150)
	await create_timer(0.25).timeout
	_check(enemy.global_position.x < 215, "El enemigo se acerca cuando ve al jugador")
	player.global_position = Vector2(372, -288)
	enemy.global_position = Vector2(290, -288)
	await physics_frame
	await physics_frame
	_check(enemy.velocity == Vector2.ZERO, "El enemigo no persigue a traves del muro")
	enemy.chase_speed = 0.0
	player.global_position = Vector2.ZERO
	enemy.global_position = Vector2(35, 0)
	enemy.health = 3
	player.collect_sword()
	await physics_frame
	var body_position: Vector2 = player.global_position
	var collision_position: Vector2 = player.get_node("CollisionShape2D").global_position
	var hitbox_shape = player.get_node("ManoPivot/EspadaVisual/HitboxEspada/CollisionShape2D").shape
	var size_before: Vector2 = hitbox_shape.size
	player.atacar()
	await create_timer(0.045).timeout
	_check(player.get_node("Sprite2D").position.x > 0.0, "El ataque tiene impulso visual frontal")
	_check(player.global_position == body_position and player.get_node("CollisionShape2D").global_position == collision_position, "El impulso no desplaza el cuerpo ni su colision")
	_check(hitbox_shape.size == size_before and player.get_node("ManoPivot").position == Vector2.ZERO, "El impulso no cambia tamaño ni origen del arma")
	await create_timer(0.2).timeout
	_check(player.get_node("Sprite2D").position.is_equal_approx(Vector2.ZERO), "El sprite regresa a su posicion base")
	_check(enemy.health == 2, "Cada barrido causa solo un impacto por enemigo")
	enemy.take_damage(99)
	await process_frame
	_check(world.remaining_enemies == 1 and not door.is_open, "Derrotar solo uno no abre la puerta")
	guard.take_damage(99)
	guard.take_damage(99)
	await process_frame
	await physics_frame
	_check(world.remaining_enemies == 0 and door.is_open, "Derrotar ambos abre la puerta una sola vez")
	_check(not player.test_move(crossing, Vector2(0, -96)), "La puerta abierta permite pasar fisicamente")
	player.global_position = Vector2(372, -288)
	await physics_frame
	await physics_frame
	await physics_frame
	_check(player.is_complete, "Entrar en la salida abierta completa el nivel")
	player.take_damage(99)
	_check(not player.is_dead, "No recibe daño despues de completar el nivel")
	var event := InputEventKey.new()
	event.pressed = true
	event.physical_keycode = KEY_R
	player._unhandled_input(event)
	await process_frame
	await process_frame
	_check(not current_scene.get_node("Puerta").is_open and current_scene.remaining_enemies == 2, "Reiniciar restaura puerta y enemigos")
	print("Failures: ", _failures)
	quit(0 if _failures == 0 else 1)
