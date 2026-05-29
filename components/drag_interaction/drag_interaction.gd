class_name DragInteraction
extends InteractionBase


@export var drag_force: float = 5.0
@export var rotation_force: float = 10.0
@export var throw_force: float = 7.5

var _player_hand: Marker3D = null

var is_rotating: bool = false
var _mouse_delta: Vector2 = Vector2.ZERO


func _unhandled_input(event: InputEvent) -> void:
	if not is_interacting:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				is_rotating = true
				request_camera_state_change.emit(false)
				request_movement_state_change.emit(false)
				request_jump_state_change.emit(false)
			if event.is_released():
				is_rotating = false
				request_camera_state_change.emit(true)
				request_movement_state_change.emit(true)
				request_jump_state_change.emit(true)

	if not is_rotating:
		return

	if event is InputEventMouseMotion:
		_mouse_delta = event.relative


func pre_interact(hand: Marker3D) -> void:
	_player_hand = hand
	is_interacting = true


func interact(dt: float) -> void:
	var object_pos: Vector3 = object_ref.global_position
	var hand_pos: Vector3 = _player_hand.global_position
	var dist: Vector3 = hand_pos - object_pos

	var rb: RigidBody3D = object_ref as RigidBody3D
	if not rb:
		return

	rb.linear_velocity = dist * (drag_force / rb.mass)

	if is_rotating:
		var angular_x: Vector3 = _player_hand.global_basis.y * _mouse_delta.x * dt / rb.mass
		var angular_y: Vector3 = _player_hand.global_basis.x * _mouse_delta.y * dt / rb.mass

		rb.apply_torque((angular_x + angular_y) * rotation_force)

		_mouse_delta = Vector2.ZERO


func post_interact() -> void:
	_player_hand = null
	is_interacting = false
