class_name Interactor
extends Node

@export var player: Player = null
@export var hand: Marker3D = null
@export var interaction_ray: RayCast3D = null

@export_category('Interaction Settings')
@export_range(0.0, 10.0, 0.5) var interact_length: float = 2.0
@export_flags_3d_physics var interaction_layer: int = 0b00000000_00000000_00000100

var _current_interactable: InteractionBase = null : set = _set_current_interactable
func _set_current_interactable(v: InteractionBase) -> void:
	var previous: InteractionBase = _current_interactable
	_current_interactable = v
	if _current_interactable:
		_current_interactable.request_camera_state_change.connect(_on_request_camera_state_change)
		_current_interactable.request_movement_state_change.connect(_on_request_movement_state_change)
		_current_interactable.request_jump_state_change.connect(_on_request_jump_state_change)
		#_current_interactable.request_interaction_end.connect(_on_request_interaction_end)
	else:
		previous.request_camera_state_change.disconnect(_on_request_camera_state_change)
		previous.request_movement_state_change.disconnect(_on_request_movement_state_change)
		previous.request_jump_state_change.disconnect(_on_request_jump_state_change)
		#previous.request_interaction_end.disconnect(_on_request_interaction_end)
var _looked_at: Node3D = null : set = _set_looked_at
func _set_looked_at(v: Node3D) -> void:
	if _looked_at != v:
		_looked_at = v
		_current_interactable = find_interaction(_looked_at)


signal request_camera_state_change(state: bool)
signal request_movement_state_change(state: bool)
signal request_jump_state_change(state: bool)


func _ready() -> void:
	interaction_ray.target_position = Vector3(0.0, 0.0, -interact_length)
	hand.position = Vector3(0.0, 0.0, -interact_length)


func _process(delta: float) -> void:
	if _current_interactable and _current_interactable.is_interacting:
		match _current_interactable.interaction_type:
			InteractionBase.InteractionType.TOGGLE:
				_current_interactable.interact(delta)
				if Input.is_action_just_pressed(&'interact'):
					_current_interactable.post_interact()

			InteractionBase.InteractionType.ONESHOT:
				_current_interactable.interact(delta)
				_current_interactable.post_interact()

			InteractionBase.InteractionType.HOLD:
				if Input.is_action_pressed(&'interact'):
					_current_interactable.interact(delta)
				elif Input.is_action_just_released(&'interact'):
					_current_interactable.post_interact()
		return

	if player.interaction_ray.is_colliding():
		_looked_at = player.interaction_ray.get_collider()
	else:
		_looked_at = null

	if not _current_interactable:
		return

	if Input.is_action_just_pressed(&'interact'):
		_current_interactable.pre_interact(hand)


func find_interaction(node: Node3D) -> InteractionBase:
	if not node:
		return null

	for child in node.get_children(true):
		if child is InteractionBase:
			return child

	return null


func _on_request_camera_state_change(state: bool) -> void:
	request_camera_state_change.emit(state)
func _on_request_movement_state_change(state: bool) -> void:
	request_movement_state_change.emit(state)
func _on_request_jump_state_change(state: bool) -> void:
	request_jump_state_change.emit(state)
