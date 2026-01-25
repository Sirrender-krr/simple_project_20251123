extends Node

var player: Player = null

var player_spawn_position = Vector2(159.0,152.0)
var player_inventory: InventoryData = preload("res://inventory/player_inventory.tres")

var target_scene: String = ""

func save_game(data = null) -> void:
	var save = ConfigFile.new()
	if data is Player:
		save.set_value("player","position",data.global_position)
		save.set_value("player","inventory",data.inventory_data)
	else:
		pass
	var save_path: String = "user://save.cfg"
	
	save.save(save_path)

func load_game() -> void:
	var save = ConfigFile.new()
	var load_path: String = "user://save.cfg"
	var err = save.load(load_path)
	if err != OK:
		print("No save data available.")
		return
	
	player_spawn_position = save.get_value('player','position')
	player_inventory = save.get_value('player','inventory')
