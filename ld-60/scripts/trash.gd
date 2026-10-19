class_name TrashBin extends Area2D

var hovered : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HoverImage.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	hovered = true
	if MonsterDragManager.monster_sprite_is_dragged:
		$HoverImage.show()


func _on_mouse_exited() -> void:
	hovered = false
	$HoverImage.hide()
