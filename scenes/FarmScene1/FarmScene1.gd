extends StoryScene

@onready var fry_world_portrait_2d: WorldPortrait2D = $FryWorldPortrait2D
@onready var time_hit_mini_game: MiniGame = $TimeHitMiniGame
@onready var wiggle_keys_mini_game: MiniGame = $WiggleKeysMiniGame
@onready var soda_cap_reaveal_mini_game: Node2D = $SodaCapReavealMiniGame
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func on_story_scene_ready() -> void:
	super.on_story_scene_ready()
	start_new_timeline("FarmScene1Timeline1")

func _handle_timeline_signal(args:Dictionary):
	super._handle_timeline_signal(args)
	if not "action" in args:
		return
		
	var action = args["action"]
	match action:
		"start_mini_game":
			_on_start_mini_game(args)
			
		"start_anim":
			if "character_name" in args and args["character_name"] != "":
				return	
			var anim_name = args["anim_name"]
			if not args["backwards"]:
				animation_player.play(anim_name)
			else:
				animation_player.play_backwards(anim_name)
			
func _on_start_mini_game(args:Dictionary):
	match args["minigame_name"]:
		"SodaCapMG":
			soda_cap_reaveal_mini_game.start()
			
		"wiggle_keys_mini_game", "wiggle":
			match args["difficulty"]:
				"easy":
					wiggle_keys_mini_game.target_hit_count = 10
				"normal":
					wiggle_keys_mini_game.target_hit_count = 15
				"hard":
					wiggle_keys_mini_game.target_hit_count = 20
			wiggle_keys_mini_game.start()
			
		"time_hit_mini_game":
			match args["difficulty"]:
				"easy":
					time_hit_mini_game.target_revolution_size = 0.3
					time_hit_mini_game.spin_revolution_per_second = 0.5
				"normal":
					time_hit_mini_game.target_revolution_size = 0.3
					time_hit_mini_game.spin_revolution_per_second = 0.75
				"hard":
					time_hit_mini_game.target_revolution_size = 0.2
					time_hit_mini_game.spin_revolution_per_second = 0.75
			time_hit_mini_game.start()

func _on_wiggle_keys_mini_game_win() -> void:
	wiggle_keys_mini_game.stop()
	Game.signal_to_dialogic.emit()
	
func _on_time_hit_mini_game_win() -> void:
	time_hit_mini_game.stop()
	Game.signal_to_dialogic.emit()

func _on_wiggle_keys_mini_game_flip(left: bool) -> void:
	fry_world_portrait_2d.flip_h = left

func _on_soda_cap_reaveal_mini_game_win() -> void:
	Game.signal_to_dialogic.emit()
