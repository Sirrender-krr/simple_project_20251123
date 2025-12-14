extends Sprite2D
class_name InteractableObject

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent
@onready var particles: GPUParticles2D = $Particles
@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D


@export var Log: SlotData
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

func enable_particle() -> void:
	particles.emitting = true

func on_max_damage_reached() -> void:
	call_deferred("add_log_scene")
	texture = null
	collision_shape_2d.queue_free()
	particles.emitting = true
	await get_tree().create_timer(0.5).timeout
	queue_free()

func add_log_scene() -> void:
	var log_instance = PickUp.instantiate()
	log_instance.slot_data = Log.duplicate()
	log_instance.global_position = global_position
	get_parent().add_child(log_instance)
	randomize()
	var extra_log = randf()
	if extra_log > 1-extra_log_drop_rat:
		var extra_log_instance = PickUp.instantiate()
		extra_log_instance.slot_data = Log.duplicate()
		extra_log_instance.global_position = global_position + Vector2(2,2)
		get_parent().add_child(extra_log_instance)
	else:
		pass
