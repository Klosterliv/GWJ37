extends Node2D

export var agentPath : NodePath
export var FlowMap : NodePath
export var path : NodePath
#onready var agentbase = preload("res://Scripts/Objects/Agent.tscn")
export var separation := 1.1
export var alignment := 0.4
export var cohesion := 0.5
export var targetseek := 3.0
export var flowfollow := 1.2
export var followflow := false
export var viewrange := 60
export var followpaths := true

export var agentMaxSpeed := 10.0
export var agentMaxForce := 0.8

export var agentAmount := 5
export var agentSpawnArea := 200.0
export var drawDir := true
export var drawNeighbors := true
export var neighborDist := 100.0
export var forceMultiplier = 1.0

export var boundsX := 1920
export var boundsY := 1080
export var gridSize := 120
export var drawGrid := false
var gridPop = []

var agentTemplate
var flowMap 

var agents = []
var neighbors

var mousePos = Vector2(0,0)
var followMouse := false

# Called when the node enters the scene tree for the first time.
func _ready():	
	
	mousePos = Vector2(boundsX/2,boundsY/2)
	agentTemplate = get_node(agentPath)
	flowMap = get_node(FlowMap)
	
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
#	newAgent.apply_central_impulse(pos*.25);
	newAgent.target = Vector2(boundsX/2,boundsY/2)
	
	newAgent.maxSpeed = agentMaxSpeed
	newAgent.maxForce = agentMaxForce
	
	agents.append(newAgent)

func FollowMouse(yesno):
	followMouse = yesno
	
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
func Bounds(agent):
	var bounds = Vector2(0,0)
	if (agent.position.x > boundsX-25):
		bounds.x = -500
	elif (agent.position.x < 25):
		bounds.x = 500
	if (agent.position.y > boundsY-25):
		bounds.y = -500
	elif (agent.position.y < 25):
		bounds.y = 500
	return bounds		
	
func FlowFieldFollow(agent, flowfield):
	return flowfield.flowAtPoint(agent.position)

func Seek(agent, target):
	
	var desV = target - agent.position
	var curV = agent.vel
	
	var d = desV.length()
	desV = desV.normalized()
	
	if (d < 100):
		var m = remap_range(d, 0, 100, 0, agent.maxSpeed)
		desV *= m
	else:
		desV *= agent.maxSpeed
	var steer = (desV - curV)
#	var steer = (desV - curV).clamped(agent.maxForce)
	return steer
		
func Separation(agent):
	var sum = Vector2(0,0)
	var sepDist = 60
	var count = 0
	for n in agent.neighbors:
		var v = agent.position - n.position
		var d = v.length()
		if (d < sepDist):
			sum += (v.normalized()/d)
			count += 1
	if (count > 0):
		sum /= count
	sum = agent.maxSpeed * sum.normalized()
	return sum
	
func Alignment(agent):
	var sum = Vector2(0,0)
	for n in agent.neighbors:
		sum += n.vel
	if(agent.neighbors.size() > 0):
		sum /= agent.neighbors.size()
		sum = agent.maxSpeed * sum.normalized()
	return sum
	
func Cohesion(agent):
	var sum = Vector2(0,0)
	for n in agent.neighbors:
		sum += n.position
	if(agent.neighbors.size() > 0):
		sum /= agent.neighbors.size()
		#sum = agent.maxSpeed * sum.normalized()
		return Seek(agent,sum)	
	else: 
		return sum

func Follow(agent, p):
	var predict = agent.vel
	predict.normalized()
	predict *= viewrange
	var predictLoc = agent.position + predict
	
	var a = p.start
	var b = p.end
	var normalPoint = getNormal(predictLoc, a, b)
	
	var dir = b - a
	dir.normalized()
	dir *= 10 #look ahead value
	var target = normalPoint + dir
	
	var distance = normalPoint.distance_to(predictLoc)
	if (distance > p.radius):
		return Seek(agent, target)

func Wander(agent):
	agent.target = agent.position + (agent.vel.normalized()*150 + (Vector2(rand_range(-1,1),rand_range(-1,1)).normalized()*5))

func Steer(agent, delta):	
	
	var sep = Separation(agent) * separation
	var align = Alignment(agent) * alignment
	var coh = Cohesion(agent) * cohesion
	var target = Seek(agent, agent.target) * targetseek
	var flow = FlowFieldFollow(agent, flowMap) * flowfollow
	var follow = Follow(agent, get_node(path))
	if !followflow:
		flow = Vector2.ZERO
	if !followpaths:
		follow = Vector2.ZERO
	
	var steer = sep + align + coh + target + flow + follow
	
	steer = steer.clamped(agent.maxForce)	
	agent.force = steer


func _physics_process(delta):
	var c = 0
	for a in agents:
#		print(c)
		if (followMouse):
			a.target = mousePos
		else: 
			Wander(a)
			
		a.target += Bounds(a)
		
		find_neighbors(a)
		
		#a.vel = a.linear_velocity
		
		Steer(a, delta)
		#var f = a.force.clamped(a.maxForce) * forceMultiplier
		var f = a.force
		a.vel += f 
		#a.vel = f
		#a.add_central_force(f)
		
		a.position += a.vel
	
	update()


func _draw():
	DrawGrid()
	if (!drawDir && !drawNeighbors): 
		return
	var c = false
	for a in agents:
		if (drawDir):
			var pos = a.position
			var vel = a.vel
			draw_line(pos, pos + vel.clamped(30), Color(255, 0, 0), 1)
			draw_line(pos, pos + a.force.clamped(30), Color(255, 255, 0), 1)
			draw_line(pos, a.target, Color(0, 0, 0, .1), 1)
			draw_line(pos, getNormal(pos + vel.normalized()*viewrange, get_node(path).start, get_node(path).end),Color.red, 1)
		if (drawNeighbors && a.neighbors.size() > 0):
			var pos = a.position
#			print(a.neighbors.size())
			for n in a.neighbors:
				if (!c): 
					c = true
				var npos = n.position
				draw_line(pos, npos, Color(.2, 1, 0, .2), 1)
			pass
	#draw_line(pos, pos + Vector2.UP, Color(255, 0, 0), 1)

func DrawGrid():
	var linesX = abs(boundsX / gridSize)
	var linesY = abs(boundsY / gridSize)
	
	for x in linesX+1:
		var o = Vector2(x*gridSize, 0)
		draw_line(o, o-Vector2.UP*boundsY, Color(0, .6, .6, .6), 1)
	for y in linesY+1:
		var o = Vector2(0, y*gridSize)
		draw_line(o, o+Vector2.RIGHT*boundsX, Color(0, .6, .6, .6), 1)	

func remap_range(value, InputA, InputB, OutputA, OutputB):
	return(value - InputA) / (InputB - InputA) * (OutputB - OutputA) + OutputA
func flowAtPoint(point):
	return flowMap.flowAtPoint(point)
func fieldAtPoint(point):
	return flowMap.fieldAtPoint(point)
func angleBetween(a:Vector2,b:Vector2):
	var dot = a.dot(b)
	return acos(dot / (a.length() * b.length()))
func getNormal(p:Vector2,a:Vector2,b:Vector2):
	var ap = p - a
	var ab = b - a
	
	ab.normalized()
	ab *= ap.dot(ab)
	
	return (a + ab)
