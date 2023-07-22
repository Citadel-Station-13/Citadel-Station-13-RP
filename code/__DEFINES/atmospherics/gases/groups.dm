//! groups
/// Should always and only include gasses that are directly selectable on interfaces.
/// Anything not in here should be in one or more of the other groups.
/// Anything in this group should have the CORE and FILTERABLE flag
#define GAS_GROUP_CORE (1<<0)
/// Should include all non-core gasses.
/// Shows up on misc lists.
#define GAS_GROUP_OTHER (1<<1)
/// Unknown / generated gases
#define GAS_GROUP_UNKNOWN (1<<2)
/// chemicals
#define GAS_GROUP_REAGENT (1<<3)

GLOBAL_REAL_LIST(gas_group_names) = list(
	"Core",
	"Other",
	"Unknown",
	"Reagents",
)

#define GAS_GROUPS_FILTERABLE (GAS_GROUP_UNKNOWN | GAS_GROUP_REAGENT | GAS_GROUP_OTHER)
