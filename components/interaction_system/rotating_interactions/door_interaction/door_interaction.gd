class_name DoorInteraction
extends RotationInteraction


@export var pivot_point: Node3D
@export var flip_pivot: bool = false
@export var reverse_input_dir: bool = false


func _ready() -> void:
	super()
	starting_rotation = pivot_point.rotation.y

	if flip_pivot:
		max_rotation = starting_rotation - abs(max_rotation)
	else:
		max_rotation = starting_rotation + abs(max_rotation)


func _input(event: InputEvent) -> void:
	if not is_interacting:
		return

	if event is InputEventMouseMotion:
		input_active = true
		var delta: float = -event.relative.x * 0.001

		if flip_pivot:
			delta = -delta
		if reverse_input_dir:
			delta = -delta

		if abs(delta) < 0.01:
			delta *= 0.25

		angular_velocity = lerp(angular_velocity, delta, 1.0 / smoothing_coefficient)


func _process(delta: float) -> void:
	if not input_active:
		angular_velocity = lerp(angular_velocity, 0.0, delta * smoothing_coefficient)

	current_angle += angular_velocity

	if flip_pivot:
		current_angle = clamp(current_angle, max_rotation, starting_rotation)
	else:
		current_angle = clamp(current_angle, starting_rotation, max_rotation)

	if previous_angle == current_angle:
		return

	pivot_point.rotation.y = current_angle
	input_active = false

	previous_angle = current_angle


func pre_interact(hand: Marker3D) -> void:
	super(hand)
	is_interacting = true
	request_camera_state_change.emit(false)
	request_jump_state_change.emit(false)
	request_movement_state_change.emit(false)

	var cam_right: Vector3 = get_viewport().get_camera_3d().global_basis.x
	var door_right: Vector3 = pivot_point.owner.global_basis.x

	var projection: float = cam_right.dot(door_right)

	if projection < 0:
		reverse_input_dir = true
	else:
		reverse_input_dir = false


func interact(dt: float) -> void:
	super(dt)


func post_interact() -> void:
	super()
	request_camera_state_change.emit(true)
	request_jump_state_change.emit(true)
	request_movement_state_change.emit(true)
	is_interacting = false
