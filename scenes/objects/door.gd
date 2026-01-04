extends Area2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.frame = 0



func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		animated_sprite_2d.play("default")


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		animated_sprite_2d.play_backwards("default")
