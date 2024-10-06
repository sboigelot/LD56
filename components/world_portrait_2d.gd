@icon("res://addons/event_audio/icons/RandomNumberGenerator.svg")
extends Node2D

class_name WorldPortrait2D

@export var dialogic_character_name: String = "fry_potato"
@export_file("*.dch") var dialogic_character_path: String = "res://dialogic_data/characters/fry/fry_potato.dch"
@export var texture:Texture2D 
@export var flip_h:bool 

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var valid_texture_paths: Array[String] = [
	"res://dialogic_data/characters/fry/fry_potato_smile.png",
	"res://dialogic_data/characters/fry/fry_potato_pain.png",
	"res://dialogic_data/characters/fry/fry_potato_uwu.png",
	"res://dialogic_data/characters/gran_potato/granpatato_smile.png",
]

func _ready() -> void:
	sprite_2d.texture = texture
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.text_signal.connect(_on_dialogic_text_signal)
	Dialogic.event_handled.connect(_on_dialogic_event_handled)

func _process(delta: float) -> void:
	sprite_2d.flip_h = flip_h

func _on_dialogic_signal(args:Variant):
	if args is Dictionary:
		if "character_name" in args:
			if args["character_name"] == dialogic_character_name:
				_handle_timeline_signal(args)
	
func _handle_timeline_signal(args:Dictionary):
	if not "action" in args:
		return
		
	var action = args["action"]
	match action:
		"start_anim":
			var anim_name = args["anim_name"]
			$AnimationPlayer.play(anim_name)
	
func _on_dialogic_text_signal(arg:Variant) -> void:
	pass
	
func _on_dialogic_event_handled(resource:DialogicEvent) -> void:
	
	if resource is DialogicTextEvent:
		var text_event:DialogicTextEvent = resource
		if text_event.character_identifier == dialogic_character_name:
			var portrait = text_event.portrait
			var portrait_info = text_event.character.get_portrait_info(portrait)
			var portrait_image = portrait_info["export_overrides"]["image"]
			sprite_2d.flip_h = flip_h
#			TODO read flip_h from portrait_info?
			for valid_texture_path in valid_texture_paths:
				if valid_texture_path in portrait:
					sprite_2d.texture = load(valid_texture_path)
					break
			#if "res://dialogic_data/characters/fry/fry_potato_smile.png" in portrait_image:
				#sprite_2d.texture = load("res://dialogic_data/characters/fry/fry_potato_smile.png")
			#if "fry/fry_potato_pain" in portrait_image:
				#sprite_2d.texture = load("res://dialogic_data/characters/fry/fry_potato_pain.png")
			#if "fry/fry_potato_uwu" in portrait_image:
				#sprite_2d.texture = load("res://dialogic_data/characters/fry/fry_potato_uwu.png")
			
			#var texture = ResourceLoader.load(image)
			#print(image)
			#print(image == "res://dialogic_data/characters/fry/fry_potato_smile.png")
			#sprite_2d.texture = load(image)
									# "res://dialogic_data/characters/fry/fry_potato_uwu.png"
			#sprite_2d.texture = load("res://dialogic_data/characters/fry/fry_potato_uwu.png")

func get_bubble_marker_2d()->Node:
	return $BubbleMarker2D
