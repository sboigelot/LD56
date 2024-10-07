extends StoryScene

@onready var ddr_position_marker_center:Marker2D = $DDR_Center
@onready var ddr_position_markers:Dictionary = {
	DdrNote.DdrDirection.LEFT: $DDR_Left,
	DdrNote.DdrDirection.DOWN: $DDR_Down,
	DdrNote.DdrDirection.UP: $DDR_Up,
	DdrNote.DdrDirection.RIGHT: $DDR_Right,
}

@onready var fry_world_portrait_2d: WorldPortrait2D = $FryWorldPortrait2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ddr_mini_game: Node2D = $DdrMiniGame

var ddr_cut = false

func on_story_scene_ready() -> void:
	super.on_story_scene_ready()
	start_new_timeline("TruckScene1Timeline1")
	
func _on_zoom_request(args:Dictionary):
	super._on_zoom_request(args)
	
	match args["character_name"]:
		"fry_potato", "fry":
			$StoryCamera2D.tween_to_rect($FryWorldPortrait2D.position, args["zoom_level"], 1.5)
		"crowtato":
			$StoryCamera2D.tween_to_rect($CrowtatoWorldPortrait2D.position, args["zoom_level"], 1.5)
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
	ddr_cut = !ddr_cut
	if ddr_cut:
		$PipWorldPortrait2D.sprite_2d.texture = preload("res://dialogic_data/characters/pip/pip_cutdown.png")
	else:
		$PipWorldPortrait2D.sprite_2d.texture = preload("res://dialogic_data/characters/pip/pip_cutup.png")

	$FryWorldPortrait2D.global_position = ddr_position_markers[note.direction].global_position
	var tween = create_tween()
	tween.tween_property($FryWorldPortrait2D,"global_position", ddr_position_marker_center.global_position, 0.1)


func _on_ddr_mini_game_win() -> void:
	Game.signal_to_dialogic.emit()
