class_name SynthMonster extends MusicMonster

@export var data : SynthMonsterData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func play_music_animation() -> void:
	$DraggableSprite/AnimatedSprite2D.play("default")


func play_sound() -> void:
	print_debug("Playing synth monster sound")
	pass


func _on_draggable_sprite_dragged_over_trigger(collider) -> void:
	if collider is ColoringPot:
		handle_drag_over_pitch_pot(collider)


func _on_draggable_sprite_dragging_ended(collider) -> void:
	if collider is TapeSlot:
		handle_release_over_tape_slot(collider)
	if collider is TrashBin:
		handle_release_over_trash_bin(collider)
		
	elif prev_slot == null:
		straight_into_the_trash()
	else:
		my_draggable_sprite.position = prev_slot.get_position_of_monster(self)
