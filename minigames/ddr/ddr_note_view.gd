extends Sprite2D
class_name DdrNoteView

@export var note:DdrNote
var hit_on_time:bool = false

func update_sprite():
	match note.direction:
		DdrNote.DdrDirection.LEFT:
			texture = preload("res://minigames/ddr/icons/ddr_right_full.png")
			flip_h = true
		DdrNote.DdrDirection.DOWN:
			texture = preload("res://minigames/ddr/icons/ddr_up_full.png")
			flip_v = true
		DdrNote.DdrDirection.UP:
			texture = preload("res://minigames/ddr/icons/ddr_up_full.png")
		DdrNote.DdrDirection.RIGHT:
			texture = preload("res://minigames/ddr/icons/ddr_right_full.png")
