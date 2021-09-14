extends Node2D

export var agentPath : NodePath
#onready var agentbase = preload("res://Scripts/Objects/Agent.tscn")
export var agentAmount := 5
export var agentSpawnArea := 2
export var drawDir := true
export var drawNeighbors := true
export var neighborDist := 100

export var boundsX := 1920
export var boundsY := 1080
export var gridSize := 120
export var drawGrid := false
var gridPop = []

var agentTemplate

var agents = []
var neighbors

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():	
	
	agentTemplate = get_node(agentPath)
	for n in agentAmount:
		
		Spawn();
	#neighbors = init_neighbors(agentAmount, 6, null)
	pass # Replace with function body.
	#set_process(true)

func Spawn():
		
	var newAgent = agentTemplate.create_instance()
	
	#add_child(newAgent)
	
	var pos = Vector2(0 + rand_range(-1,1)*agentSpawnArea, 0 + rand_range(-1,1)*agentSpawnArea)
	var fpos = pos + Vector2(boundsX/2, boundsY/2)
	draw_line(fpos, fpos + Vector2.UP, Color(255, 0, 0), 1)
	newAgent.position = fpos;
	newAgent.apply_central_impulse(pos*.25);
	
	agents.append(newAgent)


func find_neighbors(agent):
	agent.neighbors = []
	for a in agents:
		if(a!=agent):
			if(agent.position.distance_to(a.position) < neighborDist):
				agent.neighbors.append(a)
	return
#func init_neighbors(width, height, value):
#	var a = []
#
#	for x in range(width):
#		a.append([])
#		a[x].resize(height)
#
#		for y in range(height):
#			a[x][y] = value
#
#	return a
	
	
func _process(delta):
	var c = 0
	for a in agents:
#		print(c)
		c+=1
		find_neighbors(a)
	update()	
func _draw():	
	DrawGrid()
	if (!drawDir && !drawNeighbors): 
		return
	var c = false
	for a in agents:
		if (drawDir):
			var pos = a.position
			var vel = a.linear_velocity
			draw_line(pos, pos + vel.clamped(30), Color(255, 0, 0), 1)
		if (drawNeighbors && a.neighbors.size() > 0):
			var pos = a.position
#			print(a.neighbors.size())
			for n in a.neighbors:
				if (!c): 
					c = true
				var npos = n.position
				draw_line(pos, npos, Color(255, 128, 128), 1)
			pass
	#draw_line(pos, pos + Vector2.UP, Color(255, 0, 0), 1)
	
func DrawGrid():
	var linesX = abs(boundsX / gridSize)
	var linesY = abs(boundsY / gridSize)
	
	
	for x in linesX+1:
		var o = Vector2(x*gridSize, 0)
		draw_line(o, o-Vector2.UP*boundsY, Color(0, 200, 200), 1)
	for y in linesY+1:
		var o = Vector2(0, y*gridSize)
		draw_line(o, o+Vector2.RIGHT*boundsX, Color(0, 200, 200), 1)	
	
