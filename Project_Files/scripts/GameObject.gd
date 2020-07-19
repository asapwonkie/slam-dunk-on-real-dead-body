extends Node
class_name GameObject



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
	
	assert(false)
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
