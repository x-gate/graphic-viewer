using System.IO;
using Godot;

namespace graphicviewer.scripts;

public class GraphicDataHeader
{
	public char[] Magic { set; get; }
	public byte Version { set; get; }
	public int Width { set; get; }
	public int Height { set; get; }
	public int Length { set; get; }
	
	public GraphicDataHeader (byte[] data)
	{
		BinaryReader br = new BinaryReader(new BufferedStream(new MemoryStream(data)));
		Magic = br.ReadChars(2);
		Version = br.ReadByte();
		br.ReadByte(); // ignored
		Width = br.ReadInt32();
		Height = br.ReadInt32();
		Length = br.ReadInt32();
	}
	
	public bool IsValid()
	{
		return Magic[0] == 'R' && Magic[1] == 'D';
	}
}
