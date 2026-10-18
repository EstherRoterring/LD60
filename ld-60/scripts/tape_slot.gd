class_name TapeSlot extends Node2D

var monsters

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Border.hide()


func _on_mouse_entered() -> void:
	if MonsterDragManager.monster_sprite_is_dragged:
		$Border.show()


func _on_mouse_exited() -> void:
	$Border.hide()
