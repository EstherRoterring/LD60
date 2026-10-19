class_name MonsterSpawner extends Node

# monster scene for instantiation
const synth_monster_scene = preload("res://assets/scenes/synth_monster.tscn")

@export var available_synth_monsters : Array[SynthMonsterData]

var synth_monster_ids_by_name : Dictionary[String, int]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	synth_monster_ids_by_name.clear()
	for i in len(available_synth_monsters):
		synth_monster_ids_by_name[available_synth_monsters[i].monster_name] = i

func __spawn_synth_monster(name: String) -> SynthMonster:
		assert(synth_monster_ids_by_name.has(name))
		
		var synth_monster : SynthMonster = synth_monster_scene.instantiate()
		var monster_preset = available_synth_monsters[synth_monster_ids_by_name[name]]
		
		# set data
		synth_monster.pitch = monster_preset.default_pitch
		synth_monster.data = monster_preset
		synth_monster.instrument_name = monster_preset.monster_name
		return synth_monster

func spawn_music_monster(
	monster_name: String,
	immediately_drag_monster : bool = true,
	optional_parent : Node = null) -> MusicMonster:
		# look inside synth monsters
		var music_monster : MusicMonster = null
		if synth_monster_ids_by_name.has(monster_name):
			music_monster = __spawn_synth_monster(monster_name)
		
		# sad case
		if music_monster == null:
			push_warning("Monster spawner could not find any monster for given monster_name")
			return null
		
		# tell the monster it has been spawned
		music_monster.prev_slot = null
		
		# add monster to the scene tree
		if optional_parent == null:
			add_child(music_monster)
		else:
			optional_parent.add_child(music_monster)
		
		# tell the draggable sprite that it is dragged
		if immediately_drag_monster:		
			var drag_sprite : DraggableSprite = music_monster.get_node("DraggableSprite")
			drag_sprite.start_dragging()		
		
		# sync monster color with pitch
		music_monster.change_color_to_pitch()
		
		return music_monster
