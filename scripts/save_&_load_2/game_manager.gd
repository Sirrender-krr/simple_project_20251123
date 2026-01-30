extends Node

var player: Player = null

var player_spawn_position = Vector2(159.0,152.0)
var player_inventory: InventoryData = preload("res://inventory/player_inventory.tres")

## an emty inventory of 8 slots
var default_inventory: InventoryData = preload("res://inventory/default_inventory.tres")

var target_scene: String = ""

func get_random_path() -> String:
	var random_id = randi_range(0,99999999)
	return "user://item_" + str(random_id) +".tres"

func save_duplicate(original:Resource):
	var copy = original.duplicate()
	var path = get_random_path()
	var error = ResourceSaver.save(copy,path)
	
	if error == OK:
		copy.resource_path = path
		return copy

func save_game(data = null) -> void:
	var save = ConfigFile.new()
	var slot = data.inventory_data.slot_datas
	var save_slot = {}
	if data is Player:
		save.set_value("player","position",data.global_position)

		
		for item in range(slot.size()):
			if slot[item]:
				save_slot[item] = slot[item].resource_path
				
		save.set_value("inventory","item",save_slot)

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
	#player_inventory = save.get_value('player','inventory')
	var inv_paths = save.get_value("inventory","item")
	print(inv_paths)
	player_inventory = default_inventory
	player_inventory.inventory_updated.emit(player_inventory)
	for path in inv_paths:
		player_inventory.slot_datas[path] = load(inv_paths[path])
