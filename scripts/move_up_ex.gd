extends Node2D

@export var speed = 0
@export var position_end = -85


func _process(delta):
	position.y -= speed * delta
	if position.y <= position_end:
		speed = 0
	
func new_speed():
	speed = 100
func new_speed_b():
	position_end = -400
	speed = 100
func new_speed_c():
	position_end = -1000
	speed = 45
func new_speed_d():
	position_end = -3000
	speed = 200
