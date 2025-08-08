extends Control

const default_size := Vector2i(4, 4)

var isolines: PackedByteArray

@onready var map_gen: Node = $MapGenerator
@onready var map_tex: TextureRect = %MapTexture
@onready var gen_tex: TextureRect = %GenTexture

func _rerender() -> void:
	pass

func _regenerate_map() -> void:
	map_gen.new_map(default_size.x, default_size.y)
	var map_image := Image.create_from_data(
		map_gen.width,
		map_gen.height,
		false,
		Image.FORMAT_RF,
		map_gen.map.to_byte_array()
	)

	map_tex.texture = ImageTexture.create_from_image(map_image)

	self.isolines = map_gen.compute_isolines()
