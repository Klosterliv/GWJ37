extends Node2D

export var agentPath : NodePath
export var enemyPath : NodePath
export var FlowMap : NodePath
export var path : NodePath
#onready var agentbase = preload("res://Scripts/Objects/Agent.tscn")
export var separation := 1.1
export var alignment := 0.4
export var cohesion := 0.5
export var targetseek := 3.0
export var flowfollow := 1.2
export var followflow := false
export var viewrange := 70
export var followpaths := true

export var agentMaxSpeed := 6
export var agentMaxForce := 0.8

export var agentAmount := 5
export var agentSpawnArea := 200.0
export var drawDir := true
export var drawNeighbors := true
export var neighborDist := 100.0
export var forceMultiplier = 1.0

export var enemyAmount := 10
export var enemySpeed = 2.0

export var boundsX := 1920
export var boundsY := 1080
export var gridSize := 120
export var drawGrid := false

var debugLines = false

var gridPop = []

var agentTemplate
var enemyTemplate
var flowMap 

var agents = []
var neighbors

var mousePos = Vector2(0,0)
var followMouse := false

# Called when the node enters the scene tree for the first time.
func _ready():	
	
	mousePos = Vector2(boundsX/2,boundsY/2)
	agentTemplate = get_node(agentPath)
	enemyTemplate = get_node(enemyPath)
	flowMap = get_node(FlowMap)
	
	for n in agentAmount:
				
		var newAgent = Spawn(agentTemplate)
		var pos = Vector2(0 + rand_range(-1,1)*agentSpawnArea, 0 + rand_range(-1,1)*agentSpawnArea)
		var fpos = pos + Vector2(boundsX/2, boundsY/2)
		draw_line(fpos, fpos + Vector2.UP, Color(255, 0, 0), 1)
		newAgent.position = fpos;
	#	newAgent.apply_central_impulse(pos*.25);
		newAgent.target = Vector2(boundsX/2,boundsY/2)
		newAgent.targetRadius = 300
		
		newAgent.maxSpeed = agentMaxSpeed
		newAgent.maxForce = agentMaxForce
		
		newAgent.SetSize(.3)
	
	var count = 0
	for e in enemyAmount:
		count+=1
		var newEnemy = Spawn(enemyTemplate)
		var pos = Vector2(count*200, 10)
		newEnemy.position = pos;

		newEnemy.SetSize(2)
	#neighbors = init_neighbors(agentAmount, 6, null)
	pass # Replace with function body.
	#set_process(true)

func Spawn(template):
		
	var newAgent = template.create_instance()
	
	#add_child(newAgent)
	
	agents.append(newAgent)
	
	return newAgent

func FollowMouse(yesno):
	followMouse = yesno

func find_neighbors(agent):
	agent.neighbors = []
	for a in agents:
		if(a!=agent):
			if(agent.position.distance_to(a.position)+agent.radius+a.radius < neighborDist):
				agent.neighbors.append(a)
	return

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

func Attack(agent):
	for n in agent.neighbors:
		if (n.id != agent.id):
			var dist = agent.position.distance_to(n.position)
			if (dist <= (agent.radius + n.radius +.2)*24):
				var relSpeed = abs(agent.vel.dot(n.vel))
				print(str(relSpeed))
				var dmg = abs(relSpeed - n.armor)
				#print("dmg : "+str(dmg))
				n.health = n.health - dmg
				if(dmg <= n.health):
					agent.vel = -agent.vel
					agent.chargeTimer = 0
				
				
				

func FlowFieldFollow(agent, flowfield):
	return flowfield.flowAtPoint(agent.position)

