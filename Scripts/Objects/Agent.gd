extends KinematicBody2D

var neighbors = []
var direction := Vector2(0,0)
var maxSpeed := 10.0
var target = Vector2(0,0)
var vel = Vector2(0,0)
var force = Vector2(0,0)
var maxForce = 0.8
var normalPoint = Vector2(0,0)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

