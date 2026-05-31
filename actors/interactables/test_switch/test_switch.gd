extends Node3D

@onready var switch_interaction: SwitchInteraction = %SwitchInteraction

@onready var open_direction_label: Label3D = $OpenDirectionLabel
@onready var is_open_label: Label3D = $IsOpenLabel
@onready var angle_label: Label3D = $AngleLabel


signal switch_state_changed(state: bool)


func _ready() -> void:
	open_direction_label.text = 'Open Direction: %s' % ['Up' if switch_interaction.open_direction == SwitchInteraction.OpenDirection.UP else 'Down']
	is_open_label.text = 'Is On: %s' % ['On' if switch_interaction.is_on else 'Off']
	angle_label.text = 'Angle: %.2f' % [rad_to_deg(switch_interaction.current_angle)]


func _on_switch_interaction_switch_state_changed(state: bool) -> void:
	is_open_label.text = 'Is On: %s' % ['On' if state else 'Off']
	switch_state_changed.emit(state)


func _on_switch_interaction_current_angle_changed(new_angle: float) -> void:
	angle_label.text = 'Angle: %.2f' % [rad_to_deg(new_angle)]
