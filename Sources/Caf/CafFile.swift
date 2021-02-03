import Foundation

public struct CafFile {
  // MARK: Required Chunks
  /// Every CAF file must have an Audio Description chunk and an Audio Data chunk. CAF files containing variable bit rate or variable frame rate audio data must also have a Packet Table chunk.
  let audioDescription: CafChunk<AudioDescriptionChunk>

  /// Every CAF file must have exactly one Audio Data chunk. Whereas other chunks contain data that help to characterize or interpret the audio, this is the chunk in a CAF file that contains the actual audio data. If its size is specified, this chunk can be placed anywhere following the Audio Description chunk. If its size is not specified, the Audio Data chunk must be last in the file.
  let audioData: CafChunk<AudioDataChunk>

  let packetTable: CafChunk<PacketTableChunk>?

  // MARK: Channel Layout
  let channelLayout: CafChunk<ChannelLayoutChunk>?

  // MARK: Supplementary Data
  let magicCookie: CafChunk<MagicCookieChunk>?

  // MARK: Annotations
  let info: CafChunks<InformationChunk>

  /// The optional Free chunk is for reserving space, or providing padding, in a CAF file. The contents of the Free chunk data section have no significance and should be ignored.
  let freeChunks: [CafChunkMetadata]

  /// The chunks not supported by parser.
  let unknownChunks: [CafChunkMetadata]
}
