extends Node2D

@export var monster_spawner : MonsterSpawner

# monster button for instantiation
const monster_button_scene = preload("res://assets/scenes/monster_spawn_button.tscn")

func _ready() -> void:
	for child in $GridContainer.get_children():
		child.queue_free()
	
	for monster in monster_spawner.available_synth_monsters:
		var spawn_button : MonsterSpawnButton = monster_button_scene.instantiate()
		spawn_button.monster_name = monster.monster_name
		spawn_button.spawner = monster_spawner
		spawn_button.material.set_shader_parameter("pitch_id", monster.default_pitch)
		spawn_button.texture_normal = monster.thumbnail
		spawn_button.texture_hover = monster.thumbnail
		spawn_button.texture_pressed = monster.thumbnail
		spawn_button.texture_focused = monster.thumbnail
		spawn_button.texture_disabled = monster.thumbnail
		$GridContainer.add_child(spawn_button)
