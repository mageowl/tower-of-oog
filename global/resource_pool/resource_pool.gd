class_name ResourcePool extends Resource

@export var entries: Array[ResourcePoolEntry] = []

func pick_random() -> Resource:
	if entries.is_empty(): return null
	
	var weights_sum = 0
	var bounds = []
	for entry in entries:
		weights_sum += entry.weight
		bounds.push_back(weights_sum)
	
	var draw = randf_range(0, weights_sum)
	for i in entries.size():
		if bounds[i] >= draw:
			return entries[i].value
	assert(false)
	return null

func filter(cb: Callable) -> ResourcePool:
	var filtered = ResourcePool.new()
	filtered.entries = entries.filter(cb)
	return filtered
