extends Control

func _ready() -> void:
	SceneTransitionManager.transition_scene_in(self)

func _on_new_game_button_pressed() -> void:
	SceneTransitionManager.transition_scene_to_file(
		"res://scenes/FarmScene1/FarmScene1.tscn", 
		SceneTransitionManager.TRANSITIONS.CONICAL_TO_BLACK,
		SceneTransitionManager.TRANSITIONS.FADE_TO_BLACK)

func _on_star_mini_game_1_pressed() -> void:
	$VBoxContainer/StarMiniGame1.release_focus()
	$TimeHitMiniGame.start()

func _on_star_mini_game_2_pressed() -> void:
	$VBoxContainer/StarMiniGame2.release_focus()
	$WiggleKeysMiniGame.start()
	
func _on_wiggle_keys_mini_game_win() -> void:
	$WiggleKeysMiniGame.stop()

func _on_star_mini_game_3_pressed() -> void:
	$SodaCapReavealMiniGame.start()

func _on_soda_cap_reaveal_mini_game_win() -> void:
	$SodaCapReavealMiniGame.stop()

func _on_star_mini_game_4_pressed() -> void:
	$MiniGameChain.start()
