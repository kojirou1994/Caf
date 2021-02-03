import Foundation
import ByteOpetarions
import KwiftUtility

/// Every CAF file must have an Audio Description chunk and an Audio Data chunk. CAF files containing variable bit rate or variable frame rate audio data must also have a Packet Table chunk.


/// The Audio Description chunk is required and must appear in a CAF file immediately following the file header. It describes the format of the audio data in the Audio Data chunk.

public struct AudioDescriptionChunk: CafChunkDataProtocol {
  public init<T>(data: T) throws where T : DataProtocol {
    try preconditionOrThrow(data.count == 32, CafParserError.unexpectedChunkSize(size: data.count, type: .desc, expectedSize: 32))

    var reader = ByteReader(data)
    info = try .init(
      sampleRate: .init(bitPattern: reader.readInteger()),
      formatID: .init(rawValue: reader.readInteger()),
      formatFlags: reader.readInteger(),
      bytesPerPacket: reader.readInteger(),
      framesPerPacket: reader.readInteger(),
      channelsPerFrame: reader.readInteger(),
      bitsPerChannel: reader.readInteger())
  }

  public let info: CafAudioFormat
}

/*
 Table 2-1  Audio Description chunk header fields
 Field
 Value
 mChunkType
 ‘desc’
 mChunkSize
 sizeof(CAFAudioFormat)
 The chunk size is fixed at mChunkSize = sizeof(CAFAudioFormat) to accommodate the information in the Audio Description chunk’s data section.


 */

/// The Audio Description chunk can fully describe any constant-bit-rate format that has one or more channels of the same size. For variable bit rate data, a CAF file also requires a Packet Table chunk. See Packet Table Chunk.

/// A CAF file can store any number of audio channels. The mChannelsPerFrame field specifies the number of channels in the data (or encoded in the data for compressed formats). For noncompressed formats, the mBitsPerChannel field specifies how many bits are assigned to each channel (for compressed formats, this field is 0). The layout of the channels is described by the Channel Layout chunk (Channel Layout Chunk).
public struct CafAudioFormat {
  /// The number of sample frames per second of the data. You can combine this value with the frames per packet to determine the amount of time represented by a packet. This value must be nonzero.
  public let sampleRate: Float64
  /// A four-character code indicating the general kind of data in the stream. See mFormatID Field. This value must be nonzero.
  public let formatID: UnknownRawValue<CafAudioFormatID>
  /// Flags specific to each format. May be set to 0 to indicate no format flags. See mFormatFlags Field.
  public let formatFlags: UInt32
  /// The number of bytes in a packet of data. For formats with a variable packet size, this field is set to 0. In that case, the file must include a Packet Table chunk Packet Table Chunk. Packets are always aligned to a byte boundary. For an example of an Audio Description chunk for a format with a variable packet size, see Compressed Audio Formats.
  public let bytesPerPacket: UInt32
  /// The number of sample frames in each packet of data. For compressed formats, this field indicates the number of frames encoded in each packet. For formats with a variable number of frames per packet, this field is set to 0 and the file must include a Packet Table chunk Packet Table Chunk.
  public let framesPerPacket: UInt32
  /// The number of channels in each frame of data. This value must be nonzero.
  public let channelsPerFrame: UInt32
  /// The number of bits of sample data for each channel in a frame of data. This field must be set to 0 if the data format (for instance any compressed format) does not contain separate samples for each channel (see Compressed Audio Formats).
  public let bitsPerChannel: UInt32

  public var requiresPacketTable: Bool {
    bytesPerPacket == 0 || framesPerPacket == 0
  }
}
