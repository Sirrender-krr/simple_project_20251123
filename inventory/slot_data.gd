extends Resource
class_name SlotData

#@export var MAX_STACK_SIZE: int = 10

@export var item_data: ItemData
@export var quantity: int = 1:
	set(value):
		quantity = clamp(value,1,item_data.MAX_STACK_SIZE)
		if quantity > 1 and not item_data.stackable:
			quantity = 1

func can_fully_merge_with(other_slot_data: SlotData) -> bool:
	return item_data == other_slot_data.item_data\
	and item_data.stackable\
	and quantity + other_slot_data.quantity < item_data.MAX_STACK_SIZE

func fully_merge_with(other_slot_data: SlotData) -> void:
	quantity += other_slot_data.quantity
