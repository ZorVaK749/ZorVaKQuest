extends CharacterBody2D

signal defeated

@export_range(1, 20) var max_health: int = 1
@export var contact_damage: int = 1
@export var chase_speed: float = 65.0
@export var detection_radius: float = 230.0
var health: int
var _dead: bool = false
var _target: Node2D

func _ready() -> void:
	health = max_health
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

func _physics_process(_delta: float) -> void:
	if _dead:
		return
	if not is_instance_valid(_target):
		_target = get_tree().get_first_node_in_group("player") as Node2D
	velocity = Vector2.ZERO
	if is_instance_valid(_target) and not _target.is_dead and not _target.is_complete:
		var distance := global_position.distance_to(_target.global_position)
		if distance <= detection_radius and _has_line_of_sight():
			velocity = global_position.direction_to(_target.global_position) * chase_speed
	move_and_slide()
	for body in $ContactArea.get_overlapping_bodies():
		if body.is_in_group("player"):
			body.take_damage(contact_damage)

func _has_line_of_sight() -> bool:
	# Detecta muros antes de perseguir: este enemigo basico no calcula rutas.
	var query := PhysicsRayQueryParameters2D.create(global_position, _target.global_position, 1, [get_rid()])
	var hit := get_world_2d().direct_space_state.intersect_ray(query)
	return hit.is_empty() or hit.get("collider") == _target

func take_damage(amount: int = 1) -> void:
	if _dead or amount <= 0:
		return
	health = maxi(0, health - amount)
	if health == 0:
		_dead = true
		defeated.emit()
		queue_free()
