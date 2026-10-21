class_name MonsterSpawnButton extends TextureButton

var monster_name : String
var spawner : MonsterSpawner

func _on_button_down() -> void:
	spawner.spawn_music_monster(monster_name, true)
