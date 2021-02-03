import Foundation

public struct CafChunkMetadata: CustomStringConvertible {
  public let offset: Int
  public let header: CafChunkHeader

  var totalSize: Int {
    Int(header.size) + 12
  }

  public var description: String {
    """
    Chunk(offset: \(offset), size: \(header.size), type: '\(header.type.rawValue.bytes.utf8String)'(\(header.type.rawValue.bytes.hexString())))
    """
  }
}
