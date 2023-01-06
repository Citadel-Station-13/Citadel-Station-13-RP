/turf/simulated/floor/carpet
	name = "carpet"
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "carpet"
	initial_flooring = /singleton/flooring/carpet

	// smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_CARPET)
	canSmoothWith = (SMOOTH_GROUP_CARPET)

/turf/simulated/floor/carpet/bcarpet
	name = "black carpet"
	icon_state = "bcarpet"
	initial_flooring = /singleton/flooring/carpet/bcarpet

/turf/simulated/floor/carpet/blucarpet
	name = "blue carpet"
	icon_state = "blucarpet"
	initial_flooring = /singleton/flooring/carpet/blucarpet

/turf/simulated/floor/carpet/tealcarpet
	name = "teal carpet"
	icon_state = "tealcarpet"
	initial_flooring = /singleton/flooring/carpet/tealcarpet

// Legacy support for existing paths for blue carpet
/turf/simulated/floor/carpet/blue
	name = "blue carpet"
	icon_state = "blucarpet"
	initial_flooring = /singleton/flooring/carpet/blucarpet

/turf/simulated/floor/carpet/turcarpet
	name = "tur carpet"
	icon_state = "turcarpet"
	initial_flooring = /singleton/flooring/carpet/turcarpet

/turf/simulated/floor/carpet/sblucarpet
	name = "sblue carpet"
	icon_state = "sblucarpet"
	initial_flooring = /singleton/flooring/carpet/sblucarpet

/turf/simulated/floor/carpet/gaycarpet
	name = "clown carpet"
	icon_state = "gaycarpet"
	initial_flooring = /singleton/flooring/carpet/gaycarpet

/turf/simulated/floor/carpet/purcarpet
	name = "purple carpet"
	icon_state = "purcarpet"
	initial_flooring = /singleton/flooring/carpet/purcarpet

/turf/simulated/floor/carpet/oracarpet
	name = "orange carpet"
	icon_state = "oracarpet"
	initial_flooring = /singleton/flooring/carpet/oracarpet

/turf/simulated/floor/carpet/arcadecarpet
	name = "arcade carpet"
	icon_state = "arcade"
	initial_flooring = /singleton/flooring/carpet/arcadecarpet

/turf/simulated/floor/bluegrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "bcircuit"
	initial_flooring = /singleton/flooring/reinforced/circuit

/turf/simulated/floor/greengrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "gcircuit"
	initial_flooring = /singleton/flooring/reinforced/circuit/green

/turf/simulated/floor/wood
	name = "wooden floor"
	icon = 'icons/turf/flooring/wood_vr.dmi'
	icon_state = "wood"
	initial_flooring = /singleton/flooring/wood

/turf/simulated/floor/wood/broken
	icon_state = "broken0" // This gets changed when spawned.

/turf/simulated/floor/wood/broken/Initialize(mapload)
	break_tile()
	return ..()

/turf/simulated/floor/wood/sif
	name = "alien wooden floor"
	icon = 'icons/turf/flooring/wood.dmi'
	icon_state = "sifwood"
	initial_flooring = /singleton/flooring/wood/sif

/turf/simulated/floor/wood/sif/broken
	icon_state = "sifwood_broken0" // This gets changed when spawned.

/turf/simulated/floor/wood/sif/broken/Initialize(mapload)
	break_tile()
	return ..()

/turf/simulated/floor/grass
	name = "grass patch"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_state = "grass0"
	initial_flooring = /singleton/flooring/grass

/turf/simulated/floor/tiled
	name = "floor"
	icon = 'icons/turf/flooring/tiles_vr.dmi'
	icon_state = "tiled"
	initial_flooring = /singleton/flooring/tiling

/turf/simulated/floor/tiled/techmaint
	name = "floor"
	icon = 'icons/turf/flooring/tiles_vr.dmi'
	icon_state = "techmaint"
	initial_flooring = /singleton/flooring/tiling/new_tile/techmaint

/turf/simulated/floor/tiled/techmaint/airless
	initial_gas_mix = GAS_STRING_VACUUM

/turf/simulated/floor/tiled/monofloor
	name = "floor"
	icon = 'icons/turf/flooring/tiles_vr.dmi'
	icon_state = "monofloor"
	initial_flooring = /singleton/flooring/tiling/new_tile/monofloor

