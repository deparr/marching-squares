extends TextureRect


var map_scale := 32:
	set(value):
		map_scale = value
		mid = value / 2
var mid := map_scale / 2
var isolines: PackedByteArray
var grid: Vector2i
var color: Color


func draw_isolines(isolines_: PackedByteArray, grid_: Vector2i) -> void:
	self.isolines = isolines_
	self.grid = grid_
	self.map_scale = int(self.size.x) / self.grid.x
	self.queue_redraw()

func _draw() -> void:
	var start = Time.get_ticks_msec()
	var points2 := PackedVector2Array()
	for i in range(1, grid.x - 1):
		points2.append(Vector2(i * map_scale, 0.0))
		points2.append(Vector2(i * map_scale, (grid.y - 1) * map_scale))

		points2.append(Vector2(0.0, i * map_scale))
		points2.append(Vector2((grid.x - 1) * map_scale, i * map_scale))

	if points2.size() > 0:
		self.draw_multiline(points2, Color(0.24, 0.24, 0.24))

	var points := PackedVector2Array()
	for i in self.isolines.size():
		var isoline := self.isolines[i]
		var gridx := i % (grid.x - 1)
		var gridy := i / (grid.y - 1)
		var corner := Vector2(gridx * map_scale, gridy * map_scale)
		
		match isoline:
			1:
				points.append(Vector2(corner.x, corner.y + mid))
				points.append(Vector2(corner.x + mid, corner.y + map_scale))
			2:
				points.append(Vector2(corner.x + map_scale, corner.y + mid))
				points.append(Vector2(corner.x + mid, corner.y + map_scale))
			3:
				points.append(Vector2(corner.x, corner.y + mid))
				points.append(Vector2(corner.x + map_scale, corner.y + mid))
			4:
				points.append(Vector2(corner.x + mid, corner.y))
				points.append(Vector2(corner.x + map_scale, corner.y + mid))
			5:
				points.append(Vector2(corner.x, corner.y + mid))
				points.append(Vector2(corner.x + mid, corner.y))
				points.append(Vector2(corner.x + mid, corner.y + map_scale))
				points.append(Vector2(corner.x + map_scale, corner.y + mid))
			6:
				points.append(Vector2(corner.x + mid, corner.y))
				points.append(Vector2(corner.x + mid, corner.y + map_scale))
			7:
				points.append(Vector2(corner.x, corner.y + mid))
				points.append(Vector2(corner.x + mid, corner.y))
			8:
				points.append(Vector2(corner.x, corner.y + mid))
				points.append(Vector2(corner.x + mid, corner.y))
			9:
				points.append(Vector2(corner.x + mid, corner.y))
				points.append(Vector2(corner.x + mid, corner.y + map_scale))
			10:
				points.append(Vector2(corner.x + mid, corner.y))
				points.append(Vector2(corner.x + map_scale, corner.y + mid))
				points.append(Vector2(corner.x, corner.y + mid))
				points.append(Vector2(corner.x + mid, corner.y + map_scale))
			11:
				points.append(Vector2(corner.x + mid, corner.y))
				points.append(Vector2(corner.x + map_scale, corner.y + mid))
			12:
				points.append(Vector2(corner.x, corner.y + mid))
				points.append(Vector2(corner.x + map_scale, corner.y + mid))
			13:
				points.append(Vector2(corner.x + mid, corner.y + map_scale))
				points.append(Vector2(corner.x + map_scale, corner.y + mid))
			14:
				points.append(Vector2(corner.x, corner.y + mid))
				points.append(Vector2(corner.x + mid, corner.y + map_scale))

			0, 15:
				pass
	
	if points.size() > 0:
		self.draw_multiline(points, color)

	print("RENDER: %fs" % (float(Time.get_ticks_msec() - start) / 1000.))
