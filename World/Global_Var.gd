extends Node3D


var gem: int = 0
var can_interact: bool = true
var interact_wait: bool = false

var timer = 1

func _process(_delta: float):
	if interact_wait:
		if timer > 0:
			timer -= _delta
		if timer <= 0:
			timer = 0
			interact_wait = false
			await get_tree().create_timer(0.5).timeout
			timer = 1
