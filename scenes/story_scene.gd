extends Node
class_name  StoryScene

@export var bubble_chararcters: Array[NodePath]
@export var music: MusicTrack

func play_bg_music():	
	MusicManager.play_song.emit(music, true, true, 0.3)
	
func _ready() -> void:
	SceneTransitionManager.transition_scene_in(self)
	
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.text_signal.connect(_on_dialogic_text_signal)
	Dialogic.event_handled.connect(_on_dialogic_event_handled)
	Dialogic.Styles.style_changed.connect(_on_dialogic_style_changed)
	Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)
	
	on_story_scene_ready()
	
	if music != null:
		play_bg_music()
	
func on_story_scene_ready():
	pass
	
func start_new_timeline(timeline_name:String):
	var layout = Dialogic.start(timeline_name)
	register_bubble_characters(layout)

func register_bubble_characters(layout):
	for bubble_chararcter in bubble_chararcters:
		var bubble_chararcter_node = get_node(bubble_chararcter)
		layout.register_character(
			bubble_chararcter_node.dialogic_character_path, 
			bubble_chararcter_node.get_bubble_marker_2d()
		)

func hide_world_character():
	for bubble_chararcter in bubble_chararcters:
		var bubble_chararcter_node = get_node(bubble_chararcter)
		bubble_chararcter_node.visible = false

func show_world_character():
	for bubble_chararcter in bubble_chararcters:
		var bubble_chararcter_node = get_node(bubble_chararcter)
		bubble_chararcter_node.visible = true
	
func _on_dialogic_signal(args:Variant):
	if not args is Dictionary:
		return
			
	if "dialogic_command" in args:
		var dialogic_command = args["dialogic_command"]
		match  dialogic_command:
			"register_bubble_characters":
				var layout = get_node("/root/DialogicLayout_TextBubbleStyle")
				register_bubble_characters(layout)
		return
	
	_handle_timeline_signal(args)

func _handle_timeline_signal(args:Dictionary):
	if not "action" in args:
		return
		
	var action = args["action"]
	match action:
		"start_mini_game":
			_on_start_mini_game(args)
			
		"start_anim":
			_on_start_anim(args)
			
		"zoom":
			_on_zoom_request(args)
	
func _on_start_mini_game(args:Dictionary):
	pass
	
func _on_start_anim(args:Dictionary):
	pass
	
func _on_zoom_request(args:Dictionary):
	pass
	
func _on_dialogic_text_signal(text_signal_param:Variant) -> void:
	if text_signal_param == "zoom_fry":
		var dict = {}
		dict["action"] = "zoom"
		dict["character_name"] = "fry_potato"
		dict["zoom_level"] = 2.0
		_on_zoom_request(dict)
		return
		
	if text_signal_param == "zoom_reset":
		var dict = {}
		dict["action"] = "zoom"
		dict["character_name"] = ""
		dict["zoom_level"] = 1.0
		_on_zoom_request(dict)
		return
		
	if text_signal_param == "zoom_gan_hair":
		var dict = {}
		dict["action"] = "zoom"
		dict["character_name"] = "gran_patat"
		dict["zoom_level"] = 5.0
		_on_zoom_request(dict)
		return

func _on_dialogic_event_handled(resource: DialogicEvent):
	pass

func _on_dialogic_style_changed(signal_info:Dictionary):
	if signal_info["style"] == "text_bubble_style":
		var layout = signal_info["new_layout"]
		register_bubble_characters(layout)

func _on_dialogic_timeline_ended():
	show_world_character()
