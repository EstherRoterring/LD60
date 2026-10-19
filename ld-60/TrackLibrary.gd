# owner MDES
# this is part of the open source MDES library

extends Node

# active track that can be edited or listened to
var activeTrack : Track

# all tracks are stored in-memory
var local_tracks : Dictionary[String, Track]

func _enter_tree() -> void:
	activeTrack = Track.new()
	

func save_track(name: String, track : Track, allow_overwrite = false):
	if local_tracks.has(name) and not allow_overwrite:
		return
	local_tracks[name] = track


func load_track(name : String):
	if local_tracks.has(name):
		activeTrack = local_tracks[name]
	else:
		activeTrack = Track.new()
		
