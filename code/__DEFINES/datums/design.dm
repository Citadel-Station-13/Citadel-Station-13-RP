//? lathe_type bitfield

#define LATHE_TYPE_AUTOLATHE (1<<0)
#define LATHE_TYPE_PROTOLATHE (1<<1)
#define LATHE_TYPE_CIRCUIT (1<<2)
#define LATHE_TYPE_PROSTHETICS (1<<3)
#define LATHE_TYPE_MECHA (1<<4)
#define LATHE_TYPE_BIOPRINTER (1<<5)

DEFINE_BITFIELD(lathe_type, list(
	BITFIELD(LATHE_TYPE_AUTOLATHE),
	BITFIELD(LATHE_TYPE_PROTOLATHE),
	BITFIELD(LATHE_TYPE_CIRCUIT),
	BITFIELD(LATHE_TYPE_PROSTHETICS),
	BITFIELD(LATHE_TYPE_MECHA),
	BITFIELD(LATHE_TYPE_BIOPRINTER),
))

//? design_unlock bitfield

/// any lathe that can print us should have us always
#define DESIGN_UNLOCK_INTRINSIC (1<<0)
/// any lathe that can print us can have us uploaded
#define DESIGN_UNLOCK_UPLOAD (1<<1)

DEFINE_BITFIELD(design_unlock, list(
	BITFIELD(DESIGN_UNLOCK_INTRINSIC),
	BITFIELD(DESIGN_UNLOCK_UPLOAD),
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

//subcategories
//misc is the default
#define DESIGN_SUBCATEGORY_MISC "Misc"

//any category can go have station as a subcategory
#define DESIGN_SUBCATEGORY_STATION "Station Equipment"

//munition subcategories
#define DESIGN_SUBCATEGORY_BALLISTIC "Ballistic"
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
