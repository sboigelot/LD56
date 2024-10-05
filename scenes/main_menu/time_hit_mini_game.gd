extends Control

@onready var back_progress_bar: ProgressBar = $MarginContainer/BackProgressBar
@onready var front_progress_bar: ProgressBar = $MarginContainer/FrontProgressBar
@onready var h_slider: HSlider = $MarginContainer/HSlider

@export var speed:float = 75.0

var go_up:bool = true
var started:bool = false

signal win
signal loose

func _ready() -> void:
	visible = false

func start() -> void:
	started = true
	visible = true
	process_mode = PROCESS_MODE_INHERIT

func stop() -> void:
	started = false
	visible = false
	process_mode = PROCESS_MODE_DISABLED
	
func _process(delta: float) -> void:
	
	if not started:
		visible = false
		process_mode = PROCESS_MODE_DISABLED
		return
	
	var h_slider_move = speed * delta
	if go_up:
		h_slider.value += h_slider_move
		if h_slider.value >= h_slider.max_value:
			go_up = false
	else:
		h_slider.value -= h_slider_move
		if h_slider.value <= h_slider.min_value:
			go_up = true
		
func _input(event: InputEvent) -> void:
	if not started:
		return
		
	if (event is InputEventKey and 
		event.keycode == KEY_SPACE and 
		event.is_released()):
			if (h_slider.value <= back_progress_bar.value and
				h_slider.value >= front_progress_bar.value):
					win.emit()
			else:
					loose.emit()
		
