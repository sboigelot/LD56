extends Resource
class_name DdrNote

enum DdrDirection {
	LEFT,
	DOWN,
	UP,
	RIGHT
}

@export var time:float = 0.0
@export var direction:DdrDirection = DdrDirection.UP
