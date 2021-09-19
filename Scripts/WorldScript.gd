extends Node2D

var Game_Title = "NanoBiotic"

func _process(_delta):
	OS.set_window_title(Game_Title + " | fps: " + str(Engine.get_frames_per_second()))
