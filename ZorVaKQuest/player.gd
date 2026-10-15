extends CharacterBody2D

signal health_changed(current: int, maximum: int)
signal died

@export var speed: float = 250.0
@export_range(1, 20) var max_health: int = 3
@export var invulnerability_seconds: float = 1.0

var has_sword: bool = false
var is_attacking: bool = false
var last_direction: Vector2 = Vector2.RIGHT
var health: int
var is_dead: bool = false
var _invulnerability_left: float = 0.0
var _hit_this_swing: Dictionary = {}

@onready var _blade: Sprite2D = $ManoPivot/EspadaVisual
@onready var _hitbox: Area2D = $ManoPivot/EspadaVisual/HitboxEspada

func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	health = max_health
	var canvas := CanvasLayer.new()
	add_child(canvas)
	var hud := Control.new()
	hud.set_script(preload("res://hud.gd"))
	canvas.add_child(hud)
	hud.bind_player(self)

func _physics_process(delta: float) -> void:
	_invulnerability_left = maxf(0.0, _invulnerability_left - delta)
	$Sprite2D.modulate.a = 0.35 if _invulnerability_left > 0.0 and int(_invulnerability_left * 12.0) % 2 == 0 else 1.0
	if is_dead:
		return
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	if direction != Vector2.ZERO:
		last_direction = direction
	move_and_slide()
	# Comprueba tambien enemigos que ya estaban dentro al iniciar el golpe.
	if is_attacking:
		for body in _hitbox.get_overlapping_bodies():
			_try_hit(body)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if is_dead and event.physical_keycode == KEY_R:
			get_tree().reload_current_scene()
	if event.is_action_pressed("attack") and not event.is_echo():
		atacar()

func collect_sword() -> void:
	has_sword = true

func take_damage(amount: int = 1) -> void:
	if is_dead or _invulnerability_left > 0.0 or amount <= 0:
		return
	health = maxi(0, health - amount)
	_invulnerability_left = invulnerability_seconds
	health_changed.emit(health, max_health)
	if health == 0:
		is_dead = true
		velocity = Vector2.ZERO
		is_attacking = false
		_blade.hide()
		died.emit()

func atacar() -> void:
	if not has_sword or is_attacking or is_dead:
		return
	is_attacking = true
	_hit_this_swing.clear()
	_blade.show()
	var pivot: Node2D = $ManoPivot
	var angle := last_direction.angle()
	pivot.rotation = angle - deg_to_rad(60)
	var tween := create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(pivot, "rotation", angle + deg_to_rad(60), 0.15).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	await tween.finished
	_blade.hide()
	is_attacking = false

func _try_hit(body: Node2D) -> void:
	if not is_attacking or is_dead or not is_instance_valid(body):
		return
	if body.has_method("take_damage") and body != self:
		var id := body.get_instance_id()
		if not _hit_this_swing.has(id):
			_hit_this_swing[id] = true
			body.take_damage(1)

func _on_hitbox_espada_body_entered(body: Node2D) -> void:
	_try_hit(body)
