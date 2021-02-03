import ByteOpetarions
import Foundation

/// The Channel Layout chunk describes the order and role of each channel in a CAF file. It is especially useful for any CAF file with more than two audio channels but can also provide important information for one- and two-channel files. For example, when a user converts a stereo or multichannel audio file to a set of one-channel files, the Channel Layout chunk can indicate the role of each one-channel file.
/// In the Audio Data chunk (Audio Data Chunk) of an uncompressed audio CAF file, a sample for each channel appears in sequence in each frame. The number of channels per frame and the number of bits per channel are specified in the Audio Description chunk (see Audio Description Chunk Data Section). The Channel Description chunk specifies the order in which the channel data appears in the audio data chunk.
public struct ChannelLayoutChunk: CafChunkDataProtocol {
  public init<T>(data: T) throws where T : DataProtocol {
    var reader = ByteReader(data)
    let channelLayoutTag: UInt32 = try reader.readInteger()
    let channelBitmap: UInt32 = try reader.readInteger()
    /// The number of channel descriptions in the mChannelDescriptions array. If this number is 0, then this is the last field in the structure
    let numberChannelDescriptions: UInt32 = try reader.readInteger()
    info = .init(channelLayoutTag: channelLayoutTag,
                 channelBitmap: channelBitmap,
                 numberChannelDescriptions: numberChannelDescriptions,
                 channelDescriptions: [])
  }

  public let info: CafChannelLayout
}

/// The Channel Layout chunk data section begins with a tag that indicates the nature of the data in the chunk, followed by the data, as shown in the CAFChannelLayout structure.
public struct CafChannelLayout {
  /// A tag that indicates the type of layout used, as described in Channel Layout Tags.
  public let channelLayoutTag: UInt32
  /// A bitmap that describes which channels are present. The order of the channels is the same as the order of the bits; that is, the lowest-order bit that is set corresponds to the first channel of the file, and so on. The number of set bits is the number of channels, which must equal the number of channels in the file. This bit-field technique is used both in WAV files and in the USB Audio Specification. See Channel Bitmaps for bit assignments.
  public let channelBitmap: UInt32
  public let numberChannelDescriptions: UInt32
  /// An array of CAFChannelDescription structures (Channel Description) that describe the layout of the channels. This field is not present if the mNumberChannelDescriptions field is 0.

  public let channelDescriptions: [ChannelDescription]
}
public struct ChannelDescription {
  public let channelLabel: UInt32
  public let channelFlags: UInt32
  public let coordinates: (Float, Float, Float)
}

//public struct ChannelFlags: OptionSet {
//  public init(rawValue: UInt32) {
//    self.rawValue = rawValue
//  }
//  public var rawValue: UInt32
//
//  static let allOff: Self = .init(rawValue: 0)
//  static let rectangularCoordinates: Self = .init(rawValue: 1 << 0)
//  static let sphericalCoordinates: Self = .init(rawValue: 1 << 1)
//  static let meters: Self = .init(rawValue: 1 << 2)
//}

