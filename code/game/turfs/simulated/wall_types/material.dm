/// Define a wall based on the name, outer material, and girder material.
/// This is for slightly more complicated walls.
#define BASIC_WALL_DEF(TypeName, GirderMaterial, OuterMaterial)\
/turf/simulated/wall/##TypeName{\
	color           = OuterMaterial::icon_colour;\
	icon            = OuterMaterial::icon_base;\
	material_girder = GirderMaterial;\
	material_outer  = OuterMaterial;\
};\
/turf/simulated/wall/##TypeName

/// Define a wall based on the name, outer material, reinforcement material, and girder material.
/// This is for the most complicated walls.
#define REINF_WALL_DEF(TypeName, GirderMaterial, OuterMaterial, ReinfMaterial)\
BASIC_WALL_DEF(TypeName, GirderMaterial, OuterMaterial){\
	material_reinf = ReinfMaterial;\
	icon           = ReinfMaterial::icon_reinf;\
};\
/turf/simulated/wall/##TypeName


REINF_WALL_DEF(r_wall, /datum/prototype/material/steel, /datum/prototype/material/plasteel, /datum/prototype/material/plasteel)
	rad_insulation = RAD_INSULATION_SUPER

// Steel hull walls
BASIC_WALL_DEF(shull,  /datum/prototype/material/steel/hull, /datum/prototype/material/steel/hull)
REINF_WALL_DEF(rshull, /datum/prototype/material/steel/hull, /datum/prototype/material/steel/hull, /datum/prototype/material/steel/hull)

// Plasteel walls
BASIC_WALL_DEF(pshull,  /datum/prototype/material/plasteel/hull, /datum/prototype/material/plasteel/hull)
REINF_WALL_DEF(rpshull, /datum/prototype/material/plasteel/hull, /datum/prototype/material/plasteel/hull, /datum/prototype/material/durasteel/hull)

// Durasteel walls
BASIC_WALL_DEF(dshull,  /datum/prototype/material/durasteel/hull, /datum/prototype/material/durasteel/hull)
REINF_WALL_DEF(rdshull, /datum/prototype/material/durasteel/hull, /datum/prototype/material/durasteel/hull, /datum/prototype/material/durasteel/hull)

// Titanium walls
BASIC_WALL_DEF(thull,  /datum/prototype/material/plasteel/titanium/hull, /datum/prototype/material/plasteel/titanium/hull)
REINF_WALL_DEF(rthull, /datum/prototype/material/plasteel/titanium/hull, /datum/prototype/material/plasteel/titanium/hull, /datum/prototype/material/plasteel/titanium/hull)

REINF_WALL_DEF(cult, /datum/prototype/material/cult, /datum/prototype/material/cult, /datum/prototype/material/cult/reinf)

BASIC_WALL_DEF(bone,             /datum/prototype/material/steel, /datum/prototype/material/bone)
BASIC_WALL_DEF(diamond,          /datum/prototype/material/steel, /datum/prototype/material/diamond)
BASIC_WALL_DEF(gold,             /datum/prototype/material/steel, /datum/prototype/material/gold)
REINF_WALL_DEF(golddiamond,      /datum/prototype/material/steel, /datum/prototype/material/gold,      /datum/prototype/material/diamond)
BASIC_WALL_DEF(iron,             /datum/prototype/material/steel, /datum/prototype/material/iron)
REINF_WALL_DEF(ironphoron,       /datum/prototype/material/steel, /datum/prototype/material/iron,      /datum/prototype/material/phoron)
BASIC_WALL_DEF(lead,             /datum/prototype/material/steel, /datum/prototype/material/lead)
REINF_WALL_DEF(r_lead,           /datum/prototype/material/steel, /datum/prototype/material/lead,      /datum/prototype/material/lead)
BASIC_WALL_DEF(phoron,           /datum/prototype/material/steel, /datum/prototype/material/phoron)
BASIC_WALL_DEF(resin,            /datum/prototype/material/resin, /datum/prototype/material/resin)
BASIC_WALL_DEF(sandstone,        /datum/prototype/material/steel, /datum/prototype/material/sandstone)
REINF_WALL_DEF(sandstonediamond, /datum/prototype/material/steel, /datum/prototype/material/sandstone, /datum/prototype/material/diamond)
BASIC_WALL_DEF(silver,           /datum/prototype/material/steel, /datum/prototype/material/silver)
REINF_WALL_DEF(silvergold,       /datum/prototype/material/steel, /datum/prototype/material/silver,    /datum/prototype/material/gold)
BASIC_WALL_DEF(snowbrick,        /datum/prototype/material/steel, /datum/prototype/material/snowbrick)
BASIC_WALL_DEF(uranium,          /datum/prototype/material/steel, /datum/prototype/material/uranium)

BASIC_WALL_DEF(titanium,         /datum/prototype/material/steel, /datum/prototype/material/plasteel/titanium)
REINF_WALL_DEF(durasteel,        /datum/prototype/material/steel, /datum/prototype/material/durasteel, /datum/prototype/material/durasteel)

BASIC_WALL_DEF(wood,             /datum/prototype/material/wood_plank,          /datum/prototype/material/wood_plank)
BASIC_WALL_DEF(wood/sifwood,     /datum/prototype/material/wood_plank/sif,      /datum/prototype/material/wood_plank/sif)
BASIC_WALL_DEF(wood/hardwood,    /datum/prototype/material/wood_plank/hardwood, /datum/prototype/material/wood_plank/hardwood)
BASIC_WALL_DEF(wood/ironwood,    /datum/prototype/material/wood_plank/ironwood, /datum/prototype/material/wood_plank/ironwood)
BASIC_WALL_DEF(wood/log,         /datum/prototype/material/wood_log,            /datum/prototype/material/wood_log)
BASIC_WALL_DEF(log_sif,          /datum/prototype/material/wood_log/sif,        /datum/prototype/material/wood_log/sif)
BASIC_WALL_DEF(log_ironwood,     /datum/prototype/material/wood_log/ironwood,   /datum/prototype/material/wood_log/ironwood)

BASIC_WALL_DEF(skipjack,         /datum/prototype/material/steel, /datum/prototype/material/alienalloy)
/turf/simulated/wall/skipjack/attackby()
	return

/turf/unsimulated/wall/cult
	name = "cult wall"
	desc = "Hideous images dance beneath the surface."
	icon = /datum/prototype/material/cult::icon_base
	icon_state = "wall-0"
	base_icon_state = "wall"
	color = /datum/prototype/material/cult::icon_colour
