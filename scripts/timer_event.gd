extends Node

var time_clock = Timer.new()
var is_running = false
var elapsed_time = 0.0

@onready var insta_kill = $Insta_Kill
@onready var spikes_long = $SpikesLong

func _ready():
	time_clock.wait_time = 1
	time_clock.autostart = false
	time_clock.one_shot = false
	add_child(time_clock)
	Events.stopwatch_start.connect(start_clock)
	Events.stopwatch_check.connect(clock_check)
	

func _process(delta):
	if is_running:
		_on_Timer_timeout()
		print(elapsed_time)

func _on_Timer_timeout():
	elapsed_time += time_clock.wait_time / 100
	
func start_clock():
	is_running = true
	time_clock.start()

func clock_check():
	if elapsed_time >= 1.7 and elapsed_time <= 1.84:
		insta_kill.new_speed()
