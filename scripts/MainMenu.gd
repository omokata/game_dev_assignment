extends Control


func _ready() -> void:
	$BtnStart.pressed.connect(_on_btn_start_pressed)
	$BtnSettings.pressed.connect(_on_btn_settings_pressed)
	$BtnQuit.pressed.connect(_on_btn_quit_pressed)
	$SettingsWindow/Panel/CloseBtn.pressed.connect(_on_settings_close_pressed)
	_setup_music()

func _setup_music() -> void:
	var stream := load("res://assets/audio/main_menu_music.mp3") as AudioStreamMP3
	if stream:
		stream.loop = true
		$MusicPlayer.stream = stream
		$MusicPlayer.play()


func _on_btn_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/GameScene.tscn")


func _on_btn_settings_pressed() -> void:
	$SettingsWindow.visible = true


func _on_settings_close_pressed() -> void:
	$SettingsWindow.visible = false


func _on_btn_quit_pressed() -> void:
	get_tree().quit()
