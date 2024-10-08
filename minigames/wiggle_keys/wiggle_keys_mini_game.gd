extends MiniGame

signal flip(left:bool)

@export var next_input_modulate: Color = Color.WHITE
@export var not_next_input_modulate: Color = Color(1.0,1.0,1.0,0.5)
@export var target_hit_count:int = 15
@export var show_potato_texture:bool = false

@onready var left_texture_rect: TextureRect = $MarginContainer/HBoxContainer/LeftTextureRect
@onready var right_texture_rect: TextureRect = $MarginContainer/HBoxContainer/RightTextureRect
@onready var potato_texture_rect: TextureRect = $MarginContainer/HBoxContainer/PotatoTextureRect

var next_input_left: bool
var hit_count:int

func start():
	next_input_left = randi() % 1 == 1
	hit_count = 0
	super.start()

func _process(delta: float) -> void:
	super._process(delta)
	potato_texture_rect.visible = show_potato_texture
	potato_texture_rect.flip_h = not next_input_left
	left_texture_rect.modulate = next_input_modulate if next_input_left else not_next_input_modulate
	right_texture_rect.modulate = next_input_modulate if not next_input_left else not_next_input_modulate

func _input(event: InputEvent) -> void:
	
	if not started or not accept_inputs:
		return
		
	if (event is InputEventKey and 
		event.is_pressed()):
			for accepted_key in accepted_keys:
				if event.keycode == accepted_key:
					_on_hit(event.keycode in [KEY_A, KEY_Q, KEY_LEFT])
					break
	
	if(event is InputEventMouseButton and
		event.is_pressed()):
			var can_hit = true
			if inputs_needs_mouse_capture:
				var mouse_position = get_global_mouse_position()
				var capture = true
				printerr("Not implemented: hit_needs_mouse_capture")
				can_hit = capture
			if can_hit:
				for accepted_button_index in accepted_button_indexes:
					if event.button_index == accepted_button_index:
						_on_hit(event.button_index == MOUSE_BUTTON_LEFT)
						break
			
func _on_hit(is_hit_left:bool):
	if hit_count >= target_hit_count:
		return
		
	if is_hit_left != next_input_left:
		return
		
	next_input_left = not next_input_left
	flip.emit(next_input_left)
	hit_count += 1
	
	if hit_count >= target_hit_count:
		var default_texture = potato_texture_rect.texture
		potato_texture_rect.texture = icon_success
		potato_texture_rect.self_modulate = color_success
		await get_tree().create_timer(icon_show_duration).timeout
		potato_texture_rect.texture = default_texture
		potato_texture_rect.self_modulate = Color.WHITE
		trigger_win()
		
