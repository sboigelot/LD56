extends Sprite2D

class_name LaserDestination

signal lit(destination:LaserDestination)

@export var receive_light:bool = false

func _ready() -> void:
	_update_light()
	
func _update_light():
	visible = receive_light
	if receive_light:
		lit.emit(self)
