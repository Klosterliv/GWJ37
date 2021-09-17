extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var ChargeRadius = 400

export var mouseCoordLabel : NodePath
export var agentControl : NodePath
export var flowMapLabel : NodePath

func _process(delta): 
	if (Input.is_mouse_button_pressed(BUTTON_LEFT)):
		#var globalWorldMousePosition: Vector2 = get_viewport().get_canvas_transform().affine_inverse().xform(get_canvas_transform().xform(get_global_mouse_position()))
		get_node(agentControl).FollowMouse(true)
	else:
		get_node(agentControl).FollowMouse(false)
		
func _input(event):
	var globalWorldMousePosition: Vector2 = get_viewport().get_canvas_transform().affine_inverse().xform(get_canvas_transform().xform(get_global_mouse_position()))
	#get_global_mouse_position()
   # Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		if event.button_index == 1:
			get_node(agentControl).mousePos = globalWorldMousePosition
			get_node(agentControl).FollowMouse(true)
		elif event.button_index == 2:
			get_node(agentControl).ChargeAt(globalWorldMousePosition, ChargeRadius)
			$AttackSound.position = globalWorldMousePosition
			$AttackSound.play()
	elif event is InputEventMouseMotion:		
#		print(globalWorldMousePosition)
#		globalWorldMousePosition = get_local_mouse_position()
		get_node(mouseCoordLabel).text = str(globalWorldMousePosition)
		get_node(agentControl).mousePos = globalWorldMousePosition
		get_node(flowMapLabel).text = str(get_node(agentControl).fieldAtPoint(globalWorldMousePosition))+ ": " +str(get_node(agentControl).flowAtPoint(globalWorldMousePosition))
		
	else:
		get_node(agentControl).FollowMouse(false)
#		print("Mouse Motion at: ", event.position)
	


# Called when the node enters the scene tree for the first time.
func _ready():
#	mouseCoordLabel = find_node("MouseCoord")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_AttackSound_finished():
	$AttackSound.playing = false
