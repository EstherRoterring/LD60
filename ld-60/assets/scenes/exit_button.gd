extends TextureButton

func _on_button_down() -> void:
	TrackLibrary.save_library()
	get_tree().quit()
