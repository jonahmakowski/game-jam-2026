class_name Helper


static func format_float(value: float, decimals: int = 6) -> String:
	var s = ("%." + str(decimals) + "f") % value
	s = s.rstrip("0")
	s = s.rstrip(".")
	return s


static func get_aabb(node: Node3D) -> AABB:
	if not node.is_node_ready():
		print("Running on node that isn't ready, terminating")
		return AABB()

	if not node.is_inside_tree():
		print("Node not in scene tree: ", node.name)
		return AABB()

	var aabb = AABB()
	for child in node.get_children():
		if child is MeshInstance3D:
			aabb = aabb.merge(child.get_aabb())
		elif child is Node3D:
			aabb = aabb.merge(get_aabb(child))
	return aabb
