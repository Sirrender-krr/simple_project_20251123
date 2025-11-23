extends CharacterBody2D
class_name Player

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

enum Tools {none, hoe, axe, watering_can}
@export var tools: Tools = Tools.none

const speed: float = 40.0
const run_speed: float = 100.0
var accel = speed

enum dir {left, right, up, down}
enum State {idle, walk, work}

var direction = dir.down
var state = State.idle:
	set(status):
		state = status
		match status:
			0:
				print("idle")
			1:
				print("walk")
			2:
				print("work")

func get_input() -> void:
	var input_direction = Input.get_vector('left','right','up','down')
	velocity = input_direction * accel

func _physics_process(_delta: float) -> void:
	get_input()
	handle_movement()
	move_and_slide()
	handle_animation()
	handle_running()

func handle_movement() -> void:
	if can_walk():
		if velocity.length() == 0:
			state = State.idle
		else:
			state = State.walk

func handle_animation() -> void:
	##movement animation
	if can_walk():
		if accel > speed:
			animated_sprite.speed_scale = 2
		else:
			animated_sprite.speed_scale = 1
		if velocity.x >0:
			direction = dir.right
			animated_sprite.play('move_right')
		elif velocity.x <0:
			direction = dir.left
			animated_sprite.play('move_left')
		elif velocity.y >0:
			direction = dir.down
			animated_sprite.play('move_down')
		elif velocity.y <0:
			direction = dir.up
			animated_sprite.play('move_up')
		elif velocity.x > 0 and velocity.y != 0:
			direction = dir.right
			animated_sprite.play('move_right')
		elif velocity.x < 0 and velocity.y != 0:
			direction = dir.left
			animated_sprite.play('move_left')
			
	##idle animation
		if velocity == Vector2.ZERO and direction == dir.right:
			animated_sprite.play('idle_right')
		elif velocity == Vector2.ZERO and direction == dir.left:
			animated_sprite.play('idle_left')
		elif velocity == Vector2.ZERO and direction == dir.up:
			animated_sprite.play('idle_up')
		elif velocity == Vector2.ZERO and direction == dir.down:
			animated_sprite.play('idle_down')

	##tools animation
	if Input.is_action_just_pressed("click"):
		if can_work():
			state = State.work
			if tools == Tools.hoe:
				if direction == dir.down:
					animated_sprite.play("hoe_down")
					await get_tree().create_timer(.5).timeout
					state = State.idle
				elif direction == dir.up:
					animated_sprite.play("hoe_up")
					await get_tree().create_timer(.5).timeout
					state = State.idle
				elif direction == dir.left:
					animated_sprite.play("hoe_left")
					await get_tree().create_timer(.5).timeout
					state = State.idle
				elif direction == dir.right:
					animated_sprite.play("hoe_right")
					await get_tree().create_timer(.5).timeout
					state = State.idle

			
	

func can_walk() -> bool:
	return state == State.idle or state == State.walk

func can_run() -> bool:
	return state == State.walk

func can_work() -> bool:
	return state == State.idle

func handle_running() -> void:
	if can_run():
		if Input.is_action_pressed('run'):
			accel = run_speed
		if Input.is_action_just_released('run'):
			accel= speed
	else:
		accel = speed
