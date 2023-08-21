/// power surge from energy being taken
#define POWERNET_STATUS_SURGE_DRAIN (1<<0)
/// power surge from energy being grounded somewhere
#define POWERNET_STATUS_SURGE_FAULT (1<<1)

DEFINE_SHARED_BITFIELD(powernet_status, list(
	"powernet_status",
	"last_powernet_status",
), list(
	BITFIELD(POWERNET_STATUS_SURGE_DRAIN),
	BITFIELD(POWERNET_STATUS_SURGE_FAULT),
))
