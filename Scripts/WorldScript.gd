extends Node2D

var Game_Title = "Wonder-Drug"

func _process(_delta):
	OS.set_window_title(Game_Title + " | fps: " + str(Engine.get_frames_per_second()))
