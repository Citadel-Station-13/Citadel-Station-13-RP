//* Human Overlays Indexes *//
// These are used as the layers for the icons, as well as indexes in a list that holds onto them.
// Technically the layers used are all -100+layer to make them FLOAT_LAYER overlays.

/// Mutations like fat, and lasereyes
#define MUTATIONS_LAYER			1
/// Skin things added by a call on species
#define SKIN_LAYER				2
/// Bloodied hands/feet/anything else
#define BLOOD_LAYER				3
/// Injury overlay sprites like open wounds
#define DAMAGE_LAYER			4
/// Overlays for open surgical sites
#define SURGERY_LAYER			5
/// Underwear/bras/etc
#define UNDERWEAR_LAYER  		6
/// Shoe-slot item (when set to be under uniform via verb)
#define SHOES_LAYER_ALT			7
/// Uniform-slot item
#define UNIFORM_LAYER			8
/// ID-slot item
#define ID_LAYER				9
/// Shoe-slot item
#define SHOES_LAYER				10
/// Glove-slot item
#define GLOVES_LAYER			11
/// Belt-slot item
#define BELT_LAYER				12
/// Suit-slot item
#define SUIT_LAYER				13
/// Some species have tails to render
#define TAIL_LAYER				14
/// Eye-slot item
#define GLASSES_LAYER			15
/// Belt-slot item (when set to be above suit via verb)
#define BELT_LAYER_ALT			16
/// Suit storage-slot item
#define SUIT_STORE_LAYER		17
/// Back-slot item
#define BACK_LAYER				18
/// The human's hair
#define HAIR_LAYER				19
/// Both ear-slot items (combined image)
#define EARS_LAYER				20
/// Mob's eyes (used for glowing eyes)
#define EYES_LAYER				21
/// Mask-slot item
#define FACEMASK_LAYER			22
/// Head-slot item
#define HEAD_LAYER				23
/// Handcuffs, if the human is handcuffed, in a secret inv slot
#define HANDCUFF_LAYER			24
/// Same as handcuffs, for legcuffs
#define LEGCUFF_LAYER			25
/// Hand layers
#define WORN_LAYER_HELD(index)	(26 + index)
/// Wing overlay layer.
#define WING_LAYER				45
/// Tail alt. overlay layer for fixing overlay issues.
#define TAIL_LAYER_ALT			46
/// Effects drawn by modifiers
#define MODIFIER_EFFECTS_LAYER	47
/// 'Mob on fire' overlay layer
#define FIRE_LAYER				48
/// 'Mob submerged' overlay layer
#define MOB_WATER_LAYER			49
/// 'Aimed at' overlay layer
#define TARGETED_LAYER			50
//! the offset used
#define BODY_LAYER		-100

//* Human Overlay Keys *//
// These are the actual keys used in overlays_standing.

#define WORN_KEY_MUTATIONS "mutations"
#define WORN_KEY_SKIN "skin"
#define WORN_KEY_BLOOD "blood"
#define WORN_KEY_DAMAGE "damage"
#define WORN_KEY_SURGERY "surgery"
#define WORN_KEY_UNDERWEAR "underwear"
#define WORN_KEY_UNIFORM "uniform"
#define WORN_KEY_ID "id"
#define WORN_KEY_SHOES "shoes"
#define WORN_KEY_GLOVES "gloves"
#define WORN_KEY_BELT "belt"
#define WORN_KEY_SUIT "suit"
#define WORN_KEY_TAIL "tail"
#define WORN_KEY_GLASSES "glasses"
#define WORN_KEY_SUITSTORE "suitstore"
#define WORN_KEY_BACK "back"
#define WORN_KEY_HAIR "hair"
#define WORN_KEY_EARS "ears"
#define WORN_KEY_EYES "eyes"
#define WORN_KEY_FACEMASK "facemask"
#define WORN_KEY_HEAD "head"
#define WORN_KEY_HANDCUFF "handcuff"
#define WORN_KEY_LEGCUFF "legcuff"
#define WORN_KEY_HELD(index) "held[index]"
#define WORN_KEY_WING "wing"
#define WORN_KEY_MODIFIERS "modifiers"
#define WORN_KEY_FIRE "fire"
#define WORN_KEY_WATER "water"
#define WORN_KEY_TARGETED "targeted"
