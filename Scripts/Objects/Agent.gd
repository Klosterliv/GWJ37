extends KinematicBody2D

var neighbors = []
var direction := Vector2(0,0)
export var maxSpeed := 10
var target = Vector2(0,0)
var targetRadius = 0
var vel = Vector2(0,0)
var force = Vector2(0,0)
var maxForce = 0.8
var chargeStrength = 40

var chargeTimer = 0.0
var chargeDelay = 2.0
export var health := 10.0
export var armor := 5.0
export var id = 0

export var align = true
export var separate = true
export var cohere = true
export var wander = false

export var radius = 1
export var separation := 1.1
export var alignment := 0.4
export var cohesion := 0.5
export var targetseek := 3.0
export var flowfollow := 1.2
var followflow := false
var viewrange := 60
var followpaths := true

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func SetSize(size):
	#get_node("Sprite").set_texture(...)
	get_node("Sprite").scale = (Vector2(size,size))
	radius = size*24
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