/turf/simulated/floor/tiled/techfloor
	name = "floor"
	icon = 'icons/turf/flooring/techfloor_vr.dmi'
	icon_state = "techfloor_gray"
	initial_flooring = /singleton/flooring/tiling/tech

/turf/simulated/floor/tiled/monotile
	name = "floor"
	icon = 'icons/turf/flooring/tiles_vr.dmi'
	icon_state = "monotile"
	initial_flooring = /singleton/flooring/tiling/new_tile/monotile

/turf/simulated/floor/tiled/monowhite
	name = "floor"
	icon = 'icons/turf/flooring/tiles_vr.dmi'
	icon_state = "monowhite"
	initial_flooring = /singleton/flooring/tiling/new_tile/monowhite

/turf/simulated/floor/tiled/steel_grid
	name = "floor"
	icon = 'icons/turf/flooring/tiles_vr.dmi'
	icon_state = "steel_grid"
	initial_flooring = /singleton/flooring/tiling/new_tile/steel_grid

/turf/simulated/floor/tiled/steel_ridged
	name = "floor"
	icon = 'icons/turf/flooring/tiles_vr.dmi'
	icon_state = "steel_ridged"
	initial_flooring = /singleton/flooring/tiling/new_tile/steel_ridged

/turf/simulated/floor/tiled/old_tile
	name = "floor"
	icon_state = "tile_full"
	initial_flooring = /singleton/flooring/tiling/new_tile
/turf/simulated/floor/tiled/old_tile/white
	color = "#d9d9d9"
/turf/simulated/floor/tiled/old_tile/blue
	color = "#8ba7ad"
/turf/simulated/floor/tiled/old_tile/yellow
	color = "#8c6d46"
/turf/simulated/floor/tiled/old_tile/gray
	color = "#687172"
/turf/simulated/floor/tiled/old_tile/beige
	color = "#385e60"
/turf/simulated/floor/tiled/old_tile/red
	color = "#964e51"
/turf/simulated/floor/tiled/old_tile/purple
	color = "#906987"
/turf/simulated/floor/tiled/old_tile/green
	color = "#46725c"



/turf/simulated/floor/tiled/old_cargo
	name = "floor"
	icon_state = "cargo_one_full"
	initial_flooring = /singleton/flooring/tiling/new_tile/cargo_one
/turf/simulated/floor/tiled/old_cargo/white
	color = "#d9d9d9"
/turf/simulated/floor/tiled/old_cargo/blue
	color = "#8ba7ad"
/turf/simulated/floor/tiled/old_cargo/yellow
	color = "#8c6d46"
/turf/simulated/floor/tiled/old_cargo/gray
	color = "#687172"
/turf/simulated/floor/tiled/old_cargo/beige
	color = "#385e60"
/turf/simulated/floor/tiled/old_cargo/red
	color = "#964e51"
/turf/simulated/floor/tiled/old_cargo/purple
	color = "#906987"
/turf/simulated/floor/tiled/old_cargo/green
	color = "#46725c"


/turf/simulated/floor/tiled/kafel_full
	name = "floor"
	icon_state = "kafel_full"
	initial_flooring = /singleton/flooring/tiling/new_tile/kafel
/turf/simulated/floor/tiled/kafel_full/white
	color = "#d9d9d9"
/turf/simulated/floor/tiled/kafel_full/blue
	color = "#8ba7ad"
/turf/simulated/floor/tiled/kafel_full/yellow
	color = "#8c6d46"
/turf/simulated/floor/tiled/kafel_full/gray
	color = "#687172"
/turf/simulated/floor/tiled/kafel_full/beige
	color = "#385e60"
/turf/simulated/floor/tiled/kafel_full/red
	color = "#964e51"
/turf/simulated/floor/tiled/kafel_full/purple
	color = "#906987"
/turf/simulated/floor/tiled/kafel_full/green
	color = "#46725c"


/turf/simulated/floor/tiled/techfloor/grid
	name = "floor"
	icon_state = "techfloor_grid"
	initial_flooring = /singleton/flooring/tiling/tech/grid

/turf/simulated/floor/reinforced
	name = "reinforced floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "reinforced"
	initial_flooring = /singleton/flooring/reinforced

