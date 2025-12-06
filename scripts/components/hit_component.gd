extends Area2D
class_name HitComponent

var current_tool#:
	#set(x):
		#current_tool = x
		#print(current_tool)
@export var hit_damage: int = 1

func _process(delta: float) -> void:
	current_tool = get_parent().tools
