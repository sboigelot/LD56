extends Camera2D

signal tween_completed

func tween_to_origin(duration:float = 1.0):
	tween_to_rect(Vector2.ZERO, 1.0, duration)
	
func tween_to_rect(offset:Vector2, target_zoom:int, duration:float = 1.0):
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position", offset, duration).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "zoom", Vector2.ONE * target_zoom, duration).set_trans(Tween.TRANS_QUAD)
	tween.set_parallel(false)
	tween.tween_callback(tween_completed.emit)
