class_name GraphicInfo

var idx: Dictionary = {}
var mdx: Dictionary = {}
var list: Array = []

static func load(data: PackedByteArray) -> GraphicInfo:
	var gi = GraphicInfo.new()

	var pos = 0
	while (pos < len(data)):
		var d = GraphicInfoData.Load(data.slice(pos, pos+40))
		
		gi.list.push_back(d)
		gi.idx.set(d.Id, d)
		if d.Map > 0:
			if !gi.mdx.has(d.Map):
				gi.mdx.set(d.Map, [])
			gi.mdx[d.Map].push_back(d)
		
		pos += 40
	
	return gi
