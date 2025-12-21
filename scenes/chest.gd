extends StaticBody2D

signal toggle_inventory(external_inventory_owner)
signal chest_broke(external_inventory_owner, pos)

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent

@export var chest_icon: SlotData
@export var inv_data:InventoryData

var inventory_data: InventoryData

var PickUp = preload("res://inventory/Pickups/pickup.tscn")

var chest_open:bool = false:
	set(x):
		chest_open = x
		handle_animation()
var inv_open:bool = false:
	set(x):
		inv_open = x
		if not inv_open and chest_open == true: #press "inv" to close chest
			open_chest()

func _ready() -> void:
	inventory_data = inv_data.duplicate()
	animated_sprite.frame = 0
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damage)
	animated_sprite.material.set_shader_parameter("shake_intensity",0.0)


func player_interact() -> void:
	toggle_inventory.emit(self)
	open_chest()


func _on_area_2d_body_entered(body: Node2D) -> void:
	var player = body
	player.interacting = self
	get_parent().inv_show.connect(chest_check)

func _on_area_2d_body_exited(body: Node2D) -> void:
	var player = body
	player.interacting = null
	chest_close()

func chest_check(tf: bool) -> void:
	inv_open = tf

func handle_animation() -> void:
	if chest_open == true and inv_open:
		animated_sprite.frame = 0
		animated_sprite.play("default")
	else:
		animated_sprite.frame = 4
		animated_sprite.play_backwards("default")

func open_chest() -> void:
	#chest_open = !chest_open
	if inv_open and !chest_open:
		chest_open = true
	elif !inv_open and !chest_open:
		pass
	else:
		chest_open = false

func chest_close() -> void:
	if chest_open == true:
		animated_sprite.frame = 4
		animated_sprite.play_backwards("default")
		get_parent().toggle_inventory_interface()
		chest_open = false
		get_parent().inv_show.disconnect(chest_check)

func on_hurt(damage:int) -> void:
	damage_component.apply_damage(damage)
	animated_sprite.material.set_shader_parameter("shake_intensity",0.5)
	await get_tree().create_timer(0.5).timeout
	animated_sprite.material.set_shader_parameter("shake_intensity",0.0)

func on_max_damage() -> void:
	call_deferred('add_chest_pickup')
	var chest_coord = global_position
	PlacingManager.remove_placeable(chest_coord)
	queue_free()

func add_chest_pickup() -> void:
	var chest_instance = PickUp.instantiate().duplicate()
	chest_instance.slot_data = chest_icon
	chest_instance.global_position = global_position
	get_parent().add_child(chest_instance)
	chest_broke.emit(self,global_position)
	#for node in inventory_data:
		#if node.slot_datas:
			#var total_count = 0
			#total_count += 2
			#var current_pos = global_position
			#var pickup = PickUp.instantiate().duplicate()
			#pickup.slot_data = node
			#pickup.global_position = current_pos.x + total_count
		
#func populate_item_grid(inventory_data:InventoryData) -> void:
	#for child in item_grid.get_children():
		#child.queue_free()
	#
	#for slot_data in inventory_data.slot_datas:
		#var slot = Slot.instantiate()
		#item_grid.add_child(slot)
		#
		#slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		#
		#if slot_data:
			#slot.set_slot_data(slot_data)
