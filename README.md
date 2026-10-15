# ZorVaKQuest

Juego personal top-down en Godot 4, inspirado principalmente en Princess Quest de FNaF. Prototipo con recursos provisionales.

## Versiones del repositorio

- `main`: version nueva con salud, persecucion, puerta y salida. Proyecto unificado en la raiz.
- `beta-0.1`: version original que se abria antes de la unificacion, con espada y un enemigo, sin las mecanicas nuevas. Tambien se abre desde el `project.godot` de la raiz.

Guarda tus cambios antes de cambiar de rama y cierra Godot para no mezclar escenas abiertas de distintas versiones.

## Probar el nivel

1. Usa la carpeta principal del repositorio: `C:\Users\ZorVa\Desktop\Proyectos\ZorVaKQuest`. El proyecto actualizado ya esta aqui; no hay que copiarlo a otra subcarpeta.
2. Importa/abre el `project.godot` de esa carpeta y pulsa F5. Si Godot estaba abierto durante la unificacion, cierralo sin guardar escenas antiguas y vuelve a abrirlo.
3. Muevete con WASD o flechas. Recoge la espada al noroeste, en (-307, -546).
4. Ataca con Espacio/click izquierdo. Derrota a los dos enemigos rojos.
5. La puerta dorada del recinto al noreste se abre cuando ambos mueren. Entra en el cuadrado verde para terminar.
6. R o el boton de la interfaz reinician tras muerte o victoria.

## Implementado

- Movimiento normalizado en 8 direcciones y memoria de direccion.
- Barrido de espada de 120 grados y un impacto por enemigo por ataque.
- Impulso visual de 6 pixeles al atacar, con regreso a la posicion base. Solo se desplaza Sprite2D: el cuerpo, su CollisionShape2D y el origen de la hitbox del arma permanecen en su sitio. La espada mantiene su rotacion de ataque normal.
- Tres corazones, daño por contacto, invulnerabilidad de un segundo, parpadeo y muerte.
- Dos enemigos con deteccion por distancia y linea de vision, movimiento con colisiones y vida configurable.
- Puerta con colision real, contador de enemigos, salida y estado de victoria.
- Reinicio restaura jugador, objetos, enemigos y puerta.
- Mensajes de objetivo en HUD; recogida y daño independientes de nombres.

El TileMap original se conserva. Se añadio un muro independiente y una puerta para crear un pequeño recinto de salida conectado al mapa.

## Ajustes en el Inspector

Jugador: `speed`, `max_health`, `invulnerability_seconds`, `attack_visual_distance`.
Enemigos: `max_health`, `contact_damage`, `chase_speed`, `detection_radius`.
Mundo: `enemy_paths`, lista de enemigos requeridos para abrir la puerta. Si añades enemigos al objetivo, incluyelos en esta lista.

La persecucion actual no busca rutas alrededor de obstaculos. Los enemigos se detienen si una pared bloquea la vista y pueden atascarse en geometria compleja; un sistema de navegacion queda pendiente. Tampoco estan implementados aun los drops de curacion ni las cajas de dialogo narrativo.

## Archivos

| Archivo | Funcion |
| --- | --- |
| player.gd | Movimiento, combate, impulso visual, salud y estados finales. |
| enemy_budy.gd | Persecucion, contacto, daño y señal defeated. |
| world.gd | Cuenta enemigos y abre la puerta. |
| door.gd | Desactiva colision y visual de la puerta. |
| exit.gd | Completa el nivel al entrar con la puerta abierta. |
| hud.gd | Corazones, objetivos y reintento. |
| espada_item.gd | Recogida de espada. |
| PROMPT_OPENCODE.md | Prompt para continuar con curacion, drops y dialogos. |

## Validacion

29 comprobaciones automaticas (13 de salud/combate/reinicio y 16 de impulso/persecucion/progresion). Incluyen colision real de puerta, persecucion y linea de vision, un impacto por barrido, impulso visual sin desplazar cuerpo, victoria y restauracion al reiniciar. No se hizo una revision visual de la interfaz.

```powershell
godot --headless --path . --script res://tests/smoke.gd
godot --headless --path . --script res://tests/progression.gd
```

El proyecto declara 4.7 en config/features; no se cambio esa configuracion. Usa preferentemente la version con la que trabajabas.

## Guardar este avance en tu repo existente

Desde la carpeta que contiene project.godot, revisa los cambios y luego guarda:

```powershell
git status
git diff
git add .
git commit -m "Impulso visual, persecucion y salida desbloqueable"
git push
```

El .gitignore excluye .godot y exportaciones. Conserva escenas, recursos originales y archivos .uid. No se modifico tu repositorio remoto desde esta entrega.
