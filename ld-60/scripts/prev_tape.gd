extends AnimatedSprite2D

func _ready() -> void:
	pass


func _on_button_down() -> void:
	play("rotate")
	$"../..".scroll_to_prev_segment()
