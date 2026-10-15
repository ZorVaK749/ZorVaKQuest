extends CharacterBody2D

@export var speed = 250

# --- NUEVA VARIABLE ---
var has_sword = false  # Empieza en falso: no tienes arma

var is_attacking = false
var last_direction = Vector2.RIGHT 

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction:
		velocity = direction * speed
		last_direction = direction
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func _input(event):
	if event.is_action_pressed("attack"):
		atacar()

func atacar():
	if has_sword == false:
		return
	if is_attacking:
		return
	
	is_attacking = true
	
	# Referencias
	var pivot = $ManoPivot
	var espada = $ManoPivot/EspadaVisual
	
	# 1. Hacemos visible la espada
	espada.visible = true
	
	# 2. Calcular hacia dónde mirar
	# Obtenemos el ángulo de la última dirección (0 es derecha, 90 es abajo, etc.)
	var angulo_ataque = last_direction.angle()
	
	# 3. Posición INICIAL del golpe (Retroceso)
	# Empezamos 60 grados "atrás" de la dirección de ataque
	# Esto hace que el golpe empiece desde un lado
	pivot.rotation = angulo_ataque - deg_to_rad(60)
	
	var tween = create_tween()
	
	# 4. El Barrido (Swing)
	# Giramos el pivote 120 grados hacia el otro lado
	# Esto cubre todo el frente del personaje (de -60 a +60)
	tween.tween_property(pivot, "rotation", angulo_ataque + deg_to_rad(60), 0.15)\
		.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	
	# 5. Limpieza
	espada.visible = false
	is_attacking = false


func _on_hitbox_espada_body_entered(body: Node2D) -> void:
	# 1. Primero confirmamos que el choque ocurra SOLO mientras atacamos
	if is_attacking == true:
		# 2. Verificamos si lo que tocamos se llama "Enemy_budy"
		if body.name == "Enemy_budy":
			print("¡ZAS! Has derrotado a Enemy_budy!")
			# 3. Borramos al enemigo del juego
			body.queue_free() # Replace with function body.
