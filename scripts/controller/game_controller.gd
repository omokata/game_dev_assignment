extends Node
class_name GameController

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		SignalBus.pause_game_requested.emit()
