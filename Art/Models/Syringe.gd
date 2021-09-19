extends Spatial

onready var fov = $Camera.fov
var started = false

func bigZoom():
	started = true

func _process(delta):
	if started:
		$Camera.fov -= 1
