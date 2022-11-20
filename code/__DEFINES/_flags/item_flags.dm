//! Flags for the item_flags var on /obj/item
/*
#define BEING_REMOVED			(1<<0)
*/
/// is this item equipped into an inventory slot or hand of a mob? used for tooltips
#define IN_INVENTORY			(1<<1)
/*
/// used for tooltips
#define FORCE_STRING_OVERRIDE	(1<<2)
/// Used by security bots to determine if this item is safe for public use.
#define NEEDS_PERMIT			(1<<3)
#define SLOWS_WHILE_IN_HAND		(1<<4)
/// Stops you from putting things like an RCD or other items into an ORM or protolathe for materials.
#define NO_MAT_REDEMPTION		(1<<5)
*/
/// When dropped, it calls qdel on itself
#define ITEM_DROPDEL					(1<<6)

/// when an item has this it produces no "X has been hit by Y with Z" message in the default attackby()
#define ITEM_NOBLUDGEON				(1<<7)
/// for all things that are technically items but used for various different stuff
#define ITEM_ABSTRACT			(1<<8)
/// When players should not be able to change the slowdown of the item (Speed potions, ect)
#define IMMUTABLE_SLOW			(1<<9)
/// Tool commonly used for surgery: won't attack targets in an active surgical operation on help intent (in case of mistakes)
#define SURGICAL_TOOL			(1<<10)
/// is this item in a storage component?
#define IN_STORAGE				(1<<14)
/// we can't be caught when hitting a mob on throw
#define ITEM_THROW_UNCATCHABLE	(1<<15)
/// we cannot be used a tool on click, no matter what
#define ITEM_NO_TOOL_ATTACK		(1<<16)

DEFINE_BITFIELD(item_flags, list(
	BITFIELD(IN_INVENTORY),
	BITFIELD(ITEM_DROPDEL),
	BITFIELD(ITEM_NOBLUDGEON),
	BITFIELD(ITEM_ABSTRACT),
	BITFIELD(IMMUTABLE_SLOW),
	BITFIELD(SURGICAL_TOOL),
	BITFIELD(IN_STORAGE),
	BITFIELD(ITEM_THROW_UNCATCHABLE),
	BITFIELD(ITEM_NO_TOOL_ATTACK),
))

//! Flags for the clothing_flags var on /obj/item
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
/// Prevents syringes, parapens and hyposprays if equipped to slot_suit or SLOT_ID_HEAD.
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
/// ignores "is this limb here" for equip.
#define EQUIP_IGNORE_DELIMB		(1<<13)
/// ignores "do we have a jumpsuit" for belt
#define EQUIP_IGNORE_BELTLINK	(1<<14)
/// for plural limbs, wearable with just one
#define EQUIP_ALLOW_SINGLE_LIMB	(1<<15)

DEFINE_BITFIELD(clothing_flags, list(
	BITFIELD(BLOCK_GAS_SMOKE_EFFECT),
	BITFIELD(ALLOWINTERNALS),
	BITFIELD(NOSLIP),
	BITFIELD(THICKMATERIAL),
	BITFIELD(SCAN_REAGENTS),
	BITFIELD(FLEXIBLEMATERIAL),
	BITFIELD(ALLOW_SURVIVALFOOD),
	BITFIELD(EQUIP_IGNORE_DELIMB),
	BITFIELD(EQUIP_IGNORE_BELTLINK),
	BITFIELD(EQUIP_ALLOW_SINGLE_LIMB),
))

//!# bitflags for the /obj/item/var/flags_inv variable. These determine when a piece of clothing hides another, i.e. a helmet hiding glasses.
// WARNING: The following flags apply only to the external suit!
#define HIDEGLOVES      	(1<<0)
#define HIDESUITSTORAGE 	(1<<1)
#define HIDEJUMPSUIT    	(1<<2)
#define HIDESHOES       	(1<<3)
#define HIDETAIL        	(1<<4)
#define HIDETIE         	(1<<5)
///Some clothing hides holsters, but not all accessories
#define HIDEHOLSTER     	(1<<6)
// WARNING: The following flags apply only to the helmets and masks!
#define HIDEMASK 			(1<<7)
/// Headsets and such.
#define HIDEEARS			(1<<8)
/// Glasses.
#define HIDEEYES			(1<<9)
/// Dictates whether we appear as "Unknown".
#define HIDEFACE			(1<<10)
/// Hides the user's hair overlay. Leaves facial hair.
#define BLOCKHEADHAIR		(1<<11)
/// Hides the user's hair, facial and otherwise.
#define BLOCKHAIR			(1<<12)

DEFINE_BITFIELD(flags_inv, list(
	BITFIELD(HIDEGLOVES),
	BITFIELD(HIDESUITSTORAGE),
	BITFIELD(HIDEJUMPSUIT),
	BITFIELD(HIDESHOES),
	BITFIELD(HIDETAIL),
	BITFIELD(HIDETIE),
	BITFIELD(HIDEHOLSTER),
	BITFIELD(HIDEMASK),
	BITFIELD(HIDEEARS),
	BITFIELD(HIDEEYES),
	BITFIELD(HIDEFACE),
	BITFIELD(BLOCKHEADHAIR),
	BITFIELD(BLOCKHAIR),
))

//!# bitflags for /obj/item/var/body_parts_covered
#define HEAD        (1<<0)
#define FACE        (1<<1)
#define EYES        (1<<2)
#define UPPER_TORSO (1<<3)
#define LOWER_TORSO (1<<4)
#define LEG_LEFT    (1<<5)
#define LEG_RIGHT   (1<<6)
#define LEGS        (LEG_LEFT | LEG_RIGHT)
#define FOOT_LEFT   (1<<7)
#define FOOT_RIGHT  (1<<8)
#define FEET        (FOOT_LEFT | FOOT_RIGHT)
#define ARM_LEFT    (1<<9)
#define ARM_RIGHT   (1<<10)
#define ARMS        (ARM_LEFT | ARM_RIGHT)
#define HAND_LEFT   (1<<11)
#define HAND_RIGHT  (1<<12)
#define HANDS       (HAND_LEFT | HAND_RIGHT)
#define FULL_BODY   (ALL)

DEFINE_BITFIELD(body_parts_covered, list(
	BITFIELD(HEAD),
	BITFIELD(FACE),
	BITFIELD(EYES),
	BITFIELD(UPPER_TORSO),
	BITFIELD(LOWER_TORSO),
	BITFIELD(LEG_LEFT),
	BITFIELD(LEG_RIGHT),
	BITFIELD(FOOT_LEFT),
	BITFIELD(FOOT_RIGHT),
	BITFIELD(ARM_LEFT),
	BITFIELD(ARM_RIGHT),
	BITFIELD(HAND_LEFT),
	BITFIELD(HAND_RIGHT),
))

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
