/// You can use the optional Overview chunk to hold sample descriptions that you can use to draw a graphical view of the audio data in a CAF file. A CAF file can include multiple Overview chunks to represent the audio at multiple graphical resolutions.
public struct OverviewChunk {
  public let offset: Int
  public let length: Int64
}

/*

 The Overview chunk header must specify the true size of the valid data in the data section.


 Overview Chunk Data Section

 The Overview chunk data section has two informational fields followed by a list of sample descriptions. The CAFOverview structure describes the data section for this chunk.

 struct CAFOverview {
 UInt32             mEditCount;
 UInt32             mNumFramesPerOVWSample;
 CAFOverviewSample  mData[kVariableLengthArray];
 };
 typedef struct CAFOverview CAFOverview;
 mEditCount
 The modification count of the Overview Chunk data section. When you create an Overview chunk, you should set the mEditCount field to the value of the mEditCount field of the CAF file’s Audio Data chunk. You can then check whether an overview is still valid by comparing the edit counts. If they don’t match, you should regenerate the overview.
 mNumFramesPerOVWSample
 The number of frames of audio data that are represented by a single overview sample.
 mData
 An array of overview samples. For the mNumFramesPerOVWSample frames of audio in the Audio Data chunk, you must store one sample per channel in this field. The sequence of channels should be the same as in the Audio Data chunk.

 Overview Sample

 The Overview chunk data section contains overview samples, described by the CAFOverviewSample structure.

 struct CAFOverviewSample {
 SInt16  mMinValue;
 SInt16  mMaxValue;
 };

 mMinValue
 The minimum value for the sample, listed as a big-endian, 16-bit signed integer.
 mMaxValue
 The maximum value for the sample, listed as a big-endian, 16-bit signed integer.

 */
