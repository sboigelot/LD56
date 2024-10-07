extends MiniGame

@export var min_delay_between_click:float = 0.2
@onready var layer_0: Sprite2D = $Node2D/Layer0
@onready var all_leafs:Array[Node2D] = [
	$Node2D/Layer1, $Node2D/Layer0, $Node2D/Layer2, $Node2D/Layer3, $Node2D/Layer4, $Node2D/Layer5, $Node2D/Layer6
]

var mouse_over_leafs:Array[Node2D]
var delay_before_next_click:float = 0.0

var leaf_base_self_modulate: Dictionary = {
	
}

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

func get_leaf_base_color(leaf:Node2D) -> Color:
	var leaf_color:Color
	if leaf in leaf_base_self_modulate:
		leaf_color = leaf_base_self_modulate[leaf]
	else:
		leaf_color = leaf.self_modulate
		leaf_base_self_modulate[leaf] = leaf_color
	return leaf_color
	
func _on_area_2d_input_event(area_2d:Area2D, viewport: Node, event: InputEvent, shape_idx: int) -> void:

	if not accept_inputs or delay_before_next_click > 0.0:
		return

	if event.is_released() and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		
		if mouse_over_leafs.size() == 0:
			return
		
		viewport.set_input_as_handled()
		var leaf:Sprite2D = mouse_over_leafs[0]
		var leaf_color:Color = get_leaf_base_color(leaf)
		
		if is_leaf_ready_to_be_picked(leaf):
			var duration = 0.1
			var tween = get_tree().create_tween()
			tween.set_parallel(false)
			tween.tween_property(leaf, "self_modulate", color_error, duration).set_trans(Tween.TRANS_QUAD)
			tween.tween_property(leaf, "self_modulate", leaf_color, duration).set_trans(Tween.TRANS_QUAD)
			return
		
		if not leaf.name in leaf_hps:
			return
			
		delay_before_next_click = min_delay_between_click
		leaf_hps[leaf.name] -= 1
		if leaf_hps[leaf.name] <= 0:
			if leaf != layer_0:
				var duration = 0.1
				var tween = get_tree().create_tween()
				tween.set_parallel(true)
				tween.tween_property(leaf, "scale", Vector2.ZERO, duration).set_trans(Tween.TRANS_EXPO)
				tween.tween_property(leaf, "self_modulate", Color.TRANSPARENT, duration).set_trans(Tween.TRANS_QUAD)
				tween.set_parallel(false)
				tween.tween_callback(mouse_over_leafs.erase.bind(leaf))
				tween.tween_callback(leaf.queue_free)
			else:
				var duration = 2.5
				var tween = get_tree().create_tween()
				tween.set_parallel(true)
				tween.tween_property(leaf, "scale", Vector2.ONE * 2.0, duration).set_trans(Tween.TRANS_BOUNCE)
				tween.tween_property(leaf, "self_modulate", Color.WHITE, duration).set_trans(Tween.TRANS_QUAD)
				tween.set_parallel(false)
				tween.tween_callback(mouse_over_leafs.erase.bind(leaf))
				tween.tween_callback(leaf.queue_free)
				accept_inputs = false
				await get_tree().create_timer(duration).timeout
				trigger_win()
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
	higlight_leaf(leaf, true)

func _on_area_2d_mouse_exited(area_2d:Area2D) -> void:
	var leaf:Sprite2D = area_2d.get_parent()
	higlight_leaf(leaf, false)

func _sort_leaf(a:Node2D, b:Node2D):
	if all_leafs.find(a) > all_leafs.find(b):
		return true
	return false

func higlight_leaf(leaf:Node2D, highlighted:bool):
	#print("higlight_leaf %s" % leaf.name)
	
	if leaf in mouse_over_leafs:
		mouse_over_leafs.erase(leaf)
			
	if highlighted:	
		mouse_over_leafs.append(leaf)
		mouse_over_leafs.sort_custom(_sort_leaf)
		
	for leaf_to_update in all_leafs:
		if (not is_instance_valid(leaf_to_update) or 
			leaf_to_update.is_queued_for_deletion()):
				if leaf_to_update in mouse_over_leafs:
					mouse_over_leafs.erase(mouse_over_leafs)
				continue
		var leaf_to_update_is_the_highlightedleaf = mouse_over_leafs.size() > 0 and mouse_over_leafs[0] == leaf_to_update
		var leaf_color:Color = get_leaf_base_color(leaf) 
		if leaf_to_update_is_the_highlightedleaf:
			leaf_to_update.self_modulate = Color.WHITE
			leaf_to_update.scale = Vector2.ONE * 1.1
		else:
			leaf_to_update.self_modulate = leaf_color
			leaf_to_update.scale = Vector2.ONE

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

func _process(delta: float) -> void:
	super._process(delta)
	delay_before_next_click = max(0.0, delay_before_next_click - delta)
