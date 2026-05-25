extends Node

@onready var main_buttons: VBoxContainer = $NinePatchRect/MainButtons
@onready var settings: Panel = $NinePatchRect/Settings
@onready var sens_slider: HSlider = $NinePatchRect/Settings/MarginContainer/VBoxContainer/SensSlider

func _ready() -> void:
	main_buttons.visible = true
	settings.visible = false
	sens_slider.step = SettingsManager.MAX_SENS / 100
	sens_slider.max_value = SettingsManager.MAX_SENS
	sens_slider.value = SettingsManager.mouse_sens

func _on_play_button_up() -> void:
	SignalBus.play_game_triggered.emit()


func _on_quit_button_up() -> void:
	SignalBus.quit_game_requested.emit()


func _on_settings_button_up() -> void:
	settings.visible = true
	main_buttons.visible = false

func _on_back_button_option_pressed() -> void:
	_ready()

func _on_h_slider_value_changed(value: float) -> void:
	SettingsManager.set_mouse_sens(value)
