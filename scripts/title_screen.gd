extends Node2D
func _ready():
	get_tree().set_pause(false)

func _on_play_pressed():
	get_node("sound").play("ui_select")
	var t = Timer.new()
	t.set_wait_time(0.16)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	get_tree().change_scene("res://scenes/pongout.tscn")

func _on_settings_pressed():
	get_node("sound").play("ui_select")
	get_tree().set_pause(true)
	get_node("options").show()

func _on_quit_pressed():
	get_node("sound").play("ui_select")
	var t = Timer.new()
	t.set_wait_time(0.16)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	get_tree().quit()
