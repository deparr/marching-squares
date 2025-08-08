extends Node

@export var fill_threshold := 0.7

var map: PackedFloat32Array:
	get:
		return map
var width: int
var height: int


func new_map(new_width: int, new_height: int) -> void:
	var err := self.map.resize(new_width * new_height)
	if err != OK:
		print("unable to resize", error_string(err))

	for i in map.size():
		map[i] = 1.0 if randf() > fill_threshold else 0.0
	
	self.width = new_width
	self.height = new_height


func compute_isolines() -> PackedByteArray:
	assert(self.map.size() % 2 == 0, "isoline requires map.size() % 2")

	var isolines := PackedByteArray()
	var isoline_size := (self.height - 1) * (self.width - 1)
	var err := isolines.resize(isoline_size)
	if err != OK:
		print("unable to create isoline array:", error_string(err))

	var i := 0
	var iso_idx := 0
	while i < self.map.size() - self.width:
		for x in range(0, self.width - 1):
			var tl_idx := i + x
			var pattern := 0
			pattern |= (1 if is_equal_approx(map[tl_idx], 1.0) else 0) << 3
			pattern |= (1 if is_equal_approx(map[tl_idx + 1], 1.0) else 0) << 2
			pattern |= (1 if is_equal_approx(map[tl_idx + self.width + 1], 1.0) else 0) << 1
			pattern |= (1 if is_equal_approx(map[tl_idx + self.width], 1.0) else 0) << 0

			isolines[iso_idx] = pattern
			iso_idx += 1

		i += self.width
	
	return isolines

func smooth_map() -> void:
	pass
