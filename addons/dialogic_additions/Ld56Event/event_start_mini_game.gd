@tool
class_name DialogicStartMiniGameEvent
extends DialogicEvent

## Event that emits the Dialogic.signal_event signal with an argument.
## You can connect to this signal like this: `Dialogic.signal_event.connect(myfunc)`


### Settings

## The argument that will be provided with the signal.
var minigame_name: String = ""
var difficulty: String = ""
var hide_textbox := true
var wait_game_signal := true

################################################################################
## 						EXECUTE
################################################################################

func _execute() -> void:
	var dict = {}
	dict["action"] = "start_mini_game"
	dict["minigame_name"] = minigame_name
	dict["difficulty"] = difficulty
	dict.make_read_only()
	dialogic.emit_signal('signal_event', dict)
	
	if hide_textbox:
		dialogic.Text.hide_textbox()
	dialogic.current_state = DialogicGameHandler.States.IDLE
	if wait_game_signal:
		await Game.signal_to_dialogic
	finish()


################################################################################
## 						INITIALIZE
################################################################################

func _init() -> void:
	event_name = "StartMiniGame"
	set_default_color('Color6')
	event_category = "Logic"
	event_sorting_index = 10
	

################################################################################
## 						SAVING/LOADING
################################################################################

func get_shortcode() -> String:
	return "start_mini_game"


func get_shortcode_parameters() -> Dictionary:
	return {
		"minigame_name"	: {"property": "minigame_name", "default": ""},
		"difficulty"	: {"property": "difficulty", "default": ""},
		"hide_text" :  {"property": "hide_textbox", 	"default": true},
		"wait_game_signal" :  {"property": "wait_game_signal", 	"default": true},
	}

################################################################################
## 						EDITOR REPRESENTATION
################################################################################

func build_event_editor() -> void:
	add_header_label("Start a mini game")
	add_header_edit('minigame_name', ValueType.SINGLELINE_TEXT, {'left_text':'Name:'})
	add_header_edit('difficulty', ValueType.SINGLELINE_TEXT, {'left_text':'Difficulty:'})
	add_body_edit('hide_textbox', ValueType.BOOL, {'left_text':'Hide text box:'})
	add_body_edit('wait_game_signal', ValueType.BOOL, {'left_text':'Wait Game Signal:'})
	
