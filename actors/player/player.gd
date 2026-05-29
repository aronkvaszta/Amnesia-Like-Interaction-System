class_name Player
extends CharacterBody3D

@onready var head: Node3D = %Head
@onready var eyes: Node3D = %Eyes
@onready var camera: Camera3D = %Camera3D

@onready var buffer_timer: Timer = $BufferTimer


@export_group('Moving')
@export var move_speed: float = 2.5
var _move_input: Vector2 = Vector2.ZERO

@export_group('Looking')
@export var sensitivity: float = 0.6
@export var min_look_angle: float = -85
@export var max_look_angle: float = 85
var _look_input: Vector2 = Vector2.ZERO
var _look_rotation: Vector2 = Vector2.ZERO

@export_group('Jumping')
@export var jump_height: float = 1.25
@export var peak_time: float = 0.35
@export var fall_time: float = 0.3
var _jump_velocity: float = 0.0
var _up_gravity: float = 0.0
var _down_gravity: float = 0.0
@export_subgroup('Buffered Jump')
@export var buffer_time: float = 0.2
var _wants_to_jump: bool = false

@export_group('View Bobbing')
@export var frequency: float = 5.0
@export var amplitude: float = 0.04
var _headbob_time: float = 0.0

@export_group('Flags')
@export var can_move: bool = true
@export var can_jump: bool = true
@export var can_look: bool = true

var player_velocity: Vector3 = Vector3.ZERO



func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	_jump_velocity = 2 * jump_height / peak_time
	_up_gravity = -2 * jump_height / (peak_time * peak_time)
	_down_gravity = -2 * jump_height / (fall_time * fall_time)

	buffer_timer.wait_time = buffer_time
	buffer_timer.one_shot = true
	buffer_timer.timeout.connect(_on_buffer_timer_timeout)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_look_input = -event.relative


func _process(delta: float) -> void:
	if is_on_floor():
		player_velocity.y = -0.5
		if _wants_to_jump:
			buffer_timer.stop()
			_wants_to_jump = false
			player_velocity.y = _jump_velocity

	if can_look:
		_look_rotation.y += _look_input.x * sensitivity * delta
		_look_rotation.x += _look_input.y * sensitivity * delta
		_look_rotation.x = clamp(_look_rotation.x, deg_to_rad(min_look_angle), deg_to_rad(max_look_angle))

		head.rotation.y = _look_rotation.y
		eyes.rotation.x = _look_rotation.x

		_look_input = Vector2.ZERO

	if can_move:
		_move_input = Input.get_vector(&'left', &'right', &'up', &'down')
		var move_dir: Vector3 = head.transform.basis * Vector3(_move_input.x, 0.0, _move_input.y).normalized()

		player_velocity.x = move_dir.x * move_speed
		player_velocity.z = move_dir.z * move_speed

	player_velocity.y += _calc_gravity(delta)

	if can_jump:
		if Input.is_action_just_pressed(&'jump') and is_on_floor():
			player_velocity.y = _jump_velocity
		elif Input.is_action_just_pressed(&'jump') and not is_on_floor():
			buffer_timer.start()
			_wants_to_jump = true

	velocity = player_velocity
	move_and_slide()

	var period = (2.0 * PI) / (frequency * 0.5)
	_headbob_time = fmod(_headbob_time + delta * velocity.length() * float(is_on_floor()), period)

	head.transform.origin = _headbob(_headbob_time)


func _calc_gravity(dt: float) -> float:
	if velocity.y < 0:
		return _down_gravity * dt
	return _up_gravity * dt


func _headbob(time: float) -> Vector3:
	var headbob_position: Vector3 = Vector3.ZERO
	headbob_position.y = sin(time * frequency) * amplitude
	headbob_position.x = cos(time * frequency * 0.5) * amplitude
	return headbob_position


func _on_buffer_timer_timeout() -> void:
	_wants_to_jump = false
