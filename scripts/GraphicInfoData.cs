using System;
using System.IO;
using Godot;

namespace graphicviewer.scripts;

public partial class GraphicInfoData : Node
{
	public const int Size = 40;
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

	public static GraphicInfoData Load (byte[] data)
	{
		BinaryReader br = new BinaryReader(new BufferedStream(new MemoryStream(data)));
		GraphicInfoData d = new GraphicInfoData();
		d.Id = br.ReadInt32();
		d.Address = br.ReadInt32();
		d.Length = br.ReadInt32();
		d.OffX = br.ReadInt32();
		d.OffY = br.ReadInt32();
		d.Width = br.ReadInt32();
		d.Height = br.ReadInt32();
		d.GridW = br.ReadByte();
		d.GridH = br.ReadByte();
		d.Access = br.ReadByte();
		br.ReadBytes(5); // ignored 
		d.Map = br.ReadInt32();
		return d;
	}
}
