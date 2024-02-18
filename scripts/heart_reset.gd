extends Area2D

@onready var animation_player = $AnimationPlayer

func _process(delta):
	animation_player.play("Float")


func _on_body_entered(body):
	queue_free()
	Events.rotate_reset.emit()
