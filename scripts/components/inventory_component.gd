extends Node
class_name InventoryComponent

var item = {}

func add_item(item_name: String, amount: int):
	item[item_name] = amount

func has_item(item_name: String) -> bool:
	return item[item_name] > 1
