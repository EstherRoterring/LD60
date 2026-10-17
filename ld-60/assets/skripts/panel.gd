extends Panel

var Monster01 = preload("res://assets/scenes/monster01.tscn")
var item = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item = Monster01.instantiate()
	add_child(item)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _get_drag_data(_at_position: Vector2):
	# Diese Szene wird beim Ablegen instanziiert.
	var preview = Monster01.instantiate()
	# Vorschau beim Ziehen
	set_drag_preview(preview)
	# Die Monster-Szene als Drag-Daten übergeben
	return Monster01
