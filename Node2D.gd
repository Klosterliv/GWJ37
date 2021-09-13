extends Node2D

const ZOOM_STEP := 0.1
export var cameraZoom := 3.0

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_DOWN:
			change_zoom(ZOOM_STEP)
		if event.button_index == BUTTON_WHEEL_UP:
			change_zoom(-ZOOM_STEP)
	if event is InputEventMouseMotion and event.button_mask == BUTTON_MASK_MIDDLE:
		move_camera(event.relative)

func change_zoom(dz: float):
	cameraZoom = clamp(cameraZoom + dz, 0.1, 8.0)
	$Camera2D.zoom = Vector2(cameraZoom, cameraZoom)

func move_camera(dv: Vector2):
	$Camera2D.offset -= dv

