extends Node2D

export var AgentControl : NodePath

var field = []
var cols : int
var rows : int
export var resolution : int
export var noiseZoom := .1
export var noiseStrength = 3
export var drawField = false
export var drawVectorLength = 3

var noise = OpenSimplexNoise.new()

func _ready():
	
	noise.seed = randi()
	noise.octaves = 2
	noise.period = 20.0
	noise.persistence = 0.8
	
	cols = get_node(AgentControl).boundsX/resolution
	rows = get_node(AgentControl).boundsY/resolution
	
	var xoff := 0.0
	for i in cols:
		field.append([])
		var yoff := 0.0
		for j in rows:
			field[i].append(0)
			var theta = remap_range(noise.get_noise_2d(xoff,yoff),0,1,0,PI*2)
			field[i][j] = Vector2((cos(theta)),(sin(theta)))*noiseStrength
			yoff += noiseZoom
		xoff += noiseZoom

func flowAtPoint(point):
	point = fieldAtPoint(point)
	var value = field[int(point.x)][int(point.y)]
	return value

func fieldAtPoint(point):
	point /= resolution
	point.y = int(clamp(point.y, 0, rows-1))
	point.x = int(clamp(point.x, 0, cols-1))
	return point

func _draw():
	if(drawField):
		var xoff := 0.0	
		for i in cols:
			var yoff := 0.0
			for j in rows:
				draw_line(Vector2(xoff,yoff),Vector2(xoff,yoff)+field[i][j]*drawVectorLength,Color(field[i][j].x,field[i][j].y,.5, .1))
				yoff += resolution
			xoff += resolution

func remap_range(value, InputA, InputB, OutputA, OutputB):
	return(value - InputA) / (InputB - InputA) * (OutputB - OutputA) + OutputA

func _on_DebugButton_toggled(button_pressed):
	if button_pressed and owner.get_node("AgentControl").followflow:
		drawField = true
		update()
	else:
		drawField = false
	update()
