// Damage things. //TODO: Merge these down to reduce on defines.
// Way to waste perfectly good damage-type names (BRUTE) on this... If you were really worried about case sensitivity, you could have just used lowertext(damagetype) in the proc.
#define BRUTE       "brute"
#define BURN        "fire"
#define TOX         "tox"
#define OXY         "oxy"
#define CLONE       "clone"
#define HALLOSS     "halloss"
#define ELECTROCUTE "electrocute"
#define BIOACID     "bioacid"
#define SEARING     "searing"

#define CUT       "cut"
#define BRUISE    "bruise"
#define PIERCE    "pierce"

#define STUN      "stun"
#define WEAKEN    "weaken"
#define PARALYZE  "paralize"
#define IRRADIATE "irradiate"

#define AGONY     "agony"
#define SLUR      "slur"
#define STUTTER   "stutter"
#define EYE_BLUR  "eye_blur"
#define DROWSY    "drowsy"

// I hate adding defines like this but I'd much rather deal with bitflags than lists and string searches.
#define BRUTELOSS 0x1
#define FIRELOSS  0x2
#define TOXLOSS   0x4
#define OXYLOSS   0x8

/// Higher values result in more external fire damage to the skin. (default 0.0215)
#define FIRE_DAMAGE_MODIFIER 0.0215
/// More means less damage from hot air scalding lungs, less = more damage. (default 2.025)
#define  AIR_DAMAGE_MODIFIER 2.025
//! Organ defines. Bitflag into organ.status
#define ORGAN_CUT_AWAY   (1<<0)
#define ORGAN_BLEEDING   (1<<1)
#define ORGAN_BROKEN     (1<<2)
#define ORGAN_DESTROYED  (1<<3)
#define ORGAN_DEAD       (1<<4)
#define ORGAN_MUTATED    (1<<5)
#define ORGAN_BRITTLE    (1<<6) // The organ takes additional blunt damage. If robotic, cannot be repaired through normal means.
#define DROPLIMB_EDGE  0
#define DROPLIMB_BLUNT 1
#define DROPLIMB_BURN  2

// Damage above this value must be repaired with surgery.
#define ROBOLIMB_REPAIR_CAP 30

//! The condition defines. /SET/ into organ.robotic [example: if(organ.robotic == ORGAN_NANOFORM) to_chat("Organ is nanites")]
//? This isn't a flag, maybe in the future. @Zandario
/// Normal organic organs.
#define ORGAN_FLESH    0
/// Like pacemakers, not robotic
#define ORGAN_ASSISTED 1
/// Fully robotic, no organic parts
#define ORGAN_ROBOT    2
/// Robotic, made to appear organic
#define ORGAN_LIFELIKE 3
/// Fully nanoswarm organ
#define ORGAN_NANOFORM 4
/// The organ does not suffer laser damage, but shatters on droplimb.
#define ORGAN_CRYSTAL  5

//! Germs and infections.
//? Using no gloves on surgery WILL give a high risk of infection.
/// Maximum germ level you can reach by standing still.
#define GERM_LEVEL_AMBIENT  110
/// Maximum germ level you can reach by running around.
#define GERM_LEVEL_MOVE_CAP 200

#define INFECTION_LEVEL_ONE   100
#define INFECTION_LEVEL_TWO   500
#define INFECTION_LEVEL_THREE 1000
#define INFECTION_LEVEL_MAX   1500

/// Cannot be detached or reattached.
#define MODULAR_BODYPART_INVALID    0
/// Can be detached or reattached freely.
#define MODULAR_BODYPART_PROSTHETIC 1
/// Can be detached or reattached to compatible parent organs.
#define MODULAR_BODYPART_CYBERNETIC 2
