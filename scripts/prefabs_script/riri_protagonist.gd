# Author: Amin
# This script is hardcoded for the case of cutscene playing the animation.
# Modify with caution and keep that in mind

extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $protagonist_riri/AnimationPlayer

func play_run_anim():
	animation_player.play("AnimPack1/run")
