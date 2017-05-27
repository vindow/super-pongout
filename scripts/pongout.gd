extends Node2D

var screen_size

#preloaded scenes
var ball_scene = preload("res://scenes/ball.tscn")
var powerup_scene = preload("res://scenes/powerup.tscn")

#ball data
var num_balls = 0
var max_balls = global.max_balls
var ball_countdown = 0
var next_ball_spawn

#score variables
var left_score
var right_score
var score_bar
var l_score_label
var r_score_label

#variables for initial countdown
var time_left = 3.0
var countdown

enum {ARMOR, CURVE_DOWN, CURVE_UP, PAD_SPEED_DOWN, PAD_SPEED_UP, BALL_SPEED_DOWN, BALL_SPEED_UP}
var powerup_spawn_timer = 10.0
var powerup_container = null

const BALL_COUNTDOWN_TIME = 1.5

#Function to add a ball into the scene at the center
#Pass true to spawn the ball going to the left paddle, false to go to the right paddle
func add_ball(add_on_left):
	var ball = ball_scene.instance()
	ball.set_pos(Vector2(screen_size.x / 2, screen_size.y / 2 + 12.5))
	if (add_on_left):
		ball.direction = Vector2(-1.0, randf() - 0.5).normalized()
	else:
		ball.direction = Vector2(1.0, randf() - 0.5).normalized()
	get_node(".").add_child(ball)
	num_balls += 1

#Function to change the score
#Adds amount to left score and subtracts amount from right score
#Also updates score text and score bar
func change_score(amount):
	left_score += amount
	right_score -= amount
	if (left_score >= 1000 or right_score >= 1000):
		player_won()
	l_score_label.set_text(String(left_score))
	r_score_label.set_text(String(right_score))
	score_bar.set_pos(Vector2(left_score * 48 / 25 - 960, 12.5))
	num_balls -= 1
	if (amount < 0):
		next_ball_spawn = false
	else:
		next_ball_spawn = true
		
func player_won():
	get_node("sound").play("game_over")
	if (left_score >= 1000):
		left_score = 1000
		right_score = 0
		get_node("victory_panel/victory_text").set_text("Player 1 wins")
	else:
		left_score = 0
		right_score = 1000
		get_node("victory_panel/victory_text").set_text("Player 2 wins")
		
	l_score_label.set_text(String(left_score))
	r_score_label.set_text(String(right_score))
	score_bar.set_pos(Vector2(left_score * 48 / 25 - 960, 12.5))
	get_tree().set_pause(true)
	get_node("victory_panel").show()
	
func spawn_powerup():
	var new_powerup = powerup_scene.instance()
	new_powerup.set_powerup_type(randi() % 7)
	new_powerup.set_pos(Vector2(randi() % int(powerup_container.get_size().x), randi() % int(powerup_container.get_size().y)))
	get_node("powerup_spawn_zone").add_child(new_powerup)

func _ready():
	get_tree().set_pause(false)
	randomize()
	
	screen_size = get_viewport_rect().size
	
	score_bar = get_node("score/left_score")
	l_score_label = get_node("score/left_score_label")
	r_score_label = get_node("score/right_score_label")
	
	left_score = 500
	right_score = 500
	
	countdown = get_node("countdown")
	
	if (randi() % 2 == 0):
		next_ball_spawn = true
	else:
		next_ball_spawn = false
	
	powerup_container = get_node("powerup_spawn_zone")
	
	set_process(true)

func _process(delta):
	if (time_left > 0):
		countdown.set_text(String(ceil(time_left)))
		time_left -= delta
	else:
		countdown.hide()
		
		#Spawn balls if needed, or decrement spawn countdown
		if (num_balls < max_balls):
			if (ball_countdown <= 0):
				ball_countdown = BALL_COUNTDOWN_TIME
				add_ball(next_ball_spawn)
				next_ball_spawn = !next_ball_spawn
			else:
				ball_countdown -= delta
		
		#Spawn powerups if countdown is at 0 otherwise continue decrementing the countdown
		if (powerup_spawn_timer <= 0):
			spawn_powerup()
			powerup_spawn_timer = 10.0
		else:
			powerup_spawn_timer -= delta
	if (Input.is_action_pressed("pause_game")):
		get_node("sound").play("pause")
		get_tree().set_pause(true)
		get_node("pause_menu").show()

func _on_resume_pressed():
	get_node("sound").play("unpause")
	get_node("pause_menu").hide()
	get_tree().set_pause(false)

func _on_quit_to_menu_pressed():
	get_node("sound").play("ui_select")
	var t = Timer.new()
	t.set_pause_mode(2)
	t.set_wait_time(0.16)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	get_tree().set_pause(false)
	get_tree().change_scene("res://scenes/title_screen.tscn")

func _on_quit_to_desktop_pressed():
	get_node("sound").play("ui_select")
	var t = Timer.new()
	t.set_pause_mode(2)
	t.set_wait_time(0.16)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	get_tree().quit()

func _on_replay_pressed():
	get_node("sound").play("ui_select")
	var t = Timer.new()
	t.set_pause_mode(2)
	t.set_wait_time(0.16)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_node("sound").play("ui_select")
	var t = Timer.new()
	t.set_pause_mode(2)
	t.set_wait_time(0.16)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	_on_quit_to_menu_pressed()
