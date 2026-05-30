class_name SwitchInteraction
extends RotationInteraction

enum OpenDirection {
	UP,
	DOWN
}

@export var pivot_point: Node3D = null
@export var open_direction: OpenDirection = OpenDirection.DOWN
@export_range(0.0, 1.0, 0.5) var open_angle_percent: float = 0.51
var is_on: bool = false :
	set(v):
		if v == is_on:
			return

		is_on = v
		print('%s is now %s.' % [owner.name, 'On' if is_on else 'Off'])

signal switch_state_changed(state: bool)


func _ready() -> void:
	super()
	starting_rotation = pivot_point.rotation.x
	max_rotation = deg_to_rad(rad_to_deg(max_rotation) - 30)


func _input(event: InputEvent) -> void:
	if not is_interacting:
		return

	if event is InputEventMouseMotion:
		input_active = true
		var delta: float = event.relative.y * 0.001

		current_angle = clamp(current_angle, starting_rotation, max_rotation)

		if abs(delta) < 0.01:
			delta *= 0.25

		angular_velocity = lerp(angular_velocity, delta, 1.0 / smoothing_coefficient)


func _process(delta: float) -> void:
	if not input_active:
		angular_velocity = lerp(angular_velocity, 0.0, delta * smoothing_coefficient)

	current_angle += angular_velocity
	current_angle = clamp(current_angle, starting_rotation, max_rotation)

	if previous_angle == current_angle:
		return

	match open_direction:
		OpenDirection.UP:
			is_on = rad_to_deg(current_angle) <= rad_to_deg(starting_rotation) * open_angle_percent
		OpenDirection.DOWN:
			is_on = rad_to_deg(current_angle) >= rad_to_deg(max_rotation) * open_angle_percent

	pivot_point.rotation.x = current_angle
	input_active = false

	previous_angle = current_angle


func pre_interact(hand: Marker3D) -> void:
	super(hand)
	is_interacting = true
	request_camera_state_change.emit(false)
	request_jump_state_change.emit(false)
	request_movement_state_change.emit(false)


func interact(dt: float) -> void:
	super(dt)


func post_interact() -> void:
	super()
	request_camera_state_change.emit(true)
	request_jump_state_change.emit(true)
	request_movement_state_change.emit(true)
	is_interacting = false
