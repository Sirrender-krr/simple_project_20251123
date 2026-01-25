extends Node

func _on_save_button_pressed() -> void:
	## Method 1
	#var save_file = Serializer.new()
	#save_file.player.player_position = %Player.global_position
	#save_file.inventory = %Player.inventory_data.duplicate()
	#save_file.save_data()
	
	## Method 2
	GameManager.save_game(GameManager.player)


func _on_load_button_pressed() -> void:
	## Method 1
	#var save_file = Serializer.new()
	#save_file.load_data()
	#%Player.global_position = save_file.player.player_position
	#%Player.inventory_data = save_file.inventory
	load_game()

func load_game() -> void:
	GameManager.load_game()
	var world_scene = "res://test_scenes/test_scene_save_load.tscn"
	var loadingScreen = load("res://scripts/save_&_load_2/loading_screen.tscn")
	GameManager.target_scene = world_scene
	get_tree().change_scene_to_packed(loadingScreen)
