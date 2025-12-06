extends CharacterBody2D
class_name Player

signal toggle_inventory

#region player control var
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_spot_collision_shape: CollisionShape2D = $HitComponent/HitSpotCollisionShape

enum Tools {none, hoe, axe, watering_can}
@export var tools: Tools = Tools.none

const speed: float = 40.0
const run_speed: float = 100.0
var accel = speed

##Stamina
var health: int = 100

enum dir {left, right, up, down}
enum State {idle, walk, work}

var direction = dir.down
var state = State.idle#:
	#set(x):
		#state = x
		#print(State.find_key(state))
#endregion
#region inventory var
@export var inventory_data: InventoryData
var interacting

#endregion

func _ready() -> void:
	PlayerManager.player = self
	hit_spot_collision_shape.disabled = true
	hit_spot_collision_shape.position = Vector2(0,0)

func get_input() -> void:
	var input_direction = Input.get_vector('left','right','up','down')
	if can_walk():
		velocity = input_direction * accel

func _physics_process(_delta: float) -> void:
	if can_walk() or can_run():
		get_input()
	else:
		velocity = Vector2.ZERO
	handle_movement()
	move_and_slide()
	handle_animation()
	handle_running()
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()
	interact()

func handle_movement() -> void:
	if can_walk():
		if velocity.length() == 0:
			state = State.idle
		else:
			state = State.walk

#region animation
func handle_animation() -> void:
#region movement animation
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
#endregion
#region idle animation
	##idle animation
		if velocity == Vector2.ZERO and direction == dir.right:
			animated_sprite.play('idle_right')
		elif velocity == Vector2.ZERO and direction == dir.left:
			animated_sprite.play('idle_left')
		elif velocity == Vector2.ZERO and direction == dir.up:
			animated_sprite.play('idle_up')
		elif velocity == Vector2.ZERO and direction == dir.down:
			animated_sprite.play('idle_down')
#endregion
#region tools animation
func _unhandled_input(event: InputEvent) -> void:
	##tools animation
	if event.is_action_pressed("click"):
		if can_work():
			state = State.work
			if tools == Tools.none:
				state = State.idle
				return
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
			if tools == Tools.axe:
				if direction == dir.down:
					animated_sprite.play("axe_down")
					hit_spot_collision_shape.position = Vector2(0,3)
					hit()
					await get_tree().create_timer(.5).timeout
					state = State.idle
				elif direction == dir.up:
					animated_sprite.play("axe_up")
					hit_spot_collision_shape.position = Vector2(0,-20)
					hit()
					await get_tree().create_timer(.5).timeout
					state = State.idle
				elif direction == dir.left:
					animated_sprite.play("axe_left")
					hit_spot_collision_shape.position = Vector2(-10,0)
					hit()
					await get_tree().create_timer(.5).timeout
					state = State.idle
				elif direction == dir.right:
					animated_sprite.play("axe_right")
					hit_spot_collision_shape.position = Vector2(10,0)
					hit()
					await get_tree().create_timer(.5).timeout
					state = State.idle
			if tools == Tools.watering_can:
				if direction == dir.down:
					animated_sprite.play("water_down")
					hit_spot_collision_shape.position = Vector2(0,3)
					hit()
					await get_tree().create_timer(.5).timeout
					state = State.idle
				elif direction == dir.up:
					animated_sprite.play("water_up")
					hit_spot_collision_shape.position = Vector2(0,-20)
					hit()
					await get_tree().create_timer(.5).timeout
					state = State.idle
				elif direction == dir.left:
					animated_sprite.play("water_left")
					hit_spot_collision_shape.position = Vector2(-19,0)
					hit()
					await get_tree().create_timer(.5).timeout
					state = State.idle
				elif direction == dir.right:
					animated_sprite.play("water_right")
					hit_spot_collision_shape.position = Vector2(19,0)
					hit()
					await get_tree().create_timer(.5).timeout
					state = State.idle
#endregion
#endregion

#region state machine
func can_walk() -> bool:
	return state == State.idle or state == State.walk

func can_run() -> bool:
	return state == State.walk

func can_work() -> bool:
	return state == State.idle or state == State.walk

func can_interact() -> bool:
	return state == State.idle or state == State.walk

#endregion
func handle_running() -> void:
	if can_run():
		if Input.is_action_pressed('run'):
			accel = run_speed
		if Input.is_action_just_released('run'):
			accel= speed
	else:
		accel = speed

func interact() -> void:
	if can_interact() and Input.is_action_just_pressed("interact")\
	 and interacting:
		interacting.player_interact()
	else:
		pass

func heal(heal_value:int) -> void:
	health += heal_value

func hit() -> void:
	await get_tree().create_timer(.25).timeout
	hit_spot_collision_shape.disabled=false
	await get_tree().create_timer(.25).timeout
	hit_spot_collision_shape.disabled=true
	hit_spot_collision_shape.position=Vector2(0,0)
