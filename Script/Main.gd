extends Node2D



func _ready():
	pass # Replace with function body.

func restart():
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func _process(delta):
	pass
