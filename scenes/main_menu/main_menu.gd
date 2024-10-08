extends Control

@onready var full_screen_button: Button = $TitleContainer/VBoxContainer/FullScreenButton
@onready var new_game_challenge: Button = $TitleContainer/VBoxContainer/NewGameChallenge
@onready var callenge_label: Label = $TitleContainer/VBoxContainer/CallengeLabel

func _ready() -> void:
	new_game_challenge.visible = true
	callenge_label.visible = false
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
	full_screen_button.visible = false
	new_game_challenge.visible = false
	callenge_label.visible = true

func _on_mini_game_chain_win() -> void:
	new_game()

func _on_full_screen_button_pressed() -> void:
	Game.swap_fullscreen_mode()
