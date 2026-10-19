extends TextureButton


func _on_button_down() -> void:
	SceneTransition.change_scene_to_file("res://assets/scenes/MainMenu.tscn")
