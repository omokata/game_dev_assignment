extends Marker3D
class_name ItemSocketComponent

var current_attached_item
var previous_parent

func _ready() -> void:
	current_attached_item = null
	previous_parent = null

func attached_item(item_to_attached: StaticBody3D):
	current_attached_item = item_to_attached
	previous_parent = item_to_attached.get_parent()
	current_attached_item.reparent(self,)
	current_attached_item.position = Vector3.ZERO
	current_attached_item.rotation = Vector3.ONE
	
func deattach_current_item():
	if current_attached_item:
		current_attached_item.queue_free()
