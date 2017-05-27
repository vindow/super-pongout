extends Panel

enum {FULLSCREEN, WINDOWED}
var display_type = FULLSCREEN

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_display_input_event( ev ):
	if (ev.type==InputEvent.MOUSE_BUTTON and ev.pressed):
		get_node("sound").play("ui_select")
		if (display_type == FULLSCREEN):
			get_node("display/text").set_text("Display: Windowed")
			OS.set_window_fullscreen(false)
			OS.set_window_size(Vector2(1366, 799))
			display_type = WINDOWED
		else:
			get_node("display/text").set_text("Display: Fullscreen")
			OS.set_window_size(Vector2(1920, 1080))
			OS.set_window_fullscreen(true)
			display_type = FULLSCREEN

func _on_ball_count_slider_value_changed( value ):
	get_node("sound").play("ui_select")
	get_node("ball_count").set_text("Max Balls: " + String(value))
	global.max_balls = value

func _on_volume_slider_value_changed( value ):
	get_node("sound").play("ui_select")
	get_node("volume").set_text("Volume: " + String(value))
	AudioServer.set_fx_global_volume_scale(value / 100.0)

func _on_close_pressed():
	get_node("sound").play("ui_select")
	get_tree().set_pause(false)
	get_node(".").hide()
