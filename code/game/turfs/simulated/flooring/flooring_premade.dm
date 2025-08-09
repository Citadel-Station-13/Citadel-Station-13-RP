/turf/simulated/floor/carpet
	name = "carpet"
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "carpet"
	initial_flooring = /datum/prototype/flooring/carpet

	// smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_CARPET)
	canSmoothWith = (SMOOTH_GROUP_CARPET)

/turf/simulated/floor/carpet/bcarpet
	name = "black carpet"
	icon_state = "bcarpet"
	initial_flooring = /datum/prototype/flooring/carpet/bcarpet

/turf/simulated/floor/carpet/blucarpet
	name = "blue carpet"
	icon_state = "blucarpet"
	initial_flooring = /datum/prototype/flooring/carpet/blucarpet

/turf/simulated/floor/carpet/tealcarpet
	name = "teal carpet"
	icon_state = "tealcarpet"
	initial_flooring = /datum/prototype/flooring/carpet/tealcarpet

// Legacy support for existing paths for blue carpet
/turf/simulated/floor/carpet/blue
	name = "blue carpet"
	icon_state = "blucarpet"
	initial_flooring = /datum/prototype/flooring/carpet/blucarpet

/turf/simulated/floor/carpet/turcarpet
	name = "tur carpet"
	icon_state = "turcarpet"
	initial_flooring = /datum/prototype/flooring/carpet/turcarpet

/turf/simulated/floor/carpet/sblucarpet
	name = "sblue carpet"
	icon_state = "sblucarpet"
	initial_flooring = /datum/prototype/flooring/carpet/sblucarpet

/turf/simulated/floor/carpet/gaycarpet
	name = "clown carpet"
	icon_state = "gaycarpet"
	initial_flooring = /datum/prototype/flooring/carpet/gaycarpet

/turf/simulated/floor/carpet/purcarpet
	name = "purple carpet"
	icon_state = "purcarpet"
	initial_flooring = /datum/prototype/flooring/carpet/purcarpet

/turf/simulated/floor/carpet/oracarpet
	name = "orange carpet"
	icon_state = "oracarpet"
	initial_flooring = /datum/prototype/flooring/carpet/oracarpet

/turf/simulated/floor/carpet/arcadecarpet
	name = "arcade carpet"
	icon_state = "arcade"
	initial_flooring = /datum/prototype/flooring/carpet/arcadecarpet

/turf/simulated/floor/carpet/patterened/brown
	name = "brown patterend carpet"
	icon_state = "brown"
	initial_flooring = /datum/prototype/flooring/carpet/patterened/brown

/turf/simulated/floor/carpet/patterened/blue
	name = "blue patterend carpet"
	icon_state = "blue1"
	initial_flooring = /datum/prototype/flooring/carpet/patterened/blue

/turf/simulated/floor/carpet/patterened/blue/alt
	name = "blue patterend carpet"
	icon_state = "blue2"
	initial_flooring = /datum/prototype/flooring/carpet/patterened/blue/alt

/turf/simulated/floor/carpet/patterened/blue/alt2
	name = "blue patterend carpet"
	icon_state = "blue3"
	initial_flooring = /datum/prototype/flooring/carpet/patterened/blue/alt2

/turf/simulated/floor/carpet/patterened/red
	name = "red patterend carpet"
	icon_state = "red"
	initial_flooring = /datum/prototype/flooring/carpet/patterened/red

/turf/simulated/floor/carpet/patterened/green
	name = "green patterend carpet"
	icon_state = "green"
	initial_flooring = /datum/prototype/flooring/carpet/patterened/green

/turf/simulated/floor/carpet/patterened/magneta
	name = "magenta patterend carpet"
	icon_state = "magenta"
	initial_flooring = /datum/prototype/flooring/carpet/patterened/magenta

/turf/simulated/floor/carpet/patterened/purple
	name = "purple patterend carpet"
	icon_state = "purple"
	initial_flooring = /datum/prototype/flooring/carpet/patterened/purple

/turf/simulated/floor/carpet/patterened/orange
	name = "orange patterend carpet"
	icon_state = "orange"
	initial_flooring = /datum/prototype/flooring/carpet/patterened/orange

/turf/simulated/floor/bluegrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "bcircuit"
	initial_flooring = /datum/prototype/flooring/reinforced/circuit

/turf/simulated/floor/greengrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "gcircuit"
	initial_flooring = /datum/prototype/flooring/reinforced/circuit/green

