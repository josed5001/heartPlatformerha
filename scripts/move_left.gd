extends Node2D

@export var speed = 100
@export var position_start = 450
@export var position_end = -450


func _process(delta):
	position.x -= speed * delta
	if position.x <= position_end:
		position.x = position_start
