//! groups
/// core gases - not shown as group as interfaces
#define GAS_GROUP_CORE (1<<0)
/// unknown/generated gases
#define GAS_GROUP_UNKNOWN (1<<1)
/// chemicals
#define GAS_GROUP_CHEMICAL (1<<2)
/// default group
#define GAS_GROUP_OTHER (1<<3)

GLOBAL_REAL_LIST(gas_group_names) = list(
	"Core",
	"Unknown",
	"Chemicals",
	"Other",
)
