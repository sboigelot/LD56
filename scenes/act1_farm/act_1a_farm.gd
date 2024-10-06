extends StoryScene

@onready var fry_world_portrait_2d: WorldPortrait2D = $FryWorldPortrait2D
@onready var time_hit_mini_game: Control = $TimeHitMiniGame

func _on_dialogic_signal(args:Variant):
	super._on_dialogic_signal(args)
	if args is Dictionary and "action" in args:
		match args["action"]:
			"start_mini_game":
				_on_start_mini_game(args)

func _on_start_mini_game(args:Dictionary):
	match args["minigame_name"]:
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

func _on_time_hit_mini_game_win() -> void:
	time_hit_mini_game.stop()
	Game.signal_to_dialogic.emit()
