extends RigidBody3D

@onready var weight_label: Label3D = $WeightLabel


func _ready() -> void:
	weight_label.text = '%.f Kg' % mass
