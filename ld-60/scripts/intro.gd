extends CanvasLayer

func _ready() -> void:
	$AnimationPlayer.play("intro")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	SceneTransition.change_scene_to_file("res://assets/scenes/MainMenu.tscn")
