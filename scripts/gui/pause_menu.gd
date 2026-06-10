extends Control

@onready var music_slider: HSlider = $SettingsWindow/Panel/SettingsVBox/MusicRow/MusicSlider
@onready var sfx_slider: HSlider = $SettingsWindow/Panel/SettingsVBox/SFXRow/SFXSlider
@onready var sens_slider: HSlider = $SettingsWindow/Panel/SettingsVBox/MouseSensRow/SensSlider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	_setup_slider()


func _setup_slider() -> void:
	music_slider.min_value = SettingsManager.MIN_DB
	music_slider.max_value = SettingsManager.MAX_DB
	music_slider.value = SettingsManager.bgm_db
	
	sfx_slider.min_value = SettingsManager.MIN_DB
	sfx_slider.max_value = SettingsManager.MAX_DB
	sfx_slider.value = SettingsManager.sfx_db
	
	sens_slider.step = SettingsManager.MAX_SENS / 100
	sens_slider.max_value = SettingsManager.MAX_SENS
	sens_slider.value = SettingsManager.mouse_sens


func _on_btn_resume_pressed() -> void:
	SignalBus.resume_game_requested.emit()


func _on_btn_quit_pressed() -> void:
	SignalBus.main_menu_requested.emit()


func _on_btn_settings_pressed() -> void:
	$SettingsWindow.visible = true


func _on_close_btn_pressed() -> void:
	$SettingsWindow.visible = false


func _on_music_slider_value_changed(value: float) -> void:
	SettingsManager.set_bgm_vol(value)


func _on_sfx_slider_value_changed(value: float) -> void:
	SettingsManager.set_sfx_vol(value)


func _on_sens_slider_value_changed(value: float) -> void:
	SettingsManager.set_mouse_sens(value)
