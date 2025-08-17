using System.IO;
using Godot;

namespace graphicviewer.scripts;

public partial class GraphicInfoData : Node
{
	public int Id => _data.Id;
	public int Address => _data.Address;
	public int Length => _data.Length;
	public int OffX => _data.OffX;
	public int OffY => _data.OffY;
	public int Width => _data.Width;
	public int Height => _data.Height;
	public byte GridW => _data.GridW;
	public byte GridH => _data.GridH;
	public byte Access => _data.Access;
	public int Map => _data.Map;

	private GraphicInfo _data;

	public static GraphicInfoData Load(byte[] data)
	{
		GraphicInfoData ret = new GraphicInfoData();
		ret._data = new GraphicInfo(data);
		return ret;
	}
}

internal class GraphicInfo
{
	public int Id { get; set; }
	public int Address { get; set; }
	public int Length { get; set; }
	public int OffX { get; set; }
	public int OffY { get; set; }
	public int Width { get; set; }
	public int Height { get; set; }
	public byte GridW { get; set; }
	public byte GridH { get; set; }
	public byte Access { get; set; }
	public int Map { get; set; }
	
	public GraphicInfo(byte[] data)
	{
		using BinaryReader br = new BinaryReader(new BufferedStream(new MemoryStream(data)));
		Id = br.ReadInt32();
		Address = br.ReadInt32();
		Length = br.ReadInt32();
		OffX = br.ReadInt32();
		OffY = br.ReadInt32();
		Width = br.ReadInt32();
		Height = br.ReadInt32();
		GridW = br.ReadByte();
		GridH = br.ReadByte();
		Access = br.ReadByte();
		br.ReadBytes(5); // ignored 
		Map = br.ReadInt32();
	}
}
