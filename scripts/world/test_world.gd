extends Node3D

@onready var player: CharacterBody3D = $Player
@onready var background_music: AudioStreamPlayer = $BackgroundMusic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.activate_cam(true)
	start_background_music()

func start_background_music():
	background_music.play()