/turf/simulated/floor/reinforced/airless
	initial_gas_mix = GAS_STRING_VACUUM

/turf/simulated/floor/reinforced/airmix
	initial_gas_mix = GAS_STRING_PRIMARY_TANK_AIRMIX

/turf/simulated/floor/reinforced/nitrogen
	initial_gas_mix = GAS_STRING_PRIMARY_TANK_NITROGEN

/turf/simulated/floor/reinforced/oxygen
	initial_gas_mix = GAS_STRING_PRIMARY_TANK_OXYGEN

/turf/simulated/floor/reinforced/phoron
	initial_gas_mix = GAS_STRING_PRIMARY_TANK_PHORON

/turf/simulated/floor/reinforced/carbon_dioxide
	initial_gas_mix = GAS_STRING_PRIMARY_TANK_CO2

/turf/simulated/floor/reinforced/n20
	initial_gas_mix = GAS_STRING_PRIMARY_TANK_N2O

/turf/simulated/floor/cult
	name = "engraved floor"
	icon = 'icons/turf/flooring/cult.dmi'
	icon_state = "cult"
	initial_flooring = /singleton/flooring/reinforced/cult

/turf/simulated/floor/cult/cultify()
	return

/turf/simulated/floor/tiled/dark
	name = "dark floor"
	icon_state = "dark"
	initial_flooring = /singleton/flooring/tiling/dark

/turf/simulated/floor/tiled/hydro
	name = "hydro floor"
	icon_state = "hydrofloor"
	initial_flooring = /singleton/flooring/tiling/hydro

/turf/simulated/floor/tiled/neutral
	name = "light floor"
	icon_state = "neutral"
	initial_flooring = /singleton/flooring/tiling/neutral

/turf/simulated/floor/tiled/red
	name = "red floor"
	color = COLOR_RED_GRAY
	icon_state = "white"
	initial_flooring = /singleton/flooring/tiling/red

/turf/simulated/floor/tiled/steel
	name = "steel floor"
	icon_state = "steel"
	initial_flooring = /singleton/flooring/tiling/steel

/turf/simulated/floor/tiled/steel_dirty
	name = "steel floor"
	icon_state = "steel_dirty"
	initial_flooring = /singleton/flooring/tiling/steel_dirty

/turf/simulated/floor/tiled/steel_dirty/dark
	color = COLOR_GRAY

/turf/simulated/floor/tiled/steel_dirty/red
	color = COLOR_RED_GRAY

/turf/simulated/floor/tiled/steel_dirty/cyan
	color = COLOR_CYAN

/turf/simulated/floor/tiled/steel_dirty/olive
	color = COLOR_OLIVE

/turf/simulated/floor/tiled/steel_dirty/silver
	color = COLOR_SILVER

/turf/simulated/floor/tiled/steel_dirty/yellow
	color = COLOR_BROWN

/turf/simulated/floor/tiled/steel/airless
	initial_gas_mix = GAS_STRING_VACUUM

/turf/simulated/floor/tiled/asteroid_steel
	icon_state = "asteroidfloor"
	initial_flooring = /singleton/flooring/tiling/asteroidfloor

/turf/simulated/floor/tiled/asteroid_steel/airless
	name = "plating"
	initial_gas_mix = GAS_STRING_VACUUM

/turf/simulated/floor/tiled/white
	name = "white floor"
	icon_state = "white"
	initial_flooring = /singleton/flooring/tiling/white

/turf/simulated/floor/tiled/yellow
	name = "yellow floor"
	color = COLOR_BROWN
	icon_state = "white"
	initial_flooring = /singleton/flooring/tiling/yellow

/turf/simulated/floor/tiled/freezer
	name = "tiles"
	icon_state = "freezer"
	temperature = 277.15
	initial_flooring = /singleton/flooring/tiling/freezer

/turf/simulated/floor/lino
	name = "lino"
	icon = 'icons/turf/flooring/linoleum.dmi'
	icon_state = "lino"
	initial_flooring = /singleton/flooring/linoleum

/turf/simulated/floor/wmarble
	name = "marble"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "lightmarble"
	initial_flooring = /singleton/flooring/wmarble

