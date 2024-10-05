extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.text_signal.connect(_on_dialogic_text_signal)
	var layout = Dialogic.start("act1a_farm_timeline")
	register_bubble_characters(layout)

func register_bubble_characters(layout):
	layout.register_character("res://dialogic_data/characters/fry/fry_potato.dch", $FryWorldPortrait2D)

func _process(delta: float) -> void:
	pass

func _on_dialogic_signal(args:Variant):
	pass
	
func _on_dialogic_text_signal(text_signal_param:Variant) -> void:
	if text_signal_param == "zoom_fry":
		var zoom = 5.0
		$StoryCamera2D.tween_to_rect($FryWorldPortrait2D.position, zoom, 3.0)
	
