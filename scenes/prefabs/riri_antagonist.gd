# Author: Amin
# This script is hardcoded for the case of cutscene playing the animation.
# Modify with caution and keep that in mind

extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $antagonist_riri/AnimationPlayer
@onready var eyes: Camera3D = $Camera3D
@onready var vision_cast: RayCast3D = $RayCast3D

@export var max_view_distance: float = 20.0

func play_run_anim():
	animation_player.play("AnimPack1/run")


func play_walk_anim():
	animation_player.play("AnimPack1/walk")


func is_in_los(player_pos) -> bool:
	if not eyes.is_position_in_frustum(player_pos):
		return false
	return true

func can_see_player(player: CharacterBody3D) -> bool:
	var player_view_pos = player.global_position + Vector3.UP
	if not is_in_los(player_view_pos):
		return false
	
	if global_position.distance_to(player_view_pos) > max_view_distance:
		return false
	
	vision_cast.target_position = vision_cast.to_local(player_view_pos)
	vision_cast.force_raycast_update()
	
	if vision_cast.is_colliding():
		var collider = vision_cast.get_collider()
		if collider == player:
			return true
	
	return false
	
	
