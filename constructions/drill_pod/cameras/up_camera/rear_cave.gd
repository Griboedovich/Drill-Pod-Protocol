extends Node3D

@export var enemy_scene: PackedScene
@export var speed_range: Vector2 = Vector2(1, 5)
@export var enemy_direction: Vector3 = Vector3(0, 0, 1)

@onready var enemy_spawn_timer: Timer = $"EnemySpawnTimer"
@onready var enemy_spawn_location: PathFollow3D =(
	$EnemySpawnPath/EnemySpawnLocation
)
@onready var ray = $Camera3D/RayCast3D

const RAY_LENGTH = 30

func _on_enemy_spawn_timer_timeout() -> void:
	var speed = randf_range(speed_range.x, speed_range.y)
	var enemy: Enemy = enemy_scene.instantiate()
	enemy_spawn_location.progress_ratio = randf()
	enemy.position = enemy_spawn_location.position + Vector3(0, 0, -60)
	enemy.speed = speed
	enemy.direction = enemy_direction
	add_child(enemy)

func _physics_process(delta: float) -> void:
	var cam = $Camera3D
	var mousePos = get_viewport().get_mouse_position()
	
	if Input.is_action_just_pressed("shoot"):
		ray.target_position = cam.project_ray_normal(mousePos) * RAY_LENGTH
		ray.force_raycast_update()
		
		if ray.is_colliding() and ray.get_collider().is_class("StaticBody3D"):
				ray.get_collider().get_parent().free()