CREATE_STANDARD_TURFS(/turf/simulated/floor/wood)
/turf/simulated/floor/wood
	name = "wooden floor"
	icon = 'icons/turf/flooring/wood.dmi'
	icon_state = "wood"
	initial_flooring = /datum/prototype/flooring/wood


/turf/simulated/floor/wood/broken
	icon_state = "broken0" // This gets changed when spawned.

/turf/simulated/floor/wood/broken/Initialize(mapload)
	break_tile()
	return ..()

CREATE_STANDARD_TURFS(/turf/simulated/floor/wood/sif)
/turf/simulated/floor/wood/sif
	name = "alien wooden floor"
	icon = 'icons/turf/flooring/wood.dmi'
	icon_state = "sifwood"
	initial_flooring = /datum/prototype/flooring/wood/sif


/turf/simulated/floor/wood/sif/broken
	icon_state = "sifwood_broken0" // This gets changed when spawned.

/turf/simulated/floor/wood/sif/broken/Initialize(mapload)
	break_tile()
	return ..()

CREATE_STANDARD_TURFS(/turf/simulated/floor/grass)
/turf/simulated/floor/grass
	name = "grass patch"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_state = "grass0"
	initial_flooring = /datum/prototype/flooring/grass

CREATE_STANDARD_TURFS(/turf/simulated/floor/tiled)
/turf/simulated/floor/tiled
	name = "floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "tiled"
	initial_flooring = /datum/prototype/flooring/tiling

/turf/simulated/floor/tiled/techmaint
	name = "floor"
	icon_state = "techmaint"
	initial_flooring = /datum/prototype/flooring/tiling/new_tile/techmaint

/turf/simulated/floor/tiled/techmaint/airless
	initial_gas_mix = GAS_STRING_VACUUM

/turf/simulated/floor/tiled/monofloor
	name = "floor"
	icon_state = "monofloor"
	initial_flooring = /datum/prototype/flooring/tiling/new_tile/monofloor

/turf/simulated/floor/tiled/techfloor
	name = "floor"
	icon = 'icons/turf/flooring/techfloor.dmi'
	icon_state = "techfloor_gray"
	initial_flooring = /datum/prototype/flooring/tiling/tech

/turf/simulated/floor/tiled/monotile
	name = "floor"
	icon_state = "monotile"
	initial_flooring = /datum/prototype/flooring/tiling/new_tile/monotile
CREATE_STANDARD_TURFS(/turf/simulated/floor/tiled/monotile)

/turf/simulated/floor/tiled/monowhite
	name = "floor"
	icon_state = "monowhite"
	initial_flooring = /datum/prototype/flooring/tiling/new_tile/monowhite

/turf/simulated/floor/tiled/monodark
	name = "floor"
	icon_state = "monodark"
	initial_flooring = /datum/prototype/flooring/tiling/new_tile/monodark

/turf/simulated/floor/tiled/monotechmaint
	name = "floor"
	icon_state = "monotechmaint"
	initial_flooring = /datum/prototype/flooring/tiling/new_tile/monotechmaint

/turf/simulated/floor/tiled/steel_grid
	name = "floor"
	icon_state = "steel_grid"
	initial_flooring = /datum/prototype/flooring/tiling/new_tile/steel_grid

/turf/simulated/floor/tiled/steel_ridged
	name = "floor"
	icon_state = "steel_ridged"
	initial_flooring = /datum/prototype/flooring/tiling/new_tile/steel_ridged

/turf/simulated/floor/tiled/old_tile
	name = "floor"
	icon_state = "tile_full"
	initial_flooring = /datum/prototype/flooring/tiling/new_tile
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
	initial_flooring = /datum/prototype/flooring/tiling/new_tile/cargo_one
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
	initial_flooring = /datum/prototype/flooring/tiling/new_tile/kafel
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
	initial_flooring = /datum/prototype/flooring/tiling/tech/grid

/turf/simulated/floor/tiled/techfloor/monogrid
	name = "floor"
	icon_state = "techfloor_monogrid"
	initial_flooring = /datum/prototype/flooring/tiling/tech/monogrid
/turf/simulated/floor/reinforced
	name = "reinforced floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "reinforced"
	initial_flooring = /datum/prototype/flooring/reinforced

CREATE_STANDARD_TURFS(/turf/simulated/floor/reinforced)

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
	initial_flooring = /datum/prototype/flooring/reinforced/cult

