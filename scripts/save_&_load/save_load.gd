extends Node

func _on_save_button_pressed() -> void:
	var save_file = Serializer.new()
	save_file.player.player_position = %Player.global_position
	
	save_file.save_data()


func _on_load_button_pressed() -> void:
	var save_file = Serializer.new()
	save_file.load_data()
	%Player.global_position = save_file.player.player_position
