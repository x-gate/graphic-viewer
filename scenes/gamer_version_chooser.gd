extends GridContainer

signal game_file_opened(info: PackedByteArray, data: FileAccess)

@onready var menu_button: MenuButton = $MenuButton

var game_paths: Array

func _ready() -> void:
	menu_button.get_popup().id_pressed.connect(_load_game_files)


func _on_line_edit_validated_game_paths(data_paths: Array, _palette_paths: Array) -> void:
	show()
	game_paths = data_paths
	
	for path in data_paths:
		menu_button.get_popup().add_item(path["name"])


func _load_game_files(id: int) -> void:
	var path = game_paths[id]
	menu_button.text = path["name"]
	
	var info_file_data = FileAccess.get_file_as_bytes(path.info_file_path)
	if info_file_data.is_empty():
		printerr("[Game Version Chooser] Cannot open %s: %s" % [path.info_file_path, error_string(FileAccess.get_open_error())])
		return
	
	var data_file = FileAccess.open(path.data_file_path, FileAccess.READ)
	if data_file == null:
		printerr("[Game Version Chooser] Cannot open %s: %s" % [path.data_file_path, error_string(FileAccess.get_open_error())])
		return
	
	game_file_opened.emit(info_file_data, data_file)
