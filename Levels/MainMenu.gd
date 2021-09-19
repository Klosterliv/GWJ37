extends Control

onready var animation = $Viewport/Spatial/Aguja/AnimationPlayer
var fadeOut = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/StartButton.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var texture = $Viewport.get_texture()
	$Screen.texture = texture
	if !$Timer.is_stopped() and $Timer.time_left < 0.5:
		$Viewport/Spatial.bigZoom()
		fadeOut = true
	if fadeOut:
		$Black.modulate += Color(0,0,0,0.05)

func _on_StartButton_pressed():
	$Timer.start()
	animation.play("default")
	$VBoxContainer/StartButton/Ouch.play()


#func _on_OptionsButton_pressed():
#	print("Instance an options scene or something here")

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_Timer_timeout():
	get_tree().change_scene("res://Levels/WorldScene.tscn")
