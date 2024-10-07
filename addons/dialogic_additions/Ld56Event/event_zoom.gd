@tool
class_name DialogicZoomEvent
extends DialogicEvent

## Event that emits the Dialogic.signal_event signal with an argument.
## You can connect to this signal like this: `Dialogic.signal_event.connect(myfunc)`


### Settings

## The argument that will be provided with the signal.
var character: DialogicCharacter = null
var zoom_level: float = 1.0
var hide_textbox := false
var wait_game_signal := false

## Used to set the character resource from the unique name identifier and vice versa
var character_identifier: String:
	get:
		if character:
			var identifier := DialogicResourceUtil.get_unique_identifier(character.resource_path)
			if not identifier.is_empty():
				return identifier
		return character_identifier
	set(value):
		character_identifier = value
		character = DialogicResourceUtil.get_character_resource(value)

################################################################################
## 						EXECUTE
################################################################################

func _execute() -> void:
	var dict = {}
	dict["action"] = "zoom"
	dict["character_name"] = character_identifier
	dict["zoom_level"] = zoom_level
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
	event_name = "Zoom"
	set_default_color('Color6')
	event_category = "Logic"
	event_sorting_index = 9
	

################################################################################
## 						SAVING/LOADING
################################################################################

func get_shortcode() -> String:
	return "zoom"


func get_shortcode_parameters() -> Dictionary:
	return {
		"character"	: {"property": "character_identifier", "default": ""},
		"zoom_level"	: {"property": "zoom_level", "default": 1.0},
		"hide_text" :  {"property": "hide_textbox", 	"default": true},
		"wait_game_signal" :  {"property": "wait_game_signal", 	"default": true},
	}

################################################################################
## 						EDITOR REPRESENTATION
################################################################################

func _enter_visual_editor(editor:DialogicEditor):
	editor.opened.connect(func(): ui_update_needed.emit())


func build_event_editor() -> void:
	add_header_label("Zoom")
	add_header_edit('character_identifier', ValueType.DYNAMIC_OPTIONS,
			{'file_extension' 	: '.dch',
			'mode'				: 2,
			'suggestions_func' 	: get_character_suggestions,
			'empty_text' 		: '(No one - StoryScene)',
			'icon' 				: load("res://addons/dialogic/Editor/Images/Resources/character.svg")}, 'do_any_characters_exist()')
	add_header_edit('zoom_level', ValueType.NUMBER, {'left_text':'Zoom level:'})
	add_body_edit('hide_textbox', ValueType.BOOL, {'left_text':'Hide text box:'})
	add_body_edit('wait_game_signal', ValueType.BOOL, {'left_text':'Wait Game Signal:'})
	

func do_any_characters_exist() -> bool:
	return not DialogicResourceUtil.get_character_directory().is_empty()

func get_character_suggestions(search_text:String) -> Dictionary:
	return DialogicUtil.get_character_suggestions(search_text, character, true, false, editor_node)
