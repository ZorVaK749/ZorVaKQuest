# ZorVaKQuest

Prototipo personal de accion y aventura top-down en Godot 4, inspirado principalmente en Princess Quest.

## Abrir y jugar

1. Descomprime el proyecto en una carpeta nueva para comparar con tu copia anterior.
2. Importa `project.godot` en Godot 4. Usa preferentemente la version con la que trabajabas.
3. Espera la importacion de recursos y pulsa F5. La escena principal ahora es `mundo.tscn`.
4. Muevete con WASD o flechas. La espada esta al noroeste del inicio, en (-307, -546).
5. Ataca con Espacio o click izquierdo despues de recogerla.
6. El enemigo rojo sigue quieto: acercarte hace daño. Al morir pulsa R o el boton Reintentar.

## Primer avance: vida y daño

- Tres corazones en una interfaz que no depende del zoom de la camara.
- Un segundo de invulnerabilidad y parpadeo al recibir daño.
- Muerte, bloqueo del movimiento/ataque y reinicio completo del nivel.
- Enemigo de prueba con vida y daño por contacto configurables.
- Ataque y recogida de espada independientes del nombre de los nodos.
- Comprobacion de enemigos que ya estaban dentro de la hitbox al comenzar un ataque.
- Escena principal corregida: antes apuntaba a `player.tscn`.
- Mapa, controles y barrido original de la espada conservados.

No se añadieron aun persecucion, puertas, curacion, dialogos ni arte definitivo.

## Archivos para aprender y ajustar

| Archivo | Responsabilidad |
| --- | --- |
| `player.gd` | Movimiento, ataque, vida, invulnerabilidad y muerte. |
| `enemy_budy.gd` | Vida del enemigo y daño por contacto. |
| `hud.gd` | Corazones y boton de reintento. |
| `espada_item.gd` | Recogida de espada. |
| `mundo.tscn` | Tu mapa y posiciones originales. |

En el Inspector del jugador puedes ajustar `max_health`, `invulnerability_seconds` y `speed`. En el enemigo puedes ajustar `max_health` y `contact_damage`. `ContactArea` es un circulo ligeramente mayor que su cuerpo para detectar la cercania incluso cuando las colisiones impiden superponerse.

## Crear el repositorio

Conviene guardar este proyecto en Git. Puedes comenzar con un repositorio privado.

1. En GitHub crea un repositorio llamado `ZorVaKQuest`. Dejalo vacio, sin README ni .gitignore, porque estos archivos ya estan aqui.
2. Abre PowerShell en la carpeta que contiene `project.godot`.
3. Ejecuta:

```powershell
git init -b main
git add .
git commit -m "Base jugable: vida, dano y reinicio"
git remote add origin https://github.com/ZorVaK749/ZorVaKQuest.git
git push -u origin main
```

El comando de remote supone que creaste ese repositorio en tu cuenta ZorVaK749. Ajustalo si elegiste otro nombre. Si Git te pide identidad, configura tu nombre y el correo de GitHub antes de repetir el commit.

Conserva tambien el ZIP original como respaldo. Para los siguientes avances crea commits pequeños: `git add .` y `git commit -m "Descripcion del cambio"`; despues `git push`.

Sube escenas, scripts, recursos originales y archivos `.uid`. La carpeta `.godot/` se regenera y esta excluida. El repositorio remoto no se ha creado desde esta entrega.

## Siguiente objetivo

Añadir un enemigo con persecucion y una puerta que se abra al limpiar una sala.

## Validacion de esta entrega

Importacion y prueba automatica ejecutadas con Godot 4.5.1 en modo headless: 13 comprobaciones correctas sobre inicio, bloqueo sin espada, recogida, contacto fisico, invulnerabilidad, barrido contra enemigo renombrado, muerte y reinicio. No se realizo una revision visual de la interfaz; verifica los corazones al abrirlo en tu equipo.

Para repetir la prueba con Godot disponible en el PATH:

```powershell
godot --headless --path . --script res://tests/smoke.gd
```

El proyecto original declara Godot 4.7 en `config/features`; se conservo esa configuracion. La prueba en 4.5.1 paso, pero usa preferentemente tu version habitual y conserva una copia antes de abrirlo con otra version.
