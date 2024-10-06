@tool
class_name DialogicWaitSignal
extends DialogicEvent

## Event that waits for a signal before continuing.

var hide_textbox := true

################################################################################
## 						EXECUTE
################################################################################

func _execute() -> void:
	if hide_textbox:
		dialogic.Text.hide_textbox()
	dialogic.current_state = DialogicGameHandler.States.IDLE
	await Game.signal_to_dialogic
	finish()

################################################################################
## 						INITIALIZE
################################################################################

func _init() -> void:
	event_name = "Wait for Signal"
	set_default_color('Color5')
	event_category = "Flow"
	event_sorting_index = 13


################################################################################
## 						SAVING/LOADING
################################################################################

func get_shortcode() -> String:
	return "wait_signal"

func get_shortcode_parameters() -> Dictionary:
	return {
		#param_name : property_info
		"hide_text" :  {"property": "hide_textbox", 	"default": true},
	}


func build_event_editor() -> void:
	add_header_label('Wait for Signal')
	add_body_edit('hide_textbox', ValueType.BOOL, {'left_text':'Hide text box:'})
