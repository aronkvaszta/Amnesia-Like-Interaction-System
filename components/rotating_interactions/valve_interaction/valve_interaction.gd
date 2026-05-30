class_name ValveInteraction
extends RotationInteraction


enum OpenDirection {
	LEFT, RIGHT
}

@export var pivot_point: Node3D = null
@export var min_rotation: float = -180
@export var open_direction: OpenDirection = OpenDirection.LEFT
@export var angle_to_open: float = 360
var is_open: bool = false :
	set(v):
		if is_open != v:
			is_open = v
			print('%s is now %s' % [owner.name, 'Open' if is_open else 'Closed'])

signal valve_opened()
signal valve_closed()


func _ready() -> void:
	starting_rotation = pivot_point.rotation.y
	super()


func _input(event: InputEvent) -> void:
	if not is_interacting:
		return

	if event is InputEventMouseMotion:
		input_active = true
		var delta: float = -event.relative.x * 0.001

		current_angle = clamp(current_angle, starting_rotation + deg_to_rad(min_rotation), max_rotation)

		if abs(delta) < 0.01:
			delta *= 0.25

		angular_velocity = lerp(angular_velocity, delta, 1.0 / smoothing_coefficient)


func _process(delta: float) -> void:
	if not input_active:
		angular_velocity = lerp(angular_velocity, 0.0, delta * smoothing_coefficient)

	current_angle += angular_velocity
	current_angle = clamp(current_angle, deg_to_rad(min_rotation), max_rotation)

	match open_direction:
		OpenDirection.LEFT:
			is_open = rad_to_deg(pivot_point.rotation.y) >= angle_to_open
		OpenDirection.RIGHT:
			is_open = rad_to_deg(pivot_point.rotation.y) <= -angle_to_open

	if previous_angle == current_angle:
		return

	pivot_point.rotation.y = current_angle
	input_active = false


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
