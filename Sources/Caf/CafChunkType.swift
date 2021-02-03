/*
 kCAF_MarkerChunkID        = 'mark',
 kCAF_RegionChunkID        = 'regn',
 kCAF_PeakChunkID        = 'peak',
 kCAF_UMIDChunkID        = 'umid',
 kCAF_FormatListID        = 'ldsc',
 kCAF_iXMLChunkID        = 'iXML'
 */

public enum CafChunkType: UInt32 {
  /// kCAF_StreamDescriptionChunkID
  case desc = 0x64657363
  /// kCAF_AudioDataChunkID
  case data = 0x64617461
  /// kCAF_ChannelLayoutChunkID
  case chan = 0x6368616E
  /// kCAF_InfoStringsChunkID
  case info = 0x696E666F
  /// kCAF_PacketTableChunkID
  case pakt = 0x70616B74
  /// kCAF_MagicCookieID
  case kuki = 0x6B756B69
  /// kCAF_StringsChunkID
  case strg = 0x73747267
  /// kCAF_InstrumentChunkID
  case inst = 0x696E7374
  /// kCAF_MIDIChunkID
  case midi = 0x6D696469
  /// kCAF_OverviewChunkID
  case ovvw = 0x6F767677
  /// kCAF_UUIDChunkID
  case uuid = 0x75756964
  /// kCAF_FillerChunkID
  case free = 0x66726565
  /// kCAF_EditCommentsChunkID
  case edct = 0x65646374
}
