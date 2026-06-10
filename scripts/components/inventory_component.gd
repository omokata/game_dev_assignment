extends Node
class_name InventoryComponent

var item = {}

func add_item(item_name: String, amount: int):
	item[item_name] = amount

func has_item(item_name: String) -> bool:
	if item_name not in item:
		return false
	return item[item_name] > 1
