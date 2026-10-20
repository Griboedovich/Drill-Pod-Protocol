extends Node3D

@export var speed: float = 5
@export var gap: float = 0.04 

var tunnel_1: Node3D
var tunnel_1_lenght: int
var tunnel_2_lenght: int
var tunnel_2: Node3D

func _ready() -> void:
	tunnel_1 = $rear_cave_tunnel_1
	tunnel_2 = $rear_cave_tunnel_2
	#tunnel_1_lenght = tunnel_1.get_child(0).get_aabb().size.y
	#tunnel_2_lenght = tunnel_1.get_child(0).get_aabb().size.y
	#print((tunnel_1.get_aabb() * tunnel_1.global_transform).size.y)
	tunnel_1_lenght = 60
	tunnel_2_lenght = 60
	tunnel_2.position = Vector3(0, 0, tunnel_2_lenght-gap)
	print(tunnel_1.get_child(0).get_aabb())

func _process(delta: float) -> void:
	var velocity: Vector3 = Vector3(0, 0, -1) * speed * delta
	tunnel_1.position += velocity
	tunnel_2.position += velocity
	
	if tunnel_1.position.z < -tunnel_2_lenght:
		tunnel_1.position.z = tunnel_1_lenght - 2 * gap
	elif tunnel_2.position.z < -tunnel_1_lenght:
		tunnel_2.position.z = tunnel_2_lenght - gap

		
		
		
		
