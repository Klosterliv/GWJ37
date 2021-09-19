extends Control

func _ready():
	$Timer.start()

func _process(delta):
	if $Polygon2D.position.y < 40:
		$Polygon2D.position.y += 60
	else:
		$Polygon2D/Label.modulate -= Color(0,0,0,0.5*delta)
	
	
	if $Timer.time_left == 0:
		get_tree().change_scene("res://Levels/MainMenu.tscn")
	
