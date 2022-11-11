// todo: species_flags
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

DEFINE_BITFIELD(species_flags, list(
	BITFIELD(NO_MINOR_CUT),
	BITFIELD(IS_PLANT),
	BITFIELD(NO_SCAN),
	BITFIELD(NO_PAIN),
	BITFIELD(NO_SLIP),
	BITFIELD(NO_POISON),
	BITFIELD(NO_EMBED),
	BITFIELD(NO_HALLUCINATION),
	BITFIELD(NO_BLOOD),
	BITFIELD(UNDEAD),
	BITFIELD(NO_INFECT),
	BITFIELD(NO_DEFIB),
	BITFIELD(CONTAMINATION_IMMUNE),
))

//! species_fluff_flags
/// deny cultures that don't specifically whitelist us
#define SPECIES_FLUFF_PICKY_FACTION (1<<0)
/// deny origins that don't specifically whitelist us
#define SPECIES_FLUFF_PICKY_ORIGIN (1<<1)
/// deny citizenships that don't specifically whitelist us
#define SPECIES_FLUFF_PICKY_CITIZENSHIP (1<<2)
/// deny religions that don't specifically whitelist us
#define SPECIES_FLUFF_PICKY_RELIGION (1<<3)

DEFINE_BITFIELD(species_fluff_flags, list(
	BITFIELD(SPECIES_FLUFF_PICKY_FACTION),
	BITFIELD(SPECIES_FLUFF_PICKY_ORIGIN),
	BITFIELD(SPECIES_FLUFF_PICKY_CITIZENSHIP),
	BITFIELD(SPECIES_FLUFF_PICKY_RELIGION),
))

//! species_spawn_flags
/// is not considered a real character species; used for castes, monkies, etc.
/// this flag will cause the species to skip char-species generation.
#define SPECIES_SPAWN_SPECIAL (1<<0)
/// Species is selectable and visible in chargen. This must be on a species to be roundstart/latejoin.
#define SPECIES_SPAWN_CHARACTER (1<<1)
/// Must be whitelisted to play roundstart/latejoin.
#define SPECIES_SPAWN_WHITELISTED (1<<2)
/// Must be whitelisted to see this species at all.
#define SPECIES_SPAWN_SECRET (1<<3)
/// Cannot normally spawn; something must pass in PREFS_COPY_TO_NO_CHECK_SPECIES to spawn checks to use!
#define SPECIES_SPAWN_RESTRICTED (1<<4)
//? FLAGS ABOVE ARE RELEVANT TO UI.
//? If you change them, change necessary TGUI too.
//? Current TGUI that uses this:
//? SpeicesPicker.tsx
/// FBP of this species can't be made in-game.
#define SPECIES_SPAWN_NO_FBP_CONSTRUCT (1<<5)
/// FBP of this species can't be selected at chargen.
#define SPECIES_SPAWN_NO_FBP_SETUP (1<<6)
/// Species cannot start with robotic organs or have them attached.
#define SPECIES_SPAWN_NO_ROBOTIC_ORGANS (1<<7)

DEFINE_BITFIELD(species_spawn_flags, list(
	BITFIELD(SPECIES_SPAWN_SPECIAL),
	BITFIELD(SPECIES_SPAWN_CHARACTER),
	BITFIELD(SPECIES_SPAWN_WHITELISTED),
	BITFIELD(SPECIES_SPAWN_SECRET),
	BITFIELD(SPECIES_SPAWN_RESTRICTED),
	BITFIELD(SPECIES_SPAWN_NO_FBP_CONSTRUCT),
	BITFIELD(SPECIES_SPAWN_NO_FBP_SETUP),
	BITFIELD(SPECIES_SPAWN_NO_ROBOTIC_ORGANS),
))

//! species_appearance_flags
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


//! skin flags
#define SKIN_NORMAL (1<<0)
#define SKIN_THREAT (1<<1)
#define SKIN_CLOAK  (1<<2)
