extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var roof: TileMapLayer = $Roof

func _ready() -> void:
	roof.show()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		animation_player.play("player_in")


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		animation_player.play("player_out")
