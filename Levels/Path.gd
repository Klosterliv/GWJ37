extends Path2D

export var radius := 50
var start = curve.get_baked_points()[0]
var end = curve.get_baked_points()[curve.get_baked_points().size()-1]

func _ready():
	print(str(start) + " " + str(end))

func _draw():
	draw_polyline(curve.get_baked_points(), Color(0.9,0.2,0.2,0.5), radius, false) #change to polyline
