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
