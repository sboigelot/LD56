extends Control

func _ready() -> void:
	SceneTransitionManager.transition_scene_in(self)
	
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)

func _on_new_game_button_pressed() -> void:
	SceneTransitionManager.transition_scene_to_file(
		"res://scenes/act1_farm/act1a_farm.tscn", 
		SceneTransitionManager.TRANSITIONS.CONICAL_TO_BLACK,
		SceneTransitionManager.TRANSITIONS.FADE_TO_BLACK)

func _on_play_dialogic_pressed() -> void:
	if Dialogic.current_timeline != null:
		return
	
	hide_world_character()
	var layout = Dialogic.start('test_timeline')

func hide_world_character():
	$WorldPortrait2D.visible = false

func show_world_character():
	$WorldPortrait2D.visible = true

func register_bubble_characters(layout):
	layout.register_character("res://dialogic_data/characters/fry/fry_potato.dch", $WorldPortrait2D)

func _on_play_dialogic_2_pressed() -> void:
	if Dialogic.current_timeline != null:
		return

	var layout = Dialogic.start('bubble_test_timeline')
	register_bubble_characters(layout)

func _on_dialogic_timeline_ended():
	show_world_character()

func _on_dialogic_signal(args:Variant):
	if Dialogic.current_timeline != null:
		await Dialogic.timeline_ended
	var layout = Dialogic.start('bubble_test_timeline')
	register_bubble_characters(layout)

func _on_star_mini_game_1_pressed() -> void:
	$HBoxContainer/StarMiniGame1.release_focus()
	$TimeHitMiniGame.start()

func _on_time_hit_mini_game_win() -> void:
	$TimeHitMiniGame.stop()
	var layout = Dialogic.start('mini_win_timeline')
	register_bubble_characters(layout)

	
