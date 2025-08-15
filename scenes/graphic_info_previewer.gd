extends GridContainer

signal current_updated(data: GraphicInfoData)

@onready var id: SpinBox = $IDInput
@onready var address: LineEdit = $AddressInput
@onready var length: LineEdit = $LengthInput
@onready var off_x: LineEdit = $XOffsetInput
@onready var off_y: LineEdit = $YOffsetInput
@onready var width: LineEdit = $WidthInput
@onready var height: LineEdit = $HeightInput
@onready var grid_e: LineEdit = $EastGridInput
@onready var grid_s: LineEdit = $SouthGridInput
@onready var access: LineEdit = $AccessInput
@onready var map_id: LineEdit = $MapIDInput

var graphic_info: GraphicInfo

func _on_gamer_version_chooser_game_file_opened(info: FileAccess, _data: FileAccess) -> void:
	info.call_deferred("close")
	show()

	graphic_info = null
	graphic_info = GraphicInfo.load(info)
	id.value = graphic_info.list[0].Id
	_on_id_input_value_changed(graphic_info.list[0].Id)
	
	id.min_value = graphic_info.list[0].Id
	id.max_value = graphic_info.list[len(graphic_info.list)-1].Id

	print("[Graphic Info Previewer] Loaded len(graphic_info.idx) = %d, len(graphic_info.mdx) = %d, len(graphic_info.list) = %d" % [len(graphic_info.idx), len(graphic_info.mdx), len(graphic_info.list)])


func _on_id_input_value_changed(value: float) -> void:
	if graphic_info.idx.has(int(value)):
		current_updated.emit(graphic_info.idx.get(int(value)))


func _on_current_updated(data: GraphicInfoData) -> void:
	address.text = str(data.Address)
	length.text = str(data.Length)
	off_x.text = str(data.OffX)
	off_y.text = str(data.OffY)
	width.text = str(data.Width)
	height.text = str(data.Height)
	grid_e.text = str(data.GridW)
	grid_s.text = str(data.GridH)
	access.text = str(data.Access)
	map_id.text = str(data.Map)
	
