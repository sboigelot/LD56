extends Control

func _ready() -> void:
	SceneTransitionManager.transition_scene_in(self)
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)

func _on_new_game_button_pressed() -> void:
	SceneTransitionManager.transition_scene_to_file(
		"res://scenes/test_scene/test_scene.tscn", 
		SceneTransitionManager.TRANSITIONS.CONICAL_TO_BLACK,
		SceneTransitionManager.TRANSITIONS.FADE_TO_BLACK)

func _on_play_dialogic_pressed() -> void:
	# check if a dialog is already running
	if Dialogic.current_timeline != null:
		return
	
	$FrySprite.visible = false
	var layout = Dialogic.start('test_timeline')

func _on_play_dialogic_2_pressed() -> void:
	if Dialogic.current_timeline != null:
		return

	var layout = Dialogic.start('bubble_test_timeline')
	layout.register_character("res://dialogic_data/characters/fry/fry_potato.dch", $FrySprite)

func _on_dialogic_timeline_ended():
	$FrySprite.visible = true

func _on_dialogic_signal(args:String):
	if Dialogic.current_timeline != null:
		await Dialogic.timeline_ended
	var layout = Dialogic.start('bubble_test_timeline')
	layout.register_character("res://dialogic_data/characters/fry/fry_potato.dch", $FrySprite)

func _on_star_mini_game_1_pressed() -> void:
	$HBoxContainer/StarMiniGame1.release_focus()
	$TimeHitMiniGame.start()

func _on_time_hit_mini_game_win() -> void:
	$TimeHitMiniGame.stop()
	var layout = Dialogic.start('mini_win_timeline')
	layout.register_character("res://dialogic_data/characters/fry/fry_potato.dch", $FrySprite)
