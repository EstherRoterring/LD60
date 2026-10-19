
extends Control

const STORED_TRACK_SCENE: PackedScene = preload(
	"res://assets/scenes/storedTrack.tscn"
)

const PLAYER_SCENE_PATH := "res://assets/scenes/Player.tscn"

@onready var scroll_container: ScrollContainer = $ScrollContainer
@onready var track_container: Container = $ScrollContainer.get_child(0)

var track_ids: Array[String] = []
var pending_track_id: String = ""
var loading_track := false


func _ready() -> void:
	API.track_list_result.connect(_on_track_list_result)
	API.track_data_result.connect(_on_track_data_result)
	API.fetch_track_list()


func _on_track_list_result(data: Dictionary) -> void:
	track_ids.clear()

	for id in data.get("ids", []):
		track_ids.append(str(id))

	_populate_track_list()


func _populate_track_list() -> void:
	for child in track_container.get_children():
		child.queue_free()

	for id in track_ids:
		var item = STORED_TRACK_SCENE.instantiate()
		track_container.add_child(item)
		item.setup(id)
		item.track_selected.connect(_on_track_selected)


func _on_track_selected(track_id: String) -> void:
	if loading_track:
		return

	loading_track = true
	pending_track_id = track_id
	API.fetch_track_data(track_id)


func _on_track_data_result(data: String) -> void:
	if not loading_track:
		return

	var track := Track.deserialize(data)

	if track == null:
		loading_track = false
		push_error("Track konnte nicht geladen werden.")
		return

	TrackLibrary.save_track(pending_track_id, track, true)
	TrackLibrary.activeTrack = pending_track_id

	SceneTransition.change_scene_to_file("res://assets/scenes/musicPlayer_scene.tscn")


func _on_back_button_button_down() -> void:
	SceneTransition.change_scene(
		"res://assets/scenes/MainMenu.tscn"
	)
