extends ItemData
class_name ItemDataConsumeable

@export var heal_value: int

func use(target) -> void:
	target.tools = target.Tools.none
	if heal_value != 0:
		target.heal(heal_value)
