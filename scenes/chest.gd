extends StaticBody2D

signal toggle_inventory(external_inventory_owner)

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var inventory_data: InventoryData

var chest_open:bool = false

func _ready() -> void:
	animated_sprite.frame = 0

func player_interact() -> void:
	toggle_inventory.emit(self)
	chest_open = !chest_open
	if chest_open == true:
		animated_sprite.frame = 0
		animated_sprite.play("default")
	else:
		animated_sprite.frame = 4
		animated_sprite.play_backwards("default")
		


func _on_area_2d_body_entered(body: Node2D) -> void:
	var player = body
	player.interacting = self

func _on_area_2d_body_exited(body: Node2D) -> void:
	var player = body
	player.interacting = null
	if chest_open == true:
		animated_sprite.frame = 4
		animated_sprite.play_backwards("default")
	chest_open = false
