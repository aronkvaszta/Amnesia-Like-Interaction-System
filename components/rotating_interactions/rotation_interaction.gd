@abstract
class_name RotationInteraction
extends InteractionBase


@export var max_rotation: float
@export var smoothing_coefficient: float = 13.5
var starting_rotation: float

var current_angle: float
var previous_angle: float

var angular_velocity: float
var input_active: bool = false


func _ready() -> void:
	max_rotation = deg_to_rad(rad_to_deg(starting_rotation) + max_rotation)


func pre_interact(_hand: Marker3D) -> void:
	super(_hand)


func interact(_dt: float) -> void:
	super(_dt)


func post_interact() -> void:
	super()
	request_camera_state_change.emit(true)
	request_jump_state_change.emit(true)
	request_movement_state_change.emit(true)
	is_interacting = false


func _get_rotation_percentage() -> float:
	return (object_ref.rotation.z - starting_rotation) / (max_rotation - starting_rotation)
