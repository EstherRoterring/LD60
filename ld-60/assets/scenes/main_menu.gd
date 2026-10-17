extends Node2D

func load_game() -> void:
	#zoom_to_position(get_viewport_rect().size / 2.0)
	get_tree().change_scene_to_file("res://assets/scenes/mainScenen.tscn")

func zoom_to_position(screen_position: Vector2) -> void:
	var original_scale := scale
	var original_position := position

	var tween := create_tween()
	tween.set_parallel(true)

	tween.tween_property(self, "scale", Vector2(2, 2), 0.4)

	await tween.finished
	await get_tree().create_timer(1.0).timeout

	var return_tween := create_tween()
	return_tween.set_parallel(true)
	return_tween.tween_property(self, "scale", original_scale, 0.4)
	return_tween.tween_property(self, "position", original_position, 0.4)

	await return_tween.finished
