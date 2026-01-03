extends Node

var player

var current_hot_bar_index: int

func use_slot_data(slot_data: SlotData) -> void:
	slot_data.item_data.use(player)

func empty_hand() -> void:
	player.tools = 0 #tools none
