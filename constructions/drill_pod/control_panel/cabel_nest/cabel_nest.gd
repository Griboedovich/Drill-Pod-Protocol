extends Node3D

signal body_entered(body: Node3D)
signal body_exited(body: Node3D)

func _on_area_3d_body_entered(body: Node3D) -> void:
	body_entered.emit(body)


func _on_area_3d_body_exited(body: Node3D) -> void:
	body_exited.emit(body)
