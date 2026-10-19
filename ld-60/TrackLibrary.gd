# owner MDES
# this is part of the open source MDES library

extends Node

const SAVE_PATH = "user://tracks.json"

const DEFAULT_TRACK_NAME = "My first track"

# active track that can be edited or listened to
var activeTrack : String

# all tracks are stored in-memory
var local_tracks : Dictionary[String, Track]


#func _enter_tree() -> void:
	#activeTrack = ""
	#load_library()
	

func save_track(name: String, track : Track, allow_overwrite = true):
	if local_tracks.has(name) and not allow_overwrite:
		return
	local_tracks[name] = track


func load_track(name : String) -> Track:
	if local_tracks.has(name):
		activeTrack = name
		return local_tracks.get(name)
	else:
		activeTrack = DEFAULT_TRACK_NAME
		return Track.new()


# WARNING: LOADING AND SAVING IS VIBECODED
# (probably better than our code)

func save_library() -> void:
	var library: Dictionary = {}

	for track_name in local_tracks:
		# Convert the serialized JSON string into a Dictionary/Array/etc.
		var json := JSON.new()
		var error := json.parse(Track.serialize(local_tracks[track_name]))

		if error != OK:
			push_error("Failed to serialize track: " + track_name)
			return

		library[track_name] = json.data

	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)

	if file == null:
		push_error("Failed to open save file for writing.")
		return

	file.store_string(JSON.stringify(library, "\t"))
	file.close()

	print("Library saved!")


func load_library() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found. Starting with an empty library.")
		return

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)

	if file == null:
		push_error("Failed to open save file for reading.")
		return

	var json_string := file.get_as_text()
	file.close()

	var json := JSON.new()
	var error := json.parse(json_string)

	if error != OK:
		push_error("Failed to parse library JSON: " + json.get_error_message())
		return

	if not json.data is Dictionary:
		push_error("Invalid library format.")
		return

	local_tracks.clear()

	for track_name in json.data:
		# Convert the saved JSON data back into a JSON string.
		var track_json := JSON.stringify(json.data[track_name])

		# Reconstruct the Track using your existing deserializer.
		var track: Track = Track.deserialize(track_json)

		if track != null:
			local_tracks[track_name] = track

	print("Loaded ", local_tracks.size(), " tracks.")
