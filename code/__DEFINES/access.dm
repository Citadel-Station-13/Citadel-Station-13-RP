//? Access Regions
//* For custom accesses, use none.

#warn check make sure they're used as flags

#define ACCESS_REGION_NONE (NONE)
#define ACCESS_REGION_ALL (ALL)
#define ACCESS_REGION_SECURITY (1<<0)
#define ACCESS_REGION_MEDBAY (1<<1)
#define ACCESS_REGION_RESEARCH (1<<2)
#define ACCESS_REGION_ENGINEERING (1<<3)
#define ACCESS_REGION_COMMAND (1<<4)
#define ACCESS_REGION_GENERAL (1<<5)
#define ACCESS_REGION_SUPPLY (1<<6)

DEFINE_SHARED_BITFIELD(access_region, list(
	"access_region",
	"access_edit_region"
), list(
	BITFIELD(ACCESS_REGION_SECURITY),
	BITFIELD(ACCESS_REGION_MEDBAY),
	BITFIELD(ACCESS_REGION_RESEARCH),
	BITFIELD(ACCESS_REGION_ENGINEERING),
	BITFIELD(ACCESS_REGION_COMMAND),
	BITFIELD(ACCESS_REGION_GENERAL),
	BITFIELD(ACCESS_REGION_SUPPLY),
))

GLOBAL_LIST_INIT(access_region_names, list(
	ACCESS_REGION_GENERAL = "General",
	ACCESS_REGION_COMMAND = "Command",
	ACCESS_REGION_SECURITY = "Security",
	ACCESS_REGION_ENGINEERING = "Engineering",
	ACCESS_REGION_MEDBAY = "Medical",
	ACCESS_REGION_RESEARCH = "Science",
	ACCESS_REGION_SUPPLY = "Supply",
))

//? Access Types
//* For custom accesses, use none.

#define ACCESS_TYPE_NONE (NONE)
#define ACCESS_TYPE_ALL (ALL)
#define ACCESS_TYPE_CENTCOM (1<<0)
#define ACCESS_TYPE_STATION (1<<1)
#define ACCESS_TYPE_SYNDICATE (1<<2)
#define ACCESS_TYPE_PRIVATE (1<<3)

DEFINE_SHARED_BITFIELD(access_type, list(
	"access_type",
	"access_edit_type"
), list(
	BITFIELD(ACCESS_TYPE_CENTCOM),
	BITFIELD(ACCESS_TYPE_STATION),
	BITFIELD(ACCESS_TYPE_SYNDICATE),
	BITFIELD(ACCESS_TYPE_PRIVATE),
))

GLOBAL_LIST_INIT(access_type_names, list(
	ACCESS_TYPE_CENTCOM = "Central Command",
	ACCESS_TYPE_STATION = "Station",
	ACCESS_TYPE_SYNDICATE = "Mercenary",
	ACCESS_TYPE_PRIVATE = "Unknown",
))

//? Access Values - constants & datums
//! DEFINE NUMBERS MUST NEVER CHANGE !//
//* Otherwise all maps break.        *//

//* MAPPERS: This is also where you find your values! *//

#define STANDARD_ACCESS_DATUM(value, type, desc) \
/datum/prototype/access/##type { \
	access_name = desc; \
	access_value = value; \
} \
/datum/prototype/access/##type

//? Security

#define ACCESS_SECURITY_EQUIPMENT 1
STANDARD_ACCESS_DATUM(ACCESS_SECURITY_EQUIPMENT, station/security/equipment, "Security Equipment")

#define ACCESS_SECURITY_BRIG 2
STANDARD_ACCESS_DATUM(ACCESS_SECURITY_BRIG, station/security/brig, "Brig")

#define ACCESS_SECURITY_ARMORY 3
STANDARD_ACCESS_DATUM(ACCESS_SECURITY_ARMORY, station/security/armory, "Armory")

#define ACCESS_SECURITY_FORENSICS 4
STANDARD_ACCESS_DATUM(ACCESS_SECURITY_FORENSICS, station/security/forensics, "Forensics")

//? Engineering

#define ACCESS_ENGINEERING_MAIN 10
STANDARD_ACCESS_DATUM(ACCESS_ENGINEERING_BAY, station/engineering/main, "Engineering")

#define ACCESS_ENGINEERING_ENGINE 11
STANDARD_ACCESS_DATUM(ACCESS_ENGINEERING_ENGINE, station/engineering/engine, "Engine Room")

//? Medical

#define ACCESS_MEDICAL_MAIN 5
STANDARD_ACCESS_DATUM(ACCESS_MEDICAL_BAY, station/medical/main, "Medical")

#define ACCESS_MEDICAL_MORGUE 6
STANDARD_ACCESS_DATUM(ACCESS_MEDICAL_MORGUE, station/medical/morgue, "Morgue")

//? Science

#define ACCESS_SCIENCE_FABRICATION 7
STANDARD_ACCESS_DATUM(ACCESS_SCIENCE_FABRICATION, station/science/fabrication, "Fabrication")

#define ACCESS_SCIENCE_TOXINS 8
STANDARD_ACCESS_DATUM(ACCESS_SCIENCE_TOXINS, station/science/toxins, "Toxins Lab")

#define ACCESS_SCIENCE_GENETICS 9
STANDARD_ACCESS_DATUM(ACCESS_SCIENCE_GENETICS, station/science/genetics, "Genetics Lab")


