extends Node2D

export var agentControlPath : NodePath
var agentControl

export var enabled = false
export var radius = 50
export var id := 3
export var amount := 1
export var maximumAmount := 10
export var timer := 3.0
var time
export var looping = false

var spawnedAmount = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	time = timer
	agentControl = get_node(agentControlPath)
	pass # Replace with function body.

func _process(delta):
	if (!enabled):
		return
	if(time <= 0):
		for c in amount:
			if (spawnedAmount < maximumAmount):
				var spawned = agentControl.SpawnByID(id)
				spawned.position = position + Vector2(rand_range(0,radius),rand_range(0,50))				
				spawnedAmount += 1
		time = timer
	time-=delta
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
