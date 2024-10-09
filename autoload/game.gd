extends Node

signal signal_to_dialogic

var current_song:MusicTrack

func _init():
	EventAudio.log_lookups = true
	EventAudio.log_registrations = true
	EventAudio.log_deaths = true
	
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("fullscreen"):
		swap_fullscreen_mode()
		
	if Input.is_action_just_pressed("quit"):
		var current_scene = get_tree().current_scene.name
		if "MainMenu" in current_scene:
			#printerr("os name is %s"%OS.get_name())
			if OS.get_name() in ["Web", "HTML5"]:
				exit_fullscreen_mode()
			else: 
				get_tree().quit()
			return
		Dialogic.end_timeline()
		SceneTransitionManager.transition_scene_to_file(
			"res://scenes/main_menu/main_menu.tscn", 
			SceneTransitionManager.TRANSITIONS.FADE_TO_BLACK,
			SceneTransitionManager.TRANSITIONS.FADE_TO_BLACK)

func exit_fullscreen_mode():
	var current_mode = DisplayServer.window_get_mode()
	if current_mode != DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
func swap_fullscreen_mode():
	var current_mode = DisplayServer.window_get_mode()
	match(current_mode):
		DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		_:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func play_song(music:MusicTrack, force:bool=false):
	if current_song != music or force:
		current_song = music
		MusicManager.play_song.emit(music, true, true, 0.0)
