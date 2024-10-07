extends MiniGame

@export var ddr_song:DdrSong
@export var note_preview_time:float = 3.0
@export var note_preview_distance:float = 440.0
@export var accepted_tolerance_seconds:float = 0.5

@onready var lifes: Node2D = $Lifes

@onready var ddr_columns: Dictionary = {
	DdrNote.DdrDirection.LEFT: $DdrColumnLeft,
	DdrNote.DdrDirection.DOWN: $DdrColumnDown,
	DdrNote.DdrDirection.UP: $DdrColumnUp,
	DdrNote.DdrDirection.RIGHT: $DdrColumnRight,
}

@onready var ddr_note_view_scene = preload("res://minigames/ddr/ddr_note_view.tscn")

var song_time:float = 0.0
var spawn_index:int = 0

var live_notes: Array[DdrNoteView]

func start():
	if ddr_song == null or ddr_song.notes == null:
		return
	ddr_song.play_music()
	song_time = 0.0
	spawn_index = 0
	for live_notes in live_notes:
		live_notes.queue_free()
	live_notes.clear()
	for i in lifes.get_child_count():
		var child = lifes.get_child(i)
		child.visible = true
		
	super.start()
	
func stop():
	super.stop()

func _process(delta: float) -> void:
	super._process(delta)
	if not started or not accept_inputs:
		return
		
	song_time += delta
	spawn_next_note_if_time()
	
func spawn_next_note_if_time():
	if spawn_index >= ddr_song.notes.size():
		if live_notes.size() == 0:
			trigger_win()
		return
		
	var next_note = ddr_song.notes[spawn_index]
	if next_note.time - note_preview_time <= song_time:
		_spawn_note(next_note)
		spawn_index += 1
		spawn_next_note_if_time()
		return
		
func _input(event: InputEvent) -> void:
	
	if not started or not accept_inputs:
		return
		
	if (event is InputEventKey and 
		event.is_released()):
			for accepted_key in accepted_keys:
				if event.keycode == accepted_key:
					_on_key_release(event.keycode)
					break
	
func _on_key_release(keycode:Key):
	var direction = DdrNote.DdrDirection.LEFT
	match keycode:
		KEY_LEFT:
			direction = DdrNote.DdrDirection.LEFT
		KEY_DOWN:
			direction = DdrNote.DdrDirection.DOWN
		KEY_UP:
			direction = DdrNote.DdrDirection.UP
		KEY_RIGHT:
			direction = DdrNote.DdrDirection.RIGHT
	
	var any_note_found = false
	var good_timing = false
	for note_view in live_notes:
		var note = note_view.note
		if note.direction == direction:
			var time_to_note = note.time - song_time
			var blink_color = color_error
			if time_to_note < accepted_tolerance_seconds:
				blink_color = color_success
				good_timing = true
				note_view.hit_on_time = true
			_blink(note_view, blink_color)
			_blink(note_view.get_parent().get_child(0), blink_color)
			any_note_found = true
			break
			
	if not any_note_found:
		_blink(ddr_columns[direction].get_child(0), color_error)

	#if not good_timing:
		#loose_a_life()

func miss_a_note(note_view:DdrNoteView):
	if not note_view.hit_on_time:
		loose_a_life()

func loose_a_life():
	for i in lifes.get_child_count():
		var last_visible_child_i = lifes.get_child_count() - i -1
		var last_visible_child = lifes.get_child(last_visible_child_i)
		if last_visible_child.visible:
			last_visible_child.visible = false
			break
		if last_visible_child_i == 1:
			trigger_loose()

func trigger_loose():
	MusicManager.stop_music.emit()
	await get_tree().create_timer(0.5).timeout
	super.trigger_loose()
	start()

func _blink(node:Node2D, color:Color, duration:float = 0.15):
	var tween = create_tween()
	tween.set_parallel(false)
	tween.tween_property(node,"self_modulate", color, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(node,"self_modulate", Color.WHITE, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _spawn_note(note:DdrNote):
	var column:Node2D = ddr_columns[note.direction]
	var node_view:Sprite2D = ddr_note_view_scene.instantiate()
	column.add_child(node_view)
	node_view.position = Vector2(0.0, note_preview_distance)
	#node_view.self_modulate = Color.TRANSPARENT
	node_view.note = note
	node_view.update_sprite()
	live_notes.append(node_view)
	
	var node_tween = create_tween()
	node_tween.set_parallel(true)
	#node_tween.tween_property(node_view, "self_modulate", Color.WHITE, 0.5)
	node_tween.tween_property(node_view, "position", Vector2.ZERO, note_preview_time)
	node_tween.set_parallel(false)
	node_tween.set_parallel(true)
	node_tween.tween_property(node_view, "scale", Vector2.ONE * 1.1, 0.35)
	node_tween.tween_property(node_view, "self_modulate", Color.WHITE, 0.35)
	node_tween.set_parallel(false)
	node_tween.tween_callback(live_notes.erase.bind(node_view))
	node_tween.tween_callback(miss_a_note.bind(node_view))
	node_tween.tween_callback(node_view.queue_free)
