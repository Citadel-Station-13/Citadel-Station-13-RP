/// Whether can_interact() checks for anchored. Only works on movables.
#define INTERACT_ATOM_REQUIRES_ANCHORED (1<<0)
/// Calls try_interact() on attack_hand() and returns that.
#define INTERACT_ATOM_ATTACK_HAND (1<<1)
/// Automatically calls and returns ui_interact() on interact().
#define INTERACT_ATOM_UI_INTERACT (1<<2)
/// User must be dextrous.
#define INTERACT_ATOM_REQUIRES_DEXTERITY (1<<3)
/// Ignores incapacitated check.
#define INTERACT_ATOM_IGNORE_INCAPACITATED (1<<4)
/// Incapacitated check ignores restrained.
#define INTERACT_ATOM_IGNORE_RESTRAINED (1<<5)
/// Incapacitated check checks grab.
#define INTERACT_ATOM_CHECK_GRAB (1<<6)
/// Prevents leaving fingerprints automatically on attack_hand, put in hands, other touch procs.
#define INTERACT_ATOM_NO_FINGERPRINT_ON_TOUCH (1<<7)
/// Adds hiddenprints instead of fingerprints on interact.
#define INTERACT_ATOM_NO_FINGERPRINT_INTERACT (1<<8)
/// Allows this atom to skip the adjacency check.
// #define INTERACT_ATOM_ALLOW_USER_LOCATION (1<<9)

DEFINE_BITFIELD(interaction_flags_atom, list(
	BITFIELD(INTERACT_ATOM_REQUIRES_ANCHORED),
	BITFIELD(INTERACT_ATOM_NO_FINGERPRINT_ON_TOUCH),
	BITFIELD(INTERACT_ATOM_NO_FINGERPRINT_INTERACT),
))

DEFINE_BITFIELD(interaction_flags_atom, list(
	BITFIELD(INTERACT_ATOM_ATTACK_HAND),
	BITFIELD(INTERACT_ATOM_CHECK_GRAB),
	BITFIELD(INTERACT_ATOM_IGNORE_INCAPACITATED),
	BITFIELD(INTERACT_ATOM_IGNORE_RESTRAINED),
	BITFIELD(INTERACT_ATOM_NO_FINGERPRINT_ON_TOUCH),
	BITFIELD(INTERACT_ATOM_NO_FINGERPRINT_INTERACT),
	BITFIELD(INTERACT_ATOM_REQUIRES_ANCHORED),
	BITFIELD(INTERACT_ATOM_REQUIRES_DEXTERITY),
	BITFIELD(INTERACT_ATOM_UI_INTERACT),
	// BITFIELD(INTERACT_ATOM_ALLOW_USER_LOCATION),
))
/*
/// attempt pickup on attack_hand for items
#define INTERACT_ITEM_ATTACK_HAND_PICKUP (1<<0)
*/
/// can_interact() while open
#define INTERACT_MACHINE_OPEN (1<<0)
/// can_interact() while offline
#define INTERACT_MACHINE_OFFLINE (1<<1)
/// try to interact with wires if open
#define INTERACT_MACHINE_WIRES_IF_OPEN (1<<2)
/// let silicons interact
#define INTERACT_MACHINE_ALLOW_SILICON (1<<3)
/// let silicons interact while open
#define INTERACT_MACHINE_OPEN_SILICON (1<<4)
/// must be silicon to interact
#define INTERACT_MACHINE_REQUIRES_SILICON (1<<5)
/// MACHINES HAVE THIS BY DEFAULT, SOMEONE SHOULD RUN THROUGH MACHINES AND REMOVE IT FROM THINGS LIKE LIGHT SWITCHES WHEN POSSIBLE!!--------------------------
/// This flag determines if a machine set_machine's the user when the user uses it, making updateUsrDialog make the user re-call interact() on it.
/// THIS FLAG IS ON ALL MACHINES BY DEFAULT, NEEDS TO BE RE-EVALUATED LATER!!
#define INTERACT_MACHINE_SET_MACHINE (1<<6)
/// the user must have vision to interact (blind people need not apply)
#define INTERACT_MACHINE_REQUIRES_SIGHT (1<<7)

DEFINE_BITFIELD(interaction_flags_machine, list(
	BITFIELD(INTERACT_MACHINE_OPEN),
	BITFIELD(INTERACT_MACHINE_OFFLINE),
	BITFIELD(INTERACT_MACHINE_WIRES_IF_OPEN),
	BITFIELD(INTERACT_MACHINE_ALLOW_SILICON),
	BITFIELD(INTERACT_MACHINE_OPEN_SILICON),
	BITFIELD(INTERACT_MACHINE_REQUIRES_SILICON),
	BITFIELD(INTERACT_MACHINE_SET_MACHINE),
	BITFIELD(INTERACT_MACHINE_REQUIRES_SIGHT),
))
