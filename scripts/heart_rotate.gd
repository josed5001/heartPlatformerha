extends Area2D


@onready var animation_player = $AnimationPlayer

func _process(delta):
	animation_player.play("Movement")

func _on_body_entered(body):
	queue_free()
	Events.player_rotation.emit()
