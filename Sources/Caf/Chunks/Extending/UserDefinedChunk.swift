/*
 User-Defined Chunk
 If you define your own, custom chunk, you can use the User-Defined chunk type to assign a universally unique ID to the chunk.

 User-Defined Chunk Header

 Table 2-25 shows the values for the fields in the User-Defined chunk header.

 Table 2-25  CAF header field values for User-Defined Chunk
 Field
 Value
 mChunkType
 ‘uuid’
 mChunkSize
 The size of the data section plus 16 bytes for the UUID. Must always be valid
 In addition to the standard fields, the header of a custom chunk includes a universal identifier, as shown in the CAF_UUID_ChunkHeader structure.

 struct CAF_UUID_ChunkHeader {
 CAFChunkHeader  mHeader;
 UInt8           mUUID[16];
 };
 CAF_UUID_ChunkHeader CAF_UUID_ChunkHeader;
 mHeader
 The standard CAF header with the values in Table 2-25.
 mUUID
 A unique universal identifier (UUID), based on the ISO 14496-1 specification for UUID identifiers, available from http://www.iso.ch/iso/en/CatalogueListPage.CatalogueList.
 User-Defined Chunk Data Section

 Any data following the chunk header is defined by the custom chunk type. If the UUID chunk has dependencies on the edit count of the Audio Data chunk, then the edit count should be stored after the mUUID field.


 */
