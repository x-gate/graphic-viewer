extends VBoxContainer

signal palette_file_opened(palette: PackedByteArray)

@onready var palette_menu: MenuButton = $PaletteMenu

var palette_paths: Array

func _ready() -> void:
	palette_menu.get_popup().id_pressed.connect(_load_palette_file)

func _on_line_edit_validated_game_paths(_data: Array, palette: Array) -> void:
	show()
	
	palette_menu.disabled = palette.is_empty()
	palette_paths = palette
	for path in palette:
		palette_menu.get_popup().add_item(path.get_file())


func _load_palette_file(id: int) -> void:
	palette_menu.text = palette_paths[id].get_file()
	
	var data = FileAccess.get_file_as_bytes(palette_paths[id])
	if data.is_empty():
		printerr("[Preview Container] Cannot open %s: %s" % [palette_paths[id], error_string(FileAccess.get_open_error())])
	
	print("[Preview Container] Opened palette file: %s" % palette_paths[id])
	
	palette_file_opened.emit(data)
