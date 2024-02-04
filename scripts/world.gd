extends Node2D

@onready var level_completed = $CanvasLayer/LevelCompleted


func _ready():
	#Visual Polygon appearance
	RenderingServer.set_default_clear_color(Color.BLACK)
	Events.level_completed.connect(show_level_completed)
	
func show_level_completed():
	level_completed.show()
	get_tree().paused = true
