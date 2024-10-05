@icon("res://addons/event_audio/icons/RandomNumberGenerator.svg")
extends Node2D

class_name WorldPortrait2D

@export var dialogic_character_name: String = "fry_potato"
@export_file("*.dch") var dialogic_character_path: String = "res://dialogic_data/characters/fry/fry_potato.dch"
@export var texture:Texture2D 
@export var flip_h:bool 

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite_2d.texture = texture
	sprite_2d.flip_h = flip_h
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.text_signal.connect(_on_dialogic_text_signal)
	Dialogic.event_handled.connect(_on_dialogic_event_handled)
	
func _on_dialogic_signal(args:Variant):
	pass
	
func _on_dialogic_text_signal(arg:Variant) -> void:
	pass
	
func _on_dialogic_event_handled(resource:DialogicEvent) -> void:
	
	if resource is DialogicTextEvent:
		var text_event:DialogicTextEvent = resource
		if text_event.character_identifier == dialogic_character_name:
			var portrait = text_event.portrait
			var portrait_info = text_event.character.get_portrait_info(portrait)
			var portrait_image = portrait_info["export_overrides"]["image"]
			if "smile" in portrait_image:
				sprite_2d.texture = load("res://dialogic_data/characters/fry/fry_potato_smile.png")
			if "pain" in portrait_image:
				sprite_2d.texture = load("res://dialogic_data/characters/fry/fry_potato_pain.png")
			if "uwu" in portrait_image:
				sprite_2d.texture = load("res://dialogic_data/characters/fry/fry_potato_uwu.png")
			sprite_2d.flip_h = flip_h
			#var texture = ResourceLoader.load(image)
			#print(image)
			#print(image == "res://dialogic_data/characters/fry/fry_potato_smile.png")
			#sprite_2d.texture = load(image)
									# "res://dialogic_data/characters/fry/fry_potato_uwu.png"
			#sprite_2d.texture = load("res://dialogic_data/characters/fry/fry_potato_uwu.png")

func get_bubble_marker_2d()->Node:
	return $BubbleMarker2D
