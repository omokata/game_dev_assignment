extends StaticBody3D

@onready var interactable: Interactable = $Interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable.interacted.connect(_on_interactable_interacted)

func _on_interactable_interacted(actor: Node, interactable: Interactable):
	if actor.has_method("attach_item"):
		actor.attach_item(self)
		interactable.collision_layer = 1
		interactable.collision_mask = 1
	if actor.has_method("add_to_inventory"):
		actor.add_to_inventory('crowbar')
