extends TextureRect

var graphic_info: GraphicInfoData:
	set(val):
		graphic_info = val
		_render()
var graphic_data_file: FileAccess:
	set(val):
		graphic_data_file = val
		_render()
var palette_data: PackedByteArray:
	set(val):
		palette_data = val
		_render()

func _on_gamer_version_chooser_game_file_opened(_info: PackedByteArray, data_file: FileAccess) -> void:
	graphic_data_file = data_file


func _on_graphic_info_previewer_current_updated(data: GraphicInfoData) -> void:
	graphic_info = data


func _on_left_v_box_container_palette_file_opened(palette: PackedByteArray) -> void:
	palette_data = palette


func _render() -> void:
	if graphic_info == null || graphic_data_file == null || palette_data.is_empty():
		return

	size = Vector2(graphic_info.Width, graphic_info.Height)

	print("[Graphic Preview] Rendering Graphic: ID = %d" % graphic_info.Id)

	graphic_data_file.seek(graphic_info.Address)

	var palette = Palette.build(palette_data)
	var graphic = GraphicData.Load(graphic_data_file.get_buffer(graphic_info.Length))
	
	var img = Image.create(graphic_info.Width+1, graphic_info.Height+1, false, Image.FORMAT_RGBA8)
	for i in range(0, len(graphic.Data)):
		if graphic.Data[i] >= len(palette):
			printerr("[Graphic Data] Palette Data out of range: %d", graphic.Data[i])
		img.set_pixel(i%graphic_info.Width, graphic_info.Height-i/graphic_info.Width, palette[graphic.Data[i]])
	texture = ImageTexture.create_from_image(img)
