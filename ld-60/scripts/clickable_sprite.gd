extends Sprite2D

signal clicked

func _ready() -> void:
	visible = false

func _process(_delta: float) -> void:
	var local_mouse := to_local(get_global_mouse_position())
	visible = is_pixel_opaque(local_mouse)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
			and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT:

		var local_mouse := to_local(get_global_mouse_position())

		if is_pixel_opaque(local_mouse):
			clicked.emit()
			print("Sprite clicked!")
		else:
			print("not clicked")
