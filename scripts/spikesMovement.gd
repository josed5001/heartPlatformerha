extends Node2D


@onready var startingPos = global_position
@export var speed = 40

func _ready():
	Events.position_reset.connect(reset_position)

func _process(delta):
	position.y -= speed * delta
	
func reset_position():
	global_position = startingPos
