extends Node3D

@export var speed: float = 5
@export var gap: float = 0.09

var tnl_len: float
var tnls: Array[Node3D]
var isStopped: bool = false

func _ready() -> void:
	tnls.append($straight_tunnel1)
	tnls.append($straight_tunnel2)
	tnls.append($cross_tunnel)
	tnl_len = 80
	tnls[0].position = Vector3.ZERO
	tnls[1].position = Vector3(0, -tnl_len, 0)
	tnls[2].position = Vector3(0, -tnl_len * 2, 0)

func _process(delta: float) -> void:
	var velocity: Vector3 = Vector3(0, 1, 0) * speed * delta
	
	if not isStopped:
		for i in range(tnls.size()):
			tnls[i].position += velocity
			var prv_tnl: Node3D = tnls[(i - 1 + tnls.size()) % tnls.size()]
			
			if tnls[i].position.y > tnl_len * 2:
				tnls[i].position.y = prv_tnl.position.y - tnl_len
				
				if prv_tnl == $cross_tunnel:
					tnls[i].position.y += gap
					
				print(tnls[i].position.y, " ", prv_tnl.position.y)
			
			if tnls[i] == $cross_tunnel:
				#prv_tnl.position
				if tnls[i].position.y < 0.05 and tnls[i].position.y > -0.05:
					#isStopped = true
					pass
