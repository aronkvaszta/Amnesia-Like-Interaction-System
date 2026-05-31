extends Node3D

# Switches
@onready var yellow_switch: Node3D = $YellowSwitch
@onready var green_switch: Node3D = $GreenSwitch
@onready var red_switch: Node3D = $RedSwitch
@onready var blue_switch: Node3D = $BlueSwitch

# Lights
@onready var yellow_light: SpotLight3D = $YellowLight
@onready var green_light: SpotLight3D = $GreenLight
@onready var red_light: SpotLight3D = $RedLight
@onready var blue_light: SpotLight3D = $BlueLight


func _ready() -> void:
	yellow_light.light_energy = 15 * float(yellow_switch.switch_interaction.is_on)
	red_light.light_energy = 15 * float(red_switch.switch_interaction.is_on)
	blue_light.light_energy = 15 * float(blue_switch.switch_interaction.is_on)
	green_light.light_energy = 15 * float(green_switch.switch_interaction.is_on)

	yellow_switch.switch_state_changed.connect(func(state: bool) -> void:
		yellow_light.light_energy = 15 * float(state)
	)
	red_switch.switch_state_changed.connect(func(state: bool) -> void:
		red_light.light_energy = 15 * float(state)
	)
	blue_switch.switch_state_changed.connect(func(state: bool) -> void:
		blue_light.light_energy = 15 * float(state)
	)
	green_switch.switch_state_changed.connect(func(state: bool) -> void:
		green_light.light_energy = 15 * float(state)
	)
