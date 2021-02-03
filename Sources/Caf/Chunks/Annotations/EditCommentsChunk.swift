/*
 Edit Comments Chunk
 You can use the optional Edit Comments chunk to carry time-stamped, human-readable comments that coincide with edits to the audio data in a CAF file.

 Edit Comments Chunk Header

 Table 2-22 shows the values for the fields in the Edit Comments chunk header.

 Table 2-22  Edit Comments chunk header fields
 Field
 Value
 mChunkType
 ‘edct’
 mChunkSize
 Must always be valid
 The Edit Comments chunk header can specify a data section size that is larger than the chunk’s current meaningful content in order to reserve room for additional data.

 Edit Comments Chunk Data Section

 The data section for this chunk contains a field describing the number of entries, followed by a list of edit comments. The CAFCommentStringsChunk structure describes the data section for the Edit Comments chunk.

 struct CAFCommentStringsChunk {
 UInt32       mNumEntries;
 CAFStringID  mStrings[kVariableLengthArray];
 };
 mNumEntries
 The number of edit comments in the data section.
 mStrings
 A list of edit comments. See Edit Comment.
 Edit Comment

 The editComment structure describes an edit comment.

 struct editCommment {
 UInt8  mKey[kVariableLengthArray];
 UInt8  mValue[kVariableLengthArray];
 }
 mKey
 A null-terminated, time-of-day string that conforms to ISO-8601. All times are based on UTC (Coordinated Universal Time). See Time Of Day Data Format.
 mValue
 A null-terminated UTF8 string.

 */
