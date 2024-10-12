extends StoryScene



func on_story_scene_ready():
	super.on_story_scene_ready()
	Dialogic.start_timeline("promo_scene_1_timeline")
	if Dialogic.Inputs.auto_advance == null:
		Dialogic.Inputs.auto_advance = DialogicAutoAdvance.new()
	Dialogic.Inputs.auto_advance.enabled_until_user_input = true
	Dialogic.Inputs.auto_advance.fixed_delay = 0.5
	Dialogic.Inputs.auto_advance.per_word_delay = 0.2
	Dialogic.Inputs.auto_advance.per_character_delay = 0.0

func _on_zoom_request(args:Dictionary):
	super._on_zoom_request(args)
	
	match args["character_name"]:
		"crowtato":
			$StoryCamera2D.tween_to_rect($ZoomMarker2D.position, args["zoom_level"], 1.0)
			await get_tree().create_timer(1.0).timeout
			Game.signal_to_dialogic.emit()
	

func _on_start_anim(args:Dictionary):
	super._on_start_anim(args)
	if "character_name" in args and args["character_name"] != "":
		return
	var anim_name = args["anim_name"]
	
	if not args["backwards"]:
		$AnimationPlayer.play(anim_name)
	else:
		$AnimationPlayer.play_backwards(anim_name)
			
