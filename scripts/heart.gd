extends Area2D

@onready var animation_player = $AnimationPlayer

func _process(delta):
	animation_player.play("Movement")

func _on_body_entered(body):
	queue_free()
	var hearts = get_tree().get_nodes_in_group("Hearts")
	if hearts.size() == 1:
		Events.level_completed.emit()

