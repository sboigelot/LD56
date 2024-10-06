@tool
extends MiniGame

@onready var layer_0: Sprite2D = $Node2D/Layer0

var leaf_hps:Dictionary = {
	"Layer0":3,
	"Layer1":10,
	"Layer2":-1,
	"Layer3":6,
	"Layer4":8,
	"Layer5":5,
	"Layer6":5,
}

func is_leaf_ready_to_be_picked(leaf:Node) -> bool:
	var index = leaf.get_index()
	var leaf_parent_count = leaf.get_parent().get_child_count()
	if ((leaf != layer_0 and index < leaf_parent_count - 1)  or 
		(leaf == layer_0 and index < leaf_parent_count - 2)):
			return true
	return false

func _on_area_2d_input_event(area_2d:Area2D, viewport: Node, event: InputEvent, shape_idx: int) -> void:

	if event.is_released() and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		viewport.set_input_as_handled()
		var leaf:Sprite2D = area_2d.get_parent()
		var leaf_color = leaf.self_modulate
		
		if is_leaf_ready_to_be_picked(leaf):
			var duration = 0.1
			var tween = get_tree().create_tween()
			tween.set_parallel(false)
			tween.tween_property(leaf, "self_modulate", color_error, duration).set_trans(Tween.TRANS_QUAD)
			tween.tween_property(leaf, "self_modulate", leaf_color, duration).set_trans(Tween.TRANS_QUAD)
			return
		
		if not leaf.name in leaf_hps:
			return
			
		leaf_hps[leaf.name] -= 1
		if leaf_hps[leaf.name] <= 0:
			var duration = 0.1
			var tween = get_tree().create_tween()
			tween.set_parallel(true)
			tween.tween_property(leaf, "scale", Vector2.ZERO, duration).set_trans(Tween.TRANS_EXPO)
			tween.tween_property(leaf, "self_modulate", Color.TRANSPARENT, duration).set_trans(Tween.TRANS_QUAD)
			tween.set_parallel(false)
			tween.tween_callback(leaf.queue_free)
			if leaf == layer_0:
				await get_tree().create_timer(duration).timeout
				win.emit()
		else:
			var duration = 0.1
			var tween = get_tree().create_tween()
			tween.set_parallel(true)
			tween.tween_property(leaf, "rotation_degrees", randf_range(-5.0,5.0), duration).set_trans(Tween.TRANS_QUAD)
			tween.tween_property(leaf, "skew", randf_range(-0.1,0.1), duration).set_trans(Tween.TRANS_QUAD)
			tween.tween_property(leaf, "self_modulate", color_success, duration).set_trans(Tween.TRANS_QUAD)
			tween.set_parallel(false)
			tween.tween_property(leaf, "self_modulate", leaf_color, duration).set_trans(Tween.TRANS_QUAD)

func _on_area_2d_6_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	_on_area_2d_input_event($Node2D/Layer6/Area2D6, viewport, event, shape_idx)

func _on_area_2d_5_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	_on_area_2d_input_event($Node2D/Layer5/Area2D5, viewport, event, shape_idx)
	
func _on_area_2d_4_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	_on_area_2d_input_event($Node2D/Layer4/Area2D4, viewport, event, shape_idx)

func _on_area_2d_3_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	_on_area_2d_input_event($Node2D/Layer3/Area2D3, viewport, event, shape_idx)

func _on_area_2d_0_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	_on_area_2d_input_event($Node2D/Layer0/Area2D0, viewport, event, shape_idx)

func _on_area_2d_1_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	_on_area_2d_input_event($Node2D/Layer1/Area2D1, viewport, event, shape_idx)

func _on_area_2d_mouse_entered(area_2d:Area2D) -> void:
	var leaf:Sprite2D = area_2d.get_parent()
	var duration = 0.1
	var tween = get_tree().create_tween()
	tween.tween_property(leaf, "scale", Vector2.ONE * 1.1, duration).set_trans(Tween.TRANS_EXPO)

func _on_area_2d_mouse_exited(area_2d:Area2D) -> void:
	var leaf:Sprite2D = area_2d.get_parent()
	var duration = 0.1
	var tween = get_tree().create_tween()
	tween.tween_property(leaf, "scale", Vector2.ONE, duration).set_trans(Tween.TRANS_EXPO)

func _on_area_2d_1_mouse_entered() -> void:
	_on_area_2d_mouse_entered($Node2D/Layer1/Area2D1)

func _on_area_2d_1_mouse_exited() -> void:
	_on_area_2d_mouse_exited($Node2D/Layer1/Area2D1)

func _on_area_2d_0_mouse_entered() -> void:
	_on_area_2d_mouse_entered($Node2D/Layer0/Area2D0)

func _on_area_2d_0_mouse_exited() -> void:
	_on_area_2d_mouse_exited($Node2D/Layer0/Area2D0)

func _on_area_2d_3_mouse_entered() -> void:
	_on_area_2d_mouse_entered($Node2D/Layer3/Area2D3)

func _on_area_2d_3_mouse_exited() -> void:
	_on_area_2d_mouse_exited($Node2D/Layer3/Area2D3)

func _on_area_2d_4_mouse_entered() -> void:
	_on_area_2d_mouse_entered($Node2D/Layer4/Area2D4)

func _on_area_2d_4_mouse_exited() -> void:
	_on_area_2d_mouse_exited($Node2D/Layer4/Area2D4)

func _on_area_2d_5_mouse_entered() -> void:
	_on_area_2d_mouse_entered($Node2D/Layer5/Area2D5)

func _on_area_2d_5_mouse_exited() -> void:
	_on_area_2d_mouse_exited($Node2D/Layer5/Area2D5)

func _on_area_2d_6_mouse_entered() -> void:
	_on_area_2d_mouse_entered($Node2D/Layer6/Area2D6)

func _on_area_2d_6_mouse_exited() -> void:
	_on_area_2d_mouse_exited($Node2D/Layer6/Area2D6)
