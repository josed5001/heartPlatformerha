extends Node2D

class_name MainWorld

var level_time = 0.0
var start_level_msec = 0.0
var lives = 3 #custom
@export var next_level: PackedScene
@onready var level_completed = $CanvasLayer/LevelCompleted
@onready var start_in = %StartIn
@onready var start_in_label = %StartInLabel
@onready var animation_player = $AnimationPlayer
@onready var level_time_label = %LevelTimeLabel
@onready var lives_count = $CanvasLayer/VBoxContainer/LivesCount



func _ready():
	Events.level_completed.connect(show_level_completed)
	get_tree().paused = true
	start_in.visible = true
	await LevelTransition.fade_from_black()
	animation_player.play("countdown")
	await animation_player.animation_finished
	get_tree().paused = false
	start_in.visible = false
	start_level_msec = Time.get_ticks_msec()
	print(start_level_msec)
	lives_count.text = "Lives: " + str(lives) #custom 

func _process(delta):
	level_time = Time.get_ticks_msec() - start_level_msec
	level_time_label.text = str(level_time / 1000.0)


func retry():
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	get_tree().change_scene_to_file(scene_file_path)
	

func go_to_next_level():
	if not next_level is PackedScene: return
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	get_tree().change_scene_to_packed(next_level)
	
func show_level_completed():
	level_completed.show()
	level_completed.retry_button.grab_focus()
	get_tree().paused = true
	

func _on_level_completed_next_level():
	go_to_next_level()

func _on_level_completed_retry():
	retry()


func _on_player_lives_hit():
	lives -= 1
	lives_count.text = "Lives: " + str(lives)
	if lives == 0:
		#will get changed to a gameover screen
		get_tree().quit()
		
