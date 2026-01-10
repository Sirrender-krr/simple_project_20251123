extends Area2D

@export var slot_data: SlotData

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if slot_data.item_data is ItemDataCoin:
		animation_player.pause()
		cannot_pickup()
	else:
		sprite_2d.texture = slot_data.item_data.texture
		cannot_pickup()

func _on_body_entered(body: Node2D) -> void:
	if body.inventory_data.pick_up_slot_data(slot_data):
		queue_free()

func cannot_pickup() -> void:
	collision_shape.disabled = true
	await get_tree().create_timer(1.0).timeout
	collision_shape.disabled = false
