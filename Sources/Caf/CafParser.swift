import ByteOpetarions
import Foundation
import KwiftExtension

public enum CafParserError: Error {
  case invalidFileType(UInt32)
  case invalidFileVersion(UInt16)
  case invalidFileFlags(UInt16, fileVersion: UInt16)

  case unexpectedChunkSize(size: Int, type: CafChunkType, expectedSize: Int)
}

/*
 All of the fields in a CAF file are in big-endian (network) byte order, with the exception of the audio data, which can be big- or little-endian depending on the data format.
 */
public struct CafParser<T: ByteRegionReaderProtocol> {

  private let reader: T

  public let header: CafFileHeader

  public init(_ reader: T) throws {
    var localReader = reader
    try localReader.seek(to: 0)

    var headerReader = try localReader.readAsByteReader(8)

    self.reader = localReader
    self.header = try .init(fileType: headerReader.readInteger(), fileVersion: headerReader.readInteger(), fileFlags: headerReader.readInteger())
  }

  public func forEachChunk(_ handler: (CafChunkMetadata, Int, inout T, inout Bool) throws -> Void) throws {
    var localReader = self.reader
    try localReader.seek(to: 8)

    var stop = false
    var index = 0

    while !stop, !localReader.isAtEnd {
      let offset = localReader.readerOffset
      let chunkType = try localReader.readInteger(endian: .big) as UInt32
      let chunkSize = try localReader.readInteger() as Int64
      let chunkHeader = CafChunkHeader(type: .init(rawValue: chunkType), size: chunkSize)

      let anyChunk = CafChunkMetadata(offset: offset, header: chunkHeader)
      try handler(anyChunk, index, &localReader, &stop)

      let expectedNewOffset = offset + anyChunk.totalSize

      try localReader.seek(to: expectedNewOffset)
      index += 1
    }
  }

  public func parse() throws -> CafFile {
    var audioDescription: CafChunk<AudioDescriptionChunk>?
    var audioData: CafChunk<AudioDataChunk>?
    var packetTable: CafChunk<PacketTableChunk>?
    var channelLayout: CafChunk<ChannelLayoutChunk>?
    var magicCookie: CafChunk<MagicCookieChunk>?

    var info: CafChunks<InformationChunk> = []
    var freeChunks: [CafChunkMetadata] = []
    var unknownChunks: [CafChunkMetadata] = []

    try forEachChunk { metadata, index, handle, stop in

      func loadFull() throws -> T.ByteRegion {
        try handle.read(Int(metadata.header.size))
      }

      switch metadata.header.type {
      case .known(let knownChunkType):
        switch knownChunkType {
        case .desc:
          try preconditionOrThrow(audioDescription == nil)
          try preconditionOrThrow(index == 0)
          audioDescription = try .init(metadata: metadata, data: AudioDescriptionChunk(data: loadFull()))
        case .chan:
          try preconditionOrThrow(channelLayout == nil)
          channelLayout = try .init(metadata: metadata, data: ChannelLayoutChunk(data: loadFull()))
          print(channelLayout!.data.info.channelLayoutTag.binaryString())
          print(channelLayout!.data.info.channelBitmap.binaryString())
          print(channelLayout!.data.info.channelDescriptions)
        case .info:
          try info.append(.init(metadata: metadata, data: InformationChunk(data: loadFull())))
        case .data:
          try preconditionOrThrow(audioData == nil)
          if metadata.header.size == -1 {
            // is last
            stop = true
          }
          audioData = .init(metadata: metadata, data: AudioDataChunk())
        case .pakt:
          try preconditionOrThrow(packetTable == nil)
          packetTable = try .init(metadata: metadata, data: .init(data: loadFull()))
        case .kuki:
          try preconditionOrThrow(magicCookie == nil)
          magicCookie = .init(metadata: metadata, data: .init())
        case .free:
          freeChunks.append(metadata)
        default:
          fatalError("Unimplemented \(metadata)")
        }
      case .unknwon:
        unknownChunks.append(metadata)
      }

    }

    let ad = try audioDescription.unwrap()
    if ad.data.info.channelsPerFrame > 2 {
      try preconditionOrThrow(channelLayout != nil)
    }
    if ad.data.info.requiresPacketTable {
      try preconditionOrThrow(packetTable != nil)
    }

    return try .init(
      audioDescription: ad,
      audioData: audioData.unwrap(),
      packetTable: packetTable,
      channelLayout: channelLayout, magicCookie: magicCookie, info: info,
      freeChunks: freeChunks, unknownChunks: unknownChunks)
  }
}
