extends Node3D

@onready var interactable: Interactable = $Interactable
var isOpen:bool = false

func _on_interactable_interacted(actor: Node, interactable: Interactable) -> void:
	if (isOpen):
		get_node("AnimationPlayer").play_backwards("door_open")
		isOpen = false
	else:
		get_node("AnimationPlayer").play("door_open")
		isOpen = true
	
