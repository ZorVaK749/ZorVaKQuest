extends CharacterBody2D

@export_range(1, 20) var max_health: int = 1
@export var contact_damage: int = 1
var health: int
var _dead: bool = false

func _ready() -> void:
	health = max_health

func _physics_process(_delta: float) -> void:
	if _dead:
		return
	# Sigue haciendo daño al estar en contacto; el jugador regula la invulnerabilidad.
	for body in $ContactArea.get_overlapping_bodies():
		if body.has_method("collect_sword") and body.has_method("take_damage"):
			body.take_damage(contact_damage)

func take_damage(amount: int = 1) -> void:
	if _dead or amount <= 0:
		return
	health = maxi(0, health - amount)
	if health == 0:
		_dead = true
		queue_free()
