//* Design Flags *//

/// do not scale with efficiency
#define DESIGN_NO_SCALE (1<<0)
/// unit tests should ignore the lack of materials
#define DESIGN_IGNORE_RESOURCE_SANITY (1<<2)

DEFINE_BITFIELD(design_flags, list(
	BITFIELD(DESIGN_NO_SCALE),
	BITFIELD(DESIGN_IGNORE_RESOURCE_SANITY),
))

//* Design Unlock Flags *//

/// any lathe that can print us should have us always
#define DESIGN_UNLOCK_INTRINSIC (1<<0)
/// any lathe that can print us can have us uploaded
#define DESIGN_UNLOCK_UPLOAD (1<<1)

DEFINE_BITFIELD(design_unlock, list(
	BITFIELD(DESIGN_UNLOCK_INTRINSIC),
	BITFIELD(DESIGN_UNLOCK_UPLOAD),
))

//* Design Tags - DESIGN_TAG_     *//
//* C_: category                  *//
//* S_: stability                 *//

/// intentional weapon of some kind
#define DESIGN_TAG_C_WEAPON "c-weapon"
/// intentional ranged weapon of some kind
#define DESIGN_TAG_C_RANGED_WEAPON "c-weapon-ranged"
/// intentional melee weapon of some kind
#define DESIGN_TAG_C_MELEE_WEAPON "c-weapon-melee"

/// stock machine part of some kind
#define DESIGN_TAG_C_STOCK_PART "c-stock_part"

/// tool of some kind
#define DESIGN_TAG_C_TOOL "c-tool"
/// basic tinkering / construction tools, usually not including TOOL_ENGI
#define DESIGN_TAG_C_TOOL_MECH "c-tool-mech"
/// engineering tool of some kind, usually not including TOOL_MECH
#define DESIGN_TAG_C_TOOL_ENGI "c-tool-engi"
/// medical tool of some kind, usually not including TOOL_SURG
#define DESIGN_TAG_C_TOOL_MEDI "c-tool-medi"
/// surgery tool of some kind, usually not including TOOL_MEDI
#define DESIGN_TAG_C_TOOL_MEDI_SURG "c-tool-surg"

/// circuits
#define DESIGN_TAG_C_CIRCUIT "c-circuit"

/// AI-related
#define DESIGN_TAG_C_AI "c-ai"

/// mecha / vehicle parts
#define DESIGN_TAG_C_VEHICLE "c-vehicle"

/// stable: 100% working, no weird quirks, standard upgrade / printing designs
#define DESIGN_TAG_S_STABLE "s-stable"
/// prototype: mostly working with quirks
#define DESIGN_TAG_S_PROTOTYPE "s-prototype"
/// experimental: highly unstable prototypes often with unpredictable side effects
#define DESIGN_TAG_S_EXPERIMENTAL "s-experimental"

//* Design Fabrication Tags - DESIGN_F_TAG_ *//

// none yet

//* Design Sub/Categories *//

#define DESIGN_CATEGORY_MISC "Misc"
#define DESIGN_CATEGORY_MUNITIONS "Munitions"
#define DESIGN_CATEGORY_STORAGE "Storage"
#define DESIGN_CATEGORY_AI "AI"
#define DESIGN_CATEGORY_ATMOS "Atmospherics"
#define DESIGN_CATEGORY_MECHA "Mecha"
#define DESIGN_CATEGORY_RECREATION "Recreation"
#define DESIGN_CATEGORY_TELEPORTATION "Teleportation"
#define DESIGN_CATEGORY_POWER "Power"
#define DESIGN_CATEGORY_TELECOMMUNICATIONS "Telecommunications"
#define DESIGN_CATEGORY_MEDICAL "Medical"
#define DESIGN_CATEGORY_CARGO_MINING "Cargo / Mining"
#define DESIGN_CATEGORY_SECURITY "Security"
#define DESIGN_CATEGORY_SCIENCE "Science"
#define DESIGN_CATEGORY_COMPUTER "Computer Parts"
#define DESIGN_CATEGORY_ENGINEERING "Engineering"
#define DESIGN_CATEGORY_INTEGRATED_CIRCUITRY "Integrated Circuitry"
#define DESIGN_CATEGORY_SYNTH "Synth"
#define DESIGN_CATEGORY_PROSTHETIC "Prosthetics"
#define DESIGN_CATEGORY_DATA "Data"
#define DESIGN_CATEGORY_ATTACHMENTS "Attachments"
#define DESIGN_CATEGORY_TOOLS "Tools"
#define DESIGN_CATEGORY_HARDSUIT "Hardsuit"

