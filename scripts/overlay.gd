extends Node2D
const MAX_TIME = 15.0
var time_left

func draw_circle_arc_poly( center, radius, angle_from, angle_to, color ):
	var nb_points = 32
	var points_arc = Vector2Array()
	points_arc.push_back(center)
	var colors = ColorArray([color])
	
	for i in range(nb_points+1):
		var angle_point = angle_from + i*(angle_to-angle_from)/nb_points - 90
		points_arc.push_back(center + Vector2( cos( deg2rad(angle_point) ), sin( deg2rad(angle_point) ) ) * radius)
	draw_polygon(points_arc, colors)

func _draw():
	var angle = 360 * (MAX_TIME - time_left) / MAX_TIME
	draw_circle_arc_poly(Vector2(0, 0), 25, 0, angle, Color(0, 0, 0, 0.5))

func _process(delta):
	time_left -= delta
	if (time_left <= 0):
		time_left = 0
	else:
		update()

func _ready():
	time_left = 0.0
	set_process(true)

func set_time(time):
	time_left = time