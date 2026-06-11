extends Node
class_name EnemyPatrolChaseComponent

signal player_captured
signal chase_started
signal chase_ended

@export var enemy: CharacterBody3D
@export var player: CharacterBody3D
@export var path_follow: PathFollow3D

@export var walk_speed: float = 3.0
@export var run_speed: float = 5.0
@export var capture_distance: float = 1.0

var current_speed: float
var forward := true
var is_chasing := false
var captured := false


func _ready() -> void:
	current_speed = walk_speed


func _physics_process(delta: float) -> void:
	if not is_instance_valid(enemy) or not is_instance_valid(player) or not is_instance_valid(path_follow):
		return

	_update_path_progress(delta)
	_update_chase_state()
	_move_enemy()
	_check_capture()


func _update_path_progress(delta: float) -> void:
	if not forward:
		path_follow.progress -= delta * current_speed
	else:
		path_follow.progress += delta * current_speed

	if path_follow.progress_ratio >= 1.0:
		forward = false
	elif path_follow.progress_ratio <= 0.0 and not forward:
		forward = true


func _update_chase_state() -> void:
	var was_chasing := is_chasing
	if enemy.has_method("can_see_player") and enemy.can_see_player(player):
		is_chasing = true
		current_speed = run_speed
		if enemy.has_method("play_run_anim"):
			enemy.play_run_anim()
	else:
		is_chasing = false
		current_speed = walk_speed
		if enemy.has_method("play_walk_anim"):
			enemy.play_walk_anim()

	if is_chasing and not was_chasing:
		chase_started.emit()
	elif was_chasing and not is_chasing:
		chase_ended.emit()


func _move_enemy() -> void:
	var target_pos = player.global_position if is_chasing else path_follow.global_position
	var dir = Vector3(
		target_pos.x - enemy.global_position.x,
		0,
		target_pos.z - enemy.global_position.z
	).normalized()

	if dir.length() > 0:
		target_pos.y = enemy.global_position.y
		enemy.look_at(target_pos)
		enemy.rotate_y(PI)
		enemy.velocity.x = current_speed * dir.x
		enemy.velocity.z = current_speed * dir.z

	enemy.move_and_slide()


func _check_capture() -> void:
	if captured or not is_chasing:
		return

	if enemy.global_position.distance_to(player.global_position) < capture_distance:
		captured = true
		player_captured.emit()
