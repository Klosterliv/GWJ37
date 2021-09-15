extends Camera2D

export var defaultZoom := 3.0
export var zoomStep := 0.2

func _ready():
	zoom = Vector2(defaultZoom, defaultZoom)

func _unhandled_input(event):
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_DOWN:
			change_zoom(zoomStep)
		if event.button_index == BUTTON_WHEEL_UP:
			change_zoom(-zoomStep)
	if event is InputEventMouseMotion and event.button_mask == BUTTON_MASK_MIDDLE:
		move_camera(event.relative)

func change_zoom(dz: float):
	defaultZoom = clamp(defaultZoom + dz, 0.1, 8.0)
	zoom = Vector2(defaultZoom, defaultZoom)

func move_camera(dv: Vector2):
	offset -= dv*zoom
