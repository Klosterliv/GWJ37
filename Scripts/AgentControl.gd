extends Node

export var agentPath : NodePath
#onready var agentbase = preload("res://Scripts/Objects/Agent.tscn")
export var agentAmount := 5
export var agentSpawnArea := 2

var agentTemplate

var agents = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():	
	
	agentTemplate = get_node(agentPath)
	for n in agentAmount:
		Spawn();
	pass # Replace with function body.

func Spawn():
		
	var newAgent = agentTemplate.create_instance()
	
	#add_child(newAgent)
	
	
	var pos = Vector2(0 + rand_range(-1,1)*agentSpawnArea, 0 + rand_range(-1,1)*agentSpawnArea)
	
	newAgent.position = pos;
#func _process(delta):
#	pass
