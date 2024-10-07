extends Area2D

class_name LaserSource

func _ready() -> void:
	input_event.connect(_on_laser_source_input_event)

func _on_laser_source_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event is InputEventMouseButton and 
		event.is_released() and 
		event.button_index == MOUSE_BUTTON_LEFT):
		_on_click()
		
func _on_click():
	pass
