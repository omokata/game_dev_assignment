extends Node
class_name InventoryComponent

var item = {}

func add_item(item_name: String, amount: int):
	print("item name: "+item_name)
	item[item_name] = amount

func has_item(item_name: String) -> bool:
	print(item)
	return item.has(item_name)
