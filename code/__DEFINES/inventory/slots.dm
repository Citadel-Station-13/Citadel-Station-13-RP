
/// Takes 40ds = 4s to strip someone.
#define HUMAN_STRIP_DELAY		4 SECONDS
/// Takes 2s to use a UI element in somebody else's hands.
#define HUMAN_INTERACT_DELAY	2 SECONDS

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

// Slots as numbers //
//Hands
#define slot_l_hand      1
///Some things may reference this, try to keep it here
#define slot_r_hand      2
//Shown unless F12 pressed
#define slot_back        3
#define slot_wear_id     5
#define slot_s_store     6
#define slot_belt        4
#define slot_l_store     7
///Some things may reference this, try to keep it here
#define slot_r_store     8
//Shown when inventory unhidden
#define slot_glasses     9
#define slot_wear_mask   10
#define slot_gloves      11
#define slot_head        12
#define slot_shoes       13
#define slot_wear_suit   14
#define slot_w_uniform   15
#define slot_l_ear       16
#define slot_r_ear       17
//Secret slots
#define slot_tie         18
#define slot_handcuffed  19
#define slot_legcuffed   20
#define slot_in_backpack 21
#define SLOT_TOTAL       21

//Defines which slots correspond to which slot flags
var/list/global/slot_flags_enumeration = list(
	"[slot_wear_mask]" = SLOT_MASK,
	"[slot_back]" = SLOT_BACK,
	"[slot_wear_suit]" = SLOT_OCLOTHING,
	"[slot_gloves]" = SLOT_GLOVES,
	"[slot_shoes]" = SLOT_FEET,
	"[slot_belt]" = SLOT_BELT,
	"[slot_glasses]" = SLOT_EYES,
	"[slot_head]" = SLOT_HEAD,
	"[slot_l_ear]" = SLOT_EARS|SLOT_TWOEARS,
	"[slot_r_ear]" = SLOT_EARS|SLOT_TWOEARS,
	"[slot_w_uniform]" = SLOT_ICLOTHING,
	"[slot_wear_id]" = SLOT_ID,
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

