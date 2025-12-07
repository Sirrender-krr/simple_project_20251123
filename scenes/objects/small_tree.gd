extends Sprite2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent

@export var log: SlotData
@export_range(0.0, 1.0, 0.1) var extra_log_drop_rat:float = 0.1

var PickUp = preload("res://inventory/Pickups/pickup.tscn")

func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damage_reached)


func on_hurt(hit_damage: int) -> void:
	damage_component.apply_damage(hit_damage)
	material.set_shader_parameter("shake_intensity",0.5)
	await get_tree().create_timer(0.5).timeout
	material.set_shader_parameter("shake_intensity",0.0)

func on_max_damage_reached() -> void:
	call_deferred("add_log_scene")
	queue_free()

func add_log_scene() -> void:
	var log_instance = PickUp.instantiate()
	log_instance.slot_data = log.duplicate()
	log_instance.global_position = global_position
	get_parent().add_child(log_instance)
	randomize()
	var extra_log = randf()
	if extra_log > 1-extra_log_drop_rat:
		var extra_log_instance = PickUp.instantiate()
		extra_log_instance.slot_data = log.duplicate()
		extra_log_instance.global_position = global_position + Vector2(2,0)
		get_parent().add_child(extra_log_instance)
	else:
		pass