/turf/simulated/floor/cult/cultify()
	return

/turf/simulated/floor/tiled/dark
	name = "dark floor"
	icon_state = "dark"
	initial_flooring = /datum/prototype/flooring/tiling/dark

/turf/simulated/floor/tiled/hydro
	name = "hydro floor"
	icon_state = "hydrofloor"
	initial_flooring = /datum/prototype/flooring/tiling/hydro

/turf/simulated/floor/tiled/neutral
	name = "light floor"
	icon_state = "neutral"
	initial_flooring = /datum/prototype/flooring/tiling/neutral

/turf/simulated/floor/tiled/red
	name = "red floor"
	color = COLOR_RED_GRAY
	icon_state = "white"
	initial_flooring = /datum/prototype/flooring/tiling/red

/turf/simulated/floor/tiled/steel
	name = "steel floor"
	icon_state = "steel"
	initial_flooring = /datum/prototype/flooring/tiling/steel

CREATE_STANDARD_TURFS(/turf/simulated/floor/tiled/steel_dirty)
/turf/simulated/floor/tiled/steel_dirty
	name = "steel floor"
	icon_state = "steel_dirty"
	initial_flooring = /datum/prototype/flooring/tiling/steel_dirty

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
	initial_flooring = /datum/prototype/flooring/tiling/asteroidfloor

/turf/simulated/floor/tiled/asteroid_steel/airless
	name = "plating"
	initial_gas_mix = GAS_STRING_VACUUM

CREATE_STANDARD_TURFS(/turf/simulated/floor/tiled/white)
/turf/simulated/floor/tiled/white
	name = "white floor"
	icon_state = "white"
	initial_flooring = /datum/prototype/flooring/tiling/white

/turf/simulated/floor/tiled/yellow
	name = "yellow floor"
	color = COLOR_BROWN
	icon_state = "white"
	initial_flooring = /datum/prototype/flooring/tiling/yellow

/turf/simulated/floor/tiled/freezer
	name = "tiles"
	icon_state = "freezer"
	temperature = 277.15
	initial_flooring = /datum/prototype/flooring/tiling/freezer

/turf/simulated/floor/lino
	name = "lino"
	icon = 'icons/turf/flooring/linoleum.dmi'
	icon_state = "lino"
	initial_flooring = /datum/prototype/flooring/linoleum

/turf/simulated/floor/wmarble
	name = "marble"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "lightmarble"
	initial_flooring = /datum/prototype/flooring/wmarble

/turf/simulated/floor/bmarble
	name = "marble"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "darkmarble"
	initial_flooring = /datum/prototype/flooring/bmarble

/turf/simulated/floor/bananium
	name = "bananium"
	desc = "This floor feels vaguely springy and rubbery, and has an almost pleasant bounce when stepped on."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "bananium"
	initial_flooring = /datum/prototype/flooring/bananium

/turf/simulated/floor/bananium/Entered(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.is_avoiding_ground()) // Flying things shouldn't make footprints.
			return ..()
		playsound(src, 'sound/items/bikehorn.ogg', 75, 1)
	..()

/turf/simulated/floor/silencium
	name = "silencium"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "silencium"
	initial_flooring = /datum/prototype/flooring/silencium

/turf/simulated/floor/plasteel
	name = "plasteel"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "plasteel"
	initial_flooring = /datum/prototype/flooring/plasteel

CREATE_STANDARD_TURFS(/turf/simulated/floor/plasteel)

/turf/simulated/floor/durasteel
	name = "durasteel"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "durasteel"
	initial_flooring = /datum/prototype/flooring/durasteel

/turf/simulated/floor/silver
	name = "silver"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "silver"
	initial_flooring = /datum/prototype/flooring/silver

/turf/simulated/floor/gold
	name = "gold"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "gold"
	initial_flooring = /datum/prototype/flooring/gold

/turf/simulated/floor/phoron
	name = "phoron"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "phoron"
	initial_flooring = /datum/prototype/flooring/phoron

CREATE_STANDARD_TURFS(/turf/simulated/floor/phoron)

/turf/simulated/floor/uranium
	name = "uranium"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "uranium"
	initial_flooring = /datum/prototype/flooring/uranium

/turf/simulated/floor/diamond
	name = "diamond"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "diamond"
	initial_flooring = /datum/prototype/flooring/diamond

/turf/simulated/floor/brass
	name = "clockwork floor"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "clockwork_floor"
	initial_flooring = /datum/prototype/flooring/brass

