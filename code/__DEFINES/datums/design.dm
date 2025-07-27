//? design_unlock bitfield

/// any lathe that can print us should have us always
#define DESIGN_UNLOCK_INTRINSIC (1<<0)
/// any lathe that can print us can have us uploaded
#define DESIGN_UNLOCK_UPLOAD (1<<1)
/// design is unlocked via REQ_TECH
#define DESIGN_UNLOCK_TECHLEVEL (1<<2)

DEFINE_BITFIELD(design_unlock, list(
	BITFIELD(DESIGN_UNLOCK_INTRINSIC),
	BITFIELD(DESIGN_UNLOCK_UPLOAD),
	BITFIELD(DESIGN_UNLOCK_TECHLEVEL),
))

//? design_flags bitfield

/// do not scale with efficiency
#define DESIGN_NO_SCALE (1<<0)
/// unit tests should ignore the lack of materials
#define DESIGN_IGNORE_RESOURCE_SANITY (1<<2)

DEFINE_BITFIELD(design_flags, list(
	BITFIELD(DESIGN_NO_SCALE),
	BITFIELD(DESIGN_IGNORE_RESOURCE_SANITY),
))

//design categories
//misc is the default
#define DESIGN_CATEGORY_MISC "Misc"
#define DESIGN_CATEGORY_MUNITIONS "Munitions"
#define DESIGN_CATEGORY_STORAGE "Storage"
#define DESIGN_CATEGORY_AI "AI"
#define DESIGN_CATEGORY_ATMOS "Atmospherics"
#define DESIGN_CATEGORY_ANOM "Anomalous Technology"
#define DESIGN_CATEGORY_MECHA "Mecha"
#define DESIGN_CATEGORY_RECREATION "Recreation"
#define DESIGN_CATEGORY_BLUESPACE "Bluespace"
#define DESIGN_CATEGORY_POWER "Power"
#define DESIGN_CATEGORY_TELECOMMUNICATIONS "Telecommunications"
#define DESIGN_CATEGORY_MEDICAL "Medical"
#define DESIGN_CATEGORY_MEDIGUN "Medigun Cells"
#define DESIGN_CATEGORY_MODGUN "Modular Weapons"
#define DESIGN_CATEGORY_CARGO_MINING "Cargo / Mining"
#define DESIGN_CATEGORY_SECURITY "Security"
#define DESIGN_CATEGORY_SCIENCE "Science"
#define DESIGN_CATEGORY_STOCK_PARTS "Stock Parts"
#define DESIGN_CATEGORY_COMPUTER "Computer Parts"
#define DESIGN_CATEGORY_ENGINEERING "Engineering"
#define DESIGN_CATEGORY_INTEGRATED_CIRCUITRY "Integrated Circuitry"
#define DESIGN_CATEGORY_SYNTH "Synthetics"
#define DESIGN_CATEGORY_PROSTHETIC "Prosthetics"
#define DESIGN_CATEGORY_DATA "Data"
#define DESIGN_CATEGORY_ATTACHMENTS "Attachments"
#define DESIGN_CATEGORY_TOOLS "Tools"
#define DESIGN_CATEGORY_HARDSUIT "Hardsuit"

//subcategories
//misc is the default
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
 * * Implicitly allows protolathes to build it.
 */
#define GENERATE_DESIGN_FOR_AUTOLATHE(ENTITY_PATH, DESIGN_PATH, DESIGN_ID) \
GENERATE_DESIGN(ENTITY_PATH, DESIGN_PATH, DESIGN_ID); \
/datum/prototype/design/generated##DESIGN_PATH { \
	lathe_type = LATHE_TYPE_AUTOLATHE | LATHE_TYPE_PROTOLATHE; \
}; \
/datum/prototype/design/generated##DESIGN_PATH

/**
 * Generates for protolathes.
 */
#define GENERATE_DESIGN_FOR_PROTOLATHE(ENTITY_PATH, DESIGN_PATH, DESIGN_ID) \
GENERATE_DESIGN(ENTITY_PATH, DESIGN_PATH, DESIGN_ID); \
/datum/prototype/design/generated##DESIGN_PATH { \
	lathe_type = LATHE_TYPE_PROTOLATHE; \
	design_unlock = DESIGN_UNLOCK_TECHLEVEL; \
}; \
/datum/prototype/design/generated##DESIGN_PATH

//* Design Helpers - For a specific lathe & faction *//

/**
 * Generates for Nanotrasen-standard autolathes. In the future, we might have flags
 * for what factions get it automatically.
 */
#define GENERATE_DESIGN_FOR_NT_AUTOLATHE(ENTITY_PATH, DESIGN_PATH, DESIGN_ID) \
GENERATE_DESIGN_FOR_AUTOLATHE(ENTITY_PATH, DESIGN_PATH, DESIGN_ID)

/**
 * Generates for Nanotrasen-standard protolathes. In the future, we might have flags
 * for what factions get it automatically.
 */
#define GENERATE_DESIGN_FOR_NT_PROTOLATHE(ENTITY_PATH, DESIGN_PATH, DESIGN_ID) \
GENERATE_DESIGN_FOR_PROTOLATHE(ENTITY_PATH, DESIGN_PATH, DESIGN_ID)
