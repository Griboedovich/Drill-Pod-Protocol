extends Node3D

@export var speed: float = 5
@export var gap: float = 0.09

var str_tnl_1: Node3D
var str_tnl_2: Node3D
var crs_tnl: Node3D
var tnl_len: float
#var tnls: Array[Node3D]
var tnls_btwn_crs: int = 2
var tnls_cnt: int = 0
var is_stopped: bool = false

func _ready() -> void:
	#for i in range(self.get_child_count()):
		#tnls.append(self.get_child(i))
	
	str_tnl_1 = $straight_tunnel1
	str_tnl_2 = $straight_tunnel2
	crs_tnl = $cross_tunnel
	str_tnl_1.position = Vector3.ZERO
	str_tnl_2.position = Vector3(0, -tnl_len, 0)
	crs_tnl.position = Vector3(0, -tnl_len * 2, 0)
	tnl_len = 80
	#tnls[0].position = Vector3.ZERO
	#tnls[1].position = Vector3(0, -tnl_len, 0)
	#tnls[2].position = Vector3(0, -tnl_len * 2, 0)

func _process(delta: float) -> void:
	var velocity: Vector3 = Vector3(0, 1, 0) * speed * delta
	
	if tnls_cnt == tnls_btwn_crs:
		str_tnl_1.position += velocity
		str_tnl_2.position += velocity
		crs_tnl.position += velocity
		
	#if tnls_cnt == tnls_btwn_crs:
		#for i in range(3):
			#tnls[i].position += velocity
			#var prv_tnl: Node3D = tnls[(i - 1 + tnls.size()) % tnls.size()]
			#
			#if tnls[i].position.y > tnl_len:
				#tnls[i].position.y = prv_tnl.position.y - tnl_len + gap
		#
	#if tnls_cnt < tnls_btwn_crs:
		#for i in range(2):
			#tnls[i].position += velocity
			#var prv_tnl: Node3D = tnls[(i - 1 + tnls.size()) % tnls.size()]
			#
			#if tnls[i].position.y > tnl_len:
				#tnls[i].position.y = -tnl_len
				#tnls_cnt += 1
	#else:
		#for i in range(3):
			#tnls[i].position += velocity
			#var prv_tnl: Node3D = tnls[(i - 1 + tnls.size()) % tnls.size()]
			#
			#if tnls[i].position.y > tnl_len:
				#tnls[i].position.y = -tnl_len
