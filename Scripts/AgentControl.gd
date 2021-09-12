extends Node

export var agent : NodePath
export var agentAmount := 5
export var agentSpawnArea := 2

var agents = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Spawn();
	pass # Replace with function body.

func Spawn():
	var newAgent = get_node(agent).create_instance()
	var position = Vector2(1,1)
	newAgent.position = Vector2(position.x + rand_range(-1,1)*agentSpawnArea, position.y + rand_range(-1,1)*agentSpawnArea);

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
