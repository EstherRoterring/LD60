extends Node2D

func load_game() -> void:
	#zoom_to_position(get_viewport_rect().size / 2.0)
	SceneTransition.change_scene_to_file("res://assets/scenes/mainScene.tscn")

func quit() -> void:
	TrackLibrary.save_library()
	get_tree().quit()

func _ready():
	show_objects_for_2_seconds()


func show_objects_for_2_seconds():
	print("show stuff")
	%Sprite_Browse.visible = true
	%Sprite_Exit.visible = true
	%Sprite_Compose.visible = true

	await get_tree().create_timer(2.0).timeout

	print("make stuff invisible again")
	%Sprite_Browse.visible = false
	%Sprite_Exit.visible = false
	%Sprite_Compose.visible = false


func zoom_to_position(screen_position: Vector2) -> void:
	var original_scale := scale
	var original_position := position

	var tween := create_tween()
	tween.set_parallel(true)

	tween.tween_property(self, "scale", Vector2(2, 2), 0.4)

	await tween.finished
	await get_tree().create_timer(1.0).timeout

	var return_tween := create_tween()
	return_tween.set_parallel(true)
	return_tween.tween_property(self, "scale", original_scale, 0.4)
	return_tween.tween_property(self, "position", original_position, 0.4)

	await return_tween.finished


func _on_sprite_browse_clicked() -> void:
	SceneTransition.change_scene_to_file("res://Storadge.tscn")


func _on_sprite_player_clicked() -> void:
	SceneTransition.change_scene_to_file("res://assets/scenes/musicPlayer_scene.tscn")
