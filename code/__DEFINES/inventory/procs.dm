//! flags for inventory ops
/// force; implies INV_OP_IGNORE_DELAY and INV_OP_IGNORE_REACHABILITY
#define INV_OP_FORCE				(1<<0)
/// components that intercept to relocate should refrain - usually used with force
#define INV_OP_SHOULD_NOT_INTERCEPT	(1<<1)
/// no sound
#define INV_OP_SUPPRESS_SOUND		(1<<2)
/// no warnings
#define INV_OP_SUPPRESS_WARNING		(1<<3)
/// do not run logic like checking if you should drop something when something's unequipped
#define INV_OP_NO_LOGIC				(1<<4)
/// do not updatei cons
#define INV_OP_NO_UPDATE_ICONS		(1<<5)
/// hint: we are directly dropping to ground/off omb
#define INV_OP_DIRECTLY_DROPPING	(1<<6)
/// hint: we are re-equipping between slots
#define INV_OP_REEQUIPPING			(1<<7)
/// hint: we are doing this during outfit equip, antag creation, or otherwise roundstart operatoins
#define INV_OP_CREATION				(1<<8)
/// hint: we are chained through by an accessory's parent
#define INV_OP_IS_ACCESSORY			(1<<9)
/// do not allow delays when checking - if we need to sleep, immediately fail
#define INV_OP_DISALLOW_DELAY		(1<<10)
/// ignore reachability checks
#define INV_OP_IGNORE_REACHABILITY	(1<<11)
/// ignore equip/unequip delay
#define INV_OP_IGNORE_DELAY			(1<<12)
/// do not merge stacks if possible
#define INV_OP_NO_MERGE_STACKS		(1<<13)
/// used on can equip/unequip - this is the final check before point of no return, therefore side effects are permissible
#define INV_OP_IS_FINAL_CHECK		(1<<14)
/// hint: we are directly equipping to on-mob instead of semantically just being put in hands
#define INV_OP_DIRECTLY_EQUIPPING	(1<<15)
/// hint: we're mid delete. maybe don't try to delete again?
#define INV_OP_DELETING				(1<<16)
/// hint: we're currently mitigating a fatal error in an inventory proc, likely trying to revert state
#define INV_OP_FATAL				(1<<17)

/// no delays and reachability checks entirely
#define INV_OP_FLUFFLESS			(INV_OP_IGNORE_REACHABILITY | INV_OP_IGNORE_DELAY)
/// no sound, warnings, etc, entirely
#define INV_OP_SILENT				(INV_OP_SUPPRESS_SOUND | INV_OP_SUPPRESS_WARNING)

// todo: INV_OP_RECRUSE

//! return values from can_equip_conflict_check
/// yes
#define CAN_EQUIP_SLOT_CONFLICT_NONE		0
/// slot has another item, hell no
#define CAN_EQUIP_SLOT_CONFLICT_HARD		1
/// slot is semantically blocked by something else the user is wearing but you can force it on anyways
#define CAN_EQUIP_SLOT_CONFLICT_SOFT		2

//! return values for _item_by_slot, _set_inv_slot
/// this slot doesn't exist
#define INVENTORY_SLOT_DOES_NOT_EXIST			-1

//! return values for inv view/strip/access/panel procs:
//? /datum/inventory_slot_meta/proc/check_strip_conceal()
/// do not show slot
#define INV_VIEW_OBFUSCATE_HIDE_SLOT			(1<<0)
/// do not allow operations
#define INV_VIEW_OBFUSCATE_DISALLOW_INTERACT	(1<<1)
/// do not allow viewing item name
#define INV_VIEW_OBFUSCATE_HIDE_ITEM_NAME		(1<<2)
/// do not allow viewing if an item is there
#define INV_VIEW_OBFUSCATE_HIDE_ITEM_EXISTENCE	(1<<3)
/// don't display messages when stripping
#define INV_VIEW_STRIP_IS_SILENT				(1<<4)
/// display fumbling message on failure
#define INV_VIEW_STRIP_FUMBLE_ON_FAILURE		(1<<5)
