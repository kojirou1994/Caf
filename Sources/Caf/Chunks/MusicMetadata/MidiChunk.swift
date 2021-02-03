/// You can use the optional MIDI chunk to contain MIDI data using the standard MIDI file format. It can be used to store metadata about the audio in the file’s Data chunk, or even a MIDI representation of that audio. For information on the MIDI standard, see http://www.midi.org.
/// You should consider information in this chunk to supersede conflicting information in the Information chunk (Information Chunk). For example, both the Information chunk and the MIDI chunk may specify key signature and tempo. In that case, the MIDI chunk values should override the values in the Information chunk.
public struct MidiChunk {
  public let offset: Int
  public let length: Int64
}

/*
 The MIDI chunk header must specify the true size of the valid data in the data section.

 MIDI Chunk Data Section

 The data section of a MIDI Chunk can be used to hold anything that can be described by a standard MIDI file, such as:

 Tempo information
 Key signature
 Time signature
 MIDI representation of the audio data; for example, MIDI note numbers

 */