#define DESIGN_SUBCATEGORY_MISC "Misc"

//any category can go have station as a subcategory
#define DESIGN_SUBCATEGORY_STATION "Station Equipment"

//munition subcategories
#define DESIGN_SUBCATEGORY_BALLISTIC "Ballistic"
#define DESIGN_SUBCATEGORY_MAGNETIC "Magnetic"
#define DESIGN_SUBCATEGORY_ENERGY "Energy"
#define DESIGN_SUBCATEGORY_MELEE "Melee"
#define DESIGN_SUBCATEGORY_AMMO "Ammo"
#define DESIGN_SUBCATEGORY_PINS "Weapon Pins"

//if it scans? it goes here.
#define DESIGN_SUBCATEGORY_SCANNING "Scanning Equipment"

//AI subcategories
#define DESIGN_SUBCATEGORY_LAWS "Laws"
#define DESIGN_SUBCATEGORY_CORE "Cores"

//Synth subcategory
#define DESIGN_SUBCATEGORY_SYNTHETIC_MINDS "Synthetic Minds"

//Power subcategories
#define DESIGN_SUBCATEGORY_CHARGING "Charger"
#define DESIGN_SUBCATEGORY_GENERATING "Generator"


#define DESIGN_SUBCATEGORY_NIF "NIF"

//if it goes in a machine / thing? it goes in here.
#define DESIGN_SUBCATEGORY_PARTS "Parts"

//science subcategories
#define DESIGN_SUBCATEGORY_XENOBIOLOGY "Xenobiology"
#define DESIGN_SUBCATEGORY_XENOARCHEOLOGY "Xenoarcheology"

//* Design Helpers - Generic *//

/**
 * Generate a design for an entity.
 *
 * * Design path is appended to `/datum/prototype/design/generated`.
 */
#define GENERATE_DESIGN(ENTITY_PATH, DESIGN_PATH, DESIGN_ID) \
/datum/prototype/design/generated##DESIGN_PATH { \
	id = DESIGN_ID; \
	build_path = ENTITY_PATH; \
}; \
/datum/prototype/design/generated##DESIGN_PATH

//* Design Helpers - For a specific lathe *//

/**
 * Generates for all lathes.
 * * Implicitly allows both autolathes and protolathes to build it.
 */
#define GENERATE_DESIGN_FOR_AUTOLATHE(ENTITY_PATH, DESIGN_PATH, DESIGN_ID) \
GENERATE_DESIGN(ENTITY_PATH, DESIGN_PATH, DESIGN_ID); \
/datum/prototype/design/generated##DESIGN_PATH { \
	lathe_type = LATHE_TYPE_AUTOLATHE | LATHE_TYPE_PROTOLATHE; \
}; \
/datum/prototype/design/generated##DESIGN_PATH

/**
 * Generates for protolathes.
 * * faction-locked designs must use this, as autolathes are considered 'just shit we get in 2565' while
 *   protolathes are how you make other designs.
 */
#define GENERATE_DESIGN_FOR_PROTOLATHE(ENTITY_PATH, DESIGN_PATH, DESIGN_ID, TECHWEB_NODE_PATH) \
GENERATE_DESIGN(ENTITY_PATH, DESIGN_PATH, DESIGN_ID); \
/datum/prototype/design/generated##DESIGN_PATH { \
	lathe_type = LATHE_TYPE_PROTOLATHE; \
}; \
/datum/prototype/design/generated##DESIGN_PATH
