extends Node

var ground_tile: TileMapLayer

var occupied_tiles: Dictionary = {}

#func _ready() -> void:
	#call_deferred('print_first_time')

func return_in_grid(location:Vector2) -> Vector2i:
	var return_val: Vector2i = ground_tile.local_to_map(location)
	return return_val

func return_center_grid(location:Vector2i) -> Vector2:
	var return_val: Vector2 = ground_tile.map_to_local(location)
	return return_val

func is_tile_occupied(location: Vector2) -> bool:
	var tile_coord: Vector2i = return_in_grid(location)
	if occupied_tiles.has(tile_coord):
		print(tile_coord,' is occupied')
	return occupied_tiles.has(tile_coord)

func attemp_placement(location:Vector2) -> void:
	var tile_coord: Vector2i = return_in_grid(location)

	occupied_tiles[tile_coord] = return_center_grid(tile_coord)
	#print("Place successfully at: ", tile_coord)


func remove_placeable(location: Vector2) -> void:
	var tile_coord: Vector2i = return_in_grid(location)
	
	if occupied_tiles.has(tile_coord):
		occupied_tiles.erase(tile_coord)
		#print("Tile ",tile_coord," is free")
	else:
		print("Error: noting to remove here")

#func print_first_time() -> void:
	#print(occupied_tiles)
