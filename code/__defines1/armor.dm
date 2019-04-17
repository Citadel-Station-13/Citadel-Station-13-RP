//This is a defines file, but just to make it easier to sync, I'm including armor datum stuff that is ONLY FOR ARMOR VALUES!
/datum/armor
	var/melee = 0
	var/bullet = 0
	var/laser = 0
	var/energy = 0
	var/bomb = 0
	var/bio = 0
	var/rad = 0
	var/fire = 0
	var/acid = 0
	var/magic = 0
	/*
	var/conductivity = 0			//0 = SIEMENS_COEFFICIENT 1, 100 = SIEMENS_COEFFICENT 0, -100 = SIEMENS_COEFFICIENT 2, -200 = SIEMENS_COEFFICIENT 3, etc.
	var/conduct_arc					//same as above but for lightning, etc.
	var/conduct_flags				//wip
	WIP		*/

//These are NOT DAMAGE TYPES! There can be more or less armor types than damage types.
#define ARMOR_MELEE		"melee"
#define ARMOR_BULLET	"bullet"
#define ARMOR_LASER		"laser"
#define ARMOR_ENERGY	"energy"
#define ARMOR_BOMB		"bomb"
#define ARMOR_BIO		"bio"
#define ARMOR_RAD		"rad"
#define ARMOR_FIRE		"fire"
#define ARMOR_ACID		"acid"
#define ARMOR_MAGIC		"magic"

//Checks for the specified type of armor on armor variable. Variable MUST be typecasted, but if it's typecasted and null, this resolves to 0.
#define ARMOR_ACCESS(ARMOR, TYPE) ((ARMOR && ARMOR.TYPE) || 0)

#define ARMOR_DATUM_TO_LIST(D)		(D.to_list())

#define ARMOR_LIST_TO_DATUM(L)		(new /datum/armor(L))

//STANDARDIZED ARMOR, LIST STYLE!
#define STANDARD_ARMOR_LIST_NONE		list()

#define STANDARD_ARMOR_LIST_SECURITY_BASIC_ARMOR	list(melee = 40, bullet = 40, laser = 40, energy = 25, bomb = 30, bio = 0, rad = 0)

#define STANDARD_ARMOR_LIST_SECURITY_HELMET		STANDARD_ARMOR_LIST_SECURITY_BASIC_ARMOR		//Helmet items
#define STANDARD_ARMOR_LIST_SECURITY_VEST		STANDARD_ARMOR_LIST_SECURITY_BASIC_ARMOR		//Vest items
#define STANDARD_ARMOR_LIST_SECURITY_FULL		STANDARD_ARMOR_LIST_SECURITY_BASIC_ARMOR		//Plate carrier items

