extends StaticBody2D

export var polyvisual : NodePath
export var maxHealth := 1500.0
var health
var healthVisual
var id = -1
export var armor = 120.0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	health = maxHealth
	healthVisual = maxHealth
	add_to_group("barriers")
	
	var mat = get_node(polyvisual).get_material().duplicate()
	get_node(polyvisual).set_material(mat)
	
	get_node(polyvisual).material.set_shader_param("HP", 1)
	#$Sprite.set_material(get_material().duplicate())
	#$Sprite.material.set_shader_param("Color", color)
	#$Sprite.material.set_shader_param("Sprite", texture)
	#$Sprite.material.set_shader_param("HP", health/maxHealth)
	
	
	pass # Replace with function body.
	
func Damage(amount:float):
	health -= amount
	var healthPercent = health/maxHealth
	#get_node(polyvisual).material.set_shader_param("HP", healthPercent)
	if(healthPercent <= 0.2):
		queue_free()
		return true
	else: 
		return false

func _process(delta):
	if (abs(healthVisual-health)>0.02):
		healthVisual = lerp(healthVisual, health, delta*5)
		healthVisual = clamp(healthVisual,0,maxHealth)
		var healthPercent = healthVisual/maxHealth
		get_node(polyvisual).material.set_shader_param("HP", healthPercent)
		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
