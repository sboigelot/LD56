extends StoryScene

@onready var obstacles_animation_player: AnimationPlayer = $ObstaclesAnimationPlayer

func on_story_scene_ready() -> void:
	$FailSplash.visible = false
	$CrowAndPotaotes.started = false
	Dialogic.start_timeline("FlyScene1Timeline1")
	
func _on_start_anim(args:Dictionary):
	super._on_start_anim(args)
	if "character_name" in args and args["character_name"] != "":
		return
	var anim_name = args["anim_name"]
	obstacles_animation_player.play(anim_name)
	
func _on_crow_and_potaotes_area_entered(area: Area2D) -> void:
	trigger_loose()
	
func trigger_loose():
	$CrowAndPotaotes.controllable = false
	$CrowAndPotaotes.set_deferred("monitoring", false)
	$CrowAndPotaotes.set_deferred("monitorable", false)

	$FailSplash.scale = Vector2.ZERO
	$FailSplash.visible = true
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($FailSplash, "scale", Vector2.ONE * 20.0, 1.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property($CrowAndPotaotes, "rotation_degrees", 360, 1.5)
	tween.set_parallel(false)
	tween.tween_callback(SceneManager.reload_current_scene)

func _on_obstacles_animation_player_animation_finished(anim_name: StringName) -> void:
	SceneTransitionManager.transition_scene_to_file(
		"res://scenes/TruckScene1/TruckScene1.tscn", 
		SceneTransitionManager.TRANSITIONS.RADIAL_TO_BLACK,
		SceneTransitionManager.TRANSITIONS.FADE_TO_BLACK)
