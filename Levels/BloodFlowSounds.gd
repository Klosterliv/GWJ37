extends AudioStreamPlayer

onready var cam = get_parent()

func _process(delta):
	pitch_scale = rand_range(0.2,0.3)
	volume_db = int(-cam.zoom.x)%10 + 20
	

