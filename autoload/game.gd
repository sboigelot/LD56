extends Node

signal signal_to_dialogic

func _init():
	EventAudio.log_lookups = true
	EventAudio.log_registrations = true
	EventAudio.log_deaths = true
	
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("fullscreen"):
		swap_fullscreen_mode()
		
	if Input.is_action_just_pressed("quit"):			
		SceneTransitionManager.transition_scene_to_file(
			"res://scenes/main_menu/main_menu.tscn", 
			SceneTransitionManager.TRANSITIONS.FADE_TO_BLACK,
			SceneTransitionManager.TRANSITIONS.FADE_TO_BLACK)
		
func swap_fullscreen_mode():
	var current_mode = DisplayServer.window_get_mode()
	match(current_mode):
		DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		_:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
