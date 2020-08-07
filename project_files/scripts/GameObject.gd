# GameObject.gd

class_name GameObject
extends Node2D



export(String) var go_type = ""



# maybe needed if world is deleted and recreated
#func get_world():
#	return get_node("/root/Main/World")
onready var main = get_node("/root/Main")
onready var game_world = get_node("/root/Main/GameWorld")



func get_game_object(node):
	if node.get("go_type") != null:
		return node
	else:
		return get_game_object(node.get_parent())



func has_child_of_type(child_class):
	var queue = Array()
	queue.push_back(self)
	
	while !queue.empty():
		var node = queue.pop_front()
		if node is child_class:
			return true
		for child in node.get_children():
			queue.push_back(child)
	
	return false



func get_child_of_type(child_class):
	var queue = Array()
	queue.push_back(self)
	
	while !queue.empty():
		var node = queue.pop_front()
		if node is child_class:
			return node
		for child in node.get_children():
			queue.push_back(child)
	
	return null



func get_children_of_type(child_class):
	var children_of_type = Array()
	
	var queue = Array()
	queue.push_back(self)
	
	while !queue.empty():
		var node = queue.pop_front()
		if node is child_class:
			children_of_type.push_back(node)
		for child in node.get_children():
			queue.push_back(child)
	
	if children_of_type.size() > 0:
		return children_of_type
		
	return null



func has_child_of_name(child_name):
	var queue = Array()
	queue.push_back(self)
	
	while !queue.empty():
		var node = queue.pop_front()
		if node.name == child_name:
			return true
		for child in node.get_children():
			queue.push_back(child)
	
	return false



func get_child_of_name(child_name):
	var queue = Array()
	queue.push_back(self)
	
	while !queue.empty():
		var node = queue.pop_front()
		if node.name == child_name:
			return node
		for child in node.get_children():
			queue.push_back(child)
	
	return null



func set_collisions(value):
	var collision_shapes = get_children_of_type(CollisionShape2D)
	for col in collision_shapes:
		col.disabled = !value