/turf/simulated/floor/sandstone
	name = "sandstone"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "sandstone"
	initial_flooring = /datum/prototype/flooring/sandstone

/turf/simulated/floor/bone
	name = "bone floor"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "bone"
	initial_flooring = /datum/prototype/flooring/bone

/turf/simulated/floor/bone/engraved
	name = "engraved bone floor"
	icon_state = "bonecarve"
	initial_flooring = /datum/prototype/flooring/bone/engraved

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
/**This literally does nothing, need to axe or make it do something */
/turf/simulated/floor/airless/ceiling

/turf/simulated/floor/plating
	can_start_dirty = TRUE	// But let maints and decrepit areas have some randomness
CREATE_STANDARD_TURFS(/turf/simulated/floor/plating)

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
	initial_flooring = /datum/prototype/flooring/snow

/turf/simulated/floor/snow/gravsnow2
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "gravsnow"
	initial_flooring = /datum/prototype/flooring/snow/gravsnow2

/turf/simulated/floor/snow/plating
	name = "snowy playing"
	icon_state = "snowyplating"
	initial_flooring = /datum/prototype/flooring/snow/plating

/turf/simulated/floor/snow/plating/drift
	name = "snowy plating"
	icon_state = "snowyplayingdrift"
	initial_flooring = /datum/prototype/flooring/snow/plating/drift


// Roguetown Floors
/turf/simulated/floor/roguetown/wood
	name = "wooden floorboards"
	icon = 'icons/turf/flooring/roguetown/wood.dmi'
	icon_state = "wooden_floor"
	initial_flooring = /datum/prototype/flooring/roguetown/wood


/turf/simulated/floor/roguetown/dark_wood
	name = "dark wooden floorboards"
	icon = 'icons/turf/flooring/roguetown/wood.dmi'
	icon_state = "wooden_floor2"
	initial_flooring = /datum/prototype/flooring/roguetown/dark_wood


/turf/simulated/floor/roguetown/cobblestone
	name = "cobblestone"
	icon = 'icons/turf/flooring/roguetown/cobble.dmi'
	icon_state = "cobblestone1"
	initial_flooring = /datum/prototype/flooring/roguetown/cobblestone


/turf/simulated/floor/roguetown/cobblestone2
	name = "cobblestone"
	icon = 'icons/turf/flooring/roguetown/cobble.dmi'
	icon_state = "cobblestone2"
	initial_flooring = /datum/prototype/flooring/roguetown/cobblestone2


/turf/simulated/floor/roguetown/cobblestone3
	name = "cobblestone"
	icon = 'icons/turf/flooring/roguetown/cobble.dmi'
	icon_state = "cobblestone3"
	initial_flooring = /datum/prototype/flooring/roguetown/cobblestone3

/turf/simulated/floor/roguetown/paving
	name = "paving"
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_state = "paving"
	initial_flooring = /datum/prototype/flooring/roguetown/paving

/turf/simulated/floor/roguetown/mossystone1
	name = "mossy stone"
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_state = "mossystone1"
	initial_flooring = /datum/prototype/flooring/roguetown/mossy_stone_1

/turf/simulated/floor/roguetown/mossystone2
	name = "mossy stone"
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_state = "mossystone1"
	initial_flooring = /datum/prototype/flooring/roguetown/mossy_stone_2

/turf/simulated/floor/roguetown/mossystone3
	name = "mossy stone"
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_state = "mossystone1"
	initial_flooring = /datum/prototype/flooring/roguetown/mossy_stone_3

/turf/simulated/floor/roguetown/church_marble
	name = "marble floor"
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_state = "church_marble"
	initial_flooring = /datum/prototype/flooring/roguetown/church_marble

/turf/simulated/floor/roguetown/church_brick
	name = "brick floor"
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_state = "church_brick"
	initial_flooring = /datum/prototype/flooring/roguetown/church_brick

/turf/simulated/floor/roguetown/church
	name = "marble floor"
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_state = "church"
	initial_flooring = /datum/prototype/flooring/roguetown/church

/turf/simulated/floor/roguetown/blocks
	name = "stone blocks"
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_state = "blocks"
	initial_flooring = /datum/prototype/flooring/roguetown/blocks

/turf/simulated/floor/roguetown/greenstone
	name = "green stone flooring"
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_state = "greenstone"
	initial_flooring = /datum/prototype/flooring/roguetown/greenstone

