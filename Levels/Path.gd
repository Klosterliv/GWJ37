extends Path2D

export var radius := 50
var start = curve.get_baked_points()[0]
var end = curve.get_baked_points()[curve.get_baked_points().size()-1]

func _ready():
	print(str(start) + " " + str(end))

func _draw():
	var coords = []
	var c = 0
	for i in curve.get_baked_points():
		coords.append(GetPoint(c))
		c += 1
#	draw_polyline(coords, Color(0.9,0.2,0.2,0.5), radius, false)
	pass

func GetPoint(index):
	return (position + curve.get_baked_points()[index])*scale
