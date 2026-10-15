Trabaja directamente en este repositorio: ZorVaKQuest, mi proyecto personal de videojuego en Godot 4. Estoy aprendiendo y quiero avanzar con cambios concretos y explicaciones breves en español sin tildes.

Primero lee AGENTS.md si existe, README.md, project.godot, escenas, scripts y tests. Ejecuta git status y conserva mis cambios locales. El codigo actual es la fuente de verdad: no asumas que todos los cambios descritos aqui ya estan instalados. Si faltan, informalo antes de planificar y adapta el trabajo al estado real. No reescribas todo ni cambies de motor.

Concepto: accion, aventura y puzzles top-down inspirados principalmente en Princess Quest de FNaF. Movimiento en 8 direcciones normalizado, espada con barrido frontal de 120 grados, memoria de ultima direccion, corazones y progresion por salas. Mantener mi mapa y recursos de prueba mientras desarrollo las mecanicas.

Avance esperado en el repositorio:
- Inicio en mundo.tscn, jugador sin espada, recogida al noroeste.
- WASD/flechas para moverse, Espacio/click izquierdo para atacar.
- Impulso VISUAL breve al atacar: avanza Sprite2D y vuelve a su origen. NO desplazar CharacterBody2D, CollisionShape2D, ManoPivot ni la hitbox del arma para producir este efecto. Conservar el barrido normal de la espada. La distancia se ajusta con attack_visual_distance.
- Tres corazones, daño por contacto, invulnerabilidad, parpadeo, muerte y reinicio.
- Dos enemigos con persecucion por distancia y linea de vision. Aun no tienen busqueda de rutas.
- Puerta fisica que abre al derrotar a ambos y salida verde al noreste que completa el nivel. R reinicia tras muerte o victoria.
- Recogida y daño independientes de nombres; un impacto por enemigo en cada barrido.

Tu tarea: implementar el siguiente bloque en pasos pequeños y verificables.
1. Curacion: metodo heal(amount) en jugador, limitado por max_health; item de corazon Area2D que se recoge al tocarlo y actualiza el HUD. Define y documenta si permanece en el suelo cuando ya tengo vida completa.
2. Drops configurables: exportar probabilidad de soltar corazon y escena del item en el enemigo. Crear el drop antes de eliminar el enemigo, en su posicion global. Debe funcionar con enemigos duplicados y con derrotas simultaneas; evita dependencias circulares de preload entre escenas. Usa probabilidad 0 y 1 para pruebas deterministas.
3. Dialogo sencillo al obtener la espada: texto letra por letra; una pulsacion completa el texto y la siguiente cierra. Consume correctamente el input para no atacar al avanzar el dialogo. Define y explica como se bloquean jugador y enemigos mientras esta abierto, y como se restaura el estado.
4. Actualiza README y añade pruebas utiles. Conserva las mecanicas anteriores.

Antes de editar, resume lo encontrado y el alcance en pocas lineas; despues implementa. Mantiene responsabilidades claras sin agregar frameworks innecesarios. Usa la version instalada de Godot y revisa la configuracion existente antes de tocarla: el proyecto declara 4.7 y el avance anterior se probo con 4.5.1 headless. No cambies version ni renderer sin una necesidad concreta.

Pruebas existentes:
godot --headless --path . --script res://tests/smoke.gd
godot --headless --path . --script res://tests/progression.gd

Si Godot tiene otro nombre o ruta, adaptalo. Comprueba importacion, errores de scripts y comportamiento. Si no puedes ejecutar el motor, dilo sin afirmar que esta probado. Haz una revision visual cuando el entorno lo permita.

Al terminar, indica archivos cambiados, pruebas ejecutadas y como probarlo en el editor. Explica brevemente el nuevo codigo para que pueda aprender. No hagas reset, borres recursos ni publiques cambios remotos. Deja los cambios revisables y propone un mensaje de commit.
