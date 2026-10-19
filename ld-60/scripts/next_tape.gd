extends AnimatedSprite2D

func _ready() -> void:
	pass # Replace with function body.

func _on_button_button_down() -> void:
	$".".play("rotate")
	$"../..".scroll_to_next_segment()
