# Author amin
# This code is simple
# I don't care anymore. Let it be simple

extends Node3D

@onready var riri_antagonist: CharacterBody3D = $RiriAntagonist
@onready var riri_protagonist: CharacterBody3D = $CharacterBody3D
@onready var panic_music: AudioStreamPlayer = $PanicMusic
@onready var camera_3d: Camera3D = $Camera3D

const next_scene = "res://scenes/world/chapter_1_placeholder.tscn"
#const next_scene = "res://scenes/world/test_world.tscn"

var rotated: bool = false
var change_scene_timer = 1.0

func _ready() -> void:
	panic_music.volume_db = SettingsManager.bgm_db
	panic_music.play(1.5)

func _physics_process(delta: float) -> void:
	
	if riri_antagonist.has_method('play_run_anim') and riri_protagonist.has_method('play_run_anim'):
		riri_antagonist.play_run_anim()
		riri_protagonist.play_run_anim()
	
	riri_antagonist.velocity.z = 10
	riri_antagonist.move_and_slide()
	
	riri_protagonist.velocity.z = 10
	riri_protagonist.move_and_slide()
	
	if not rotated and riri_antagonist.global_position.z > camera_3d.global_position.z:
		camera_3d.rotate_y(180)
		rotated = true
		
	if rotated:
		change_scene_timer -= 0.8 * delta
	
	print(change_scene_timer)
	if change_scene_timer <= 0:
		var tween = create_tween()
		# Fade to silence over 2 seconds
		tween.tween_property(panic_music, "volume_db", -80.0, 3.0)
		await tween.finished
		SignalBus.change_scene_requested.emit(
			next_scene,
			SignalBus.SCENE_TYPE.WORLD, 
			SignalBus.SCENE_TYPE.WORLD
		)
