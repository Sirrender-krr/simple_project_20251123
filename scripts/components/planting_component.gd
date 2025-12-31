extends Node
class_name PlantingComponent

@onready var player: Player = get_tree().get_first_node_in_group("player")


@export var ground_tilemap_layer: TileMapLayer
@export var tilled_dirt_tilemap_layer: TileMapLayer
@export var player_radius: int = 25

enum dir {left, right, up, down}
var direction

var mouse_position: Vector2
var cell_position: Vector2i #position of the cell under mouse
var cell_source_id: int #check if there is ground or none
var local_cell_positon: Vector2 #cell position in world, this one is used for distance to player
var distance: float

var Corn = preload("res://scenes/objects/corn.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		planting_crop()


func get_cell_under_mouse() -> void:
	mouse_position = ground_tilemap_layer.get_local_mouse_position()
	cell_position = ground_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = tilled_dirt_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_positon = ground_tilemap_layer.map_to_local(cell_position)
	distance = player.global_position.distance_to(local_cell_positon)



func planting_crop() -> void:
	direction = player.direction
	get_cell_under_mouse()
	
	var player_grid = ground_tilemap_layer.local_to_map(player.global_position)
	var plant_pos: Vector2
	plant_pos = planting_dir(player_grid,cell_position)
	
	if distance <= player_radius and player.tools == 4 and cell_source_id != -1:
		var plant_crop = player.seed_in_hand.instantiate() as Node2D
		#var plant_crop = Corn.instantiate() as Node2D
		plant_crop.global_position = plant_pos
		if !PlacingManager.is_tile_occupied(plant_crop.global_position):
			get_parent().add_child(plant_crop)
			PlacingManager.attemp_placement(plant_crop.global_position)
		else:
			pass
		
	elif distance > player_radius and player.tools == 4 and cell_source_id != -1:
		var plant_crop = player.seed_in_hand.instantiate() as Node2D
		#var plant_crop = Corn.instantiate() as Node2D
		plant_crop.global_position = plant_pos
		if !PlacingManager.is_tile_occupied(plant_crop.global_position):
			get_parent().add_child(plant_crop)
			PlacingManager.attemp_placement(plant_crop.global_position)
		else:
			pass


#func remove_tilled_dirt_cell() -> void:
	#direction = player.direction
	#get_cell_under_mouse()
	#var player_grid = ground_tilemap_layer.local_to_map(player.global_position)
	#var plant_pos:Array = []
	#plant_pos = tilling_dir(player_grid,cell_position)
	#if distance <= player_radius and player.tools == 1 and cell_source_id != -1:
		#tilled_dirt_tilemap_layer.set_cells_terrain_connect(plant_pos,0,-1)
	#elif distance > player_radius and player.tools == 1 and cell_source_id != -1:
		#tilled_dirt_tilemap_layer.set_cells_terrain_connect(plant_pos,0,-1)

func planting_dir(player_grid, position) -> Vector2:
	var plant_pos: Vector2i
	if distance > player_radius:
		match direction:
			dir.left:
				plant_pos = Vector2i(player_grid.x-1,player_grid.y)
			dir.right:
				plant_pos = Vector2i(player_grid.x+1,player_grid.y)
			dir.up:
				plant_pos = Vector2i(player_grid.x,player_grid.y-1)
			dir.down:
				plant_pos = Vector2i(player_grid.x,player_grid.y+1)
		return ground_tilemap_layer.map_to_local(plant_pos)
	else:
		match direction:
			dir.left:
				if position.x >player_grid.x:
					plant_pos = Vector2i(player_grid.x,position.y)
				else:
					plant_pos = position
			dir.right:
				if position.x < player_grid.x:
					plant_pos = Vector2i(player_grid.x,position.y)
				else:
					plant_pos = position
			dir.up:
				if position.y >player_grid.y:
					plant_pos = Vector2i(position.x,player_grid.y)
				else:
					plant_pos = position
			dir.down:
				if position.y <player_grid.y:
					plant_pos = Vector2i(position.x,player_grid.y)
				else:
					plant_pos = position
		return ground_tilemap_layer.map_to_local(plant_pos)

func to_grid(position:Vector2) -> Vector2:
	var return_val = ground_tilemap_layer.local_to_map(position)
	return ground_tilemap_layer.map_to_local(return_val)
