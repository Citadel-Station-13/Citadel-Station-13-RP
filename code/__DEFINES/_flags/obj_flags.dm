// Flags for the obj_flags var on /obj
/// we're emagged
#define EMAGGED					(1<<0)
/// can this be bludgeoned by items?
#define CAN_BE_HIT				(1<<1)
/// Are we visible on the station blueprints at roundstart?
#define ON_BLUEPRINTS			(1<<2)
/// Prevent people from clicking under us
#define OBJ_PREVENT_CLICK_UNDER	(1<<3)

DEFINE_BITFIELD(obj_flags, list(
	BITFIELD(EMAGGED),
	BITFIELD(CAN_BE_HIT),
	BITFIELD(ON_BLUEPRINTS),
	BITFIELD(OBJ_PREVENT_CLICK_UNDER),
))
