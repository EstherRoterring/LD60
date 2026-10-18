extends CanvasLayer

var targetScene
var changing_scene := false

func change_scene_to_file(target: String) -> void:
	targetScene = target
	$AnimationPlayer.play("disolve")
	changing_scene = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if not changing_scene:
		return
	get_tree().change_scene_to_file(targetScene)
	$AnimationPlayer.play_backwards("disolve")
	changing_scene = false
