extends Node

signal level_completed #Game completed
signal level_lost      #Game Lost
signal Rotate          #Signal for Rotating the Player Camera
signal rotate_reset    #reset player rotation
signal reset           #Manual Retry
signal position_reset  #Rest any moving Spikes Position when player hits spike
signal stopwatch_start
signal stopwatch_check

var lives = 3
