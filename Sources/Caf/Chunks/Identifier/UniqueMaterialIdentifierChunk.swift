/*
 You can use the optional Unique Material Identifier chunk to uniquely identify the audio contained in a CAF file. There can be at most one UMID chunk within a file.

 The data in this chunk conforms to the standard SMPTE 330M-2004 specification for unique material identifiers. See http://www.smpte.org/standards/.

 The European Broadcasting Union (EBU) provides guidelines for use of UMIDs in broadcast production. CAF files should adhere to these guidelines. See http://www.ebu.ch/CMSimages/en/tec_text_d92-2001_tcm6-4721.pdf.

 Unique Material Identifier Chunk Header

 Table 2-24 shows the values for the fields in the Unique Material Identifier chunk header.

 Table 2-24  Unique Material Identifier chunk header fields
 Field
 Value
 mChunkType
 ‘umid’
 mChunkSize
 64 (sizeof(CAFUMIDChunk)); Must always be valid
 Unique Material Identifier Chunk Data Section

 The CAFUMIDChunk structure describes the UMID chunk’s data section.

 struct CAFUMIDChunk {
 UInt8 mBytes[64];
 };
 typedef struct CAFUMIDChunk CAFUMIDChunk;
 mBytes
 The UMID for the file. The first 32 bytes constitute the “Basic” UMID and include four pieces of information: instance number, flag indicating copy or original, material number, and description of device that recorded the original material.
 The second 32 bytes constitute the so-called “Source Pack” section for the UMID, which includes three additional pieces of information: timestamp of recording, geographic coordinates of recording, and ownership information.
 The size of a UMID chunk’s data section is exactly 64 bytes. If a CAF file has only a “Basic” UMID, the remaining 32 bytes in the data section should be set to 0.
 For more information, refer to the UMID specification, SMPTE 330M-2004, available from http://www.smpte.org/standards/.

 */
