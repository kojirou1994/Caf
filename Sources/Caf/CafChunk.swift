public struct CafChunk<T> {
  internal init(metadata: CafChunkMetadata, data: T) {
    self.metadata = metadata
    self.data = data
  }

  public let metadata: CafChunkMetadata
  public let data: T
}

public typealias CafChunks<T> = [CafChunk<T>]
