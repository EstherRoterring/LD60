extends Panel

var Monster01 = preload("res://assets/scenes/monster01.tscn")
var item = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
	
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is PackedScene

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if not data is PackedScene:
		return

	var monster = data.instantiate()
	add_child(monster)

	# Monster an das Feld anpassen
	monster.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
		)
