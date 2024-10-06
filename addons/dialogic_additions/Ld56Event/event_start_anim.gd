@tool
class_name DialogicStartAnimEvent
extends DialogicEvent

## Event that emits the Dialogic.signal_event signal with an argument.
## You can connect to this signal like this: `Dialogic.signal_event.connect(myfunc)`


### Settings

## The argument that will be provided with the signal.
var character: DialogicCharacter = null
var anim_name: String = ""
var backwards: bool = false

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
	dict["action"] = "start_anim"
	dict["anim_name"] = anim_name
	dict["backwards"] = backwards
	dict["character_name"] = character_identifier
	dict.make_read_only()
	dialogic.emit_signal('signal_event', dict)
	finish()


################################################################################
## 						INITIALIZE
################################################################################

func _init() -> void:
	event_name = "StartAnim"
	set_default_color('Color6')
	event_category = "Logic"
	event_sorting_index = 9
	

################################################################################
## 						SAVING/LOADING
################################################################################

func get_shortcode() -> String:
	return "start_anim"


func get_shortcode_parameters() -> Dictionary:
	return {
		"character"	: {"property": "character_identifier", "default": ""},
		"anim_name"	: {"property": "anim_name", "default": ""},
		"backwards"	: {"property": "anim_name", "default": false},
		"hide_text" :  {"property": "hide_textbox", "default": true},
	}

################################################################################
## 						EDITOR REPRESENTATION
################################################################################

func _enter_visual_editor(editor:DialogicEditor):
	editor.opened.connect(func(): ui_update_needed.emit())


func build_event_editor() -> void:
	add_header_label("Start a story animation")
	add_header_edit('character_identifier', ValueType.DYNAMIC_OPTIONS,
			{'file_extension' 	: '.dch',
			'mode'				: 2,
			'suggestions_func' 	: get_character_suggestions,
			'empty_text' 		: '(No one - StoryScene)',
			'icon' 				: load("res://addons/dialogic/Editor/Images/Resources/character.svg")}, 'do_any_characters_exist()')
	add_header_edit('anim_name', ValueType.SINGLELINE_TEXT, {'left_text':'Anim Name:'})
	add_body_edit('backwards', ValueType.BOOL, {'left_text':'Play Backwards:'})
	
	

func do_any_characters_exist() -> bool:
	return not DialogicResourceUtil.get_character_directory().is_empty()


func get_character_suggestions(search_text:String) -> Dictionary:
	return DialogicUtil.get_character_suggestions(search_text, character, true, false, editor_node)
