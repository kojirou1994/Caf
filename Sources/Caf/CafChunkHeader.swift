import KwiftUtility

public struct CafChunkHeader {
  /// The chunk type, described as a four-character code. Apple reserves all codes that use only lowercase alphabetic characters—that is, characters in the ASCII range of 'a'–'z' along with ' ' (space) and '.' (period). Application-defined chunk identifiers must include at least one character outside of this range (see User-Defined Chunk.
  public let type: UnknownRawValue<CafChunkType>
  /// The size, in bytes, of the data section for the chunk. This is the size of the chunk not including the header. Unless noted otherwise for a particular chunk type, mChunkSize must always be valid.
  /// The Audio Data chunk can use the special value for mChunkSize of –1 when the data section size is not known. See Audio Data Chunk.
  public let size: Int64
}
