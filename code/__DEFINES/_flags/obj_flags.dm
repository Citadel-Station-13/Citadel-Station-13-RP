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
/// Base materials have been modified
#define OBJ_MATERIALS_MODIFIED      (1<<7)
/// Material parts have been modified
#define OBJ_MATERIAL_PARTS_MODIFIED (1<<8)
/// Materials have been initialized
#define OBJ_MATERIAL_INITIALIZED    (1<<9)
/// no sculpting
#define OBJ_NO_SCULPTING			(1<<10)
/// wall-mounted; facing *towards* the wall we're mounted on (e.g. be NORTH if we're shifted north)
#define OBJ_WALL_MOUNTED			(1<<11)
/// Allow throwing stuff through us if we get destroyed by a throw
#define OBJ_ALLOW_THROW_THROUGH     (1<<23)

DEFINE_BITFIELD(obj_flags, list(
	BITFIELD(OBJ_EMAGGED),
	BITFIELD(OBJ_PREVENT_CLICK_UNDER),
	BITFIELD(OBJ_ON_BLUEPRINTS),
	BITFIELD(OBJ_MELEE_TARGETABLE),
	BITFIELD(OBJ_RANGE_TARGETABLE),
	BITFIELD(OBJ_HOLOGRAM),
	BITFIELD(OBJ_IGNORE_MOB_DEPTH),
	BITFIELD(OBJ_MATERIALS_MODIFIED),
	BITFIELD(OBJ_MATERIAL_PARTS_MODIFIED),
	BITFIELD(OBJ_MATERIAL_INITIALIZED),
	BITFIELD(OBJ_NO_SCULPTING),
	BITFIELD_NAMED("Wall Mounted", OBJ_WALL_MOUNTED),
	BITFIELD_NAMED("Allow Thrown to Pass if Devastated", OBJ_ALLOW_THROW_THROUGH), // dumb, rename later
))

//* /obj/var/obj_rotation_flags

/// obj rotation enabled; we'll go to context menu
#define OBJ_ROTATION_ENABLED (1<<0)
/// allow defaulting on context menu
#define OBJ_ROTATION_DEFAULTING (1<<1)
/// do not perform standard anchor check
#define OBJ_ROTATION_NO_ANCHOR_CHECK (1<<2)
/// rotate CCW
#define OBJ_ROTATION_CCW (1<<3)
/// give optiosn to rotate both directions
#define OBJ_ROTATION_BIDIRECTIONAL (1<<4)

DEFINE_BITFIELD(obj_rotation_flags, list(
	BITFIELD_NAMED("Enabled", OBJ_ROTATION_ENABLED),
	BITFIELD_NAMED("Defaulting", OBJ_ROTATION_DEFAULTING),
	BITFIELD_NAMED("Allow Anchored", OBJ_ROTATION_NO_ANCHOR_CHECK),
	BITFIELD_NAMED("Counterclockwise", OBJ_ROTATION_CCW),
	BITFIELD_NAMED("Show Both Directions", OBJ_ROTATION_BIDIRECTIONAL),
))
