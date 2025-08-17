using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Godot;

namespace graphicviewer.scripts;

public partial class GraphicData : Node
{
	public byte[] Data => _graphic.Data;
	private Graphic _graphic;
	public static GraphicData Load(byte[] data)
	{
		try
		{
			GraphicData ret = new GraphicData();
			ret._graphic = new Graphic(data);
			return ret;
		}
		catch (GraphicException e)
		{
			GD.PrintErr("[Graphic Data]: "+e.Message);
		}

		return null;
	}
}

internal class Graphic
{
	public GraphicDataHeader Header;
	public byte[] Data { set; get; }

	public Graphic(byte[] data)
	{
		using BinaryReader br = new BinaryReader(new BufferedStream(new MemoryStream(data)));
		Header = new GraphicDataHeader(br);
		if (!Header.IsValid())
		{
			throw new GraphicException("Invalid graphic data header");
		}

		Data = (Header.Version & 1) == 0 ? data[16 ..] : new Codec().Decode(br);
	}

}

internal class GraphicDataHeader
{
	public char[] Magic { set; get; }
	public byte Version { set; get; }
	public int Width { set; get; }
	public int Height { set; get; }
	public int Length { set; get; }
	
	public GraphicDataHeader (BinaryReader br)
	{
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

internal class Codec
{
	public byte[] Decode(BinaryReader br)
	{
		byte[] decoded = [];

		try
		{
			using MemoryStream ms = new MemoryStream();

			for (byte fb = br.ReadByte();; fb = br.ReadByte())
			{
				byte d = ReadData(fb, br);
				int bc = ReadByteCount(fb, br);

				ms.Write(d == 0xff ? br.ReadBytes(bc) : Enumerable.Repeat(d, bc).ToArray());
				decoded = ms.ToArray();
			}
		}
		catch (EndOfStreamException)
		{
			return decoded;
		}
	}

	private byte ReadData(byte fb, BinaryReader br)
	{
		switch (fb&0xf0)
		{
			case 0x00:
			case 0x10:
			case 0x20:
				return 0xff;
			case 0x80:
			case 0x90:
			case 0xa0:
				return br.ReadByte();
			case 0xc0:
			case 0xd0: 
			case 0xe0:
				return 0;
			default:
				throw new GraphicException($"Invalid data: first byte = 0x{fb:X}");
		}
	}

	private int ReadByteCount(byte fb, BinaryReader br)
	{
		switch (fb & 0xf0)
		{
			case 0x00:
			case 0x80:
			case 0xc0:
				return fb & 0x0f;
			case 0x10:
			case 0x90: 
			case 0xd0:
				return ((fb & 0x0f) << 8) + br.ReadByte();
			case 0x20:
			case 0xa0: 
			case 0xe0:
				return ((fb & 0x0f) << 16) + (br.ReadByte() << 8) + br.ReadByte();
			default:
				throw new GraphicException($"Invalid byte count: first byte = 0x{fb:X}");
		}
	}
}

public class GraphicException(string message) : Exception(message);
