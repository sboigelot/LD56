extends Node

enum TRANSITIONS {
	CONICAL_TO_BLACK,
	FADE_TO_BLACK,
	RADIAL_TO_BLACK
}

const transition_scene:Dictionary = {
	TRANSITIONS.CONICAL_TO_BLACK: preload("res://autoload/scene_transition_manager/transition/conical_to_black.tres"),
	TRANSITIONS.FADE_TO_BLACK: preload("res://autoload/scene_transition_manager/transition/fade_to_black.tres"),
	TRANSITIONS.RADIAL_TO_BLACK: preload("res://autoload/scene_transition_manager/transition/radial_to_black.tres"),
}

var next_scene_path:String
var next_transition_in:TRANSITIONS = TRANSITIONS.FADE_TO_BLACK

func _ready() -> void:
	SceneManager.loading_completed.connect(_on_scene_loaded)

func transition_scene_to_file(path: String, transition_out:TRANSITIONS, transition_in:TRANSITIONS):
	next_scene_path = path
	next_transition_in = transition_in
	var scene_transition:SceneTransition = transition_scene[transition_out]
	var transition_tween = SceneManager.transition_start(scene_transition)
	transition_tween.finished.connect(_on_transition_in_completed)
	
func _on_transition_in_completed():
	SceneManager.change_scene_to_file(next_scene_path)

func transition_scene_in(scene):
	scene.process_mode = PROCESS_MODE_DISABLED
	var scene_transition:SceneTransition = transition_scene[next_transition_in]
	SceneManager.transition_start(scene_transition, true).finished.connect(func():
		scene.process_mode = PROCESS_MODE_INHERIT
	)

func _on_scene_loaded():
	pass
	#var scene_transition:SceneTransition = transition_scene[next_transition_out]
	#var transition_tween = SceneManager.transition_start(scene_transition)
	#SceneManager.transition_start(transition_scene[TRANSITIONS.FADE_TO_BLACK], true)
