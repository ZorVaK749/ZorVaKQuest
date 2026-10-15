extends Control

var _hearts: HBoxContainer
var _message: Label
var _finished: bool = false
var _retry: Button

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var panel := PanelContainer.new()
	panel.position = Vector2(16, 16)
	add_child(panel)
	var margin := MarginContainer.new()
	for side in ["left", "top", "right", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 12)
	panel.add_child(margin)
	var column := VBoxContainer.new()
	margin.add_child(column)
	_hearts = HBoxContainer.new()
	column.add_child(_hearts)
	_message = Label.new()
	_message.text = "Busca la espada. WASD / Flechas: moverse\nEspacio / Click: atacar"
	column.add_child(_message)
	_retry = Button.new()
	_retry.text = "Reintentar (R)"
	_retry.hide()
	_retry.pressed.connect(func(): get_tree().reload_current_scene())
	column.add_child(_retry)

func bind_player(player: Node) -> void:
	player.health_changed.connect(_update_hearts)
	player.died.connect(_on_player_died)
	player.objective_changed.connect(_set_objective)
	player.victory.connect(_on_victory)
	_update_hearts(player.health, player.max_health)

func _update_hearts(current: int, maximum: int) -> void:
	for child in _hearts.get_children():
		_hearts.remove_child(child)
		child.queue_free()
	for i in maximum:
		var heart := Label.new()
		heart.text = "♥"
		heart.add_theme_font_size_override("font_size", 30)
		heart.add_theme_color_override("font_color", Color("ff5666") if i < current else Color("555565"))
		_hearts.add_child(heart)

func _on_player_died() -> void:
	_finished = true
	_message.text = "Has caido. Pulsa R o Reintentar."
	_retry.show()

func _set_objective(text: String) -> void:
	if not _finished:
		_message.text = text

func _on_victory() -> void:
	_finished = true
	_message.text = "Nivel completado. Bien hecho, ZorVaK!"
	_retry.text = "Volver a jugar (R)"
	_retry.show()
