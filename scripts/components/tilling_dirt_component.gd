extends Node
class_name TillingDirtComponent

@onready var player: Player = get_tree().get_first_node_in_group("player")


@export var ground_tilemap_layer: TileMapLayer
@export var tilled_dirt_tilemap_layer: TileMapLayer
@export var player_radius: int = 25

enum dir {left, right, up, down}
var direction

var tilled_dirt_terrain_set: int = 0
var tilled_dirt_terrain: int = 0
var mouse_position: Vector2
var cell_position: Vector2i #position of the cell under mouse
var cell_source_id: int #check if there is ground or none
var local_cell_positon: Vector2 #cell position in world, this one is used for distance to player
var distance: float


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("right_click"):
		#get_cell_under_mouse()
		remove_tilled_dirt_cell()
#
#
#
#func get_cell_under_mouse() -> void:
	#mouse_position = ground_tilemap_layer.get_local_mouse_position()
	#cell_position = ground_tilemap_layer.local_to_map(mouse_position)
	#cell_source_id = ground_tilemap_layer.get_cell_source_id(cell_position)
	#local_cell_positon = ground_tilemap_layer.map_to_local(cell_position)
	#distance = player.global_position.distance_to(local_cell_positon)
	#print(
		#"\nmouse_postion: ", mouse_position,
		#"\ncell_postion: ", cell_position,
		#"\ncell_source_id: ", cell_source_id,
		#"\ndistance: ", distance
	#)

func _ready() -> void:
	player.tilling.connect(add_tilled_dirt_cell)

func add_tilled_dirt_cell() -> void:
	direction = player.direction
	mouse_position = ground_tilemap_layer.get_local_mouse_position()
	cell_position = ground_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = ground_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_positon = ground_tilemap_layer.map_to_local(cell_position)
	distance = player.global_position.distance_to(local_cell_positon)
	
	var player_grid = ground_tilemap_layer.local_to_map(player.global_position)
	var tilled_pos:Array = []
	match direction:
		dir.left:
			tilled_pos = [Vector2i(player_grid.x-1,cell_position.y)]
		dir.right:
			tilled_pos = [Vector2i(player_grid.x+1,cell_position.y)]
		dir.up:
			tilled_pos = [Vector2i(cell_position.x, player_grid.y-1)]
		dir.down:
			tilled_pos = [Vector2i(cell_position.x, player_grid.y+1)]
	
	if distance <= player_radius and player.tools == 1 and cell_source_id != -1:
		tilled_dirt_tilemap_layer.set_cells_terrain_connect(tilled_pos,tilled_dirt_terrain_set,tilled_dirt_terrain)

func remove_tilled_dirt_cell() -> void:
	var player_grid = ground_tilemap_layer.local_to_map(player.global_position)
	var tilled_pos:Array = []
	match direction:
		dir.left:
			tilled_pos = [Vector2i(player_grid.x-1,cell_position.y)]
		dir.right:
			tilled_pos = [Vector2i(player_grid.x+1,cell_position.y)]
		dir.up:
			tilled_pos = [Vector2i(cell_position.x, player_grid.y-1)]
		dir.down:
			tilled_pos = [Vector2i(cell_position.x, player_grid.y+1)]
	if distance <= player_radius and player.tools == 1 and cell_source_id != -1:
		tilled_dirt_tilemap_layer.set_cells_terrain_connect(tilled_pos,0,-1)
