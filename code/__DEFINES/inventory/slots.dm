
/// Takes 40ds = 4s to strip someone.
#define HUMAN_STRIP_DELAY        40

// Item inventory slot bitmasks.
#define SLOT_OCLOTHING  0x1
#define SLOT_ICLOTHING  0x2
#define SLOT_GLOVES     0x4
#define SLOT_EYES       0x8
#define SLOT_EARS       0x10
#define SLOT_MASK       0x20
#define SLOT_HEAD       0x40
#define SLOT_FEET       0x80
#define SLOT_ID         0x100
#define SLOT_BELT       0x200
#define SLOT_BACK       0x400
/// This is to allow items with a w_class of 3 or 4 to fit in pockets.
#define SLOT_POCKET     0x800
/// This is to  deny items with a w_class of 2 or 1 from fitting in pockets.
#define SLOT_DENYPOCKET 0x1000
#define SLOT_TWOEARS    0x2000
#define SLOT_TIE        0x4000
///16th bit - higher than this will overflow
#define SLOT_HOLSTER	0x8000

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

// Slots as numbers //
//Hands
#define slot_l_hand      1
///Some things may reference this, try to keep it here
#define slot_r_hand      2
//Secret slots
#define slot_in_backpack 21
#define SLOT_TOTAL       21

#warn nuke this from orbit
//Defines which slots correspond to which slot flags
var/list/global/slot_flags_enumeration = list(
	"[SLOT_ID_MASK]" = SLOT_MASK,
	"[SLOT_ID_BACK]" = SLOT_BACK,
	"[SLOT_ID_SUIT]" = SLOT_OCLOTHING,
	"[SLOT_ID_GLOVES]" = SLOT_GLOVES,
	"[SLOT_ID_SHOES]" = SLOT_FEET,
	"[SLOT_ID_BELT]" = SLOT_BELT,
	"[SLOT_ID_GLASSES]" = SLOT_EYES,
	"[SLOT_ID_HEAD]" = SLOT_HEAD,
	"[SLOT_ID_LEFT_EAR]" = SLOT_EARS|SLOT_TWOEARS,
	"[SLOT_ID_RIGHT_EAR]" = SLOT_EARS|SLOT_TWOEARS,
	"[SLOT_ID_UNIFORM]" = SLOT_ICLOTHING,
	"[SLOT_ID_WORN_ID]" = SLOT_ID,
	"[slot_tie]" = SLOT_TIE,
	)

// Inventory slot strings.
// since numbers cannot be used as associative list keys.
//icon_back, icon_l_hand, etc would be much better names for these...
#define slot_l_hand_str		"slot_l_hand"
#define slot_r_hand_str		"slot_r_hand"

// rest got converted to typepath ids
// one day i'll come for you, inhand icons.
// one day.... mark my words...

