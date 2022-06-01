// Flags for the item_flags var on /obj/item
/*
#define BEING_REMOVED			(1<<0)
*/
///is this item equipped into an inventory slot or hand of a mob? used for tooltips
#define IN_INVENTORY			(1<<1)
/*
///used for tooltips
#define FORCE_STRING_OVERRIDE	(1<<2)
///Used by security bots to determine if this item is safe for public use.
#define NEEDS_PERMIT			(1<<3)
#define SLOWS_WHILE_IN_HAND		(1<<4)
///Stops you from putting things like an RCD or other items into an ORM or protolathe for materials.
#define NO_MAT_REDEMPTION		(1<<5)
*/
///When dropped, it calls qdel on itself
#define DROPDEL					(1<<6)

///when an item has this it produces no "X has been hit by Y with Z" message in the default attackby()
//#define NOBLUDGEON			(1<<7)
///for all things that are technically items but used for various different stuff
#define ABSTRACT				(1<<8)
///When players should not be able to change the slowdown of the item (Speed potions, ect)
#define IMMUTABLE_SLOW			(1<<9)
///Tool commonly used for surgery: won't attack targets in an active surgical operation on help intent (in case of mistakes)
#define SURGICAL_TOOL			(1<<10)
///Can be worn on certain slots (currently belt and id) that would otherwise require an uniform.
#define NO_UNIFORM_REQUIRED		(1<<11)
/// This item can be used to parry. Only a basic check used to determine if we should proceed with parry chain at all.
#define ITEM_CAN_PARRY			(1<<12)
/// This item can be used in the directional blocking system. Only a basic check used to determine if we should proceed with directional block handling at all.
#define ITEM_CAN_BLOCK			(1<<13)
/// is this item in a storage component?
#define IN_STORAGE				(1<<14)


// Flags for the clothing_flags var on /obj/item/clothing
/*
#define LAVAPROTECT				(1<<0)
/// SUIT and HEAD items which stop pressure damage. To stop you taking all pressure damage you must have both a suit and head item with this flag.
#define STOPSPRESSUREDAMAGE		(1<<1)
*/
/// Blocks the effect that chemical clouds would have on a mob --glasses, mask and helmets ONLY! (NOTE: flag shared with ONESIZEFITSALL)
#define BLOCK_GAS_SMOKE_EFFECT	(1<<2)
/// Mask allows internals
#define ALLOWINTERNALS			(1<<3)
/// Prevents from slipping on wet floors, in space etc
#define NOSLIP					(1<<4)
/*
/// Prevents from slipping on frozen floors
#define NOSLIP_ICE				(1<<5)
*/
/// Prevents syringes, parapens and hyposprays if equipped to slot_suit or slot_head.
#define THICKMATERIAL			(1<<6)
/*
/// The voicebox in this clothing can be toggled.
#define VOICEBOX_TOGGLABLE		(1<<7)
/// The voicebox is currently turned off.
#define VOICEBOX_DISABLED		(1<<8)
/// Hats with negative effects when worn (i.e the tinfoil hat).
#define IGNORE_HAT_TOSS			(1<<9)
*/
/// Allows helmets and glasses to scan reagents.
#define SCAN_REAGENTS			(1<<10)
/// At the moment, masks with this flag will not prevent eating even if they are covering your face.
#define FLEXIBLEMATERIAL		(1<<11)
/// Allows special survival food items to be eaten through it
#define ALLOW_SURVIVALFOOD		(1<<12)
// Flags for the organ_flags var on /obj/item/organ
/*
/// Synthetic organs, or cybernetic organs. Reacts to EMPs and don't deteriorate or heal
#define ORGAN_SYNTHETIC			(1<<0)
/// Frozen organs, don't deteriorate
#define ORGAN_FROZEN			(1<<1)
/// Failing organs perform damaging effects until replaced or fixed
#define ORGAN_FAILING			(1<<2)
/// Was this organ implanted/inserted/etc, if true will not be removed during species change.
#define ORGAN_EXTERNAL			(1<<3)
/// Currently only the brain
#define ORGAN_VITAL				(1<<4)
/// Do not spoil under any circumstances
#define ORGAN_NO_SPOIL			(1<<5)
/// Immune to disembowelment.
#define ORGAN_NO_DISMEMBERMENT	(1<<6)
/// Is a snack? :D
#define ORGAN_EDIBLE			(1<<7)
/// Synthetic organ affected by an EMP. Deteriorates over time.
#define ORGAN_SYNTHETIC_EMP		(1<<6)
*/
