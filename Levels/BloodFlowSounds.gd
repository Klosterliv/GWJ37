extends AudioStreamPlayer

onready var cam = get_parent()

func _process(delta):
	pitch_scale = rand_range(0.5,1.5)
	volume_db = int(-cam.zoom.x)%10 + 5
	

