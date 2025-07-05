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
