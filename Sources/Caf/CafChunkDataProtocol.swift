import Foundation

public protocol CafChunkDataProtocol {
  init<T: DataProtocol>(data: T) throws
}
