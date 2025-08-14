extends Control

@export var default_size := Vector2i(16, 16)
@export var color := Color.RED

var isolines: PackedByteArray
var map_size := default_size.x

@onready var map_gen: Node = $MapGenerator
@onready var map_tex: TextureRect = %MapTexture
@onready var gen_tex: TextureRect = %GenTexture
@onready var width_input: SpinBox = $Ui/WidthInput


func _ready() -> void:
	gen_tex.color = self.color
	width_input.value = default_size.x


func _rerender() -> void:
	gen_tex.queue_redraw()


func _regenerate_map() -> void:
	map_gen.new_map(map_size, map_size)
	var map_image := Image.create_from_data(
		map_gen.width,
		map_gen.height,
		false,
		Image.FORMAT_RF,
		map_gen.map.to_byte_array()
	)

	map_tex.texture = ImageTexture.create_from_image(map_image)

	self.isolines = map_gen.compute_isolines()
	gen_tex.draw_isolines(self.isolines, Vector2i(map_size, map_size))


func _on_width_input_changed(value: float) -> void:
	map_size = int(value)
	gen_tex.map_scale = int(value)
	_regenerate_map()
