extends GridContainer

@onready var progress_panel: PopupPanel = $PopupPanel
@onready var progress_bar: ProgressBar = $PopupPanel/ProgressBar

@onready var id: SpinBox = $IDInput
@onready var address: LineEdit = $AddressInput
@onready var off_x: LineEdit = $XOffsetInput
@onready var off_y: LineEdit = $YOffsetInput
@onready var width: LineEdit = $WidthInput
@onready var height: LineEdit = $HeightInput
@onready var grid_e: LineEdit = $EastGridInput
@onready var grid_s: LineEdit = $SouthGridInput
@onready var access: LineEdit = $AccessInput
@onready var map_id: LineEdit = $MapIDInput

var graphic_info:
	set(val):
		graphic_info = val

func _on_gamer_version_chooser_game_file_opened(info: FileAccess, _data: FileAccess) -> void:
	show()

	progress_panel.show()
	progress_bar.max_value = info.get_length() / 40
	while !info.eof_reached():
		var buf = info.get_buffer(40)
		#todo
		progress_bar.value += 1
	progress_panel.hide()
