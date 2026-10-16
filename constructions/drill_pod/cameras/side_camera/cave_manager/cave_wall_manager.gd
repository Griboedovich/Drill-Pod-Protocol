extends Node3D

@export var speed: float = 5
@export var gap: float = 0.1

var tunnel_1: Node3D
var tunnel_1_lenght: float
var tunnel_2_lenght: float
var tunnel_2: Node3D

func _ready() -> void:
	tunnel_1 = $CaveWall1
	tunnel_2 = $CaveWall2
	#tunnel_1_lenght = tunnel_1.get_child(0).get_aabb().size.y
	#tunnel_2_lenght = tunnel_1.get_child(0).get_aabb().size.y
	tunnel_1_lenght = 40.5
	tunnel_2_lenght = 40.5
	tunnel_2.position = Vector3(0, -tunnel_2_lenght, 0)
	print(tunnel_1.get_child(0).get_aabb())

func _process(delta: float) -> void:
	var velocity: Vector3 = Vector3(0, 1, 0) * speed * delta
	tunnel_1.position += velocity
	tunnel_2.position += velocity
	
	if tunnel_1.position.y > tunnel_2_lenght:
		tunnel_1.position.y = -tunnel_1_lenght + gap
	elif tunnel_2.position.y > tunnel_1_lenght:
		tunnel_2.position.y = -tunnel_2_lenght
