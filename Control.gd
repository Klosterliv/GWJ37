extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var mouseCoordLabel : NodePath

func _input(event):
	#get_global_mouse_position()
   # Mouse in viewport coordinates.
	if event is InputEventMouseButton:
	   pass
	elif event is InputEventMouseMotion:
		var globalWorldMousePosition: Vector2 = get_viewport().get_canvas_transform().affine_inverse().xform(get_canvas_transform().xform(get_global_mouse_position()))
#		print(globalWorldMousePosition)
#		globalWorldMousePosition = get_local_mouse_position()
		get_node(mouseCoordLabel).text = str(globalWorldMousePosition)
#		print("Mouse Motion at: ", event.position)
	


# Called when the node enters the scene tree for the first time.
func _ready():
#	mouseCoordLabel = find_node("MouseCoord")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
