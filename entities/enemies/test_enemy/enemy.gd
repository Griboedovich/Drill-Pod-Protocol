class_name Enemy extends Node3D

var direction: Vector3
var speed: float

func _process(delta: float) -> void:
	var velocity = speed * delta * direction
	position += velocity

func _on_screen_exited() -> void:
	self.queue_free()
