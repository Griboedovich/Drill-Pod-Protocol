class_name Socket extends Node3D

var connect_position: Vector3

var is_active: bool = true

signal plug_entered(plug: Plug, socket: Socket)
signal plug_exited(plug: Plug, socket: Socket)

func _ready() -> void:
	var pivot: Node3D = $Pivot
	self.connect_position = pivot.global_position


func _on_connect_area_body_entered(body: Node3D) -> void:
	if body is Plug and is_active:
		plug_entered.emit(body, self)


func _on_connect_area_body_exited(body: Node3D) -> void:
	if body is Plug and is_active:
		plug_exited.emit(body, self)

func disable() -> void:
	self.is_active = false
	$ConnectArea.set_collision_mask_value(8, false)

func activate() -> void:
	self.is_active = true
	$ConnectArea.set_collision_mask_value(8, true)
