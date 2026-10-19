class_name TapeSlot extends Node2D

var id : int # gets set by the tape managing all slots
var monsters : Dictionary[MusicMonster, Vector2] # stores a position for each monster

var hovered : bool = false

signal stored_monster_signal
signal removed_monster_signal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Border.hide()

# call this when you know the monster is in here
func get_position_of_monster(monster : MusicMonster) -> Vector2:
	return monsters.get(monster, Vector2(0,0))

func add_music_monster(monster : MusicMonster) -> Vector2:
	$Border.hide()
	if monsters.has(monster):
		return get_position_of_monster(monster)
	var position_of_new_monster = to_global(Vector2(0,0))
	monsters.set(monster, position_of_new_monster)
	stored_monster_signal.emit(monster, id)
	return position_of_new_monster
	
func remove_music_monster(monster : MusicMonster) -> void:
	if not monsters.has(monster):
		push_warning("Tried to remove unknown monster from slot!")
	monsters.erase(monster)
	removed_monster_signal.emit(monster, id)

func _on_mouse_entered() -> void:
	hovered = true
	if MonsterDragManager.monster_sprite_is_dragged:
		$Border.show()


func _on_mouse_exited() -> void:
	hovered = false
	$Border.hide()
