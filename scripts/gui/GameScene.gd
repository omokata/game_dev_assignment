extends Node2D


func _ready() -> void:
	$CanvasLayer/PauseBtn.pressed.connect(_on_pause_btn_pressed)
	$CanvasLayer/PauseMenu/Panel/VBox/BtnResume.pressed.connect(_on_resume_pressed)
	$CanvasLayer/PauseMenu/Panel/VBox/BtnRestart.pressed.connect(_on_restart_pressed)
	$CanvasLayer/PauseMenu/Panel/VBox/BtnQuit.pressed.connect(_on_quit_pressed)
	$CanvasLayer/PauseMenu/QuitConfirmWindow/ConfirmPanel/BtnHBox/BtnYes.pressed.connect(_on_confirm_yes_pressed)
	$CanvasLayer/PauseMenu/QuitConfirmWindow/ConfirmPanel/BtnHBox/BtnNo.pressed.connect(_on_confirm_no_pressed)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")


func _on_pause_btn_pressed() -> void:
	get_tree().paused = true
	$CanvasLayer/PauseMenu.visible = true


func _on_resume_pressed() -> void:
	get_tree().paused = false
	$CanvasLayer/PauseMenu.visible = false


func _on_restart_pressed() -> void:
	pass


func _on_quit_pressed() -> void:
	$CanvasLayer/PauseMenu/QuitConfirmWindow.visible = true


func _on_confirm_yes_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()


func _on_confirm_no_pressed() -> void:
	$CanvasLayer/PauseMenu/QuitConfirmWindow.visible = false
