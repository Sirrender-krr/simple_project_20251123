extends Node
class_name TillingDirtComponent

@export var ground_tilemap_layer: TileMapLayer
@export var tilled_dirt_tilemap_laner: TileMapLayer
var tilled_dirt_terrain_set: int =0
var tilled_dirt_terrain: int = 0

@onready var player: Player = get_tree().get_first_node_in_group("player")


var mouse_position: Vector2
var cell_position: Vector2i #position of the cell under mouse
var cell_source_id: int #check if there is ground or none
var local_cell_positon: Vector2 #cell position in world, this one is used for distance to player
var distance: float


#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("click"):
		#get_cell_under_mouse()
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
	#
