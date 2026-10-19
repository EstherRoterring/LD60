extends Node

var monster_sprite_is_dragged: bool
var hover_scores : Dictionary[int, int]
var next_free_key : int = 0
var largest_score : int = -1

func _enter_tree() -> void:
	largest_score = -1
	next_free_key = 0

func register_hovered_sprite() -> int:
	for key in hover_scores:
		if hover_scores[key] != -1:
			hover_scores[key] += 1
	print_debug("registered: ", next_free_key)
	hover_scores[next_free_key] = 0
	largest_score += 1
	next_free_key += 1
	return next_free_key - 1
	
func sprite_is_draggable(key: int) -> bool:
	assert(hover_scores.has(key))
	return hover_scores.get(key) == largest_score
	
func unregister_hovered_sprite(key: int):
	if not hover_scores.has(key):
		return
	
	print_debug("unregistering: ",key)
		
	var unregistering_winner = sprite_is_draggable(key)
	hover_scores.erase(key)
	if unregistering_winner:
		print_debug("was winner!")
		if not hover_scores.is_empty():
			largest_score = hover_scores.values().max()
	
	# reset everything if nothing is selected anymore
	if hover_scores.is_empty():
		next_free_key = 0
		largest_score = -1
