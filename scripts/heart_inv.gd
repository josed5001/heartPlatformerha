extends Area2D

signal Rotate
func _on_body_entered(body):
	queue_free()
	Rotate.emit()
