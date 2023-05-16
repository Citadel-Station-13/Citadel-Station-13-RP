//! Riding filters
//? Filter flags
/// automatically enable and reset buckle_allowed on add/remove
#define CF_RIDING_FILTER_AUTO_BUCKLE_TOGGLE			(1<<0)

DEFINE_BITFIELD(riding_filter_flags, list(
	BITFIELD(CF_RIDING_FILTER_AUTO_BUCKLE_TOGGLE),
))


//! Riding handlers
//? Handler flags
/// ephemeral - delete on last mob unbuckled
#define CF_RIDING_HANDLER_EPHEMERAL					(1<<0)
/// allow us to be one away from valid turfs
#define CF_RIDING_HANDLER_ALLOW_BORDER				(1<<1)
/// always allow spacemove
#define CF_RIDING_HANDLER_FORCED_SPACEMOVE			(1<<2)
/// allow "piloting" of the thing we're riding at all
#define CF_RIDING_HANDLER_IS_CONTROLLABLE			(1<<3)
/// for allow borders, do not allow crossing
#define CF_RIDING_HANDLER_FORBID_BORDER_CROSS		(1<<4)
/// shift rider to our plane
#define CF_RIDING_HANDLER_SHIFT_RIDER_PLANE			(1<<5)

DEFINE_BITFIELD(riding_handler_flags, list(
	BITFIELD(CF_RIDING_HANDLER_EPHEMERAL),
	BITFIELD(CF_RIDING_HANDLER_ALLOW_BORDER),
	BITFIELD(CF_RIDING_HANDLER_FORCED_SPACEMOVE),
	BITFIELD(CF_RIDING_HANDLER_IS_CONTROLLABLE),
	BITFIELD(CF_RIDING_HANDLER_FORBID_BORDER_CROSS),
	BITFIELD(CF_RIDING_HANDLER_SHIFT_RIDER_PLANE),
))

//? Check flags
/// if unconscious
#define CF_RIDING_CHECK_UNCONSCIOUS					(1<<0)
/// if restrained
#define CF_RIDING_CHECK_RESTRAINED					(1<<1)
/// if no arms - behavior depends on component
#define CF_RIDING_CHECK_ARMS						(1<<2)
/// if no legs - behavior depends on component
#define CF_RIDING_CHECK_LEGS						(1<<3)
/// if incapacitated
#define CF_RIDING_CHECK_INCAPACITATED				(1<<4)
/// check not laying down - ONLY SENSICAL ON RIDDEN
#define CF_RIDING_CHECK_LYING						(1<<5)

DEFINE_BITFIELD(rider_check_flags, list(
	BITFIELD(CF_RIDING_CHECK_UNCONSCIOUS),
	BITFIELD(CF_RIDING_CHECK_RESTRAINED),
	BITFIELD(CF_RIDING_CHECK_ARMS),
	BITFIELD(CF_RIDING_CHECK_LEGS),
	BITFIELD(CF_RIDING_CHECK_INCAPACITATED),
	BITFIELD(CF_RIDING_CHECK_LYING),
))
DEFINE_BITFIELD(ridden_check_flags, list(
	BITFIELD(CF_RIDING_CHECK_UNCONSCIOUS),
	BITFIELD(CF_RIDING_CHECK_RESTRAINED),
	BITFIELD(CF_RIDING_CHECK_ARMS),
	BITFIELD(CF_RIDING_CHECK_LEGS),
	BITFIELD(CF_RIDING_CHECK_INCAPACITATED),
	BITFIELD(CF_RIDING_CHECK_LYING),
))

//? rider offset list format
/// list(x, y, layer)
#define CF_RIDING_OFFSETS_SIMPLE 0
/// list(list(x, y, layer), ...), for NESW
#define CF_RIDING_OFFSETS_DIRECTIONAL 1
/// list(list(list(x, y, layer), ...), ...) for NESW inner, indices outer (last index used for remainder)
#define CF_RIDING_OFFSETS_ENUMERATED 2
