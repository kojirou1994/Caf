/// You can use the optional Peak chunk to describe the peak amplitude present in each channel of a CAF file and to indicate in which frame the peak occurs for each channel.
public struct PeakChunk {
  public let offset: Int
  public let length: Int64
}

/*

 The Peak chunk uses a Peak structure to describe each peak (see Peak Structure). The size of a Peak chunk’s data section, to be placed in the mChunkSize field of the header, depends on the number of channels in the file as follows:

 mChunkSize = sizeof(CAFPositionPeak) * numChannelsInFile + sizeof(UInt32);
 The sizeof(UInt32) argument represents the data section’s mEditCount field. The number of channels in the file, represented by the numChannelsInFile argument, is specified in the mChannelsPerFrame field of the Audio Description chunk.


 Peak Chunk Data Section

 The Peak chunk data section contains a field for edit count, followed by a list of Peak structures. The CAFPeakChunk structure describes the data section for the Peak chunk.

 struct CAFPeakChunk {
 UInt32           mEditCount;
 CAFPositionPeak  mPeaks[kVariableLengthArray];
 };
 typedef struct CAFPeakChunk CAFPeakChunk;
 mEditCount
 The modification status of the Peak Chunk data section. When you create a Peak chunk, set the mEditCount field to the value of the mEditCount field of the CAF file’s Audio Data chunk. You can then check whether the peak data is still valid by comparing the edit counts. If they don’t match, the peak information must be regenerated.
 mPeaks
 An array of Peak structures, one for each channel of audio data contained in the file. See Peak Structure.
 The number of channels in the file is specified in the mChannelsPerFrame field of the Audio Description chunk (Audio Description Chunk).

 Peak Structure

 The Peak chunk data section contains one Peak structure for each channel, defined as follows:

 struct CAFPositionPeak {
 Float32  mValue;
 UInt64   mFrameNumber;
 };
 mValue
 The signed maximum absolute amplitude in a channel, normalized to a floating-point value in the interval [{–1.0, +1.0}].
 mFrameNumber
 The frame number where the peak occurs. The first frame in a CAF file is 0.

 */
