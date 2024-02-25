extends Node2D

@export var speed = 0
@export var position_end = -50


func _process(delta):
	position.y -= speed * delta
	if position.y <= position_end:
		speed = 0
	
func new_speed():
	speed = 100
