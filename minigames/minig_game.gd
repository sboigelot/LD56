extends Node2D
class_name MiniGame

signal win
signal loose

@export var accepted_keys:Array[Key] = [KEY_SPACE]
@export var accepted_button_indexes:Array[MouseButton] = [MOUSE_BUTTON_LEFT]
@export var accept_inputs_delay_on_start:float = 0.6
@export var started:bool = false
@export var inputs_needs_mouse_capture:bool = false
@export var icon_show_duration:float = 0.6

@export var on_start_auto_self_modulate:Color = Color.WHITE
@export var on_win_auto_hide:bool = true
@export var on_win_auto_self_modulate:Color = Color(0.3,0.3,0.3,0.5)

## Icon to display when status is Status.SUCCESS
var icon_success : Texture2D = preload("res://addons/tattomoosa.spinner/icons/StatusSuccess.svg"):
	set(value):
		icon_success = value
		
## Icon to display when status is Status.ERROR
var icon_error : Texture2D = preload("res://addons/tattomoosa.spinner/icons/StatusError.svg"):
	set(value):
		icon_error = value
		
## Color when status is Status.SUCCESS
var color_success := Color(0.45, 0.95, 0.5):
	set(value): color_success = value;
## Color when status is Status.PROGRESSING or Status.SPINNING
var color_progress := Color(0.44, 0.73, 0.98):
	set(value): color_progress = value;
## Color when status is Status.ERROR
var color_error := Color(1, 0.47, 0.42):
	set(value): color_error = value;

var accept_inputs:bool = false

func _ready() -> void:
	if started:
		start()
	else:
		stop()

func start() -> void:
	started = true
	visible = true
	process_mode = PROCESS_MODE_INHERIT
	self_modulate = on_start_auto_self_modulate
	await get_tree().create_timer(accept_inputs_delay_on_start).timeout
	accept_inputs = true
	
func stop() -> void:
	started = false
	visible = false
	accept_inputs = false
	process_mode = PROCESS_MODE_DISABLED
		
func trigger_win():
	if on_win_auto_hide:
		hide()
	self_modulate = on_win_auto_self_modulate
	win.emit()

func trigger_loose():
	loose.emit()
