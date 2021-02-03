/// The optional Instrument chunk can be used to describe the audio data in a CAF file in terms relevant to samplers or to other digital audio processing applications. For example, a file or a portion of a file can be described as a MIDI instrument. (For more information about MIDI and MIDI instruments, go to http://www.midi.org/.)There can be any number of Instrument chunks in a CAF file, each specifying a portion of the file.
public struct InstrumentChunk {
  public let offset: Int
  public let length: Int64
}

/*
 Instrument Chunk Data Section

 The Instrument chunk data section has informational fields and a list of region descriptions. The CAFInstrumentChunk structure describes the data section for this chunk.

 struct CAFInstrumentChunk {
 Float32  mBaseNote;
 UInt8    mMIDILowNote;
 UInt8    mMIDIHighNote;
 UInt8    mMIDILowVelocity;
 UInt8    mMIDIHighVelocity;
 Float32  mdBGain;
 UInt32   mStartRegionID;
 UInt32   mSustainRegionID;
 UInt32   mReleaseRegionID;
 UInt32   mInstrumentID;
 };
 typedef struct CAFInstrumentChunk CAFInstrumentChunk;

 mBaseNote
 The MIDI note number, and fractional pitch, for the base note of the MIDI instrument. The integer portion of this field indicates the base note, in the integer range 0 to 127, where a value of 60 represents middle C and each integer is a step on a standard piano keyboard (for example, 61 is C# above middle C). The fractional part of the field specifies the fractional pitch; for example, 60.5 is a pitch halfway between notes 60 and 61.
 mMIDILowNote
 The lowest note for the region, in the integer range 0 to 127, where a value of 60 represents middle C (following the MIDI convention). This value represents the suggested lowest note on a keyboard for playback of this instrument definition. The sound data should be played if the instrument is requested to play a note between mMIDILowNote and mMIDIHighNote, inclusive. The mBaseNote value must be within this range.
 mMIDIHighNote
 The highest note for the region when used as a MIDI instrument, in the integer range 0 to 127, where a value of 60 represents middle C. See the discussions of the mBaseNote and mMIDILowNote fields for more information.
 mMIDILowVelocity
 The lowest MIDI velocity for playing the region , in the integer range 0 to 127.
 mMIDIHighVelocity
 The highest MIDI velocity for playing the region, in the integer range 0 to 127.
 mdBGain
 The gain, in decibels, for playing the region. A value of 0 represents unity gain. Use negative numbers to indicate a decrease in gain.
 mStartRegionID
 The ID of the region (seeRegion Description) that defines the portion of the file to use as the “start” stage for a MIDI instrument. A lack of a valid region ID in this field indicates that there is no start stage. It is recommended that you do not assign an ID of 0 to any region description, so that you can use 0 in this and the following fields to indicate the lack of a region ID.
 mSustainRegionID
 The ID of the region (in the Region chunk) that defines the portion of the file to use as the “sustain” stage for a MIDI instrument. A lack of a valid region ID in this field indicates that there is no sustain stage.
 mReleaseRegionID
 The ID of the region (in the Region chunk) that defines the portion of the file to use as the “release” stage for a MIDI instrument. A lack of a valid region ID in this field indicates that there is no release stage.
 mInstrumentID
 The ID of the string (in the Strings chunk, Strings Chunk) that specifies the name of the instrument. A lack of a valid string ID in this field means that no name is specified. It is recommended that you do not assign an ID of 0 to any string description, so that you can use 0 in this field to indicate the lack of a string ID.

 */
