extends TextureRect

const MONSTER_SCENE = preload("res://assets/scenes/monster01.tscn")

func _get_drag_data(_at_position: Vector2) -> Variant:
	var preview := TextureRect.new()
	preview.texture = texture
	preview.custom_minimum_size = Vector2(64, 64)
	preview.size = Vector2(64, 64)
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.mouse_filter = Control.MOUSE_FILTER_IGNORE

	set_drag_preview(preview)

	return MONSTER_SCENE
