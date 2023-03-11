//? --- armor defines ---
//* Want to add more?
//* Update [code/__HELPERS/datastructs/armor.dm]
//* Add an armor var, define it here,
//* and update to_list() and from_list().
//* The system will handle the rest.
//* Make sure the var names match the names in here!

#define ARMOR_MELEE "melee"
#define ARMOR_BULLET "bullet"
#define ARMOR_LASER "laser"
#define ARMOR_ENERGY "energy"
#define ARMOR_BOMB "bomb"
#define ARMOR_BIO "bio"
#define ARMOR_RAD "rad"

GLOBAL_REAL_LIST_MANAGED(armor_enums) = list(
	ARMOR_MELEE,
	ARMOR_BULLET,
	ARMOR_LASER,
	ARMOR_ENERGY,
	ARMOR_BOMB,
	ARMOR_BIO,
	ARMOR_RAD,
)
