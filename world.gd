extends Node2D

@export var enemy_paths: Array[NodePath] = [NodePath("Enemy_budy"), NodePath("Enemy_guard")]
var remaining_enemies: int = 0
@onready var _player: CharacterBody2D = $ZorVaK

func _ready() -> void:
	for path in enemy_paths:
		var enemy := get_node_or_null(path)
		if enemy != null:
			remaining_enemies += 1
			enemy.defeated.connect(_on_enemy_defeated)
	if remaining_enemies == 0:
		$Puerta.open()
	_player.objective_changed.emit("Busca la espada al noroeste. Enemigos: %d" % remaining_enemies)

func _on_enemy_defeated() -> void:
	remaining_enemies = maxi(0, remaining_enemies - 1)
	if remaining_enemies == 0:
		$Puerta.open()
		_player.objective_changed.emit("Puerta abierta. Busca la salida verde al noreste.")
	else:
		_player.objective_changed.emit("Enemigos restantes: %d" % remaining_enemies)
