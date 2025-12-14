extends Area2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var destroyed_particle: GPUParticles2D = $destroyed_particle
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var damage_component: DamageComponent = $DamageComponent

func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	destroyed_particle.emitting = false
	damage_component.max_damaged_reached.connect(on_max_damage)


func on_hurt(damage:int) -> void:
	damage_component.apply_damage(damage)


func on_max_damage() -> void:
	#sprite_2d.texture = null
	destroyed_particle.emitting = true
	await get_tree().create_timer(0.5).timeout
	queue_free()


func _on_area_entered(_area: Area2D) -> void:
	sprite_2d.material.set_shader_parameter("shake_intensity",1.0)
	await get_tree().create_timer(0.3).timeout
	sprite_2d.material.set_shader_parameter("shake_intensity",0.0)


func _on_body_entered(_body: Node2D) -> void:
	sprite_2d.material.set_shader_parameter("shake_intensity",1.0)
	await get_tree().create_timer(0.4).timeout
	sprite_2d.material.set_shader_parameter("shake_intensity",0.0)
