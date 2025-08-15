extends LineEdit

signal validated_game_paths(data_paths: Array, palette_paths: Array)

@onready var file_dialog: FileDialog = $FileDialog

func _ready() -> void:
	gui_input.connect(func(event: InputEvent): if event.is_pressed(): file_dialog.show())
	file_dialog.connect("dir_selected", _on_folder_choosed)


func _on_folder_choosed(dir: String) -> void:
	text = dir
	var data_paths = _get_game_data_paths(dir)
	var palette_paths = _get_game_palette_paths(dir)
	if len(data_paths) > 0 && len(palette_paths) > 0:
		print("[Game Folder Chooser] Valid game paths: ", data_paths)
		print("[Game Folder Chooser] Valid palette paths: ", palette_paths)
		validated_game_paths.emit(data_paths, palette_paths)
	else:
		printerr("[Game Folder Chooser] Invalid game path: %s" % dir)


func _choose_dir(path: String) -> DirAccess:
	var dir = DirAccess.open(path)
	if dir.dir_exists("Assets"):
		dir.change_dir("Assets")
		print("[Game Folder Chooser] '/Assets' exists, could be CGoriginmood version")
	if dir.dir_exists("bin"):
		dir.change_dir("bin")
	
	return dir


func _get_game_data_paths(path: String) -> Array:
	var dir = _choose_dir(path)
	var cur = dir.get_current_dir()
	
	var palette_paths = []
	for palette_path in DirAccess.get_files_at(cur + "/pal"):
		palette_paths.push_back(cur + "/pal/" + palette_path)

	print("[Game Folder Chooser] current dir = %s" % cur)
	var ret = []
	if dir.file_exists("GraphicInfo_66.bin") && dir.file_exists("Graphic_66.bin"):
		ret.push_back({
			"name": "1.0：神獸傳奇 + 魔弓傳奇",
			"info_file_path": cur + "/GraphicInfo_66.bin",
			"data_file_path": cur + "/Graphic_66.bin",
		})
	if dir.file_exists("GraphicInfoEx_5.bin") && dir.file_exists("GraphicEx_5.bin"):
		ret.push_back({
			"name": "2.0：龍之沙漏",
			"info_file_path": cur + "/GraphicInfoEx_5.bin",
			"data_file_path": cur + "/GraphicEx_5.bin",
		})

	# todo
	
	return ret


func _get_game_palette_paths(path: String) -> Array:
	var dir = _choose_dir(path)
	var cur = dir.get_current_dir()
	
	var palette_paths = []
	for palette_path in DirAccess.get_files_at(cur + "/pal"):
		palette_paths.push_back(cur + "/pal/" + palette_path)

	return palette_paths
