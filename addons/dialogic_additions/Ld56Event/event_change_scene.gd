@tool
class_name DialogicChangeSceneEvent
extends DialogicEvent

## Event that emits the Dialogic.signal_event signal with an argument.
## You can connect to this signal like this: `Dialogic.signal_event.connect(myfunc)`


### Settings

## The argument that will be provided with the signal.
var scene_path: String = ""

################################################################################
## 						EXECUTE
################################################################################

func _execute() -> void:	
	SceneTransitionManager.transition_scene_to_file(
		scene_path, 
		SceneTransitionManager.TRANSITIONS.FADE_TO_BLACK,
		SceneTransitionManager.TRANSITIONS.FADE_TO_BLACK)
	finish()


################################################################################
## 						INITIALIZE
################################################################################

func _init() -> void:
	event_name = "ChangeScene"
	set_default_color('Color6')
	event_category = "Logic"
	event_sorting_index = 10
	

################################################################################
## 						SAVING/LOADING
################################################################################

func get_shortcode() -> String:
	return "change_scene"


func get_shortcode_parameters() -> Dictionary:
	return {
		"scene_path"	: {"property": "scene_path", "default": ""},
	}

################################################################################
## 						EDITOR REPRESENTATION
################################################################################

func build_event_editor() -> void:
	add_header_label("Change scene")
	add_header_edit('scene_path', ValueType.SINGLELINE_TEXT, {'left_text':'Scene Path:'})
