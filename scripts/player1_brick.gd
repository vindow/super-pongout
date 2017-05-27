extends Area2D

var is_destroyed = false
var is_armored = false

func _ready():
	if (get_node(".").get_pos().x < 0):
		get_node("sound").set_default_pitch_scale(2)
	elif (get_node(".").get_pos().x > 0):
		get_node("sound").set_default_pitch_scale(0.5)

func destroy():
	get_node("sound").play("hit")
	get_node("animation").play("destroyed")
	is_destroyed = true
	
func respawn():
	get_node("animation").play("respawned")
	is_destroyed = false
	
func armor_up():
	is_armored = true
	get_node("Sprite").set_frame(1)

func armor_down():
	is_armored = false
	get_node("Sprite").set_frame(0)