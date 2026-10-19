extends Control

signal track_selected(track_id: String)

@onready var track_button: Button = $Button
@onready var texture_rect: TextureRect = $TextureRect

var track_id: String = ""


func setup(id: String) -> void:
	track_id = id

	if is_node_ready():
		track_button.text = track_id


func _ready() -> void:
	track_button.text = track_id
	track_button.pressed.connect(_on_button_pressed)


func _on_button_pressed() -> void:
	track_selected.emit(track_id)
