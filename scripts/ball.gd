extends Area2D

const MAX_SPEED = 850
const BASE_SPEED = 500
const MIN_SPEED = 350
var num_bounces = 0
var direction = Vector2(1.0, 0.0)
var curvature = 0
var speed = BASE_SPEED
var position
var radius
var root = null
var blue_particles = null
var red_particles = null
var power_particles = null

func _ready():
	radius = get_node("ball_collider").get_shape().get_radius()
	position = get_node(".").get_pos()
	root = get_tree().get_root().get_node("game")
	blue_particles = get_node("blue_particles")
	red_particles = get_node("red_particles")
	power_particles = get_node("power_particles")
	power_particles.set_emitting(false)
	set_fixed_process(true)
	
func _fixed_process(delta):
	position = get_node(".").get_pos()
	direction.y += curvature * delta
	position += direction * speed * delta
	get_node(".").set_pos(position)
	
	# Bounce ball off walls
	if ((position.y - radius < root.get_node("score/left_score").get_texture().get_size().y and direction.y < 0) 
	or (position.y + radius > get_viewport_rect().size.y and direction.y > 0)):
		get_node("sound").play("bump")
		direction.y *= -1

func _on_ball_area_enter( area ):
	if (area extends preload("res://scripts/player1_brick.gd") and direction.x < 0 and not area.is_destroyed):
		if (not area.is_armored):
			area.destroy()
		else:
			get_node("sound").play("tink")
		direction.x *= -1
		var player1 = area.get_parent()
		var player1_size = player1.high - player1.low
		direction.y = -(player1.position.y + player1_size / 2 + player1.low - position.y) / (player1_size)
		direction = direction.normalized()
		get_node("particle_trail").set_color(Color("6D81FF"))
		if (player1.velocity.y > 0):
			curvature = area.get_parent().curve_amount
		elif (player1.velocity.y < 0):
			curvature = area.get_parent().curve_amount * -1
		else:
			curvature = 0
		if (area.get_parent().ball_speed_timer > 0):
			if (area.get_parent().ball_speed_changer):
				speed = MAX_SPEED
			else:
				speed = MIN_SPEED
		elif (speed < MAX_SPEED):
			speed += 50
		num_bounces += 1
		power_particles.set_emitting(true)
		if (num_bounces < 11):
			power_particles.set_amount(num_bounces)
			if (num_bounces % 2 == 0):
				power_particles.set_param(power_particles.PARAM_FINAL_SIZE, power_particles.get_param(power_particles.PARAM_FINAL_SIZE) + 0.1)
		blue_particles.set_pos(direction * -radius)
		blue_particles.set_param(blue_particles.PARAM_DIRECTION, rad2deg(direction.angle()))
		blue_particles.set_emitting(true)
		
	if (area extends preload("res://scripts/player2_brick.gd") and direction.x > 0 and not area.is_destroyed):
		if (not area.is_armored):
			area.destroy()
		else:
			get_node("sound").play("tink")
		direction.x *= -1
		var player2 = area.get_parent()
		var player2_size = player2.high - player2.low
		direction.y = -(player2.position.y + player2_size / 2 + player2.low - position.y) / (player2_size)
		direction = direction.normalized()
		get_node("particle_trail").set_color(Color("FF6D72"))
		if (player2.velocity.y > 0):
			curvature = area.get_parent().curve_amount
		elif (player2.velocity.y < 0):
			curvature = area.get_parent().curve_amount * -1
		else:
			curvature = 0
		if (area.get_parent().ball_speed_timer > 0):
			if (area.get_parent().ball_speed_changer):
				speed = MAX_SPEED
			else:
				speed = MIN_SPEED
		elif (speed < MAX_SPEED):
			speed += 20
		num_bounces += 1
		power_particles.set_emitting(true)
		if (num_bounces < 11):
			power_particles.set_amount(num_bounces)
			if (num_bounces % 2 == 0):
				power_particles.set_param(power_particles.PARAM_FINAL_SIZE, power_particles.get_param(power_particles.PARAM_FINAL_SIZE) + 0.1)
		red_particles.set_pos(direction * -radius)
		red_particles.set_param(red_particles.PARAM_DIRECTION, rad2deg(direction.angle()))
		red_particles.set_emitting(true)

func _on_ball_exit_screen():
	speed = 0
	if (direction.x < 0):
		root.change_score(-50 - num_bounces * 20)
	else:
		root.change_score(50 + num_bounces * 20)
	get_node("death_timer").start()
	
	
func _on_death_timer_timeout():
	queue_free()
