extends ItemData
class_name ItemDataSeed

@export var scene: PackedScene


func use(target) -> void:
	target.tools = 4 #seed tool
	target.seed_in_hand = scene
