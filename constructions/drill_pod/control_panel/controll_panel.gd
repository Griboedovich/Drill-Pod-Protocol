extends Node3D

# Базовая реализация, над архитектурой будем задумываться потом

var up_cave_scene = preload("res://constructions/drill_pod/cameras/up_camera/rear_cave.tscn").instantiate()
var side_cave_scene = preload("res://constructions/drill_pod/cameras/side_camera/cave_wall.tscn").instantiate()

var plugs_connection: Dictionary
var current_scene

var first_scenario: Array[String] = ["Camera1Socket", "MainSocket"]
var second_scenario: Array[String] = ["Camera2Socket", "MainSocket"]

var in_camera: bool = false

func _ready() -> void:
	# Переписать в будущем для автоматизации
	# Например добавить get plugs в control cabbel
	self.plugs_connection["FirstPlug"] = "None"
	self.plugs_connection["SecondPlug"] = "None"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit") and in_camera:
		self.get_node("CameraPivot/Camera3D").make_current()
		get_tree().root.remove_child(current_scene)
		get_node("Controllers/DragAndDropController").temporary_disconnect()
		self.show()
		in_camera = false

func _on_plug_connect_with_socket(plug: Plug, socket: Socket) -> void:
	self.plugs_connection[plug.name] = socket.name
	_connect_handler()


func _on_plug_disconnect_with_socket(plug: Plug, socket: Socket) -> void:
	self.plugs_connection[plug.name] = "None"

func _connect_handler():
	var first_channel: String = self.plugs_connection["FirstPlug"]
	var second_channel: String = self.plugs_connection["SecondPlug"]
	if (
		first_channel in first_scenario
		and
		second_channel in first_scenario
	):
		get_tree().root.add_child(up_cave_scene)
		up_cave_scene.get_node("Camera3D").make_current()
		get_node("/root/ControlPanel").hide()
		current_scene = up_cave_scene
		in_camera = true
	if (
		first_channel in second_scenario
		and
		second_channel in second_scenario
	):
		get_tree().root.add_child(side_cave_scene)
		side_cave_scene.get_node("Camera3D").make_current()
		get_node("/root/ControlPanel").hide()
		current_scene = side_cave_scene
		in_camera = true
