class_name DrawerInteraction
extends InteractionBase

@export_group('References')
@export var drawer_start_point: Marker3D = null
@export var drawer_end_point: Marker3D = null

@export_group('Drawer Settings')
@export var max_depth: float = -0.2
@export var smoothing_coefficient: float = 13.5

var input_active: bool = false

var linear_velocity: float = 0.0
var previous_velocity: float = 0.0


func _ready() -> void:
	drawer_start_point.position.x = max_depth
	object_ref.position.x = drawer_start_point.position.x


func _input(event: InputEvent) -> void:
	if not is_interacting:
		return

	if event is InputEventMouseMotion:
		var delta: float = event.relative.y * 0.001
		linear_velocity = lerp(linear_velocity, delta, 1.0 / smoothing_coefficient)


func _process(delta: float) -> void:
	if not input_active:
		linear_velocity = lerp(linear_velocity, 0.0, delta * smoothing_coefficient)

	if previous_velocity == linear_velocity:
		return

	object_ref.position.x += linear_velocity
	object_ref.position.x = clamp(object_ref.position.x, drawer_start_point.position.x, drawer_end_point.position.x)

	input_active = false
	previous_velocity = linear_velocity



func pre_interact(_hand: Marker3D) -> void:
	is_interacting = true

	request_camera_state_change.emit(false)
	request_movement_state_change.emit(false)
	request_jump_state_change.emit(false)


func interact(_dt: float) -> void:
	pass

func post_interact() -> void:
	is_interacting = false

	request_camera_state_change.emit(true)
	request_movement_state_change.emit(true)
	request_jump_state_change.emit(true)
