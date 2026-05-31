extends Node3D

@onready var is_open_label: Label3D = $IsOpenLabel
@onready var rotation_label: Label3D = $RotationLabel
@onready var valve_interaction: ValveInteraction = %ValveInteraction
@onready var open_direction_label: Label3D = $OpenDirectionLabel


func _ready() -> void:
	is_open_label.text = 'Is Open: %s' % 'Open' if valve_interaction.is_open else 'Closed'
	rotation_label.text = 'Rotation: %.2f' % valve_interaction.current_angle
	open_direction_label.text = 'Open Direction: %s' % ['Left' if valve_interaction.open_direction == ValveInteraction.OpenDirection.LEFT else 'Right']


func _on_valve_interaction_valve_open_state_changed(state: bool) -> void:
	is_open_label.text = 'Is Open: %s' % 'Open' if state else 'Closed'


func _on_valve_interaction_current_angle_changed(new_angle: float) -> void:
	rotation_label.text = 'Rotation: %.2f' % rad_to_deg(new_angle)
