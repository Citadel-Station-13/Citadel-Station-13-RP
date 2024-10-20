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


REINF_WALL_DEF(r_wall, /datum/material/steel, /datum/material/plasteel, /datum/material/plasteel)
	rad_insulation = RAD_INSULATION_SUPER

// Steel hull walls
BASIC_WALL_DEF(shull,  /datum/material/steel/hull, /datum/material/steel/hull)
REINF_WALL_DEF(rshull, /datum/material/steel/hull, /datum/material/steel/hull, /datum/material/steel/hull)

// Plasteel walls
BASIC_WALL_DEF(pshull,  /datum/material/plasteel/hull, /datum/material/plasteel/hull)
REINF_WALL_DEF(rpshull, /datum/material/plasteel/hull, /datum/material/plasteel/hull, /datum/material/durasteel/hull)

// Durasteel walls
BASIC_WALL_DEF(dshull,  /datum/material/durasteel/hull, /datum/material/durasteel/hull)
REINF_WALL_DEF(rdshull, /datum/material/durasteel/hull, /datum/material/durasteel/hull, /datum/material/durasteel/hull)

// Titanium walls
BASIC_WALL_DEF(thull,  /datum/material/plasteel/titanium/hull, /datum/material/plasteel/titanium/hull)
REINF_WALL_DEF(rthull, /datum/material/plasteel/titanium/hull, /datum/material/plasteel/titanium/hull, /datum/material/plasteel/titanium/hull)

REINF_WALL_DEF(cult, /datum/material/cult, /datum/material/cult, /datum/material/cult/reinf)

BASIC_WALL_DEF(bone,             /datum/material/steel, /datum/material/bone)
BASIC_WALL_DEF(diamond,          /datum/material/steel, /datum/material/diamond)
BASIC_WALL_DEF(gold,             /datum/material/steel, /datum/material/gold)
REINF_WALL_DEF(golddiamond,      /datum/material/steel, /datum/material/gold,      /datum/material/diamond)
BASIC_WALL_DEF(iron,             /datum/material/steel, /datum/material/iron)
REINF_WALL_DEF(ironphoron,       /datum/material/steel, /datum/material/iron,      /datum/material/phoron)
BASIC_WALL_DEF(lead,             /datum/material/steel, /datum/material/lead)
REINF_WALL_DEF(r_lead,           /datum/material/steel, /datum/material/lead,      /datum/material/lead)
BASIC_WALL_DEF(phoron,           /datum/material/steel, /datum/material/phoron)
BASIC_WALL_DEF(resin,            /datum/material/resin, /datum/material/resin)
BASIC_WALL_DEF(sandstone,        /datum/material/steel, /datum/material/sandstone)
REINF_WALL_DEF(sandstonediamond, /datum/material/steel, /datum/material/sandstone, /datum/material/diamond)
BASIC_WALL_DEF(silver,           /datum/material/steel, /datum/material/silver)
REINF_WALL_DEF(silvergold,       /datum/material/steel, /datum/material/silver,    /datum/material/gold)
BASIC_WALL_DEF(snowbrick,        /datum/material/steel, /datum/material/snowbrick)
BASIC_WALL_DEF(uranium,          /datum/material/steel, /datum/material/uranium)

BASIC_WALL_DEF(titanium,         /datum/material/steel, /datum/material/plasteel/titanium)
REINF_WALL_DEF(durasteel,        /datum/material/steel, /datum/material/durasteel, /datum/material/durasteel)

BASIC_WALL_DEF(wood,             /datum/material/wood_plank,          /datum/material/wood_plank)
BASIC_WALL_DEF(wood/sifwood,     /datum/material/wood_plank/sif,      /datum/material/wood_plank/sif)
BASIC_WALL_DEF(wood/hardwood,    /datum/material/wood_plank/hardwood, /datum/material/wood_plank/hardwood)
BASIC_WALL_DEF(wood/ironwood,    /datum/material/wood_plank/ironwood, /datum/material/wood_plank/ironwood)
BASIC_WALL_DEF(wood/log,         /datum/material/wood_log,            /datum/material/wood_log)
BASIC_WALL_DEF(log_sif,          /datum/material/wood_log/sif,        /datum/material/wood_log/sif)
BASIC_WALL_DEF(log_ironwood,     /datum/material/wood_log/ironwood,   /datum/material/wood_log/ironwood)

BASIC_WALL_DEF(skipjack,         /datum/material/steel, /datum/material/alienalloy)
/turf/simulated/wall/skipjack/attackby()
	return

/turf/unsimulated/wall/cult
	name = "cult wall"
	desc = "Hideous images dance beneath the surface."
	icon = /datum/material/cult::icon_base
	icon_state = "wall-0"
	base_icon_state = "wall"
	color = /datum/material/cult::icon_colour