/turf/simulated/floor/roguetown/glyph1
	name = "green stone glyph"
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_state = "glyph1"
	initial_flooring = /datum/prototype/flooring/roguetown/glyph1

/turf/simulated/floor/roguetown/glyph2
	name = "green stone glyph"
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_state = "glyph2"
	initial_flooring = /datum/prototype/flooring/roguetown/glyph2

/turf/simulated/floor/roguetown/glyph3
	name = "green stone glyph"
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_state = "glyph3"
	initial_flooring = /datum/prototype/flooring/roguetown/glyph3

/turf/simulated/floor/roguetown/glyph4
	name = "green stone glyph"
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_state = "glyph4"
	initial_flooring = /datum/prototype/flooring/roguetown/glyph4

/turf/simulated/floor/roguetown/glyph5
	name = "green stone glyph"
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_state = "glyph5"
	initial_flooring = /datum/prototype/flooring/roguetown/glyph5

/turf/simulated/floor/roguetown/glyph6
	name = "green stone glyph"
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_state = "glyph6"
	initial_flooring = /datum/prototype/flooring/roguetown/glyph6

/turf/simulated/floor/roguetown/glyph7
	name = "green stone glyph"
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_state = "glyph7"
	initial_flooring = /datum/prototype/flooring/roguetown/glyph7

/turf/simulated/floor/roguetown/glyph8
	name = "green stone glyph"
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_state = "glyph8"
	initial_flooring = /datum/prototype/flooring/roguetown/glyph8

/turf/simulated/floor/roguetown/glyph9
	name = "green stone glyph"
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_state = "glyph9"
	initial_flooring = /datum/prototype/flooring/roguetown/glyph9

/turf/simulated/floor/roguetown/tempered
	name = "tempered flooring"
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_state = "lavafloor"
	initial_flooring = /datum/prototype/flooring/roguetown/tempered

/turf/simulated/floor/roguetown/grass
	name = "grass"
	icon = 'icons/turf/flooring/roguetown/grass.dmi'
	icon_state = "grass"
	initial_flooring = /datum/prototype/flooring/roguetown/grass


/turf/simulated/floor/roguetown/grass_red
	name = "red grass"
	icon = 'icons/turf/flooring/roguetown/grass.dmi'
	icon_state = "grass_red"
	initial_flooring = /datum/prototype/flooring/roguetown/grass_red


/turf/simulated/floor/roguetown/grass_yellow
	name = "yellow grass"
	icon = 'icons/turf/flooring/roguetown/grass.dmi'
	icon_state = "grass_yellow"
	initial_flooring = /datum/prototype/flooring/roguetown/grass_yellow


/turf/simulated/floor/roguetown/grass_cold
	name = "cold grass"
	icon = 'icons/turf/flooring/roguetown/grass.dmi'
	icon_state = "grass_cold"
	initial_flooring = /datum/prototype/flooring/roguetown/grass_cold


/turf/simulated/floor/roguetown/grass_odd
	name = "odd grass"
	icon = 'icons/turf/flooring/roguetown/grass.dmi'
	icon_state = "grass_odd"
	initial_flooring = /datum/prototype/flooring/roguetown/grass_odd


/turf/simulated/floor/roguetown/mud
	name = "mud"
	icon = 'icons/turf/flooring/roguetown/mud.dmi'
	icon_state = "mud1"
	initial_flooring = /datum/prototype/flooring/roguetown/mud


/turf/simulated/floor/roguetown/mud2
	name = "mud"
	icon = 'icons/turf/flooring/roguetown/mud.dmi'
	icon_state = "mud2"
	initial_flooring = /datum/prototype/flooring/roguetown/mud2


/turf/simulated/floor/roguetown/mud3
	name = "mud"
	icon = 'icons/turf/flooring/roguetown/mud.dmi'
	icon_state = "mud3"
	initial_flooring = /datum/prototype/flooring/roguetown/mud3


/turf/simulated/floor/roguetown/dirt
	name = "dirt"
	icon = 'icons/turf/flooring/roguetown/dirt.dmi'
	icon_state = "dirt"
	initial_flooring = /datum/prototype/flooring/roguetown/dirt


/turf/simulated/floor/roguetown/rock
	name = "rocks"
	icon = 'icons/turf/flooring/roguetown/rock.dmi'
	icon_state = "rock"
	initial_flooring = /datum/prototype/flooring/roguetown/rock
