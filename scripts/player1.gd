extends Node2D

const BASE_CURVE_AMOUNT = 0.4
const BASE_SPEED = 500
const POWERUP_DURATION = 15.0
enum {ARMOR, CURVE_DOWN, CURVE_UP, PAD_SPEED_DOWN, PAD_SPEED_UP, BALL_SPEED_DOWN, BALL_SPEED_UP}

var speed = BASE_SPEED
var blocks = []
var root = null
var position = Vector2(0, 0)
var velocity = Vector2(0, 0)
var block_size = 0
var low
var high
var curve_amount = BASE_CURVE_AMOUNT
var max_pad_length = 0

var ball_speed_changer = false

var armor_timer = 0
var curve_timer = 0
var ball_speed_timer = 0
var pad_speed_timer = 0

func _ready():
	for i in range(18):
		blocks.append(get_node("block" + str(i)))
	root = get_tree().get_root().get_node("game")
	position = get_node(".").get_pos()
	block_size = get_node("block0").get_node("Sprite").get_texture().get_size()
	low = blocks[0].get_pos().y - block_size.y / 2
	high = blocks[17].get_pos().y + block_size.y / 2
	max_pad_length = high - low
	set_fixed_process(true)

func _fixed_process(delta):
	position = get_node(".").get_pos()
	velocity = Vector2(0, 0)
	if (low + position.y > root.get_node("score/left_score").get_texture().get_size().y and Input.is_action_pressed("left_move_up")):
		velocity.y = -speed * delta
	if (high + position.y < get_viewport_rect().size.y and Input.is_action_pressed("left_move_down")):
		velocity.y = speed * delta
	if (low + position.y < root.get_node("score/left_score").get_texture().get_size().y):
		position.y = root.get_node("score/left_score").get_texture().get_size().y - low
	elif (high + position.y > get_viewport_rect().size.y):
		position.y = get_viewport_rect().size.y - high
	get_node(".").set_pos(position + velocity)
	var is_destroyed = true
	low = 192
	high = -192
	for block in blocks:
		if (not block.is_destroyed):
			is_destroyed = false
			if (block.get_pos().y - block_size.y / 2 < low):
				low = block.get_pos().y - block_size.y / 2
			if (block.get_pos().y + block_size.y / 2 > high):
				high = block.get_pos().y + block_size.y / 2
	if (is_destroyed):
		for block in blocks:
			block.respawn()
			if (position.y - max_pad_length / 2 < root.get_node("score/left_score").get_texture().get_size().y):
				position.y = max_pad_length / 2 + root.get_node("score/left_score").get_texture().get_size().y
				get_node(".").set_pos(position)
			elif (position.y + max_pad_length / 2 > get_viewport_rect().size.y):
				position.y = get_viewport_rect().size.y - max_pad_length / 2
				get_node(".").set_pos(position)
	if (armor_timer > 0):
		armor_timer -= delta
		if (armor_timer <= 0):
			for block in blocks:
				block.armor_down()
	if (curve_timer > 0):
		curve_timer -= delta
		if (curve_timer <= 0):
			curve_amount = BASE_CURVE_AMOUNT
	if (pad_speed_timer > 0):
		pad_speed_timer -= delta
		if (pad_speed_timer <= 0):
			speed = BASE_SPEED
	if (ball_speed_timer > 0):
		ball_speed_timer -= delta

func powerup(var type):
	if (type == ARMOR):
		root.get_node("player1_powerups/armor/overlay").set_time(POWERUP_DURATION)
		for block in blocks:
			block.armor_up()
			armor_timer = POWERUP_DURATION
	elif (type == CURVE_DOWN):
		root.get_node("player1_powerups/curve/overlay").set_time(POWERUP_DURATION)
		root.get_node("player1_powerups/curve").set_frame(type)
		curve_amount *= 0.66
		curve_timer = POWERUP_DURATION
	elif (type == CURVE_UP):
		root.get_node("player1_powerups/curve/overlay").set_time(POWERUP_DURATION)
		root.get_node("player1_powerups/curve").set_frame(type)
		curve_amount *= 1.5
		curve_timer = POWERUP_DURATION
	elif (type == PAD_SPEED_DOWN):
		root.get_node("player1_powerups/pad_speed/overlay").set_time(POWERUP_DURATION)
		root.get_node("player1_powerups/pad_speed").set_frame(type)
		speed -= 200
		pad_speed_timer = POWERUP_DURATION
	elif (type == PAD_SPEED_UP):
		root.get_node("player1_powerups/pad_speed/overlay").set_time(POWERUP_DURATION)
		root.get_node("player1_powerups/pad_speed").set_frame(type)
		speed += 200
		pad_speed_timer = POWERUP_DURATION
	elif (type == BALL_SPEED_DOWN):
		root.get_node("player1_powerups/ball_speed/overlay").set_time(POWERUP_DURATION)
		root.get_node("player1_powerups/ball_speed").set_frame(type)
		ball_speed_changer = false
		ball_speed_timer = POWERUP_DURATION
	elif (type == BALL_SPEED_UP):
		root.get_node("player1_powerups/ball_speed/overlay").set_time(POWERUP_DURATION)
		root.get_node("player1_powerups/ball_speed").set_frame(type)
		ball_speed_changer = true
		ball_speed_timer = POWERUP_DURATION
	else:
		print("Invalid powerup type, something went wrong...")