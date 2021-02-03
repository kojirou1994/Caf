import Foundation
import ByteOpetarions

/// You can use the optional Information chunk to contain any number of human-readable text strings. Each string is accessed through a standard or application-defined key.

/// You should consider information in this chunk to be secondary when the same information appears in other chunks. For example, both the Information chunk and the MIDI chunk (MIDI Chunk) may specify key signature and tempo. In that case, the MIDI chunk values overrides the values in the Information chunk.

/*
 The Information chunk header can specify a data section size that is larger than the chunk’s current meaningful content in order to reserve room for additional data.

 Information Chunk Data Section

 The CAFStringsChunk structure describes the data section for the Information chunk.

 struct CAFStringsChunk {
 UInt32       mNumEntries;
 CAFStringID  mStrings[kVariableLengthArray];
 };
 mNumEntries
 The number of information strings in the chunk. Must always be valid.
 mStrings
 A variable-length keyed array of information entries. See Information Entries.
 CAF includes some conventions for the Information chunk’s key-value pairs.

 Apple reserves keys that are all lowercase (see Information Entry Keys). Application-defined keys should include at least one uppercase character.
 For any key that ends with ' date' (that is, the space character followed by the word 'date'—for example, 'recorded date'), the value must be a time-of-day string. See Time Of Day Data Format.
 Using a '.' (period) character as the first character of a key means that the key-value pair is not to be displayed. This allows you to store private information that should be preserved by other applications but not displayed to a user.
 Information Entries

 The CAFInformation structure describes an information entry.

 struct CAFInformation {
 UInt8  mKey[kVariableLengthArray];
 UInt8  mValue[kVariableLengthArray];
 };
 mKey
 A null-terminated UTF8 string. See Information Entry Keys.
 mValue
 A null-terminated UTF8 string.
 Information Entry Keys

 Apple reserves keys that are all lowercase. Application-defined keys should contain at least one uppercase character. Each key can be used only once. You can specify multiple values for a single key by separating the values with commas. The following are the standard keys for the Information chunk:

 tempo
 The base tempo of the audio data in beats per minute.
 key signature
 The key signature for the audio in the file. In the mValue field, the note is capitalized with values from A to G. Lowercase m indicates a minor key. Lowercase b indicates a flat key. The # symbol indicates a sharp key.
 Examples: ‘C’, ‘Cm’, ‘C#’, ‘Cb’.
 time signature
 The time signature for the audio in the file.
 Examples: ‘4/4’, ‘6/8’.
 artist
 The name of the performance artist for the audio in the file.
 Example: ‘Able Baker,Charlie Delta’
 album
 The name of the album that the audio in the file is a part of.
 track number
 The track number, within the album, for the audio in the file.
 year
 The year of publication for the audio in the file.
 composer
 The name of the composer for the audio in the file.
 lyricist
 The name of the lyricist for the audio in the file.
 genre
 The name of the genre for the audio in the file.
 title
 The title or name of the audio in the file. Can be different from the filename.
 recorded date
 A timestamp for the recording in the file. See Time Of Day Data Format.
 comments
 Freeform comments about the audio in the file.
 copyright
 Copyright information for the audio in the file.
 Example: 'Copyright © 2004 The CoolBandName. All Rights Reserved'
 source encoder
 Description of the encoding algorithm, if any, used for the audio in the file.
 Example: 'My AAC Encoder v4.2'
 encoding application
 Description of the encoding application, if any, used for the audio in the file.
 Example: 'My App v1.0'
 nominal bit rate
 Description of the bit rate used for the audio in the file.
 Example: '128 kbits'
 channel layout
 Description of the channel layout for the file.
 Examples: 'stereo', '5.1 Surround', '10.2 Surround'

 */
public struct InformationChunk: CafChunkDataProtocol, CustomStringConvertible {
  public init<T>(data: T) throws where T : DataProtocol {
    var reader = ByteReader(data)
    let number = try reader.readInteger() as UInt32
    strings = try reader.readAll()!.split(separator: 0).map { $0.utf8String }

    assert(strings.count == number*2)
  }

  public let strings: [String]

  public func toDictionary() -> [String : String] {
    var iterator = strings.makeIterator()
    var dictionary = [String : String]()
    while let key = iterator.next(),
          let value = iterator.next() {
      dictionary[key] = value
    }
    return dictionary
  }

  public var description: String {
    toDictionary().description
  }
}
