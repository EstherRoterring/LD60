extends Node2D

#Tapeslot = array of multiple Monsters 
#should hold the 8 visable monsters (maybee multiple in one slot)
@export var current_slots : Array[TapeSlot]

@export var total_number_of_tape_segments : int

@onready var monster_spawner : MonsterSpawner = $"../MonsterSpawner"

var current_track : Track
var current_segment : int 	#0: 0-7, 1: 8-15 ...
var synth 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_segment = 0
	initialize_all_slots()
	current_track = TrackLibrary.activeTrack
	$"../SaveTrackUI/NameField".text = TrackLibrary.activeTrackName
	
	monster_spawner.init_spawner()
	fill_current_segment_with_monsters()
	
func initialize_all_slots() -> void:
	for slot_id in len(current_slots):
		var curr_slot : TapeSlot = current_slots[slot_id]
		curr_slot.id = slot_id
		curr_slot.stored_monster_signal.connect(place_music_monster)
		curr_slot.removed_monster_signal.connect(remove_music_monster)


func get_time_from_slot_id(slot_id: int) -> int:
	return current_segment * len(current_slots) + slot_id


# adds music monster to track
func place_music_monster(monster : MusicMonster, slot_id : int):
	current_track.add_note(monster.instrument_name, get_time_from_slot_id(slot_id), monster.pitch)


# removes music monster from track
func remove_music_monster(monster : MusicMonster, slot_id : int):
	current_track.delete_note(monster.instrument_name, get_time_from_slot_id(slot_id), monster.pitch)


# visually removes all monsters (without editing track)
func clear_current_segment() -> void:
	for slot in current_slots:
		for monster in slot.monsters:
			monster.straight_into_the_trash()
		slot.monsters.clear()


# fills all slots with monsters from the track
func fill_current_segment_with_monsters() -> void:
	for slot_id in len(current_slots):
		var current_notes = current_track.get_instrument_pitch_pairs_at_ime(get_time_from_slot_id(slot_id))
		var slot = current_slots[slot_id]
		for note in current_notes:
			var name = note["monster"]
			var pitch = note["pitch"]
			var monster : MusicMonster = monster_spawner.spawn_music_monster(name, false, slot)
			# placement
			monster.pitch = pitch
			monster.change_color_to_pitch()
			# assigning a monster to a slot 
			monster.my_draggable_sprite.global_position = slot.add_music_monster(monster, true)


func scroll_to_next_segment() -> void:
	# max track length reached
	if current_segment >= total_number_of_tape_segments - 1:
		return
	clear_current_segment() # visually remove all monsters
	current_segment += 1
	fill_current_segment_with_monsters() # add all monsters from the next segment
		

func scroll_to_prev_segment() -> void:
	# at track start
	if current_segment == 0:
		return
	clear_current_segment() # visually remove all monsters
	current_segment -= 1
	fill_current_segment_with_monsters() # add all monsters from the next segment	


func start_preview_play() -> void:
	MonsterDragManager.dragging_enabled = false
	pass


func _on_save_button_button_down() -> void:
	var track_name : String = $"../SaveTrackUI/NameField".text
	if track_name.is_empty():
		return
	# selber schuld wer überschreibt!
	TrackLibrary.save_track(track_name, current_track, true)


func _on_upload_button_button_down() -> void:
	if not current_track == null:
		print_debug("uploading track.. lol")
		API.save_track_data(Track.serialize(current_track))
