extends StoryScene

@onready var fry_world_portrait_2d: WorldPortrait2D = $FryWorldPortrait2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ddr_mini_game: Node2D = $DdrMiniGame

func on_story_scene_ready() -> void:
	super.on_story_scene_ready()
	start_new_timeline("TruckScene1Timeline1")
	
func _on_zoom_request(args:Dictionary):
	super._on_zoom_request(args)
	
	match args["character_name"]:
		"fry_potato", "fry":
			$StoryCamera2D.tween_to_rect($FryWorldPortrait2D.position, args["zoom_level"], 1.5)
		"gran_patat", "gran_potato":
			$StoryCamera2D.tween_to_rect($GranpaWorldPortrait2D.position, args["zoom_level"], 1.5)
		"":
			$StoryCamera2D.tween_to_origin(args["zoom_level"], 1.5)
		_:
			printerr("_on_zoom_request unknown character_name '%s'" % args["character_name"])
	
func _on_start_anim(args:Dictionary):
	super._on_start_anim(args)
	if "character_name" in args and args["character_name"] != "":
		return
	var anim_name = args["anim_name"]
	
	var player = animation_player
	if not args["backwards"]:
		player.play(anim_name)
	else:
		player.play_backwards(anim_name)
			
func _on_start_mini_game(args:Dictionary):
	super._on_start_mini_game(args)
	match args["minigame_name"]:
		"DdrMiniGame":
			ddr_mini_game.start()
		"exemple":
			match args["difficulty"]:
				"easy":
					pass
				"normal":
					pass
				"hard":
					pass
			#mini_game.start()
			pass

func _on_ddr_mini_game_note_hit_in_time(note: DdrNote) -> void:
	pass # Replace with function body.
