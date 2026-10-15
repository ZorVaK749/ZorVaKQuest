extends Area2D

# Esta función se activa sola cuando algo entra en el área
func _on_body_entered(body):
	# Verificamos si el cuerpo que entró se llama "ZorVaK" (o como le hayas puesto a tu nodo Player)
	# OJO: Asegúrate de que en la escena "Mundo", tu jugador se llame "ZorVaK"
	if body.name == "ZorVaK":
		# Accedemos a la variable del jugador y se la activamos
		body.has_sword = true
		
		print("¡Has conseguido la espada!")
		
		# Borramos el item del suelo (porque ya lo recogiste)
		queue_free()
