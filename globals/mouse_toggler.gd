extends Node


var _mouse_enabled: bool = false :
	set(v):
		_mouse_enabled = v
		if _mouse_enabled:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_pressed():
			if OS.get_keycode_string(event.keycode) == 'QuoteLeft':
				_mouse_enabled = not _mouse_enabled
