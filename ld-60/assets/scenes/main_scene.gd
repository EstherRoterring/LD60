extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_home_button_down() -> void:
	SceneTransition.change_scene_to_file("res://assets/scenes/MainMenu.tscn")



func _on_to_player_button_down() -> void:
	SceneTransition.change_scene_to_file("res://assets/scenes/musicPlayer_scene.tscn")
