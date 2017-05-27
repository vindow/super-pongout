extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
enum {ARMOR, CURVE_DOWN, CURVE_UP, PAD_SPEED_DOWN, PAD_SPEED_UP, BALL_SPEED_DOWN, BALL_SPEED_UP}
var powerup_type = ARMOR
var root = null
var is_picked_up = false

func _ready():
	root = get_tree().get_root().get_node("game")

func set_powerup_type(var type):
	var pickup_text = get_node("pickup_text")
	powerup_type = type % 7
	get_node("Sprite").set_frame(type % 7)
	if(powerup_type == ARMOR):
		pickup_text.set_text("ARMOR")
	elif (powerup_type == CURVE_DOWN):
		pickup_text.set_text("CURVE -")
	elif (powerup_type == CURVE_UP):
		pickup_text.set_text("CURVE +")
	elif (powerup_type == PAD_SPEED_DOWN):
		pickup_text.set_text("PAD SPEED -")
	elif (powerup_type == PAD_SPEED_UP):
		pickup_text.set_text("PAD SPEED +")
	elif (powerup_type == BALL_SPEED_DOWN):
		pickup_text.set_text("BALL SPEED -")
	elif (powerup_type == BALL_SPEED_UP):
		pickup_text.set_text("BALL SPEED +")
		
func picked_up(player):
	is_picked_up = true
	if (player == 0):
		if (powerup_type == CURVE_DOWN or powerup_type == PAD_SPEED_DOWN or powerup_type == BALL_SPEED_DOWN):
			get_node("animation").play("player1_picked_up_powerdown")
		else:
			get_node("animation").play("player1_picked_up_powerup")
	else:
		if (powerup_type == CURVE_DOWN or powerup_type == PAD_SPEED_DOWN or powerup_type == BALL_SPEED_DOWN):
			get_node("animation").play("player2_picked_up_powerdown")
		else:
			get_node("animation").play("player2_picked_up_powerup")
	get_node("death_timer").start()

func _on_powerup_area_enter( area ):
	if (area extends preload("res://scripts/ball.gd") and not is_picked_up):
		if (area.num_bounces > 0):
			if (area.direction.x < 0):
				root.get_node("player2").powerup(powerup_type)
				get_node("pickup_text").add_color_override("font_color", Color("FF6D72"))
				picked_up(1)
			else:
				root.get_node("player1").powerup(powerup_type)
				get_node("pickup_text").add_color_override("font_color", Color("6D81FF"))
				picked_up(0)


func _on_death_timer_timeout():
	queue_free()
