/// Every CAF file must have exactly one Audio Data chunk. Whereas other chunks contain data that help to characterize or interpret the audio, this is the chunk in a CAF file that contains the actual audio data. If its size is specified, this chunk can be placed anywhere following the Audio Description chunk. If its size is not specified, the Audio Data chunk must be last in the file.


public struct AudioDataChunk {
  
}

/*
 Size of data section in bytes, or -1 if unknown.

 An mChunkSize value of -1 indicates that the size of the data section for this chunk is unknown. In this case, the Audio Data chunk must appear last in the file so that the end of the Audio Data chunk is the same as the end of the file. This placement allows you to determine the data section size.

 It is highly recommended that, after recording or modifying the audio data, you finalize the CAF file by updating the mChunkSize field to reflect the size of the Audio Data chunk’s data section. When you read a CAF file whose audio data section size is not specified, you should determine the size and update the mChunkSize value for the Audio Data chunk.

 If the Audio Data chunk is not the last chunk in a CAF file, the mChunkSize field must contain the size of the chunk’s data section for the file to be valid.

 Immediately following the Audio Data chunk’s header is the audio data section.


 Audio Data Chunk Data Section

 The data section in an Audio Data chunk contains audio data in the format specified by the Audio Description chunk. See Audio Description Chunk.

 The Audio Data chunk’s data section has an edit count field followed by the audio data for the file. The CAFData structure describes the data section for this chunk.

 struct CAFData {
 UInt32 mEditCount;                 // initially set to 0
 UInt8 mData [kVariableLengthArray];
 };
 mEditCount
 The modification status of the data section. You should initially set this field to 0, and should increment it each time the audio data in the file is modified.
 mData
 The audio data for the CAF file, in the format specified by the Audio Description chunk.
 You can compare the value of mEditCount to the corresponding value in a dependent chunk, such as the Overview Chunk or Peak Chunk.

 This document does not address the specifics of the data formats specified by the Audio Description chunk. Refer to specifications issued by the appropriate standards body or industry entity for information on a specific audio data format.


 */
