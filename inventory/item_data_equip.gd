extends ItemData
class_name ItemDataEquip

enum Tools {none, hoe, axe, watering_can}
@export var tools_catagory: Tools

func use(target) -> void:
	target.tools = tools_catagory
