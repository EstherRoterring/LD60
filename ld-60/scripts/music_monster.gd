@abstract class_name MusicMonster extends Node

var pitch : int = 0
var slot_id : int = -1 # -1 for monsters just picked from the bench

@onready var my_sprite : AnimatedSprite2D = $DraggableSprite/AnimatedSprite2D

@abstract func play_music_animation()
	
@abstract func play_sound()

func handle_drag_over_pitch_pot(pot: ColoringPot):
	if pot.pitchID == pitch:
		return
	pitch = pot.pitchID
	print("monster pitch is now: ", pitch)
	change_color_to_pitch()
	play_sound()

func change_color_to_pitch():
	var mat : ShaderMaterial = my_sprite.material
	print_debug(mat)
	mat.set_shader_parameter("pitch_id", pitch)
