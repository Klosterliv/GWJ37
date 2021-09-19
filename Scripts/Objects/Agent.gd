extends RigidBody2D

export var texture:Texture
export var color:Color

var neighbors = []
var direction := Vector2(0,0)
export var maxSpeed := 10
var target = Vector2(0,0)
var targetRadius = 0
var vel = Vector2(0,0)
var force = Vector2(0,0)
var maxForce = 0.8
var chargeStrength = 40

var hasAttacked := false
var chargeTimer = 0.0
var chargeDelay = 2.0
export var maxHealth := 10.0
var health
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
export var pathFollow := 0.0
var followflow := false
var viewrange := 60
var followpaths := true

var followMouse := false

export var targetSearchInterval := 5.0
export var targetSearchDelay := 10.0
export var neighborUpdateInterval := 1.0
export var steerUpdateInterval := 0.05
var steerTimer = 0.0
var neighborTimer = 0.0
var targetSearchTimer

var debugCircle := false
var targetSearching := false
var targetAgent

var collision_force : Vector2 = Vector2.ZERO
var previous_linear_velocity : Vector2 = Vector2.ZERO

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func SetSize(size):
	#get_node("Sprite").set_texture(...)
	
	get_node("Sprite").scale = (Vector2(size,size))
	get_node("CollisionShape2D").scale = (Vector2(size*4,size*4))
	radius = size*24
	

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if(id == 2):
		SetSize(.8)
	if(id == 4):
		SetSize(1.4)
		radius +=10000
	
	targetSearchTimer = targetSearchDelay + targetSearchInterval
	health = maxHealth
	var mat = get_node("Sprite").get_material().duplicate()
	get_node("Sprite").set_material(mat)
	#$Sprite.set_material(get_material().duplicate())
	$Sprite.material.set_shader_param("Color", color)
	$Sprite.material.set_shader_param("Sprite", texture)
	$Sprite.material.set_shader_param("HP", health/maxHealth)
	set_contact_monitor(true)
	set_max_contacts_reported(20)
	add_to_group("agentgrp")
	pass # Replace with function body.

func UpdateMaterial():
	$Sprite.material.set_shader_param("cooldown", clamp(chargeTimer/chargeDelay,0,1))

func Damage(amount:float):
	health -= amount
	var healthPercent = health/maxHealth
	$Sprite.material.set_shader_param("HP", healthPercent)
	if(healthPercent <= 0.2):
		queue_free()
		return true
	else: 
		return false

func _integrate_forces(state : Physics2DDirectBodyState)->void:

	collision_force = Vector2.ZERO

	if (!hasAttacked && state.get_contact_count() > 0):

		var colls = get_colliding_bodies()
		
			
		for coll in colls:
#			if(id == 0 && coll.is_in_group("agentgrp") && coll.id != id):
#				print(str(colls.size()))
#			if (coll.is_in_group("agentgrp") && coll.position != position):
#				print("zork")
			if (coll.is_in_group("agentgrp") && coll.position != position):
				if(coll.id != id && chargeTimer >= 0):
					
					#var dv : Vector2 = state.linear_velocity - previous_linear_velocity
					var dv : Vector2 =  previous_linear_velocity - state.linear_velocity
					#collision_force = dv / (state.inverse_mass * state.step)
					collision_force = dv
					
					if(coll.id != 0):
						get_parent().Attack(self, coll, collision_force, false)
					pass
			if (coll.is_in_group("barriers")):
				if(coll.id != id && chargeTimer >= 0):
					
					var dv : Vector2 =  previous_linear_velocity - state.linear_velocity
					collision_force = dv
					get_parent().Attack(self, coll, collision_force, false)
				pass

	previous_linear_velocity = state.linear_velocity


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

