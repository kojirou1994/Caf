/// CAF files that contain variable bit-rate (VBR) or variable frame-rate (VFR) audio data contain audio packets of varying size. Such files must have exactly one Packet Table chunk to specify the size of each packet.

/// You can identify CAF files containing VBR or VFR audio by their Audio Description chunk. In such files, one or both of the mBytesPerPacket and mFramesPerPacket fields in the Audio Description chunk has a value of 0. See Audio Description Chunk.

/// The content of the Packet Table chunk describes, and therefore depends on, the content of the Audio Data chunk. See Audio Data Chunk. The packet table must always reflect current state of the audio data in a CAF file.

/// A CAF file with constant packet size can still include a Packet Table chunk in order to record certain information about frames (see Packet Table Description).
import ByteOpetarions
import Foundation

public struct PacketTableChunk: CafChunkDataProtocol, CustomStringConvertible {
  public init<T>(data: T) throws where T : DataProtocol {
    var reader = ByteReader(data)
    self.header = try .init(
      packetsCount: reader.readInteger(),
      validFramesCount: reader.readInteger(),
      primingFramesCount: reader.readInteger(),
      remainderFramesCount: reader.readInteger())
    self.data = try reader.readAll().map(ContiguousArray.init) ?? .init()
  }

  let header: PacketTableHeader
  let data: ContiguousArray<UInt8>

  public var description: String {
    "header: \(header), data: \(data.count) elements"
  }
}

/*
 For a CAF file with variable packet sizes, the value for mChunkSize can be greater than the actual valid content of the packet table chunk. The Packet Table description indicates the number of valid entries in the Packet Table (see Packet Table Description). In the case of a CAF file with constant packet size, the value for mChunkSize should be 24 bytes—just enough to contain the Packet Table description itself.


 Packet Table Description

 This chunk has a descriptive section for the packet table itself. It appears immediately after the chunk header. The CAFPacketTableHeader structure describes it:

 struct CAFPacketTableHeader {
 SInt64  mNumberPackets;
 SInt64  mNumberValidFrames;
 SInt32  mPrimingFrames;
 SInt32  mRemainderFrames;
 };

 The mNumberPackets value is specified only when the chunk contains a packet table—that is, when the CAF file contains variable-sized packets. On the other hand, regardless of whether its packets vary in size or not, any CAF file can use the mNumberValildFrames, mPrimingFrames, and mRemainderFrames fields.

 Packet Table Chunk Data Section

 The Packet Table chunk’s data section lists information about variable-sized packets in the file’s Audio Data chunk. See Audio Data Chunk.

 For a given CAF file, depending on the file’s audio format, packets can vary in size because of a variable bit rate (variable bytes per packet), a variable number of frames per packet, or both.

 The following list of these three audio format types includes the corresponding values for mBytesPerPacket and mFramesPerPacket present in the Audio Description chunk. See Audio Description Chunk:

 Variable bit rate, constant number of frames per packet (such as AAC and variable-bit-rate MP3): mBytesPerPacket is zero, mFramesPerPacket is nonzero.
 The Packet Table chunk data section contains single-number entries that describe the size, in bytes, of each packet in the Audio Data chunk.

 Variable number of frames per packet, constant bit rate: mBytesPerPacket is nonzero; mFramesPerPacket is zero.
 The Packet Table chunk data section contains single-number entries that describe the number of frames represented by each packet in the Audio Data chunk.

 Variable bit rate, variable number of frames per packet (such as Ogg Vorbis): mBytesPerPacket is zero, mFramesPerPacket is zero.
 The Packet Table chunk data section contains ordered-pair entries. The first number in each pair is the packet size, in bytes; the second is the number of frames per packet.

 The numbers describing the size of packets or frames per packet are encoded as variable-length integers. In this encoding scheme, each byte contains 7 bits of the binary integer and a 1-bit continuation flag—the high-order bit in each byte is used to indicate whether the number is continued in the next byte. The lowest-order byte in any given integer is therefore the first one for which the high-order bit is not set; that is, the first byte that has a value less than 128 holds the last 7 bits in the integer. Table 2-9 gives some examples of encoded integers.


 */

public struct PacketTableHeader {
  /// The total number of packets of audio data described in the packet table. This value must always be valid.
  /// For a CAF file with variable packet sizes, this value should reflect the actual number of packets in the Audio Data chunk. In a CAF file with constant packet size, and therefore no packet table, this field should be set to 0.
  public let packetsCount: Int64
  /// The total number of audio frames encoded in the file. The duration of the audio in the file is this value divided by the sample rate specified in the file’s Audio Description chunk. See Audio Description Chunk. The value of this field must always be valid.
  public let validFramesCount: Int64
  /// The number of frames for priming or processing latency for a compressed audio format. For example, MPEG-AAC codecs typically have a latency of 2112 frames. The number of priming frames can be useful for any CAF file containing compressed audio, whether or not the packets vary in size.
  public let primingFramesCount: Int32
  /// The number of unused frames in the CAF file’s final packet; that is, the number of frames that should be trimmed from the output of the last packet when decoding.
  /// For example, an AAC file may have only 313 frames containing audio data in its final packet. AAC files hold 1024 frames per packet. The value for mRemainderFrames is then 1024 – 313 = 711.
  public let remainderFramesCount: Int32

}
