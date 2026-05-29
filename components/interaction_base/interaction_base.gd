@abstract
class_name InteractionBase
extends Node

enum InteractionType {
	ONESHOT,
	HOLD,
	TOGGLE
}

@export var object_ref: Node3D = null
@export var interaction_type: InteractionType = InteractionType.ONESHOT
var is_interacting: bool = false
var can_interact: bool = true


signal request_interaction_end(use_post: bool)
signal request_camera_state_change(state: bool)
signal request_movement_state_change(state: bool)
signal request_jump_state_change(state: bool)


func pre_interact(_hand: Marker3D) -> void: pass
func interact(_dt: float) -> void: pass
func post_interact() -> void: pass
