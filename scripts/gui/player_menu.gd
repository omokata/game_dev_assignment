extends Control

@onready var settings: Panel = $NinePatchRect/Settings
@onready var main_buttons: VBoxContainer = $NinePatchRect/MarginContainer/MainButtons
@onready var sens_slider: HSlider = $NinePatchRect/Settings/MarginContainer/VBoxContainer/SensSlider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	settings.visible = false
	main_buttons.visible = true
	sens_slider.step = SettingsManager.MAX_SENS / 100
	sens_slider.max_value = SettingsManager.MAX_SENS
	sens_slider.value = SettingsManager.mouse_sens

func _on_resume_pressed() -> void:
	print("Click!")
	SignalBus.resume_game_requested.emit()


func _on_settings_pressed() -> void:
	settings.visible = true
	main_buttons.visible = false

func _on_back_button_settings_pressed() -> void:
	_ready()

func _on_main_menu_pressed() -> void:
	SignalBus.main_menu_requested.emit()

func _on_sens_slider_value_changed(value: float) -> void:
	SettingsManager.set_mouse_sens(value)
	print(value)
	print(SettingsManager.mouse_sens)
