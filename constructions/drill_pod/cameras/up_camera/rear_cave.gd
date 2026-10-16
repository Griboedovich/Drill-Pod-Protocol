extends Node3D

@export var enemy_scene: PackedScene
@export var speed_range: Vector2 = Vector2(1, 5)
@export var enemy_direction: Vector3 = Vector3(0, 0, 1)

@onready var enemy_spawn_timer: Timer = $"EnemySpawnTimer"
@onready var enemy_spawn_location: PathFollow3D =(
	$EnemySpawnPath/EnemySpawnLocation
)

func _on_enemy_spawn_timer_timeout() -> void:
	var speed = randf_range(speed_range.x, speed_range.y)
	var enemy: Enemy = enemy_scene.instantiate()
	enemy_spawn_location.progress_ratio = randf()
	enemy.position = enemy_spawn_location.position + Vector3(0, 0, -60)
	enemy.speed = speed
	enemy.direction = enemy_direction
	add_child(enemy)
