class_name DraggableSprite extends Area2D

@export var is_monster : bool = true # tag

var dragging_is_enabled : bool
var is_being_dragged : bool
var is_hovered_over : bool
var id_for_drag_manager : int

signal dragged_over_trigger
signal dragging_started
signal dragging_ended

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	id_for_drag_manager = -1
	is_being_dragged = false
	dragging_is_enabled = true
	is_hovered_over = false
	mouse_entered.connect(handle_mouse_enter)
	mouse_exited.connect(handle_mouse_exit)

func handle_mouse_enter() -> void:
	id_for_drag_manager = MonsterDragManager.register_hovered_sprite()
	is_hovered_over = true

func handle_mouse_exit() -> void:
	if id_for_drag_manager != -1:
		MonsterDragManager.unregister_hovered_sprite(id_for_drag_manager)
		id_for_drag_manager = -1
	is_hovered_over = false
"res://assets/scenes/tape.tscn"

func _input(event: InputEvent) -> void:
	handle_dragging_state_logic(event)
	if event is InputEventMouseMotion:
		handle_mouse_drag(event)

func handle_dragging_state_logic(event: InputEvent) -> void:
	if not event.is_action("click"):
		return
	if (event.is_pressed()):
		handle_just_clicked()
		return
	if (event.is_released()):
		handle_just_released()
		return

func handle_mouse_drag(event: InputEventMouseMotion) -> void:
	if not is_being_dragged:
		return
	drag(event.global_position)
	
func handle_just_clicked():
	if is_being_dragged:
		return	
	if is_hovered_over and MonsterDragManager.sprite_is_draggable(id_for_drag_manager):
		start_dragging()

func handle_just_released():
	if is_being_dragged:
		end_dragging()

# Signals when dragging starts
func start_dragging() -> void:
	if is_monster:
		MonsterDragManager.monster_sprite_is_dragged = true
	is_being_dragged = true
	dragging_started.emit()
	drag(get_global_mouse_position())

# Signals whenever the sprite is dragged over a trigger
func drag(mouse_position : Vector2) -> void:
	global_position = mouse_position
	
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true
	query.exclude = [get_rid()]
	var results = space_state.intersect_point(query, 1)
	
	if results.size() > 0:
		dragged_over_trigger.emit(results[0].collider)

# Signals when dragging ends
func end_dragging() -> void:
	if is_monster:
		MonsterDragManager.monster_sprite_is_dragged = false
	is_being_dragged = false
	
	# check for any tape slot under mouse position
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true
	query.exclude = [get_rid()]
	query.collision_mask = 0b10
	var results = space_state.intersect_point(query, 1)
	
	if results.size() > 0:
		dragging_ended.emit(results[0].collider)
	dragging_ended.emit(null)
	
# when removing the dragged object, tell this to drag manager
func removal_hook() -> void:
	if MonsterDragManager.hover_scores.has(id_for_drag_manager):
		MonsterDragManager.unregister_hovered_sprite(id_for_drag_manager)
