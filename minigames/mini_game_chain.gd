extends Node2D

class_name MiniGameChain

var mini_game_index = -1
var current_mini_game:MiniGame

func start():
	mini_game_index = -1
	next_game()
	
func next_game():
	mini_game_index += 1
	if mini_game_index >= get_child_count():
		trigger_win()
		return
		
	current_mini_game = get_child(mini_game_index)
	if not current_mini_game.win.is_connected(_on_current_mini_game_win):
		current_mini_game.win.connect(_on_current_mini_game_win)
	current_mini_game.start()

func _on_current_mini_game_win():
	next_game()
	
func trigger_win():
	for child in get_children():
		child.stop()
