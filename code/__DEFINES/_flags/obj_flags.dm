// Flags for the obj_flags var on /obj
/// we're emagged
#define OBJ_EMAGGED                 (1<<0)
/// Prevent people from clicking under us
#define OBJ_PREVENT_CLICK_UNDER     (1<<1)
/// Are we visible on the station blueprints at roundstart?
#define OBJ_ON_BLUEPRINTS           (1<<2)
/// can be targeted in melee
#define OBJ_MELEE_TARGETABLE        (1<<3)
/// can be targeted by projectiles
#define OBJ_RANGE_TARGETABLE        (1<<4)
/// is a hologram
#define OBJ_HOLOGRAM                (1<<5)
/// We ignore depth system when blocking mobs
#define OBJ_IGNORE_MOB_DEPTH        (1<<6)

DEFINE_BITFIELD(obj_flags, list(
	BITFIELD(OBJ_EMAGGED),
	BITFIELD(OBJ_PREVENT_CLICK_UNDER),
	BITFIELD(OBJ_ON_BLUEPRINTS),
	BITFIELD(OBJ_MELEE_TARGETABLE),
	BITFIELD(OBJ_RANGE_TARGETABLE),
	BITFIELD(OBJ_HOLOGRAM),
	BITFIELD(OBJ_IGNORE_MOB_DEPTH),
))
