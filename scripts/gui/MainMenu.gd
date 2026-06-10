extends Control

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var music_slider: HSlider = $SettingsWindow/Panel/SettingsVBox/MusicRow/MusicSlider
@onready var sfx_slider: HSlider = $SettingsWindow/Panel/SettingsVBox/SFXRow/SFXSlider

func _ready() -> void:
	$MarginContainer/VBoxContainer/BtnStart.pressed.connect(_on_btn_start_pressed)
	$MarginContainer/VBoxContainer/BtnSettings.pressed.connect(_on_btn_settings_pressed)
	$MarginContainer/VBoxContainer/BtnQuit.pressed.connect(_on_btn_quit_pressed)
	$SettingsWindow/Panel/CloseBtn.pressed.connect(_on_settings_close_pressed)
	_setup_slider()
	music_player.volume_db = SettingsManager.bgm_db
	_setup_music()

func _setup_slider() -> void:
	music_slider.min_value = SettingsManager.MIN_DB
	music_slider.max_value = SettingsManager.MAX_DB
	music_slider.value = SettingsManager.bgm_db
	
	sfx_slider.min_value = SettingsManager.MIN_DB
	sfx_slider.max_value = SettingsManager.MAX_DB
	sfx_slider.value = SettingsManager.sfx_db

func _setup_music() -> void:
	var stream := load("res://assets/audio/main_menu_music.mp3") as AudioStreamMP3
	if stream:
		stream.loop = true
		$MusicPlayer.stream = stream
		$MusicPlayer.play()


func _on_btn_start_pressed() -> void:
	SignalBus.play_game_triggered.emit()


func _on_btn_settings_pressed() -> void:
	$SettingsWindow.visible = true


func _on_settings_close_pressed() -> void:
	$SettingsWindow.visible = false


func _on_btn_quit_pressed() -> void:
	SignalBus.quit_game_requested.emit()


func _on_music_slider_value_changed(value: float) -> void:
	SettingsManager.set_bgm_vol(value)
	music_player.volume_db = SettingsManager.bgm_db


func _on_sfx_slider_value_changed(value: float) -> void:
	SettingsManager.set_sfx_vol(value)
