extends Node3D
var draggingCollider
var mousePosition
var doDrag

func _input(event: InputEvent) -> void:
	var intersect = get_mouse_intersect(event.position)

	if event is InputEventMouse:
		if intersect: mousePosition = intersect.position

		
	if event is InputEventMouseButton:
		var leftButtonPressed = event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed()
		var leftButtonReleased = event.button_index == MOUSE_BUTTON_LEFT && event.is_released()
		if leftButtonReleased:
			doDrag = false
			drag_and_drop(intersect)
		elif leftButtonPressed:
			doDrag = true
			drag_and_drop(intersect)
		print(intersect)

func _process(delta: float) -> void:
	if draggingCollider:
		draggingCollider.global_position = mousePosition

func drag_and_drop(intersect):
	if !draggingCollider && doDrag:
		draggingCollider = intersect.collider
		draggingCollider.set_collision_layer(false)
	elif draggingCollider:
		draggingCollider.set_collision_layer(true)
		draggingCollider = null
		

func get_mouse_intersect(mousePosition):
	var currentCamera = get_viewport().get_camera_3d()
	var params = PhysicsRayQueryParameters3D.new()
	params.from = currentCamera.project_ray_origin(mousePosition)
	params.to = currentCamera.project_position(mousePosition, 1000)
	
	var worldspace = get_world_3d().direct_space_state
	var result = worldspace.intersect_ray(params)
	
	return result
