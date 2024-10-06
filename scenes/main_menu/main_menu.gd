extends Control

func _ready() -> void:
	SceneTransitionManager.transition_scene_in(self)

func _on_new_game_button_pressed() -> void:
	SceneTransitionManager.transition_scene_to_file(
		"res://scenes/act1_farm/act1a_farm.tscn", 
		SceneTransitionManager.TRANSITIONS.CONICAL_TO_BLACK,
		SceneTransitionManager.TRANSITIONS.FADE_TO_BLACK)

func _on_star_mini_game_1_pressed() -> void:
	$VBoxContainer/StarMiniGame1.release_focus()
	$TimeHitMiniGame.start()

func _on_time_hit_mini_game_win() -> void:
	$TimeHitMiniGame.stop()

	
