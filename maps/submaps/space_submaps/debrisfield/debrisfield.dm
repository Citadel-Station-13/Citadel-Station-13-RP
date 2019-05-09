// This causes PoI maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new PoI, please add it to this list.
#if MAP_TEST
// #define "your_map_here.dmm"
#endif

/datum/map_template/submap/space/debrisfield
	name = "Debris Field Content"
	abstract_type = /datum/map_template/submap/space/debrisfield
	id = "ruin_space_debris_"
	desc = "A map template base.  In space."

// No points of interest yet, but the infrastructure is there for people to add!