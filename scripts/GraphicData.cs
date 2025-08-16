using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Godot;

namespace graphicviewer.scripts;

public partial class GraphicData : Node
{
	public GraphicDataHeader Header { set; get; }
	public byte[] Data { set; get; }
	
	public static GraphicData Load(byte[] data)
	{
		GraphicData ret = new GraphicData();
		ret.Header = new GraphicDataHeader(data[.. 16]);
		if (!ret.Header.IsValid())
		{
			GD.PrintErr("[Graphic Data] Invalid graphic data header");
			return null;
		}

		if ((ret.Header.Version & 1) == 0)
		{
			ret.Data = data[16 ..];
		}
		else
		{
			ret.Data = new Codec().Decode(data[16 ..]);
		}

		return ret;
	}
}

internal class Codec
{
	public byte[] Decode(byte[] data)
	{
		BinaryReader br = new BinaryReader(new BufferedStream(new MemoryStream(data)));
		List<byte> decoded = new List<byte>();

		try
		{
			for (byte fb = br.ReadByte();; fb = br.ReadByte())
			{
				byte d = ReadData(fb, br);
				int bc = ReadByteCount(fb, br);

				decoded.AddRange(d == 0xff ? br.ReadBytes(bc) : Enumerable.Repeat(d, bc).ToArray());
			}
		} catch (EndOfStreamException)
		{
		}

		return decoded.ToArray();
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
				throw new Exception("Invalid data");
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
				throw new Exception("Invalid byte count");
		}
	}
}
