extends Control

func _ready() -> void:
	$VBoxContainer/NewGameChallenge.visible = true
	$VBoxContainer/CallengeLabel.visible = false
	SceneTransitionManager.transition_scene_in(self)

func _on_new_game_button_pressed() -> void:
	new_game()
	
func new_game():
	SceneTransitionManager.transition_scene_to_file(
		"res://scenes/FarmScene1/FarmScene1.tscn", 
		SceneTransitionManager.TRANSITIONS.CONICAL_TO_BLACK,
		SceneTransitionManager.TRANSITIONS.FADE_TO_BLACK)

func _on_star_mini_game_4_pressed() -> void:
	$MiniGameChain.start()
	$VBoxContainer/FullScreenButton.visible = false
	$VBoxContainer/NewGameChallenge.visible = false
	$VBoxContainer/CallengeLabel.visible = true

func _on_mini_game_chain_win() -> void:
	new_game()

func _on_full_screen_button_pressed() -> void:
	Game.swap_fullscreen_mode()
