extends Area2D

class_name LaserSource

@export var receive_light:bool = false
@export var targets:Array[Node2D]
@export var target_index:int = 0

@onready var line_2d: Line2D = $Line2D

func _update_bounce_light():
	var target:Node2D = self
	if targets.size() > target_index:
		target = targets[target_index]
		if target is LaserSource:
			target.receive_light = receive_light
			target._update_bounce_light()
		elif target is LaserDestination:
			target.receive_light = receive_light
			target._update_light()
			
	if line_2d != null:
		line_2d.visible = receive_light
		line_2d.points[1] = target.global_position - global_position
	else:
		pass

func _rotate_toward_target():
	var target:Node2D = self
	if targets.size() > target_index:
		target = targets[target_index]
	
	var angle_to_target = global_position.angle_to_point(target.global_position)
	$Sprite2D.rotation = angle_to_target
	
func _ready() -> void:
	input_event.connect(_on_laser_source_input_event)
	_rotate_toward_target()
	_update_bounce_light()

func _on_laser_source_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event is InputEventMouseButton and 
		event.is_released() and 
		event.button_index == MOUSE_BUTTON_LEFT):
		_on_click()
		
func _on_click():
	if targets.size() > target_index:
		var old_target = targets[target_index]
		if old_target is LaserSource:
			old_target.receive_light = false
			old_target._update_bounce_light()
		elif old_target is LaserDestination:
			old_target.receive_light = false
			old_target._update_light()
			
	target_index += 1
	if target_index >= targets.size():
		target_index = 0
	
	_rotate_toward_target()
	_update_bounce_light()
