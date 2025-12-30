extends Node2D

var Pickup = preload("res://inventory/Pickups/pickup.tscn")
@export var harvest_resource: SlotData
@export var growth_interval:int
@export var harvest_amount:int

## For the same sprite sheet to start at a different frame
@export var sprite_offset: int

@onready var watering_particle: GPUParticles2D = $WateringParticle
@onready var flowering_particle: GPUParticles2D = $FloweringParticle
@onready var hurt_component: HurtComponent = $HurtComponent
@onready var growing_timer: Timer = $growing_timer
@onready var sprite_2d: Sprite2D = $Sprite2D

var is_watered: bool= false:
	set(tf):
		is_watered = tf
		if is_watered == true:
			growing_timer.start()
var crop_state:int:
	set(frame):
		crop_state = clamp(frame,1,5)
		sprite_2d.frame = crop_state + sprite_offset

enum state{
	seed,
	germination,
	vegatiative,
	repriduction,
	maturity,
	harvesting
}

func _ready() -> void:
	crop_state = state.germination
	sprite_2d.frame = crop_state + sprite_offset
	watering_particle.emitting = false
	flowering_particle.emitting = false
	growing_timer.wait_time = growth_interval
	hurt_component.hurt.connect(on_hurt)


func on_hurt(_hit_damage:int) -> void:
	if crop_state == state.maturity:
		return
	
	if is_watered == false:
		is_watered = true
		watering_particle.emitting =true
	else:
		pass


func _on_growing_timer_timeout() -> void:
	crop_state += 1
	is_watered = false
	
	if crop_state == state.maturity:
		flowering_particle.emitting = true
	#if crop_state == state.harvesting:
		#var rep_count = 0
		#var pos = global_position
		#for item in harvest_amount:
			#var harvest = Pickup.instantiate()
			#harvest.slot_data = harvest_resource.duplicate()
			#var variant = pow(-1.0,rep_count)*rep_count * 3
			#harvest.global_position = Vector2((pos.x + variant),pos.y)
			#get_parent().add_child(harvest)
			#rep_count +=1
		#queue_free()

func _on_crop_spawn_body_entered(body: Player) -> void:
	if crop_state == state.maturity and body is Player:
		var rep_count = 0
		var pos = global_position
		for item in harvest_amount:
			var crops = Pickup.instantiate()
			crops.slot_data = harvest_resource.duplicate()
			var variant = pow(-1.0,rep_count)*rep_count * 3
			crops.global_position = Vector2((pos.x + variant),pos.y)
			get_parent().add_child(crops)
			rep_count +=1
		PlayerManager.immune.emit()
		queue_free()