/turf/simulated/floor/bmarble
	name = "marble"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "darkmarble"
	initial_flooring = /singleton/flooring/bmarble

/turf/simulated/floor/bananium
	name = "bananium"
	desc = "This floor feels vaguely springy and rubbery, and has an almost pleasant bounce when stepped on."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "bananium"
	initial_flooring = /singleton/flooring/bananium

/turf/simulated/floor/bananium/Entered(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.hovering) // Flying things shouldn't make footprints.
			return ..()
		playsound(src, 'sound/items/bikehorn.ogg', 75, 1)
	..()

/turf/simulated/floor/silencium
	name = "silencium"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "silencium"
	initial_flooring = /singleton/flooring/silencium

/turf/simulated/floor/plasteel
	name = "plasteel"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "plasteel"
	initial_flooring = /singleton/flooring/plasteel

/turf/simulated/floor/durasteel
	name = "durasteel"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "durasteel"
	initial_flooring = /singleton/flooring/durasteel

/turf/simulated/floor/silver
	name = "silver"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "silver"
	initial_flooring = /singleton/flooring/silver

/turf/simulated/floor/gold
	name = "gold"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "gold"
	initial_flooring = /singleton/flooring/gold

/turf/simulated/floor/phoron
	name = "phoron"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "phoron"
	initial_flooring = /singleton/flooring/phoron

/turf/simulated/floor/uranium
	name = "uranium"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "uranium"
	initial_flooring = /singleton/flooring/uranium

/turf/simulated/floor/diamond
	name = "diamond"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "diamond"
	initial_flooring = /singleton/flooring/diamond

/turf/simulated/floor/brass
	name = "clockwork floor"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "clockwork_floor"
	initial_flooring = /singleton/flooring/brass

//ATMOS PREMADES
/turf/simulated/floor/reinforced/airless
	name = "vacuum floor"
	initial_gas_mix = GAS_STRING_VACUUM

/turf/simulated/floor/airless
	name = "plating"
	initial_gas_mix = GAS_STRING_VACUUM

/turf/simulated/floor/tiled/airless
	name = "floor"
	initial_gas_mix = GAS_STRING_VACUUM

/turf/simulated/floor/bluegrid/airless
	name = "floor"
	initial_gas_mix = GAS_STRING_VACUUM

/turf/simulated/floor/greengrid/airless
	name = "floor"
	initial_gas_mix = GAS_STRING_VACUUM

/turf/simulated/floor/greengrid/nitrogen
	initial_gas_mix = GAS_STRING_STANDARD_NO_OXYGEN

/turf/simulated/floor/tiled/white/airless
	name = "floor"
	initial_gas_mix = GAS_STRING_VACUUM

// Placeholders

/turf/simulated/floor/airless/lava
/turf/simulated/floor/light
/*
/turf/simulated/floor/beach
/turf/simulated/floor/beach/sand
/turf/simulated/floor/beach/sand/desert
/turf/simulated/floor/beach/coastline
/turf/simulated/floor/beach/water
/turf/simulated/floor/beach/water/ocean
*/
/turf/simulated/floor/airless/ceiling
/turf/simulated/floor/plating

/turf/simulated/floor/plating/external
	outdoors = TRUE

/turf/simulated/floor/tiled/external
	outdoors = TRUE

//**** Here lives snow ****
/turf/simulated/floor/snow
	name = "snow"
	icon = 'icons/turf/snow_new.dmi'
	icon_state = "snow"
	var/list/crossed_dirs = list()

/turf/simulated/floor/snow/gravsnow
	name = "snowy gravel"
	icon = 'icons/turf/snow_new.dmi'
	icon_state = "gravsnow"

/turf/simulated/floor/snow/snow2
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"
	initial_flooring = /singleton/flooring/snow

/turf/simulated/floor/snow/gravsnow2
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "gravsnow"
	initial_flooring = /singleton/flooring/snow/gravsnow2

/turf/simulated/floor/snow/plating
	name = "snowy playing"
	icon_state = "snowyplating"
	initial_flooring = /singleton/flooring/snow/plating

/turf/simulated/floor/snow/plating/drift
	name = "snowy plating"
	icon_state = "snowyplayingdrift"
	initial_flooring = /singleton/flooring/snow/plating/drift