/*
 Channel Bitmaps

 The significance of the bits in the mChannelBitmap field is specified in the following enumeration:

 enum {
 kCAFChannelBit_Left                 = (1<<0),
 kCAFChannelBit_Right                = (1<<1),
 kCAFChannelBit_Center               = (1<<2),
 kCAFChannelBit_LFEScreen            = (1<<3),
 kCAFChannelBit_LeftSurround         = (1<<4),   // WAVE: "Back Left"
 kCAFChannelBit_RightSurround        = (1<<5),   // WAVE: "Back Right"
 kCAFChannelBit_LeftCenter           = (1<<6),
 kCAFChannelBit_RightCenter          = (1<<7),
 kCAFChannelBit_CenterSurround       = (1<<8),   // WAVE: "Back Center"
 kCAFChannelBit_LeftSurroundDirect   = (1<<9),   // WAVE: "Side Left"
 kCAFChannelBit_RightSurroundDirect  = (1<<10),  // WAVE: "Side Right"
 kCAFChannelBit_TopCenterSurround    = (1<<11),
 kCAFChannelBit_VerticalHeightLeft   = (1<<12),  // WAVE: "Top Front Left"
 kCAFChannelBit_VerticalHeightCenter = (1<<13),  // WAVE: "Top Front Center"
 kCAFChannelBit_VerticalHeightRight  = (1<<14),  // WAVE: "Top Front Right"
 kCAFChannelBit_TopBackLeft          = (1<<15),
 kCAFChannelBit_TopBackCenter        = (1<<16),
 kCAFChannelBit_TopBackRight         = (1<<17)
 };
 Channel Layout Tags

 Channel layouts can be described by a code in the mChannelLayoutTag field.

 A value of kCAFChannelLayoutTag_UseChannelDescriptions (== 0) indicates there is no standard description for the ordering or use of channels in the file, so that channel descriptions are used instead. In this case, the number of channel descriptions (mNumberChannelDescriptions) must equal the number of channels contained in the file. The channel descriptions follow the mNumberChannelDescriptions field; see Channel Description.

 A value of kCAFChannelLayoutTag_UseChannelBitmap (== 0x10000) indicates that the Channel Layout chunk uses a bitmap (in the mChannelBitmap field) to describe which channels are present.

 A value greater than 0x10000 indicates one of the layout tags listed below in this section. Each channel layout tag has two parts:

 The low 16 bits represents the number of channels described by the tag.
 The high 16 bits indicates a specific ordering of the channels.
 For example, the tag kCAFChannelLayoutTag_Stereo is defined as ((101<<16) | 2 ) and indicates a two-channel stereo, ordered left as the first channel, right as the second.

 Current values for this code are listed in the following enumeration:

 enum {
 kCAFChannelLayoutTag_UseChannelDescriptions = (0<<16) | 0,
 // use the array of AudioChannelDescriptions to define the mapping.

 kCAFChannelLayoutTag_UseChannelBitmap       = (1<<16) | 0,
 // use the bitmap to define the mapping.

 // 1 Channel Layout
 kCAFChannelLayoutTag_Mono                   = (100<<16) | 1,
 // a standard mono stream

 // 2 Channel layouts
 kCAFChannelLayoutTag_Stereo                 = (101<<16) | 2,
 // a standard stereo stream (L R)

 kCAFChannelLayoutTag_StereoHeadphones       = (102<<16) | 2,
 // a standard stereo stream (L R) - implied headphone playback

 kCAFChannelLayoutTag_MatrixStereo           = (103<<16) | 2,
 // a matrix encoded stereo stream (Lt, Rt)

 kCAFChannelLayoutTag_MidSide                = (104<<16) | 2,
 // mid/side recording

 kCAFChannelLayoutTag_XY                     = (105<<16) | 2,
 // coincident mic pair (often 2 figure 8's)

 kCAFChannelLayoutTag_Binaural               = (106<<16) | 2,
 // binaural stereo (left, right)

 // Symmetric arrangements - same distance between speaker locations
 kCAFChannelLayoutTag_Ambisonic_B_Format     = (107<<16) | 4,
 // W, X, Y, Z

 kCAFChannelLayoutTag_Quadraphonic           = (108<<16) | 4,
 // front left, front right, back left, back right

 kCAFChannelLayoutTag_Pentagonal             = (109<<16) | 5,
 // left, right, rear left, rear right, center

 kCAFChannelLayoutTag_Hexagonal              = (110<<16) | 6,
 // left, right, rear left, rear right, center, rear

 kCAFChannelLayoutTag_Octagonal              = (111<<16) | 8,
 // front left, front right, rear left, rear right,
 // front center, rear center, side left, side right

 kCAFChannelLayoutTag_Cube                   = (112<<16) | 8,
 // left, right, rear left, rear right
 // top left, top right, top rear left, top rear right

 //  MPEG defined layouts
 kCAFChannelLayoutTag_MPEG_1_0   = kCAFChannelLayoutTag_Mono,    //  C
 kCAFChannelLayoutTag_MPEG_2_0   = kCAFChannelLayoutTag_Stereo,  //  L R
 kCAFChannelLayoutTag_MPEG_3_0_A = (113<<16) | 3,         // L R C
 kCAFChannelLayoutTag_MPEG_3_0_B = (114<<16) | 3,         // C L R
 kCAFChannelLayoutTag_MPEG_4_0_A = (115<<16) | 4,         // L R C Cs
 kCAFChannelLayoutTag_MPEG_4_0_B = (116<<16) | 4,         // C L R Cs
 kCAFChannelLayoutTag_MPEG_5_0_A = (117<<16) | 5,         // L R C Ls Rs
 kCAFChannelLayoutTag_MPEG_5_0_B = (118<<16) | 5,         // L R Ls Rs C
 kCAFChannelLayoutTag_MPEG_5_0_C = (119<<16) | 5,         // L C R Ls Rs
 kCAFChannelLayoutTag_MPEG_5_0_D = (120<<16) | 5,         // C L R Ls Rs
 kCAFChannelLayoutTag_MPEG_5_1_A = (121<<16) | 6,         // L R C LFE Ls Rs
 kCAFChannelLayoutTag_MPEG_5_1_B = (122<<16) | 6,         // L R Ls Rs C LFE
 kCAFChannelLayoutTag_MPEG_5_1_C = (123<<16) | 6,         // L C R Ls Rs LFE
 kCAFChannelLayoutTag_MPEG_5_1_D = (124<<16) | 6,         // C L R Ls Rs LFE
 kCAFChannelLayoutTag_MPEG_6_1_A = (125<<16) | 7,         // L R C LFE Ls Rs Cs
 kCAFChannelLayoutTag_MPEG_7_1_A = (126<<16) | 8,         // L R C LFE Ls Rs Lc Rc
 kCAFChannelLayoutTag_MPEG_7_1_B = (127<<16) | 8,         // C Lc Rc L R Ls Rs LFE
 kCAFChannelLayoutTag_MPEG_7_1_C = (128<<16) | 8,         // L R C LFE Ls R Rls Rrs

 kCAFChannelLayoutTag_Emagic_Default_7_1 = (129<<16) | 8,
 //  L R Ls Rs C LFE Lc Rc

 kCAFChannelLayoutTag_SMPTE_DTV          = (130<<16) | 8,
 //  L R C LFE Ls Rs Lt Rt
 //  (kCAFChannelLayoutTag_ITU_5_1 plus a matrix encoded stereo mix)

 //  ITU defined layouts
 kCAFChannelLayoutTag_ITU_1_0    = kCAFChannelLayoutTag_Mono,    //  C
 kCAFChannelLayoutTag_ITU_2_0    = kCAFChannelLayoutTag_Stereo,  //  L R

 kCAFChannelLayoutTag_ITU_2_1    = (131<<16) | 3,    // L R Cs
 kCAFChannelLayoutTag_ITU_2_2    = (132<<16) | 4,    // L R Ls Rs
 kCAFChannelLayoutTag_ITU_3_0    = kCAFChannelLayoutTag_MPEG_3_0_A,  //  L R C
 kCAFChannelLayoutTag_ITU_3_1    = kCAFChannelLayoutTag_MPEG_4_0_A,  //  L R C Cs

 kCAFChannelLayoutTag_ITU_3_2    = kCAFChannelLayoutTag_MPEG_5_0_A,  //  L R C Ls Rs
 kCAFChannelLayoutTag_ITU_3_2_1  = kCAFChannelLayoutTag_MPEG_5_1_A,
 //  L R C LFE Ls Rs
 kCAFChannelLayoutTag_ITU_3_4_1  = kCAFChannelLayoutTag_MPEG_7_1_C,
 //  L R C LFE Ls Rs Rls Rrs

 // DVD defined layouts
 kCAFChannelLayoutTag_DVD_0  = kCAFChannelLayoutTag_Mono,    // C (mono)
 kCAFChannelLayoutTag_DVD_1  = kCAFChannelLayoutTag_Stereo,  // L R
 kCAFChannelLayoutTag_DVD_2  = kCAFChannelLayoutTag_ITU_2_1, // L R Cs
 kCAFChannelLayoutTag_DVD_3  = kCAFChannelLayoutTag_ITU_2_2, // L R Ls Rs
 kCAFChannelLayoutTag_DVD_4  = (133<<16) | 3,                // L R LFE
 kCAFChannelLayoutTag_DVD_5  = (134<<16) | 4,                // L R LFE Cs
 kCAFChannelLayoutTag_DVD_6  = (135<<16) | 5,                // L R LFE Ls Rs
 kCAFChannelLayoutTag_DVD_7  = kCAFChannelLayoutTag_MPEG_3_0_A,// L R C
 kCAFChannelLayoutTag_DVD_8  = kCAFChannelLayoutTag_MPEG_4_0_A,// L R C Cs
 kCAFChannelLayoutTag_DVD_9  = kCAFChannelLayoutTag_MPEG_5_0_A,// L R C Ls Rs
 kCAFChannelLayoutTag_DVD_10 = (136<<16) | 4,                // L R C LFE
 kCAFChannelLayoutTag_DVD_11 = (137<<16) | 5,                // L R C LFE Cs
 kCAFChannelLayoutTag_DVD_12 = kCAFChannelLayoutTag_MPEG_5_1_A,// L R C LFE Ls Rs
 // 13 through 17 are duplicates of 8 through 12.
 kCAFChannelLayoutTag_DVD_13 = kCAFChannelLayoutTag_DVD_8,   // L R C Cs
 kCAFChannelLayoutTag_DVD_14 = kCAFChannelLayoutTag_DVD_9,   // L R C Ls Rs
 kCAFChannelLayoutTag_DVD_15 = kCAFChannelLayoutTag_DVD_10,  // L R C LFE
 kCAFChannelLayoutTag_DVD_16 = kCAFChannelLayoutTag_DVD_11,  // L R C LFE Cs
 kCAFChannelLayoutTag_DVD_17 = kCAFChannelLayoutTag_DVD_12,  // L R C LFE Ls Rs
 kCAFChannelLayoutTag_DVD_18 = (138<<16) | 5,                // L R Ls Rs LFE
 kCAFChannelLayoutTag_DVD_19 = kCAFChannelLayoutTag_MPEG_5_0_B,// L R Ls Rs C
 kCAFChannelLayoutTag_DVD_20 = kCAFChannelLayoutTag_MPEG_5_1_B,// L R Ls Rs C LFE

 // These layouts are recommended for audio unit use
 // These are the symmetrical layouts
 kCAFChannelLayoutTag_AudioUnit_4= kCAFChannelLayoutTag_Quadraphonic,
 kCAFChannelLayoutTag_AudioUnit_5= kCAFChannelLayoutTag_Pentagonal,
 kCAFChannelLayoutTag_AudioUnit_6= kCAFChannelLayoutTag_Hexagonal,
 kCAFChannelLayoutTag_AudioUnit_8= kCAFChannelLayoutTag_Octagonal,
 // These are the surround-based layouts
 kCAFChannelLayoutTag_AudioUnit_5_0  = kCAFChannelLayoutTag_MPEG_5_0_B,
 // L R Ls Rs C
 kCAFChannelLayoutTag_AudioUnit_6_0  = (139<<16) | 6,        // L R Ls Rs C Cs
 kCAFChannelLayoutTag_AudioUnit_7_0  = (140<<16) | 7,        // L R Ls Rs C Rls Rrs
 kCAFChannelLayoutTag_AudioUnit_5_1  = kCAFChannelLayoutTag_MPEG_5_1_A,
 // L R C LFE Ls Rs
 kCAFChannelLayoutTag_AudioUnit_6_1  = kCAFChannelLayoutTag_MPEG_6_1_A,
 // L R C LFE Ls Rs Cs
 kCAFChannelLayoutTag_AudioUnit_7_1  = kCAFChannelLayoutTag_MPEG_7_1_C,
 // L R C LFE Ls Rs Rls Rrs

 // These layouts are used for AAC Encoding within the MPEG-4 Specification
 kCAFChannelLayoutTag_AAC_Quadraphonic   = kCAFChannelLayoutTag_Quadraphonic,
 // L R Ls Rs
 kCAFChannelLayoutTag_AAC_4_0= kCAFChannelLayoutTag_MPEG_4_0_B,  // C L R Cs
 kCAFChannelLayoutTag_AAC_5_0= kCAFChannelLayoutTag_MPEG_5_0_D,  // C L R Ls Rs
 kCAFChannelLayoutTag_AAC_5_1= kCAFChannelLayoutTag_MPEG_5_1_D,  // C L R Ls Rs Lfe
 kCAFChannelLayoutTag_AAC_6_0= (141<<16) | 6,            // C L R Ls Rs Cs
 kCAFChannelLayoutTag_AAC_6_1= (142<<16) | 7,            // C L R Ls Rs Cs Lfe
 kCAFChannelLayoutTag_AAC_7_0= (143<<16) | 7,            // C L R Ls Rs Rls Rrs
 kCAFChannelLayoutTag_AAC_7_1= kCAFChannelLayoutTag_MPEG_7_1_B,
 // C Lc Rc L R Ls Rs Lfe
 kCAFChannelLayoutTag_AAC_Octagonal  = (144<<16) | 8,    // C L R Ls Rs Rls Rrs Cs


 kCAFChannelLayoutTag_TMH_10_2_std   = (145<<16) | 16,
 // L R C Vhc Lsd Rsd Ls Rs Vhl Vhr Lw Rw Csd Cs LFE1 LFE2
 kCAFChannelLayoutTag_TMH_10_2_full  = (146<<16) | 21,
 // TMH_10_2_std plus: Lc Rc HI VI Haptic

 kCAFChannelLayoutTag_RESERVED_DO_NOT_USE= (147<<16)
 };
 Channel Description

 If the channel layout tag is set to kCAFChannelLayoutTag_UseChannelDescriptions , there is no standard description for the ordering or use of channels in the file; channel descriptions are used instead. In this case, the number of channel descriptions (mNumberChannelDescriptions) must equal the number of channels contained in the file. Following the mNumberChannelDescriptions field is an array of channel descriptions, one for each channel, as specified by the CAFChannelDescription structure:

 struct CAFChannelDescription {
 UInt32   mChannelLabel;
 UInt32   mChannelFlags;
 Float32  mCoordinates[3];
 };
 mChannelLabel
 A label that describes the role of the channel. In common cases, such as “Left” or “Right,” role implies location. In such cases, mChannelFlags and mCoordinates can be set to 0. Refer to Label Codes for Channel Layouts.
 mChannelFlags
 Flags that indicate how to interpret the data in the mCoordinates field. Refer to Channel Flags for Channel Layouts. If the audio channel does not require this information, set this field to 0.
 mCoordinates
 A set of three coordinates that specify the placement of the sound source for the channel in three dimensions, according to the mChannelFlags information. If the audio channel does not require this information, set this field to 0.
 The number of channel descriptions in this chunk’s data section must match the number of channels specified in the mChannelsPerFrame field of the Audio Description chunk. In addition, the order of the channel descriptions must correspond to the order of the channels in the Audio Data chunk. See Audio Description Chunk and Audio Data Chunk.

 You can use the optional Information chunk (Information Chunk) to supply user-presentable names for particular channel layouts. However, if there is any conflict between the channel assignments in the Information chunk and those in the Channel Layout chunk, the Channel Layout chunk always takes precedence.

 Label Codes for Channel Layouts

 Label Codes indicate the role of a channel. CAF files specify this information in this chunk’s mChannelLabel field.

 The following list includes most channel layouts in common use. Due to differences in channel labeling by various industry groups, there may be overlap or duplication. In every case, use the label that most clearly describes the role of the audio channel.

 enum {
 kCAFChannelLabel_Unknown        = 0xFFFFFFFF, // unknown role or unspecified other use for channel
 kCAFChannelLabel_Unused         = 0,          // channel is present, but has no intended role or destination
 kCAFChannelLabel_UseCoordinates = 100,        // channel is described solely by the mCoordinates fields

 kCAFChannelLabel_Left                 = 1,
 kCAFChannelLabel_Right                = 2,
 kCAFChannelLabel_Center               = 3,
 kCAFChannelLabel_LFEScreen            = 4,
 kCAFChannelLabel_LeftSurround         = 5,    // WAVE (.wav files): “Back Left”
 kCAFChannelLabel_RightSurround        = 6,    // WAVE: "Back Right"
 kCAFChannelLabel_LeftCenter           = 7,
 kCAFChannelLabel_RightCenter          = 8,
 kCAFChannelLabel_CenterSurround       = 9,    // WAVE: "Back Center or plain "Rear Surround"
 kCAFChannelLabel_LeftSurroundDirect   = 10,   // WAVE: "Side Left"
 kCAFChannelLabel_RightSurroundDirect  = 11,   // WAVE: "Side Right"
 kCAFChannelLabel_TopCenterSurround    = 12,
 kCAFChannelLabel_VerticalHeightLeft   = 13,   // WAVE: "Top Front Left”
 kCAFChannelLabel_VerticalHeightCenter = 14,   // WAVE: "Top Front Center”
 kCAFChannelLabel_VerticalHeightRight  = 15,   // WAVE: "Top Front Right”
 kCAFChannelLabel_TopBackLeft          = 16,
 kCAFChannelLabel_TopBackCenter        = 17,
 kCAFChannelLabel_TopBackRight         = 18,
 kCAFChannelLabel_RearSurroundLeft     = 33,
 kCAFChannelLabel_RearSurroundRight    = 34,
 kCAFChannelLabel_LeftWide             = 35,
 kCAFChannelLabel_RightWide            = 36,
 kCAFChannelLabel_LFE2                 = 37,
 kCAFChannelLabel_LeftTotal            = 38,   // matrix encoded 4 channels
 kCAFChannelLabel_RightTotal           = 39,   // matrix encoded 4 channels
 kCAFChannelLabel_HearingImpaired      = 40,
 kCAFChannelLabel_Narration            = 41,
 kCAFChannelLabel_Mono                 = 42,
 kCAFChannelLabel_DialogCentricMix     = 43,
 kCAFChannelLabel_CenterSurroundDirect = 44,   // back center, non diffuse

 // first order ambisonic channels
 kCAFChannelLabel_Ambisonic_W          = 200,
 kCAFChannelLabel_Ambisonic_X          = 201,
 kCAFChannelLabel_Ambisonic_Y          = 202,
 kCAFChannelLabel_Ambisonic_Z          = 203,

 // Mid/Side Recording
 kCAFChannelLabel_MS_Mid               = 204,
 kCAFChannelLabel_MS_Side              = 205,

 // X-Y Recording
 kCAFChannelLabel_XY_X                 = 206,
 kCAFChannelLabel_XY_Y                 = 207,

 // other
 kCAFChannelLabel_HeadphonesLeft       = 301,
 kCAFChannelLabel_HeadphonesRight      = 302,
 kCAFChannelLabel_ClickTrack           = 304,
 kCAFChannelLabel_ForeignLanguage      = 305
 };
 Channel Flags for Channel Layouts

 Channel Flags specify whether a channel layout uses spherical or rectangular coordinates, and whether distances are absolute or relative. CAF files specify this information in this chunk’s mChannelFlags field.

 Here are the CAF conventions for rectangular coordinates:

 Negative is left, and positive is right.
 Negative is back, and positive is front.
 Negative is below ground level, 0 is ground level, and positive is above ground level.
 In CAF files, spherical coordinates are measured in degrees. Here are the CAF conventions for spherical coordinates:

 0 is front center, positive is right, negative is left.
 +90 is zenith, 0 is horizontal, -90 is nadir.
 These constants are used in the mChannelFlags field of the Channel Layout chunk:

 enum {
 kCAFChannelFlags_AllOff                  = 0,
 kCAFChannelFlags_RectangularCoordinates  = (1<<0),
 kCAFChannelFlags_SphericalCoordinates    = (1<<1),
 kCAFChannelFlags_Meters                  = (1<<2)
 };
 kCAFChannelFlags_AllOff
 No flags are set.
 kCAFChannelFlags_RectangularCoordinates
 The channel is specified by the cartesian coordinates of the speaker position. This flag is mutually exclusive with kCAFChannelFlags_SphericalCoordinates.
 kCAFChannelFlags_SphericalCoordinates
 The channel is specified by the spherical coordinates of the speaker position. This flag is mutually exclusive with kCAFChannelFlags_RectangularCoordinates.
 kCAFChannelFlags_Meters
 A flag that indicates whether the units are absolute or relative. Set to indicate the units are in meters, clear to indicate the units are relative to the unit cube or unit sphere. For relative units, the listener is assumed to be at the center of the cube or sphere and the maximum radius of the sphere or the distance from the center to the midpoint of the side of the cube is 1.
 If the channel description provides no coordinate information, then the mChannelFlags field is set to 0.
 */
