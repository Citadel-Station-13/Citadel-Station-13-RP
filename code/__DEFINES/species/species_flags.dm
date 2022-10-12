//! ## SPECIES_FLAGS
/// Can step on broken glass with no ill-effects. Either thick skin (diona), cut resistant (slimes) or incorporeal (shadows)
#define NO_MINOR_CUT (1<<0)
/// Is a treeperson.
#define IS_PLANT (1<<1)
/// Cannot be scanned in a DNA machine/genome-stolen.
#define NO_SCAN (1<<2)
/// Cannot suffer halloss/recieves deceptive health indicator.
#define NO_PAIN (1<<3)
/// Cannot fall over.
#define NO_SLIP (1<<4)
/// Cannot not suffer toxloss.
#define NO_POISON (1<<5)
/// Can step on broken glass with no ill-effects and cannot have shrapnel embedded in it.
#define NO_EMBED (1<<6)
/// Don't hallucinate, ever.
#define NO_HALLUCINATION (1<<7)
/// Never bleed, never show blood amount.
#define NO_BLOOD (1<<8)
/// Various things that living things don't do, mostly for skeletons.
#define UNDEAD (1<<9)
/// Don't allow infections in limbs or organs, similar to IS_PLANT, without other strings.
#define NO_INFECT (1<<10)
/// Cannot be defibbed.
#define NO_DEFIB (1<<11)
///(Phoron) Contamination doesnt affect them.
#define CONTAMINATION_IMMUNE (1<<12)
// unused: 0x8000 - higher than this will overflow


//! ## SPAWN_FLAGS
/// Must be whitelisted to play.
#define SPECIES_IS_WHITELISTED (1<<0)
/// Is not a core/normally playable species. (castes, mutantraces)
#define SPECIES_IS_RESTRICTED (1<<1)
/// Species is selectable in chargen.
#define SPECIES_CAN_JOIN (1<<2)
/// FBP of this species can't be made in-game.
#define SPECIES_NO_FBP_CONSTRUCTION (1<<3)
/// FBP of this species can't be selected at chargen.
#define SPECIES_NO_FBP_CHARGEN (1<<4)
/// Species cannot start with robotic organs or have them attached.
#define SPECIES_NO_ROBOTIC_INTERNAL_ORGANS (1<<5)
/// Can select and customize, but not join as
#define SPECIES_WHITELIST_SELECTABLE (1<<6)


//! ## APPEARANCE_FLAGS
/// Skin tone selectable in chargen. (0-255)
#define HAS_SKIN_TONE (1<<0)
/// Skin colour selectable in chargen. (RGB)
#define HAS_SKIN_COLOR (1<<1)
/// Lips are drawn onto the mob icon. (lipstick)
#define HAS_LIPS (1<<2)
/// Underwear is drawn onto the mob icon.
#define HAS_UNDERWEAR (1<<3)
/// Eye colour selectable in chargen. (RGB)
#define HAS_EYE_COLOR (1<<4)
/// Hair colour selectable in chargen. (RGB)
#define HAS_HAIR_COLOR (1<<5)
/// Radiation causes this character to glow.
#define RADIATION_GLOWS (1<<6)
/// Sets default skin colors based on icons.
#define HAS_BASE_SKIN_COLOR (1<<7)

DEFINE_BITFIELD(species_appearance_flags, list(
	"HAS_SKIN_TONE"   = HAS_SKIN_TONE,
	"HAS_SKIN_COLOR"  = HAS_SKIN_COLOR,
	"HAS_LIPS"        = HAS_LIPS,
	"HAS_UNDERWEAR"   = HAS_UNDERWEAR,
	"HAS_EYE_COLOR"   = HAS_EYE_COLOR,
	"HAS_HAIR_COLOR"  = HAS_HAIR_COLOR,
	"RADIATION_GLOWS" = RADIATION_GLOWS,
	"HAS_BASE_SKIN_COLOR" = HAS_BASE_SKIN_COLOR,
))


//! ## SKIN FLAGS
#define SKIN_NORMAL (1<<0)
#define SKIN_THREAT (1<<1)
#define SKIN_CLOAK  (1<<2)
