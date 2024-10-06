extends StoryScene

@onready var obstacles_animation_player: AnimationPlayer = $ObstaclesAnimationPlayer

func on_story_scene_ready() -> void:
	obstacles_animation_player.play("Advance")
