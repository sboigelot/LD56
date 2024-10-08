extends MiniGame

@export var min_delay_between_click:float = 0.2
@onready var layer_0: Sprite2D = $Node2D/Layer0
@onready var all_leaf_names:Array[String] = [
	$Node2D/Layer1.name, 
	$Node2D/Layer0.name, 
	$Node2D/Layer2.name, 
	$Node2D/Layer3.name, 
	$Node2D/Layer4.name, 
	$Node2D/Layer5.name, 
	$Node2D/Layer6.name
]

var mouse_over_leaf: Node2D
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
	
func _process(delta: float) -> void:
	super._process(delta)
	if Input.is_action_just_released("click"):
		if delay_before_next_click <= 0.0:
			delay_before_next_click = min_delay_between_click
			on_click()

	delay_before_next_click = max(0.0, delay_before_next_click - delta)

func on_click():
	if mouse_over_leaf == null or not is_instance_valid(mouse_over_leaf) or mouse_over_leaf.is_queued_for_deletion():
		mouse_over_leaf = null
		return
	
	var leaf:Sprite2D = mouse_over_leaf
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
		
	leaf_hps[leaf.name] -= 1
	if leaf_hps[leaf.name] <= 0:
		if leaf != layer_0:
			var duration = 0.1
			var tween = get_tree().create_tween()
			tween.set_parallel(true)
			tween.tween_property(leaf, "scale", Vector2.ZERO, duration).set_trans(Tween.TRANS_EXPO)
			tween.tween_property(leaf, "self_modulate", Color.TRANSPARENT, duration).set_trans(Tween.TRANS_QUAD)
			tween.set_parallel(false)
			tween.tween_callback(all_leaf_names.erase.bind(leaf.name)).set_delay(0.01)
			tween.tween_callback(leaf.queue_free)
		else:
			var duration = 2.5
			var tween = get_tree().create_tween()
			tween.set_parallel(true)
			tween.tween_property(leaf, "scale", Vector2.ONE * 2.0, duration).set_trans(Tween.TRANS_BOUNCE)
			tween.tween_property(leaf, "self_modulate", Color.WHITE, duration).set_trans(Tween.TRANS_QUAD)
			tween.set_parallel(false)
			tween.tween_callback(all_leaf_names.erase.bind(leaf.name)).set_delay(0.01)
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

func _on_area_2d_mouse_entered(area_2d:Area2D) -> void:
	var leaf:Sprite2D = area_2d.get_parent()
	higlight_leaf(leaf, true)

func _on_area_2d_mouse_exited(area_2d:Area2D) -> void:
	var leaf:Sprite2D = area_2d.get_parent()
	higlight_leaf(leaf, false)

func higlight_leaf(leaf:Node2D, highlighted:bool):
	
	if highlighted:
		return #not implemented, not needed
	
	if (mouse_over_leaf == null or 
		not is_instance_valid(mouse_over_leaf) or 
		mouse_over_leaf.is_queued_for_deletion()):
		mouse_over_leaf = null
		
	if (leaf == null or 
		not is_instance_valid(leaf) or 
		leaf.is_queued_for_deletion()):
		leaf = null
		return
		
	if mouse_over_leaf != null and leaf != mouse_over_leaf:
		var prev_leaf_index = all_leaf_names.find(mouse_over_leaf.name)
		var new_leaf_index = all_leaf_names.find(leaf.name)
		if prev_leaf_index >= new_leaf_index:
			var leaf_color:Color = get_leaf_base_color(mouse_over_leaf) 
			mouse_over_leaf.self_modulate = leaf_color
			mouse_over_leaf.scale = Vector2.ONE
			return

	mouse_over_leaf = leaf
	mouse_over_leaf.self_modulate = Color.WHITE
	mouse_over_leaf.scale = Vector2.ONE * 1.1

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
