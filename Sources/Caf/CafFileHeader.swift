import KwiftExtension

public struct CafFileHeader {
  internal init(fileType: UInt32, fileVersion: UInt16, fileFlags: UInt16) throws {
    /*'caff'*/
    try preconditionOrThrow(fileType == 0x63616666, CafParserError.invalidFileType(fileType))

    switch fileVersion {
    case 1:
      try preconditionOrThrow(fileFlags == 0, CafParserError.invalidFileFlags(fileFlags, fileVersion: fileVersion))
    default:
      throw CafParserError.invalidFileVersion(fileVersion)
    }

    self.fileType = fileType
    self.fileVersion = fileVersion
    self.fileFlags = fileFlags
  }

  /// The file type. This value must be set to 'caff'. You should consider only files with the mFileType field set to 'caff' to be valid CAF files.
  public let fileType: UInt32
  /// The file version. For CAF files conforming to this specification, the version must be set to 1. If Apple releases a substantial revision of this specification, files compliant with that revision will have their mFileVersion field set to a number greater than 1.
  public let fileVersion: UInt16
  /// Flags reserved by Apple for future use. For CAF v1 files, must be set to 0. You should ignore any value of this field you don’t understand, and you should accept the file as a valid CAF file as long as the version and file type fields are valid.
  public let fileFlags: UInt16
}
