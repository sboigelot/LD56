extends Node
class_name  StoryScene

@export var bubble_chararcters: Array[NodePath]

func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.text_signal.connect(_on_dialogic_text_signal)
	Dialogic.event_handled.connect(_on_dialogic_event_handled)
	Dialogic.Styles.style_changed.connect(_on_dialogic_style_changed)
	
	var layout = Dialogic.start("act1a_farm_timeline")
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
	if args is Dictionary:
		if "dialogic_command" in args:
			var dialogic_command = args["dialogic_command"]
			match  dialogic_command:
				"register_bubble_characters":
					var layout = get_node("/root/DialogicLayout_TextBubbleStyle")
					register_bubble_characters(layout)

func _on_dialogic_text_signal(text_signal_param:Variant) -> void:
	if text_signal_param == "zoom_fry":
		var zoom = 5.0
		$StoryCamera2D.tween_to_rect($FryWorldPortrait2D.position, zoom, 2.0)
	if text_signal_param == "zoom_reset":
		var zoom = 5.0
		$StoryCamera2D.tween_to_origin(2.0)

func _on_dialogic_event_handled(resource: DialogicEvent):
	pass

func _on_dialogic_style_changed(signal_info:Dictionary):
	if signal_info["style"] == "text_bubble_style":
		var layout = signal_info["new_layout"]
		register_bubble_characters(layout)
