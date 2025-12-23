extends CanvasLayer

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_F1:
		$Panel.visible = not $Panel.visible

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
