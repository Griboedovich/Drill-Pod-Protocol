extends Node

@export var ray_lenght: int = 1000
@export var object_on_floor_height: float = 0.5
@export var mouse_to_object_velocity_ratio: float = 0.005
@export var is_drop_velocity_mod: bool = true
@export_flags_3d_physics var drop_object_collision_mask: int = 64
@export_flags_3d_physics var drag_object_collision_mask: int = 128
@export_flags_3d_physics var ground_collision_mask: int = 0x0001

@onready var camera: Camera3D = get_node("/root/ControlPanel/CameraPivot/Camera3D")

var mouse_position: Vector2
var last_mouse_velocity: Vector2
var dragging_object: Plug
var connectable_socket: Socket

var is_dragging: bool = false
var is_connecting: = false
var on_update_mouse_intersect: bool = false
var on_drag: bool = false
var on_drop: bool = false

signal on_plug_connect_with_socket(
	plug: Plug,
	socket: Socket
)

signal on_plug_disconnect_with_socket(
	plug: Plug,
	socket: Socket
)

func _ready() -> void:
	var sockets = get_node("/root/ControlPanel/Sockets").get_children()
	for socket in sockets:
		if socket is Socket:
			socket.plug_entered.connect(_on_socket_plug_entered)
			socket.plug_exited.connect(_on_socket_plug_exited)

func _input(event: InputEvent) -> void:
	print(1)
	if event.is_action_pressed("drag_and_drop"):
		# Чтобы не было ситуациия, что on_drug and on_drop it's true
		self.on_drag = true
		self.on_drop = false
	if event.is_action_released("drag_and_drop"):
		self.on_drag = false
		self.on_drop = true
	if event is InputEventMouseMotion:
		mouse_position = event.position
		last_mouse_velocity = event.velocity

func _physics_process(delta: float) -> void:
	var ray_from_to_points: Array[Vector3]
	var intersect_info: Dictionary
	if self.on_drag:
		ray_from_to_points = get_camera_ray_points()
		intersect_info = get_mouse_intersect(
			ray_from_to_points[0],
			ray_from_to_points[1],
			self.drop_object_collision_mask
		)
		self.on_drag = false
		if not intersect_info.is_empty() and intersect_info.collider is Plug:
			_drag_object(intersect_info.collider)
			
	if self.on_drop:
		self.on_drop = false
		if is_dragging:
			_drop_object()
	if is_dragging:	
		var floor_intersect_position: Vector3
		var offset_direction: Vector3
		var object_position: Vector3
		ray_from_to_points = get_camera_ray_points()
		intersect_info = get_mouse_intersect(
			ray_from_to_points[0],
			ray_from_to_points[1],
			self.ground_collision_mask
		)
		floor_intersect_position = intersect_info.position
		offset_direction = (
			(ray_from_to_points[0]
			- floor_intersect_position
			).normalized()
		)
		object_position = ( 
			floor_intersect_position
			+ offset_direction
			* self.object_on_floor_height
		)
		
		dragging_object.global_position = object_position


func _drag_object(object: Plug):
	self.dragging_object = object
	self.dragging_object.angular_velocity = Vector3.ZERO
	self.dragging_object.set_collision_layer(drag_object_collision_mask)
	if dragging_object.is_freeze_enabled():
		# Нужно выделить в отдельную функцию дисконекта
		dragging_object.set_freeze_enabled(false)
		dragging_object.connected_socket.activate()
		on_plug_disconnect_with_socket.emit(
			dragging_object,
			dragging_object.connected_socket
		)
		dragging_object.connected_socket = null
	
	self.is_dragging = true

func _drop_object():
	if is_connecting:
		connectable_socket.disable()
		dragging_object.global_position = connectable_socket.connect_position
		dragging_object.global_rotation = Vector3.ZERO
		dragging_object.set_collision_layer(self.drop_object_collision_mask)
		dragging_object.set_freeze_enabled(true)
		dragging_object.connected_socket = connectable_socket

		on_plug_connect_with_socket.emit(dragging_object, connectable_socket)

		self.is_connecting = false
		connectable_socket = null
		self.dragging_object = null
		self.is_dragging = false
		return
	
	if is_drop_velocity_mod:
		dragging_object.linear_velocity = Vector3(
			self.last_mouse_velocity.x,
			0,
			self.last_mouse_velocity.y
		) * mouse_to_object_velocity_ratio

	dragging_object.set_collision_layer(self.drop_object_collision_mask)
	self.dragging_object = null
	self.is_dragging = false
	

func get_camera_ray_points() -> Array[Vector3]:
	var from: Vector3 = self.camera.project_ray_origin(self.mouse_position) 
	var to: Vector3 = self.camera.project_position(
		self.mouse_position,
		self.ray_lenght
	)
	return [from, to]

func get_mouse_intersect(
	from_point: Vector3,
	to_point: Vector3,
	search_collision_mask: int
	)-> Dictionary:
	
	var intersect_info: Dictionary
	var space_state: PhysicsDirectSpaceState3D =(
	get_node("/root/ControlPanel").get_world_3d().direct_space_state)
	var query: PhysicsRayQueryParameters3D =(
	PhysicsRayQueryParameters3D.new())

	query.collision_mask = search_collision_mask
	query.from = from_point
	query.to = to_point

	intersect_info = space_state.intersect_ray(query)
	return intersect_info


func _on_socket_plug_entered(plug: Plug, socket: Socket) -> void:
	if is_dragging and dragging_object == plug:
		connectable_socket = socket
		self.is_connecting = true

func _on_socket_plug_exited(plug: Plug, socket: Socket) -> void:
	if is_connecting and connectable_socket == socket:
		connectable_socket = null
		self.is_connecting = false
		
# Перепиши этот ужас, его не должно существовать!!!
func temporary_disconnect():
		dragging_object = get_node("/root/ControlPanel/ControllCable").get_child(0)
		dragging_object.set_freeze_enabled(false)
		dragging_object.connected_socket.activate()
		on_plug_disconnect_with_socket.emit(
			dragging_object,
			dragging_object.connected_socket
		)
		dragging_object.connected_socket = null
		dragging_object.global_position = Vector3(0, 1, 0)
		dragging_object = null
