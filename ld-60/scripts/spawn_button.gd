extends TextureButton

@export var monster_name : String

var spawner : MonsterSpawner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawner = get_node("../../../MonsterSpawner")

func _on_button_down() -> void:
	spawner.spawn_music_monster(monster_name, true)
