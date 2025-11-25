extends Resource
class_name SlotData

#@export var MAX_STACK_SIZE: int = 10

@export var item_data: ItemData
@export var quantity: int = 1:
	set(value):
		quantity = clamp(value,1,item_data.MAX_STACK_SIZE)
		if quantity > 1 and not item_data.stackable:
			quantity = 1
