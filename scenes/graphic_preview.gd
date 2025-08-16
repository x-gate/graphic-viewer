extends TextureRect

@onready var parent = $".."

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

var img_scales: Array = []
var img_scales_index: int = 0

func _ready() -> void:
	gui_input.connect(_on_gui_input)


func _on_gamer_version_chooser_game_file_opened(_info: PackedByteArray, data_file: FileAccess) -> void:
	graphic_data_file = data_file


func _on_graphic_info_previewer_current_updated(data: GraphicInfoData) -> void:
	graphic_info = data


func _on_left_v_box_container_palette_file_opened(palette: PackedByteArray) -> void:
	palette_data = palette


func _on_gui_input(event: InputEvent) -> void:
	if texture == null:
		return
	
	var scale_up: bool = Input.is_action_just_pressed("scale_up")
	var scale_down: bool = Input.is_action_just_pressed("scale_down")
	
	if scale_up: img_scales_index += 1
	if scale_down && img_scales_index > 0: img_scales_index -= 1
	
	if scale_up || scale_down:
		var img = texture.get_image()
		var max_size = parent.size
		if img.get_width() * 1.1 > max_size[0] || img.get_height() * 1.1 > max_size[1]:
			img_scales_index -= 1
		
		if img_scales_index == len(img_scales):
			img.resize(img.get_width() * 1.1, img.get_height() * 1.1)
			img_scales.push_back(img)

		texture.set_image(img_scales[img_scales_index])

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

	img_scales.clear()
	img_scales.push_back(img)
	img_scales_index = 0

	if texture == null:
		texture = ImageTexture.create_from_image(img)
	else:
		if img.get_size() == texture.get_image().get_size():
			texture.update(img)
		else:
			texture.set_image(img)


func _on_save_button_pressed() -> void:
	var img: Image = img_scales[0]
	
	var path = "user://%d-%d.webp" % [graphic_info.Id, img.get_data().get_string_from_utf32().hash()]
	img.save_webp(path)
	DisplayServer.clipboard_set(ProjectSettings.globalize_path(path))
