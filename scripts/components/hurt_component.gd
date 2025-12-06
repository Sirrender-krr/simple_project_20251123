extends Area2D
class_name HurtComponent

enum Tools {none, hoe, axe, watering_can}
@export var tools: Tools = Tools.none

signal hurt

func _on_area_entered(area: Area2D) -> void:
	var hit_component = area as HitComponent
	
	if tools == hit_component.current_tool:
		hurt.emit(hit_component.hit_damage)
