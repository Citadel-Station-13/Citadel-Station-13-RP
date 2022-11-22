//! Flags for the obj_flags var on /obj
#define OBJ_FLAG_EMAGGED             (1<<0) // We're emagged.
#define OBJ_FLAG_IN_USE              (1<<1) // If we have a user using us, this will be set on. We will check if the user has stopped using us, and thus stop updating and LAGGING EVERYTHING!
#define OBJ_FLAG_CAN_BE_HIT          (1<<2) // Can this be bludgeoned by items?
#define OBJ_FLAG_ON_BLUEPRINTS       (1<<3) // Are we visible on the station blueprints at roundstart?
#define OBJ_FLAG_USES_TGUI           (1<<4) // Put on things that use tgui on ui_interact instead of custom/old UI.
#define OBJ_FLAG_PREVENT_CLICK_UNDER (1<<5) // Will prevent mobs from clicking on things under this object.
#define OBJ_FLAG_NOFALL              (1<<6) // Will prevent mobs from falling.


//! Unused Flags.
// #define BEING_SHOCKED        (1<<3) // Whether this thing is currently (already) being shocked by a tesla.
// #define DANGEROUS_POSSESSION (1<<4) // Admin possession yes/no.
// #define UNIQUE_RENAME        (1<<6) // Can you customize the description/name of the thing?
// #define FROZEN               (1<<8)
// #define BLOCK_Z_OUT_DOWN     (1<<9)   // Should this object block z falling from loc?
// #define BLOCK_Z_OUT_UP       (1<<10)  // Should this object block z uprise from loc?
// #define BLOCK_Z_IN_DOWN      (1<<11)  // Should this object block z falling from above?
// #define BLOCK_Z_IN_UP        (1<<12)  // Should this object block z uprise from below?
// #define SHOVABLE_ONTO        (1<<13)  //called on turf.shove_act() to consider whether an object should have a niche effect (defined in their own shove_act()) when someone is pushed onto it, or do a sanity CanPass() check.
// #define EXAMINE_SKIP         (1<<14)  // Makes the Examine proc not read out this item.


/*
/// Integrity defines for clothing (not flags but close enough)
/// We have no damage on the clothing
#define CLOTHING_PRISTINE 0
/// There's some damage on the clothing but it still has at least one functioning bodypart
#define CLOTHING_DAMAGED  1
/// The clothing is near useless and has their sensors broken
#define CLOTHING_SHREDDED 2
// If you add new ones, be sure to add them to /obj/Initialize as well for complete mapping support

/// Flags for the pod_flags var on /obj/structure/closet/supplypod
/// If it shouldn't play sounds the first time it lands, used for reverse mode
#define FIRST_SOUNDS (1<<0)
*/

DEFINE_BITFIELD(obj_flags, list(
	BITFIELD(OBJ_FLAG_EMAGGED),
	BITFIELD(OBJ_FLAG_IN_USE),
	BITFIELD(OBJ_FLAG_CAN_BE_HIT),
	BITFIELD(OBJ_FLAG_ON_BLUEPRINTS),
	BITFIELD(OBJ_FLAG_USES_TGUI),
	BITFIELD(OBJ_FLAG_PREVENT_CLICK_UNDER),
	BITFIELD(OBJ_FLAG_NOFALL),
))
