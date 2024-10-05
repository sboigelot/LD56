extends Control

func _ready() -> void:
	SceneTransitionManager.transition_scene_in(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
