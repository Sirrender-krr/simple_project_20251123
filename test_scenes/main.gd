extends Node2D

const PickUp = preload("res://inventory/Pickups/pickup.tscn")


@onready var player: Player = $Player
@onready var inventory_interface: Control = $CanvasLayer/InventoryInterface
@onready var hot_bar_inventory: PanelContainer = $CanvasLayer/HotBarInventory

func _ready() -> void:
	player.toggle_inventory.connect(toggle_inventory_interface)
	inventory_interface.set_player_inventory_data(player.inventory_data)
	inventory_interface.drop_slot_data.connect(_on_inventory_interface_drop_slot_data)
	hot_bar_inventory.set_inventory_data(player.inventory_data)
	
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(toggle_inventory_interface)


func toggle_inventory_interface(external_inventory_owner = null) -> void:
	inventory_interface.visible = not inventory_interface.visible
	
	if inventory_interface.visible:
		hot_bar_inventory.hide()
		inventory_interface.set_anchors_preset(Control.PRESET_FULL_RECT)
		
	else:
		hot_bar_inventory.show()
		inventory_interface.set_anchors_preset(Control.PRESET_TOP_LEFT)
	
	if external_inventory_owner:
		inventory_interface.set_external_inventory(external_inventory_owner)
	else:
		inventory_interface.clear_external_inventory()

func _on_inventory_interface_drop_slot_data(slot_data: SlotData) -> void:
	var pick_up = PickUp.instantiate()
	pick_up.slot_data = slot_data
	pick_up.position = position_in_radius()
	add_child(pick_up)

##calculate drop position
func position_in_radius() -> Vector2:
	var radius = 30
	var mouse_pos = get_global_mouse_position()
	var direction_vector = mouse_pos - player.global_position
	var normal_dir = direction_vector.normalized()
	var return_position = player.global_position + (normal_dir * radius)
	
	var dis = normal_dir * radius
	var distance = dis.length()
	
	if direction_vector.length() < distance:
		return mouse_pos
	else:
		return return_position
	
