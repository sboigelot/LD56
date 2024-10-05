extends Control

func _ready() -> void:
	SceneTransitionManager.transition_scene_in(self)

func _on_new_game_button_pressed() -> void:
	SceneTransitionManager.transition_scene_to_file(
		"res://scenes/test_scene/test_scene.tscn", 
		SceneTransitionManager.TRANSITIONS.CONICAL_TO_BLACK,
		SceneTransitionManager.TRANSITIONS.FADE_TO_BLACK)
