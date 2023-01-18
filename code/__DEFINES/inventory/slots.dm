// slot ids - reference abstract slots by type instead, these are only ids because lots of html/tgui requires strings
#define SLOT_ID_BACK			"back"
#define SLOT_ID_UNIFORM			"uniform"
#define SLOT_ID_HEAD			"head"
#define SLOT_ID_SUIT			"suit"
#define SLOT_ID_BELT			"belt"
#define SLOT_ID_LEFT_POCKET		"lpocket"
#define SLOT_ID_RIGHT_POCKET	"rpocket"
#define SLOT_ID_WORN_ID			"id"
#define SLOT_ID_SHOES			"shoes"
#define SLOT_ID_GLASSES			"glasses"
#define SLOT_ID_GLOVES			"gloves"
#define SLOT_ID_SUIT_STORAGE	"suitstore"
#define SLOT_ID_MASK			"mask"
#define SLOT_ID_LEFT_EAR		"lear"
#define SLOT_ID_RIGHT_EAR		"rear"
#define SLOT_ID_HANDCUFFED		"handcuffed"
#define SLOT_ID_LEGCUFFED		"legcuffed"
/// this is an id because SLOT_ID_HANDS is used for worn_slot when something is being held :/
#define SLOT_ID_HANDS			"hands"
/// *ONLY USE THIS FOR RENDERING* - this is nonsensical anywhere else
#define SLOT_ID_LEFT_HAND		"left_hand"
/// *ONLY USE THIS FOR RENDERING* - this is nonsensical anywhere else
#define SLOT_ID_RIGHT_HAND		"right_hand"

//! slot meta slot_equip_checks flags
/// check slot flags - must match
#define SLOT_EQUIP_CHECK_USE_FLAGS			(1<<0)
/// use proc
#define SLOT_EQUIP_CHECK_USE_PROC			(1<<1)

DEFINE_BITFIELD(slot_equip_checks, list(
	BITFIELD(SLOT_EQUIP_CHECK_USE_FLAGS),
	BITFIELD(SLOT_EQUIP_CHECK_USE_PROC),
))

//! slot meta inventory_slot_flags flags
/// render on mob
#define INV_SLOT_IS_RENDERED				(1<<0)
/// considered worn equipment
#define INV_SLOT_CONSIDERED_WORN			(1<<1)
/// allow random uid
#define INV_SLOT_ALLOW_RANDOM_ID			(1<<2)
/// considered inventory? mob can access normally from hud if so
#define INV_SLOT_IS_INVENTORY				(1<<3)
/// hide unless inv is expanded
#define INV_SLOT_HUD_REQUIRES_EXPAND		(1<<4)
/// considered abstract - represents a logical action, isn't actually an item holding slot
#define INV_SLOT_IS_ABSTRACT				(1<<5)
/// show on strip menu?
#define INV_SLOT_IS_STRIPPABLE				(1<<6)
/// simple stripping - show slot + link, do not show item regardless of obfuscation. handles obfuscation differently.
#define INV_SLOT_STRIP_SIMPLE_LINK			(1<<7)
/// do not show on strip panel unless it's occupied by an item
#define INV_SLOT_STRIP_ONLY_REMOVES			(1<<8)

DEFINE_BITFIELD(inventory_slot_flags, list(
	BITFIELD(INV_SLOT_IS_RENDERED),
	BITFIELD(INV_SLOT_CONSIDERED_WORN),
	BITFIELD(INV_SLOT_ALLOW_RANDOM_ID),
	BITFIELD(INV_SLOT_IS_INVENTORY),
	BITFIELD(INV_SLOT_HUD_REQUIRES_EXPAND),
	BITFIELD(INV_SLOT_IS_ABSTRACT),
	BITFIELD(INV_SLOT_IS_STRIPPABLE),
	BITFIELD(INV_SLOT_STRIP_SIMPLE_LINK),
	BITFIELD(INV_SLOT_STRIP_ONLY_REMOVES),
))

//! slot flags
// Item inventory slot bitmasks.
#define SLOT_OCLOTHING  (1<<0)
#define SLOT_ICLOTHING  (1<<1)
#define SLOT_GLOVES     (1<<2)
#define SLOT_EYES       (1<<3)
#define SLOT_EARS       (1<<4)
#define SLOT_MASK       (1<<5)
#define SLOT_HEAD       (1<<6)
#define SLOT_FEET       (1<<7)
#define SLOT_ID         (1<<8)
#define SLOT_BELT       (1<<9)
#define SLOT_BACK       (1<<10)
/// This is to allow items with a w_class of 3 or 4 to fit in pockets.
#define SLOT_POCKET     (1<<11)
/// This is to  deny items with a w_class of 2 or 1 from fitting in pockets.
#define SLOT_DENYPOCKET (1<<12)
#define SLOT_TWOEARS    (1<<13)
// todo: remove
#define SLOT_TIE        (1<<14)
/// items with this can fit in holster no matter what
// todo: this shouldn't be a slot flag wtf
#define SLOT_HOLSTER	(1<<15)

#define SLOT_FLAG_BITFIELDS list( \
	BITFIELD(SLOT_OCLOTHING), \
	BITFIELD(SLOT_ICLOTHING), \
	BITFIELD(SLOT_GLOVES), \
	BITFIELD(SLOT_EYES), \
	BITFIELD(SLOT_EARS), \
	BITFIELD(SLOT_MASK), \
	BITFIELD(SLOT_HEAD), \
	BITFIELD(SLOT_FEET), \
	BITFIELD(SLOT_ID), \
	BITFIELD(SLOT_BELT), \
	BITFIELD(SLOT_BACK), \
	BITFIELD(SLOT_POCKET), \
	BITFIELD(SLOT_DENYPOCKET), \
	BITFIELD(SLOT_TWOEARS), \
	BITFIELD(SLOT_TIE), \
	BITFIELD(SLOT_HOLSTER), \
)

DEFINE_BITFIELD(slot_flags, SLOT_FLAG_BITFIELDS)
DEFINE_BITFIELD(slot_flags_required, SLOT_FLAG_BITFIELDS)
DEFINE_BITFIELD(slot_flags_forbidden, SLOT_FLAG_BITFIELDS)

//! legacy
/// Takes 40ds = 4s to strip someone.
#define HUMAN_STRIP_DELAY		4 SECONDS
/// Takes 2s to use a UI element in somebody else's hands.
#define HUMAN_INTERACT_DELAY	2 SECONDS

// rest got converted to typepath ids
// one day i'll come for you, inhand icons.
// one day.... mark my words...

/// global list of default slots to use when equipping to appropriate slot
GLOBAL_LIST_INIT(slot_equipment_priority, meta_slot_equipment_priority())

/proc/meta_slot_equipment_priority()
	return list(
		SLOT_ID_BACK,
		SLOT_ID_WORN_ID,
		SLOT_ID_UNIFORM,
		SLOT_ID_SUIT,
		SLOT_ID_MASK,
		SLOT_ID_HEAD,
		SLOT_ID_SHOES,
		SLOT_ID_GLOVES,
		SLOT_ID_LEFT_EAR,
		SLOT_ID_RIGHT_EAR,
		SLOT_ID_GLASSES,
		SLOT_ID_BELT,
		SLOT_ID_SUIT_STORAGE,
		/datum/inventory_slot_meta/abstract/attach_as_accessory,
		SLOT_ID_LEFT_POCKET,
		SLOT_ID_RIGHT_POCKET
	)
