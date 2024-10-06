extends MiniGame

@export var target_revolution_size:float = 0.2
@export var spin_revolution_per_second:float = 0.5
@export var spinner_revolution_size:float = 0.05

@export var input_prompt_texture: Texture2D

@onready var spinner: Spinner = $MarginContainer/Spinner
@onready var green_zone_spinner: Spinner = $MarginContainer/GreenZoneSpinner
@onready var input_prompt: TextureRect = $MarginContainer/InputPrompt

func start() -> void:
	spinner.spin_revolution_per_second = spin_revolution_per_second
	spinner.spin_fill_percent = spinner_revolution_size
	spinner._radial_initial_angle = randf_range(0.0, 360.0)
	green_zone_spinner.value = target_revolution_size * green_zone_spinner.max_value
	green_zone_spinner._radial_initial_angle = randf_range(0.0, 360.0)
	input_prompt.texture = input_prompt_texture
	super.start()
		
func _input(event: InputEvent) -> void:
	if not started or not accept_inputs:
		return
		
	if not spinner.status == spinner.Status.SPINNING:
		return
		
	if (event is InputEventKey and 
		event.is_released()):
			for accepted_key in accepted_keys:
				if event.keycode == accepted_key:
					_on_hit()
					break
			
	if(event is InputEventMouseButton and
		event.is_released()):
			var can_hit = true
			if inputs_needs_mouse_capture:
				var mouse_position = get_global_mouse_position()
				var capture = true
				printerr("Not implemented: hit_needs_mouse_capture")
				can_hit = capture
			if can_hit:
				for accepted_button_index in accepted_button_indexes:
					if event.button_index == accepted_button_index:
						_on_hit()
						break
			
func _on_hit():
	var hit = false
	if (spinner._progress_border.start_angle >= green_zone_spinner._progress_border.start_angle and
		spinner._progress_border.end_angle <= green_zone_spinner._progress_border.end_angle):
		hit = true
		spinner.status = spinner.Status.SUCCESS
	else:
		spinner.status = spinner.Status.ERROR
		
	input_prompt.visible = false	
	await get_tree().create_timer(icon_show_duration).timeout
	spinner.status = spinner.Status.SPINNING
	spinner._radial_initial_angle = randf_range(0.0, 360.0)
	green_zone_spinner._radial_initial_angle = randf_range(0.0, 360.0)
	input_prompt.visible = true
	
	if hit:
		win.emit()
	else:
		loose.emit()
