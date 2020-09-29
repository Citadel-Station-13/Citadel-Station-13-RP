// Different types of atom colorations
#define ADMIN_COLOR_PRIORITY		1	// Only used by rare effects like greentext coloring mobs and when admins varedit color
#define TEMPORARY_COLOR_PRIORITY	2	// e.g. purple effect of the revenant on a mob, black effect when mob electrocuted
#define WASHABLE_COLOR_PRIORITY	3	// Color splashed onto an atom (e.g. paint on turf)
#define FIXED_COLOR_PRIORITY		4	// Color inherent to the atom (e.g. blob color)
#define COLOR_PRIORITY_AMOUNT		4	// How many priority levels there are.
