/// The Strings chunk header can specify a data section size that is larger than the chunk’s current meaningful content in order to reserve room for additional data.
public struct StringsChunk {
  public let offset: Int
  public let length: Int64
}
/*
 Strings Chunk Data Section

 The CAFStrings structure describes the data section for the Strings chunk.

 struct CAFStrings {
 UInt32       mNumEntries;
 CAFStringID  mStringsIDs[kVariableLengthArray];
 UInt8        mStrings[kVariableLengthArray];
 };
 mNumEntries
 The number of strings in the mStrings field.
 mStringsIDs
 A lookup table of string IDs for each of the strings in the mStrings field. You access strings by using the associated ID. It is recommended that you do not use 0 for an ID.
 mStrings
 An array of null-terminated UTF8-encoded text strings.

 String ID

 The CAFStringID structure describes a string ID, used for accessing a string.

 struct CAFStringID {
 UInt32  mStringID;
 SInt64  mStringStartByteOffset;
 };
 typedef struct CAFStringID CAFStringID;
 mStringID
 The identifier for the string, allowing applications and other chunks in the file to refer to the string.
 mStringStartByteOffset
 The offset, in bytes, for the start of the string, counting from the first byte after the last mStringsIDs entry. The first string has an offset value of 0.

 */
