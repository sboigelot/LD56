@tool
extends DialogicIndexer

func _get_events() -> Array:
	return [
		this_folder.path_join('event_change_scene.gd'),
		this_folder.path_join('event_start_anim.gd'),
		this_folder.path_join('event_wait_signal.gd'),
		this_folder.path_join('event_start_mini_game.gd'),
		this_folder.path_join('event_zoom.gd'),
	]
