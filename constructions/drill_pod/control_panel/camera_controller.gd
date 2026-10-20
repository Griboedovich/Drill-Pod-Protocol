extends Node3D

@export var camera_angle = deg_to_rad(20)

var is_ready = false
var camera_pivot: Node3D
var pivot_base_rotation

@onready var viewport_size: Vector2 = get_viewport().size

func _input(event: InputEvent) -> void:
	if (camera_pivot == null):
		camera_pivot = $"../CameraPivot"
		return
	if (pivot_base_rotation == null):
		pivot_base_rotation = camera_pivot.rotation
		return
		
		
		
	if event is InputEventMouseMotion:
		var mouse_position: Vector2 = event.position
		var coff = (mouse_position / viewport_size) - Vector2(0.5, 0.5)
		camera_pivot.rotation.x = pivot_base_rotation.x + camera_angle *  coff.y
		camera_pivot.rotation.z = pivot_base_rotation.z + camera_angle * 16/9 *  -coff.x
		
