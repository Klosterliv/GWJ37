extends Camera2D

export var defaultZoom := 3.0
export var zoomStep := 0.2

export var zoomMin := 0.1
export var zoomMax := 8.0

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
	defaultZoom = clamp(defaultZoom + dz, zoomMin, zoomMax)
	#zoom = Vector2(defaultZoom, 1)

func move_camera(dv: Vector2):
	offset -= dv*zoom

func _process(delta):
	var newZoom = lerp(zoom.x, defaultZoom, delta*10)
	zoom = Vector2(newZoom, newZoom)
	
	if Input.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://Levels/GameOver.tscn")
