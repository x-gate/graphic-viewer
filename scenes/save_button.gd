extends Button

func _ready() -> void:
	button_down.connect(func(): text = "路徑已複製，請使用瀏覽器開啟")
	button_up.connect(func(): text = "另存圖片")
