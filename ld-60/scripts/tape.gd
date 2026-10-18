extends Node2D

@export var slots : Array[TapeSlot]

#holds track thats currently edited
@export var current_track : Track
#should hold the 8 visable monsters
@export var current_monsters : Array[MusicMonster]

var total_number_of_tape_segments : int
var current_segment : int 	#0: 0-7, 1: 8-15 ...

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_track = Track.new()
	current_monsters.resize(8)
	current_segment = 0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func place_music_monster(monster : MusicMonster, slot_id : int):
	pass

#func load_track(track : Track) -> void:
	#pass
	#
#func export_track() -> Track:
	#var track : Track
	#return track

func scroll_to_next_segment() -> void:
	current_monsters = get_current_monsters()
	if current_monsters.size() != 8:
		printerr('not 08 Monsters')
		return
	#Schleife über 8 Monster
	for i in range(8):
		var m = current_monsters[i]
		var slot = i + (current_segment * 8)
		#save monster to Track
			#add_note(instrument: String, time: int, pitch: int)
		current_track.add_note(m.instrument, slot, m.pitch)
		#delete monsters from UI and Load Monsteri+8
		#ToDo
		#current_monsters[m] = 
		current_segment = current_segment + 1
	
func scroll_to_prev_segment() -> void:
	pass
	
func get_current_monsters() -> Array:
	return []
func set_monster(m:MusicMonster, pos:int) -> void:
	pass
	
func set_preview_play_position() -> void:
	pass
	
func start_preview_play() -> void:
	pass
	
func stop_preview_play() -> void:
	pass
	
