extends CanvasLayer

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var gain: Button = $Gain
@onready var loss: Button = $loss
@export var COIN: SlotData
var coins:
	set(value):
		coins = value
		print(coins)

var inventory: InventoryData

func _ready() -> void:
	find_money()

func gain_money() -> void:
	inventory = player.inventory_data as InventoryData
	var coin = COIN.duplicate() as SlotData
	coin.quantity = 0
	var slots = inventory.slot_datas
	for i in slots:
		if i.item_data is ItemDataCoin:
			i.quantity += 1
			find_money()
			inventory.inventory_updated.emit(inventory)
			return
		else:
			for index in range(slots.size()):
				if !slots[index]:
					slots[index] = coin

func loss_money() -> void:
	inventory = player.inventory_data as InventoryData
	var slots = inventory.slot_datas
	for i in slots:
		if i.item_data is ItemDataCoin:
			i.quantity -= 1
			find_money()
			inventory.inventory_updated.emit(inventory)
			return
		else:
			for index in range(slots.size()):
				if !slots[index]:
					return


func find_money() -> void:
	inventory = player.inventory_data
	for i in inventory.slot_datas:
		if i.item_data is ItemDataCoin:
			coins = i.quantity


func _on_gain_pressed() -> void:
	gain_money()


func _on_loss_pressed() -> void:
	loss_money()
