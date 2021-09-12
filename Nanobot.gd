extends KinematicBody2D

export var speed = 50

func _physics_process(delta):
	move_and_slide(get_global_mouse_position())

func _look_at_mouse():
	look_at(get_global_mouse_position())
	rotation_degrees = rotation_degrees + 90

func _move_to_mouse():
	var direction = get_global_mouse_position() - position
	move_and_slide(direction)
