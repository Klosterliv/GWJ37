extends Area2D

export var playMusic = true
export var musicPath : NodePath
export var spawnerPath : NodePath

var music
var spawner

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#func _on_Area2D_body_entered(body):
#	if body.is_in_group("agentgrp"):
#		if (body.id == 0):
#			print("triggered!")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	music = get_node(musicPath)
	spawner = get_node(spawnerPath)
	
	pass # Replace with function body.

func _physics_process(delta):
	var overlaps = get_overlapping_bodies()
	if (overlaps.size() > 0):
		for o in overlaps:
			if (o.is_in_group("agentgrp") && o.id == 0):
				if (playMusic):
					music.play()
				spawner.enabled = true
				queue_free()
					
				

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
