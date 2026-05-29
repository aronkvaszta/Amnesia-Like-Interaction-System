class_name DragInteraction
extends InteractionBase


@export var drag_force: float = 5.0
var _player_hand: Marker3D = null


func pre_interact(hand: Marker3D) -> void:
	_player_hand = hand
	is_interacting = true


func interact(_dt: float) -> void:
	var object_pos: Vector3 = object_ref.global_position
	var hand_pos: Vector3 = _player_hand.global_position
	var dist: Vector3 = hand_pos - object_pos

	var rb: RigidBody3D = object_ref as RigidBody3D
	if not rb:
		return

	rb.linear_velocity = dist * (drag_force / rb.mass)


func post_interact() -> void:
	_player_hand = null
	is_interacting = false
