@abstract class_name MusicMonster extends Node

var pitch : int = 0
var prev_slot : TapeSlot = null # null for monsters picked from bench

@onready var my_draggable_sprite : DraggableSprite = $DraggableSprite
@onready var my_sprite : AnimatedSprite2D = $DraggableSprite/AnimatedSprite2D

@abstract func play_music_animation()
	
@abstract func play_sound()

func straight_into_the_trash() -> void:
	my_draggable_sprite.removal_hook()
	queue_free()

func handle_drag_over_pitch_pot(pot: ColoringPot):
	if pot.pitchID == pitch:
		return
	pitch = pot.pitchID
	change_color_to_pitch()
	play_sound()

func handle_release_over_trash_bin(_trash : TrashBin):
	if prev_slot != null:
		prev_slot.remove_music_monster(self)
	straight_into_the_trash()
	
func handle_release_over_tape_slot(slot : TapeSlot):
	if slot == prev_slot:
		my_draggable_sprite.position = slot.get_position_of_monster(self)
		return
	# remove from old slot
	if prev_slot != null:
		prev_slot.remove_music_monster(self)
	# add to new slot (and set to position the slot gave me)
	my_draggable_sprite.position = slot.add_music_monster(self)
	prev_slot = slot
	

func change_color_to_pitch():
	var mat : ShaderMaterial = my_sprite.material
	mat.set_shader_parameter("pitch_id", pitch)
