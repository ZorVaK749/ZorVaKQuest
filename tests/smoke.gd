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
	enemy.chase_speed = 0.0
	world.get_node("Enemy_guard").chase_speed = 0.0
	_check(player.health == 3 and not player.has_sword, "Inicio con tres corazones y sin espada")
	player.atacar()
	_check(not player.is_attacking, "No puede atacar sin espada")
	player.name = "JugadorRenombrado"
	world.get_node("EspadaItem")._on_body_entered(player)
	_check(player.has_sword, "Recogida independiente del nombre")
	await process_frame
	_check(not world.has_node("EspadaItem"), "La espada recogida desaparece")
	# Probar contacto real en una zona despejada del mapa.
	enemy.global_position = player.global_position + Vector2(28, 0)
	await physics_frame
	await physics_frame
	await physics_frame
	_check(player.health == 2, "El area de contacto causa daño")
	player.take_damage(1)
	_check(player.health == 2, "Invulnerabilidad impide daño inmediato repetido")
	# Espada y enemigo renombrado: barrido y deteccion fisica reales.
	enemy.name = "EnemigoRenombrado"
	player.last_direction = Vector2.RIGHT
	player.atacar()
	await create_timer(0.3).timeout
	_check(not is_instance_valid(enemy), "El barrido derrota a un enemigo renombrado")
	_check(not player.is_attacking, "El ataque termina")
	await create_timer(1.1).timeout
	player.take_damage(1)
	_check(player.health == 1, "El daño vuelve a estar habilitado tras invulnerabilidad")
	await create_timer(1.1).timeout
	player.take_damage(1)
	_check(player.is_dead and player.health == 0, "Muerte al agotar corazones")
	player.atacar()
	_check(not player.is_attacking, "No ataca despues de morir")
	var event := InputEventKey.new()
	event.pressed = true
	event.physical_keycode = KEY_R
	player._unhandled_input(event)
	await process_frame
	await process_frame
	var fresh = current_scene.get_node("ZorVaK")
	_check(fresh.health == 3 and not fresh.has_sword and not fresh.is_dead, "Reiniciar restaura vida, espada y estado")
	_check(current_scene.has_node("Enemy_budy") and current_scene.has_node("EspadaItem"), "Reiniciar restaura los objetos del mundo")
	print("Failures: ", _failures)
	quit(0 if _failures == 0 else 1)
