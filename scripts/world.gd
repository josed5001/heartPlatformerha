extends Node2D

class_name MainWorld

var level_time = 0.0
var start_level_msec = 0.0
var lives = Events.lives
var is_rotating = false

@export var next_level: PackedScene
@onready var level_completed = $CanvasLayer/LevelCompleted
@onready var level_lost = $CanvasLayer/LevelLost
@onready var start_in = %StartIn
@onready var start_in_label = %StartInLabel
@onready var animation_player = $AnimationPlayer
@onready var level_time_label = %LevelTimeLabel

@onready var lives_count = $CanvasLayer/VBoxContainer/LivesCount
@onready var hearts_left = $CanvasLayer/VBoxContainer/HeartsLeft

@onready var player = $Player



func _ready():
	if not next_level is PackedScene:
		level_completed.next_level_button.text = "Victory Scren"
		next_level = load("res://scenes/victory_screen.tscn")
	Events.level_completed.connect(show_level_completed)
	Events.level_lost.connect(show_level_lost)
	Events.Rotate.connect(rotate_camera)
	Events.rotate_reset.connect(rotate_reset)
	Events.rotate_reset.connect(_on_player_lives_hit)
	Events.reset.connect(retry)
	Events.player_rotation.connect(player_rotated)
	get_tree().paused = true
	start_in.visible = true
	LevelTransition.fade_from_black()
	animation_player.play("countdown")
	await animation_player.animation_finished
	get_tree().paused = false
	start_in.visible = false
	start_level_msec = Time.get_ticks_msec()
	Events.stopwatch_start.emit()
	lives_count.text = "Lives: " + str(lives) #custom
	

func _process(delta):
	level_time = Time.get_ticks_msec() - start_level_msec
	level_time_label.text = str(level_time / 1000.0)
	clock_checker()
	heart_count()
	do_rotate()
	
func heart_count():
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
	hearts_left.hide()
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
	if lives == 0:
		Events.level_lost.emit()

func rotate_camera():
	var angle = randi_range(45, 300)
	var camera = player.get_node("Camera2D")
	angle = deg_to_rad(angle)
	camera.rotation = angle

func rotate_reset():
	var camera = player.get_node("Camera2D")
	camera.rotation = 0
	
func clock_checker():
	if not level_time >= 2000 and level_time <= 2010: pass
	else: Events.stopwatch_check.emit()
	if not level_time >= 11900 and level_time <= 11920: pass
	else: Events.stopwatch_check.emit()
	if not level_time >= 18880 and level_time <= 18890: pass
	else: Events.stopwatch_check.emit()
	if not level_time >= 38000 and level_time <= 38050: pass
	else: Events.stopwatch_check.emit()
	
func player_rotated():
	is_rotating = true
func do_rotate():
	if not is_rotating: pass
	else:
		var camera = player.get_node("Camera2D")
		if Input.is_action_pressed("action_left"):
			camera.rotation -= 0.01
		if Input.is_action_pressed("action_right"):
			camera.rotation += 0.01
		if Input.is_action_just_pressed("action_r_reset"):
			camera.rotation = 0
