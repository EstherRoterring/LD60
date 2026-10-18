extends Node2D

@export var slots : Array[TapeSlot]

var tape_dict : Dictionary[int, Array]
var total_number_of_tape_segments : int

var current_segment : int
var preview_play_position : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_segment = 0
	preview_play_position = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func place_music_monster(monster : MusicMonster, slot_id : int):
	pass

func load_track(track : Track) -> void:
	pass
	
func export_track() -> Track:
	var track : Track
	return track

func scroll_to_next_segment() -> void:
	pass
	
func scroll_to_prev_segment() -> void:
	pass
	
func set_preview_play_position() -> void:
	pass
	
func start_preview_play() -> void:
	pass
	
func stop_preview_play() -> void:
	pass
	
