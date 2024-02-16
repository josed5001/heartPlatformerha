extends Node2D

class_name MainWorld

var level_time = 0.0
var start_level_msec = 0.0

var lives = 3 #custom
var SpikesPos: Vector2 = Vector2(-112, 48)



@export var next_level: PackedScene
@onready var level_completed = $CanvasLayer/LevelCompleted
@onready var level_lost = $CanvasLayer/LevelLost
@onready var start_in = %StartIn
@onready var start_in_label = %StartInLabel
@onready var animation_player = $AnimationPlayer
@onready var level_time_label = %LevelTimeLabel

@onready var lives_count = $CanvasLayer/VBoxContainer/LivesCount
@onready var hearts_left = $CanvasLayer/VBoxContainer/HeartsLeft

@onready var spikes_move = $SpikesMove
@onready var player = $Player



func _ready():
	if not next_level is PackedScene:
		level_completed.next_level_button.text = "Victory Scren"
		next_level = load("res://scenes/victory_screen.tscn")
	Events.level_completed.connect(show_level_completed)
	Events.level_lost.connect(show_level_lost)
	Events.Rotate.connect(rotate_camera)
	get_tree().paused = true
	start_in.visible = true
	LevelTransition.fade_from_black()
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
	var heart_group = get_tree().get_nodes_in_group("Hearts")
	var hearts = heart_group.size()
	hearts_left.text = "Hearts Remain: " + str(hearts)
	


func retry():
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	get_tree().change_scene_to_file(scene_file_path)
	

func go_to_next_level():
	if not next_level is PackedScene: return
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	get_tree().change_scene_to_packed(next_level)
	
func go_to_main_menu():
	get_tree().paused = false
	next_level = load("res://scenes/start_menu.tscn")
	get_tree().change_scene_to_packed(next_level)
	
func show_level_completed():
	level_completed.show()
	level_completed.next_level_button.grab_focus()
	get_tree().paused = true
	
func show_level_lost():
	level_lost.show()
	level_lost.lose_retry_button.grab_focus()
	get_tree().paused = true
	
func _on_level_completed_next_level():
	go_to_next_level()

func _on_level_completed_retry():
	retry()

func _on_level_lost_main_menu():
	go_to_main_menu()

func _on_level_lost_lose_retry():
	retry()

func _on_player_lives_hit():
	lives -= 1
	lives_count.text = "Lives: " + str(lives)
	if spikes_move:
		spikes_move.position = SpikesPos
	if lives == 0:
		Events.level_lost.emit()

func rotate_camera():
	var angle = randi_range(45, 300)
	var camera = player.get_node("Camera2D")
	angle = deg_to_rad(angle)
	camera.rotation = angle
