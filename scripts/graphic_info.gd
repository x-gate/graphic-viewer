class_name GraphicInfo

var idx: Dictionary
var mdx: Dictionary
var list: Array

static func load(f: FileAccess) -> GraphicInfo:
	var gi = GraphicInfo.new()
	
	while true:
		var buf = f.get_buffer(40)
		if f.eof_reached(): break
		
		var d = GraphicInfoData.Load(buf)
		gi.idx.set(d.Id, d)
		if d.Map > 0:
			if !gi.mdx.has(d.Map):
				gi.mdx.set(d.Map, [])
			gi.mdx[d.Map].push_back(d)
		gi.list.push_back(d)
	
	return gi
