class_name TrashBin extends Area2D

var hovered : bool = false

@export var default_sprite : CompressedTexture2D
@export var open_sprite : CompressedTexture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Image.texture = default_sprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	hovered = true
	if MonsterDragManager.monster_sprite_is_dragged:
		$Image.texture = open_sprite


func _on_mouse_exited() -> void:
	hovered = false
	$Image.texture = default_sprite