func Seek(agent, target):
	
	var desV = target - agent.position
	var curV = agent.vel
	
	var d = desV.length()
	desV = desV.normalized()
	
	if (d <= agent.targetRadius && agent.targetRadius != 0):
		d /= agent.targetRadius
	
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
	predict = predict.normalized()
	predict *= viewrange
	var predictLoc = agent.position + predict
	
	var a = p.start
	var b = p.end
	var normalPoint = getNormal(predictLoc, a, b)
	
	var dir = b - a
	dir = dir.normalized()
	dir *= 10 #look ahead value
	var target = normalPoint + dir
	
	var distance = normalPoint.distance_to(predictLoc)
	if (distance > p.radius):
		return Seek(agent, target)
	else:
		return Seek(agent, target)

func Wander(agent):
	agent.target = agent.position + (agent.vel.normalized()*150 + (Vector2(rand_range(-1,1),rand_range(-1,1)).normalized()*5))

func Steer(agent, delta):
	
	var steer = Vector2.ZERO
	
	if(agent.separate):
		var sep = Separation(agent) * separation
		steer += sep * agent.separation
	if(agent.align):
		var align = Alignment(agent) * alignment
		steer += align * agent.separation
	if(agent.cohere):
		var coh = Cohesion(agent) * cohesion
		steer += coh * agent.cohesion
	
	var bounds = Bounds(agent)
	
	var target = Seek(agent, agent.target) * targetseek
	var flow = FlowFieldFollow(agent, flowMap) * flowfollow
	var follow = Follow(agent, get_node(path))
	if !followflow:
		flow = Vector2.ZERO
	if !followpaths:
		follow = Vector2.ZERO
	
	steer = steer + target + flow + follow + bounds
	
	steer = steer.clamped(agent.maxForce)	
	agent.force = steer

func Charge(agent, target):	
	var dir = (target - agent.position).normalized()
	agent.vel += dir * agent.chargeStrength * agent.maxForce
	agent.chargeTimer = agent.chargeDelay
	
func ChargeAt(point, radius):
	for a in agents:
		if (a.id == 0):
			if (a.chargeTimer <= 0 && a.position.distance_to(point) <= radius):
				Charge(a, point)

func _physics_process(delta):
	var c = 0
	for a in agents:
#		print(c)
		a.chargeTimer -= delta
		if (a.chargeTimer > 0):
			Attack(a)
		
		if (a.id == 0 && followMouse):
			a.target = mousePos
			a.targetRadius = 260
		elif(a.wander): 
			Wander(a)
			a.targetRadius = 0
			
		#a.target += Bounds(a)
		
		find_neighbors(a)
		
		#a.vel = a.linear_velocity
		
		Steer(a, delta)
		#var f = a.force.clamped(a.maxForce) * forceMultiplier
		var f = a.force
		a.vel += f 
		#a.vel = f
		#a.add_central_force(f)
		
		a.position += a.vel*delta*100
		
		if(a.health <= 0):
			a.SetSize(0)
	
	update()


func _draw():
	draw_line(get_node(path).curve.get_point_position(0), get_node(path).curve.get_point_position(1),Color(.4,.1,.1,.4), 20)
	DrawGrid()
	if (!drawDir && !drawNeighbors): 
		return
	var c = false
	for a in agents:
		if (drawDir):
			var pos = a.position
			var vel = a.vel
			if debugLines:
				draw_line(pos, pos + vel.clamped(30)*2, Color(255, 0, 0), 1)
				draw_line(pos, pos + a.force.clamped(30)*2, Color(255, 255, 0), 1)
				draw_line(pos, a.target, Color(0, 0, 0, .1), 1)
				var pathpt1 = get_node(path).curve.get_point_position(0)
				var pathpt2 = get_node(path).curve.get_point_position(1)
				draw_line(pos, getNormal(pos + vel, pathpt1, pathpt2),Color(.8, .8, .2, .5), 1)
				#print(get_node(path).curve.get_point_position(0))
			
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
	
	ab = ab.normalized()
	1+1
	ab *= ap.dot(ab)
	
	return (a + ab)


func _on_DebugButton_toggled(button_pressed):
	if button_pressed:
		debugLines = true
		update()
	else:
		debugLines = false
		update()
