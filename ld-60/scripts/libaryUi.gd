
extends Control

const STORED_TRACK_SCENE: PackedScene = preload(
	"res://assets/scenes/storedTrack.tscn"
)

const PLAYER_SCENE_PATH := "res://assets/scenes/Player.tscn"

@onready var scroll_container: ScrollContainer = $OnlineTracks
@onready var track_container: Container = $"OnlineTracks".get_child(0)

@onready var offline_scroll_container: ScrollContainer = $OfflineTracks
@onready var offline_track_container : Container = $OfflineTracks.get_child(0)

# tracks stored locally
var local_track_ids : Array[String] = []

var online_track_ids: Array[String] = []
var pending_track_id: String = ""
var loading_track := false


func _ready() -> void:
	API.track_list_result.connect(_on_online_track_list_result)
	API.track_data_result.connect(_on_online_track_data_result)
	API.fetch_track_list()
	
	# all locally stored tracks
	local_track_ids = TrackLibrary.local_tracks.keys()
	_populate_offline_track_list()

func _on_online_track_list_result(data: Dictionary) -> void:
	online_track_ids.clear()

	for id in data.get("ids", []):
		online_track_ids.append(str(id))

	_populate_online_track_list()


func _populate_online_track_list() -> void:
	for child in track_container.get_children():
		child.queue_free()

	for id in online_track_ids:
		var item = STORED_TRACK_SCENE.instantiate()
		track_container.add_child(item)
		item.setup(id)
		item.track_selected.connect(_on_online_track_selected)

func _populate_offline_track_list() -> void:
	for child in offline_track_container.get_children():
		child.queue_free()
	
	for id in local_track_ids:
		var item = STORED_TRACK_SCENE.instantiate()
		offline_track_container.add_child(item)
		item.setup(id)
		item.track_selected.connect(_on_offline_track_selected)


func _on_online_track_selected(track_id: String) -> void:
	if loading_track:
		return

	loading_track = true
	pending_track_id = track_id
	API.fetch_track_data(track_id)


func _on_offline_track_selected(track_id: String) -> void:
	var track : Track = TrackLibrary.load_track(track_id)
	TrackLibrary.activeTrack = pending_track_id
	
	SceneTransition.change_scene_to_file("res://assets/scenes/musicPlayer_scene.tscn")


func _on_online_track_data_result(data: String) -> void:
	if not loading_track:
		return

	var track := Track.deserialize(data)

	if track == null:
		loading_track = false
		push_error("Track konnte nicht geladen werden.")
		return

	SceneTransition.change_scene_to_file("res://assets/scenes/musicPlayer_scene.tscn")


func _on_back_button_button_down() -> void:
	SceneTransition.change_scene_to_file("res://assets/scenes/MainMenu.tscn")
