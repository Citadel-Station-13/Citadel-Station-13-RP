/datum/prototype/flooring/asteroid
	name = "coarse sand"
	desc = "Gritty and unpleasant."
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_base = "asteroid"
	flooring_flags = TURF_HAS_EDGES | TURF_REMOVE_SHOVEL
	build_type = null

/datum/prototype/flooring/snow
	name = "snow"
	desc = "A layer of many tiny bits of frozen water. It's hard to tell how deep it is."
	icon = 'icons/turf/snow_new.dmi'
	icon_base = "snow"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/snow1.ogg',
		'sound/effects/footstep/snow2.ogg',
		'sound/effects/footstep/snow3.ogg',
		'sound/effects/footstep/snow4.ogg',
		'sound/effects/footstep/snow5.ogg'))

/datum/prototype/flooring/snow/gravsnow
	name = "snowy gravel"
	desc = "A layer of coarse ice pebbles and assorted gravel."
	icon = 'icons/turf/snow_new.dmi'
	icon_base = "gravsnow"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/snow1.ogg',
		'sound/effects/footstep/snow2.ogg',
		'sound/effects/footstep/snow3.ogg',
		'sound/effects/footstep/snow4.ogg',
		'sound/effects/footstep/snow5.ogg'))

/datum/prototype/flooring/snow/snow2
	name = "snow"
	desc = "A layer of many tiny bits of frozen water. It's hard to tell how deep it is."
	icon = 'icons/turf/snow.dmi'
	icon_base = "snow"
	flooring_flags = TURF_HAS_EDGES

/datum/prototype/flooring/snow/gravsnow2
	name = "gravsnow"
	icon = 'icons/turf/snow.dmi'
	icon_base = "gravsnow"

/datum/prototype/flooring/snow/plating
	name = "snowy plating"
	desc = "Steel plating coated with a light layer of snow."
	icon_base = "snowyplating"
	flooring_flags = null

/datum/prototype/flooring/snow/ice
	name = "ice"
	desc = "Looks slippery."
	icon_base = "ice"

/datum/prototype/flooring/snow/plating/drift
	icon_base = "snowyplayingdrift"

/datum/prototype/flooring/carpet
	name = "carpet"
	desc = "Imported and comfy."
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_base = "carpet"
	build_type = /obj/item/stack/tile/carpet
	damage_temperature = T0C+200
	flooring_flags = TURF_HAS_EDGES | TURF_HAS_CORNERS | TURF_REMOVE_CROWBAR | TURF_CAN_BURN
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/carpet1.ogg',
		'sound/effects/footstep/carpet2.ogg',
		'sound/effects/footstep/carpet3.ogg',
		'sound/effects/footstep/carpet4.ogg',
		'sound/effects/footstep/carpet5.ogg'))

/datum/prototype/flooring/carpet/bcarpet
	name = "black carpet"
	icon_base = "bcarpet"
	build_type = /obj/item/stack/tile/carpet/bcarpet

/datum/prototype/flooring/carpet/blucarpet
	name = "blue carpet"
	icon_base = "blucarpet"
	build_type = /obj/item/stack/tile/carpet/blucarpet

/datum/prototype/flooring/carpet/turcarpet
	name = "tur carpet"
	icon_base = "turcarpet"
	build_type = /obj/item/stack/tile/carpet/turcarpet

/datum/prototype/flooring/carpet/sblucarpet
	name = "silver blue carpet"
	icon_base = "sblucarpet"
	build_type = /obj/item/stack/tile/carpet/sblucarpet

/datum/prototype/flooring/carpet/gaycarpet
	name = "clown carpet"
	icon_base = "gaycarpet"
	build_type = /obj/item/stack/tile/carpet/gaycarpet

/datum/prototype/flooring/carpet/purcarpet
	name = "purple carpet"
	icon_base = "purcarpet"
	build_type = /obj/item/stack/tile/carpet/purcarpet

/datum/prototype/flooring/carpet/oracarpet
	name = "orange carpet"
	icon_base = "oracarpet"
	build_type = /obj/item/stack/tile/carpet/oracarpet

/datum/prototype/flooring/carpet/tealcarpet
	name = "teal carpet"
	icon_base = "tealcarpet"
	build_type = /obj/item/stack/tile/carpet/teal

/datum/prototype/flooring/carpet/arcadecarpet
	name = "arcade carpet"
	icon_base = "arcade"
	build_type = /obj/item/stack/tile/carpet/arcadecarpet

/datum/prototype/flooring/carpet/patterened/brown
	name = "brown patterened carpet"
	icon_base = "brown"
	build_type = /obj/item/stack/tile/carpet/patterned/brown

/datum/prototype/flooring/carpet/patterened/red
	name = "red patterened carpet"
	icon_base = "red"
	build_type = /obj/item/stack/tile/carpet/patterned/red

/datum/prototype/flooring/carpet/patterened/blue
	name = "blue patterened carpet"
	icon_base = "blue1"
	build_type = /obj/item/stack/tile/carpet/patterned/blue

/datum/prototype/flooring/carpet/patterened/blue/alt
	name = "blue patterened carpet"
	icon_base = "blue2"
	build_type = /obj/item/stack/tile/carpet/patterned/blue/alt

/datum/prototype/flooring/carpet/patterened/blue/alt2
	name = "blue patterened carpet"
	icon_base = "blue3"
	build_type = /obj/item/stack/tile/carpet/patterned/blue/alt2

/datum/prototype/flooring/carpet/patterened/green
	name = "green patterened carpet"
	icon_base = "green"
	build_type = /obj/item/stack/tile/carpet/patterned/green

/datum/prototype/flooring/carpet/patterened/magenta
	name = "magenta patterened carpet"
	icon_base = "magenta"
	build_type = /obj/item/stack/tile/carpet/patterned/magenta

/datum/prototype/flooring/carpet/patterened/purple
	name = "purple patterened carpet"
	icon_base = "purple"
	build_type = /obj/item/stack/tile/carpet/patterned/purple

/datum/prototype/flooring/carpet/patterened/orange
	name = "orange patterened carpet"
	icon_base = "orange"
	build_type = /obj/item/stack/tile/carpet/patterned/orange

/datum/prototype/flooring/tiling
	name = "floor"
	desc = "Scuffed from the passage of countless greyshirts."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "tiled"
	has_damage_range = 2
	damage_temperature = T0C+1400
	flooring_flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK | TURF_CAN_BURN
	build_type = /obj/item/stack/tile/floor
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))

/datum/prototype/flooring/tiling/tech
	desc = "Scuffed from the passage of countless greyshirts."
	icon = 'icons/turf/flooring/techfloor.dmi'
	icon_base = "techfloor_gray"
	build_type = /obj/item/stack/tile/floor/techgrey

/datum/prototype/flooring/tiling/tech/grid
	icon_base = "techfloor_grid"
	build_type = /obj/item/stack/tile/floor/techgrid

/datum/prototype/flooring/tiling/tech/monogrid
	icon_base = "techfloor_monogrid"
	flooring_flags = TURF_IS_FRAGILE
	build_type = null

/datum/prototype/flooring/tiling/new_tile
	name = "floor"
	icon_base = "tile_full"
	flooring_flags = TURF_CAN_BREAK | TURF_CAN_BURN | TURF_IS_FRAGILE
	build_type = null

/datum/prototype/flooring/tiling/new_tile/cargo_one
	icon_base = "cargo_one_full"

/datum/prototype/flooring/tiling/new_tile/kafel
	icon_base = "kafel_full"

/datum/prototype/flooring/tiling/new_tile/techmaint
	icon_base = "techmaint"

/datum/prototype/flooring/tiling/new_tile/monofloor
	icon_base = "monofloor"

/datum/prototype/flooring/tiling/new_tile/monotile
	icon_base = "monotile"

/datum/prototype/flooring/tiling/new_tile/monowhite
	icon_base = "monowhite"

/datum/prototype/flooring/tiling/new_tile/monodark
	icon_base = "monodark"

/datum/prototype/flooring/tiling/new_tile/monotechmaint
	icon_base = "monotechmaint"

/datum/prototype/flooring/tiling/new_tile/steel_grid
	icon_base = "steel_grid"

/datum/prototype/flooring/tiling/new_tile/steel_ridged
	icon_base = "steel_ridged"

/datum/prototype/flooring/tiling/red
	name = "floor"
	icon_base = "white"
	has_damage_range = null
	flooring_flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor/red

/datum/prototype/flooring/tiling/steel
	name = "floor"
	icon_base = "steel"
	build_type = /obj/item/stack/tile/floor/steel

/datum/prototype/flooring/tiling/steel_dirty
	name = "floor"
	icon_base = "steel_dirty"
	build_type = /obj/item/stack/tile/floor/steel_dirty

/datum/prototype/flooring/tiling/asteroidfloor
	name = "floor"
	icon_base = "asteroidfloor"
	has_damage_range = null
	flooring_flags = TURF_REMOVE_CROWBAR

/datum/prototype/flooring/tiling/white
	name = "floor"
	desc = "How sterile."
	icon_base = "white"
	build_type = /obj/item/stack/tile/floor/white

/datum/prototype/flooring/tiling/yellow
	name = "floor"
	icon_base = "white"
	has_damage_range = null
	flooring_flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor/yellow

/datum/prototype/flooring/tiling/dark
	name = "floor"
	desc = "How ominous."
	icon_base = "dark"
	has_damage_range = null
	flooring_flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor/dark

/datum/prototype/flooring/tiling/hydro
	name = "floor"
	icon_base = "hydrofloor"

/datum/prototype/flooring/tiling/neutral
	name = "floor"
	icon_base = "neutral"

/datum/prototype/flooring/tiling/freezer
	name = "floor"
	desc = "Don't slip."
	icon_base = "freezer"
	build_type = /obj/item/stack/tile/floor/freezer

/datum/prototype/flooring/wmarble
	name = "marble floor"
	desc = "Very regal white marble flooring."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "lightmarble"
	build_type = /obj/item/stack/tile/wmarble
	flooring_flags = TURF_REMOVE_CROWBAR

/datum/prototype/flooring/bmarble
	name = "marble floor"
	desc = "Very regal black marble flooring."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "darkmarble"
	build_type = /obj/item/stack/tile/bmarble
	flooring_flags = TURF_REMOVE_CROWBAR

/datum/prototype/flooring/concrete
	name = "concrete"
	desc = "That's concrete baby!"
	icon = 'icons/turf/flooring/concrete.dmi'
	icon_base = "concrete"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))

/datum/prototype/flooring/concrete/tile
	name = "concrete tile"
	desc = "That's concrete baby!"
	icon = 'icons/turf/flooring/concrete.dmi'
	icon_base = "concrete3"

/datum/prototype/flooring/bananium
	name = "bananium floor"
	desc = "Have you ever seen a clown frown?"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "bananium"
	build_type = /obj/item/stack/tile/bananium
	flooring_flags = TURF_REMOVE_CROWBAR

/datum/prototype/flooring/silencium
	name = "silencium floor"
	desc = "Surprisingly, doesn't mask your footsteps."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "silencium"
	build_type = /obj/item/stack/tile/silencium
	flooring_flags = TURF_REMOVE_CROWBAR

/datum/prototype/flooring/silencium
	name = "silencium floor"
	desc = "Surprisingly, doesn't mask your footsteps."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "silencium"
	build_type = /obj/item/stack/tile/silencium
	flooring_flags = TURF_REMOVE_CROWBAR

/datum/prototype/flooring/plasteel
	name = "plasteel floor"
	desc = "Sturdy metal flooring. Almost certainly a waste."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "plasteel"
	build_type = /obj/item/stack/tile/plasteel
	flooring_flags = TURF_REMOVE_CROWBAR

/datum/prototype/flooring/durasteel
	name = "durasteel floor"
	desc = "Incredibly sturdy metal flooring. Definitely a waste."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "durasteel"
	build_type = /obj/item/stack/tile/durasteel
	flooring_flags = TURF_REMOVE_CROWBAR

/datum/prototype/flooring/silver
	name = "silver floor"
	desc = "This opulent flooring reminds you of the ocean. Almost certainly a waste."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "silver"
	build_type = /obj/item/stack/tile/silver
	flooring_flags = TURF_REMOVE_CROWBAR

/datum/prototype/flooring/gold
	name = "gold floor"
	desc = "This richly tooled flooring makes you feel powerful."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "gold"
	build_type = /obj/item/stack/tile/gold
	flooring_flags = TURF_REMOVE_CROWBAR

/datum/prototype/flooring/phoron
	name = "phoron floor"
	desc = "Although stable for now, this solid phoron flooring radiates danger."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "phoron"
	build_type = /obj/item/stack/tile/phoron
	flooring_flags = TURF_REMOVE_CROWBAR

/datum/prototype/flooring/uranium
	name = "uranium floor"
	desc = "This flooring literally radiates danger."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "uranium"
	build_type = /obj/item/stack/tile/uranium
	flooring_flags = TURF_REMOVE_CROWBAR

/datum/prototype/flooring/diamond
	name = "diamond floor"
	desc = "This flooring proves that you are a king among peasants. It's virtually impossible to scuff."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "diamond"
	build_type = /obj/item/stack/tile/diamond
	flooring_flags = TURF_REMOVE_CROWBAR

/datum/prototype/flooring/brass
	name = "brass floor"
	desc = "There's something strange about this tile. If you listen closely, it sounds like it's ticking."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "clockwork_floor"
	build_type = /obj/item/stack/tile/brass
	flooring_flags = TURF_REMOVE_CROWBAR

/datum/prototype/flooring/wood
	name = "wooden floor"
	desc = "Polished redwood planks."
	icon = 'icons/turf/flooring/wood.dmi'
	icon_base = "wood"
	has_damage_range = 6
	damage_temperature = T0C+200
	descriptor = "planks"
	build_type = /obj/item/stack/tile/wood
	flooring_flags = TURF_CAN_BREAK | TURF_IS_FRAGILE | TURF_REMOVE_SCREWDRIVER | TURF_MZ_ON_BREAK
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/wood1.ogg',
		'sound/effects/footstep/wood2.ogg',
		'sound/effects/footstep/wood3.ogg',
		'sound/effects/footstep/wood4.ogg',
		'sound/effects/footstep/wood5.ogg'))

/datum/prototype/flooring/wood/sif
	name = "alien wooden floor"
	desc = "Polished alien wood planks."
	icon_base = "sifwood"
	build_type = /obj/item/stack/tile/wood/sif

/datum/prototype/flooring/reinforced
	name = "reinforced floor"
	desc = "Heavily reinforced with steel rods."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "reinforced"
	flooring_flags = TURF_REMOVE_WRENCH | TURF_ACID_IMMUNE
	build_type = /obj/item/stack/rods
	build_cost = 2
	build_time = 30

/datum/prototype/flooring/reinforced/circuit
	name = "processing strata"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_base = "bcircuit"
	build_type = null
	flooring_flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_REMOVE_CROWBAR

/datum/prototype/flooring/reinforced/circuit/green
	name = "processing strata"
	icon_base = "gcircuit"

/datum/prototype/flooring/reinforced/cult
	name = "engraved floor"
	desc = "Unsettling whispers waver from the surface..."
	icon = 'icons/turf/flooring/cult.dmi'
	icon_base = "cult"
	build_type = null
	has_damage_range = 6
	flooring_flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK

/datum/prototype/flooring/outdoors/lavaland
	name = "ash sand"
	desc = "Soft and ominous."
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_base = "asteroid"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/datum/prototype/flooring/outdoors/classd
	name = "irradiated sand"
	desc = "It literally glows in the dark."
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_base = "asteroid"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/datum/prototype/flooring/outdoors/dirt
	name = "dirt"
	icon = 'icons/turf/outdoors.dmi'
	icon_base = "dirt-dark"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))


/datum/prototype/flooring/outdoors/grass
	name = "grass"
	icon = 'icons/turf/outdoors.dmi'
	icon_base = "grass"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/grass1.ogg',
		'sound/effects/footstep/grass2.ogg',
		'sound/effects/footstep/grass3.ogg',
		'sound/effects/footstep/grass4.ogg'))

/datum/prototype/flooring/outdoors/grass/sif
	name = "growth"
	icon = 'icons/turf/outdoors.dmi'
	icon_base = "grass_sif"

/datum/prototype/flooring/water
	name = "water"
	desc = "Water is wet, gosh, who knew!"
	icon = 'icons/turf/outdoors.dmi'
	icon_base = "seashallow"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/water1.ogg',
		'sound/effects/footstep/water2.ogg',
		'sound/effects/footstep/water3.ogg',
		'sound/effects/footstep/water4.ogg'))

/datum/prototype/flooring/outdoors/beach
	name = "beach"
	icon = 'icons/turf/outdoors.dmi'
	icon_base = "sand"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/turf/simulated/floor/flesh
	name = "flesh"
	desc = "This slick flesh ripples and squishes under your touch"
	icon = 'icons/turf/stomach_vr.dmi'
	icon_state = "flesh_floor"
	initial_flooring = /datum/prototype/flooring/flesh

/turf/simulated/floor/flesh/colour
	icon_state = "c_flesh_floor"
	initial_flooring = /datum/prototype/flooring/flesh

/turf/simulated/floor/flesh/attackby()
	return

/datum/prototype/flooring/flesh
	name = "flesh"
	desc = "This slick flesh ripples and squishes under your touch"
	icon = 'icons/turf/stomach_vr.dmi'
	icon_base = "flesh_floor"

/datum/prototype/flooring/outdoors/beach/sand/desert
	name = "beach"
	icon = 'icons/turf/outdoors.dmi'
	icon_base = "desert"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/turf/simulated/floor/tiled/freezer/cold
	temperature = T0C - 5

/datum/prototype/flooring/trap
	name = "suspicious flooring"
	desc = "There's something off about this tile."
	icon = 'icons/turf/flooring/plating.dmi'
	icon_base = "plating"
	build_type = null
	flooring_flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK

/datum/prototype/flooring/wax
	name = "wax floor"
	desc = "Soft wax sheets shaped into tile sheets. It's a little squishy, and leaves a waxy residue when touched."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "wax"
	damage_temperature = T0C+200
	build_type = /obj/item/stack/tile/wax
	flooring_flags = TURF_REMOVE_CROWBAR

/datum/prototype/flooring/honeycomb
	name = "honeycomb floor"
	desc = "A shallow layer of honeycomb. Some pods have been filled with honey and sealed over in wax, while others are vacant."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "honeycomb"
	has_damage_range = 6
	damage_temperature = T0C+200
	build_type = /obj/item/stack/tile/honeycomb
	flooring_flags = TURF_CAN_BREAK | TURF_IS_FRAGILE | TURF_REMOVE_SCREWDRIVER

/datum/prototype/flooring/crystal
	name = "crystal floor"
	icon = 'icons/turf/flooring/crystal.dmi'
	build_type = null
	flooring_flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_REMOVE_CROWBAR
	//color = "#00ffe1"

/datum/prototype/flooring/sandstone
	name = "sandstone floor"
	desc = "A tile made out of sand that has been compacted and hardened until it's nearly as dense as stone."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "sandstone"
	build_type = /obj/item/stack/tile/floor/sandstone
	flooring_flags = TURF_REMOVE_CROWBAR

/datum/prototype/flooring/bone
	name = "bone floor"
	desc = "A plate of solid bone etched into a subtle tiled pattern."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "bone"
	build_type = null
	flooring_flags = TURF_ACID_IMMUNE

/datum/prototype/flooring/bone/engraved
	name = "engraved bone floor"
	desc = "A plate of solid bone with intricate symbols and patterns engraved into it."
	icon_base = "bonecarve"

/datum/prototype/flooring/glass
	name = "glass flooring"
	desc = "A window to the world outside. Or the world beneath your feet, rather."
	icon = 'icons/turf/flooring/glass.dmi'
	icon_base = "glass"
	build_type = /obj/item/stack/material/glass
	build_cost = 1
	build_time = 30
	damage_temperature = T100C
	flooring_flags = TURF_REMOVE_CROWBAR | TURF_ACID_IMMUNE
	// can_engrave = FALSE
	// color = GLASS_COLOR
	mz_flags = MZ_MIMIC_DEFAULTS
	// footstep_type = /decl/footsteps/plating

/datum/prototype/flooring/glass/reinforced
	name = "reinforced glass flooring"
	desc = "Heavily reinforced with steel rods."
	icon = 'icons/turf/flooring/glass_reinf.dmi'
	icon_base = "glass_reinf"
	// build_type = /obj/item/stack/material/glass/reinforced
	build_cost = 2
	flooring_flags = TURF_REMOVE_WRENCH | TURF_ACID_IMMUNE

	mz_flags = MZ_MIMIC_DEFAULTS


// Roguetown

/datum/prototype/flooring/roguetown/wood
	name = "wooden floorboards"
	desc = "Old wooden floorboards."
	icon = 'icons/turf/flooring/roguetown/wood.dmi'
	icon_base = "wooden_floor"
	descriptor = "planks"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/wood1.ogg',
		'sound/effects/footstep/wood2.ogg',
		'sound/effects/footstep/wood3.ogg',
		'sound/effects/footstep/wood4.ogg',
		'sound/effects/footstep/wood5.ogg'))


/datum/prototype/flooring/roguetown/dark_wood
	name = "dark wooden floorboards"
	desc = "Old and dark wooden floorboards."
	icon = 'icons/turf/flooring/roguetown/wood.dmi'
	icon_base = "wooden_floor2"
	descriptor = "planks"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/wood1.ogg',
		'sound/effects/footstep/wood2.ogg',
		'sound/effects/footstep/wood3.ogg',
		'sound/effects/footstep/wood4.ogg',
		'sound/effects/footstep/wood5.ogg'))


/datum/prototype/flooring/roguetown/cobblestone
	name = "cobblestone"
	desc = "Hard and cold cobblestone flooring."
	icon = 'icons/turf/flooring/roguetown/cobble.dmi'
	icon_base = "cobblestone1"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))

/datum/prototype/flooring/roguetown/cobblestone2
	name = "cobblestone"
	desc = "Hard and cold cobblestone flooring."
	icon = 'icons/turf/flooring/roguetown/cobble.dmi'
	icon_base = "cobblestone2"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))

/datum/prototype/flooring/roguetown/cobblestone3
	name = "cobblestone"
	desc = "Hard and cold cobblestone flooring."
	icon = 'icons/turf/flooring/roguetown/cobble.dmi'
	icon_base = "cobblestone3"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))


/datum/prototype/flooring/roguetown/paving
	name = "paving"
	desc = "Paved floor crafted from brick."
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_base = "paving"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))


/datum/prototype/flooring/roguetown/mossy_stone_1
	name = "mossy stone"
	desc = "Stone flooring which has evidently seen better days."
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_base = "mossystone1"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))

/datum/prototype/flooring/roguetown/mossy_stone_2
	name = "mossy stone"
	desc = "Stone flooring which has evidently seen better days."
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_base = "mossystone2"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))

/datum/prototype/flooring/roguetown/mossy_stone_3
	name = "mossy stone"
	desc = "Stone flooring which has evidently seen better days."
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_base = "mossystone3"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))


/datum/prototype/flooring/roguetown/church_marble
	name = "marble flooring"
	desc = "Fine marble flooring, tainted by endless time."
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_base = "church_marble"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))

/datum/prototype/flooring/roguetown/church_brick
	name = "brick flooring"
	desc = "Fine brick flooring, tainted by endless time."
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_base = "church_brick"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))

/datum/prototype/flooring/roguetown/church
	name = "stone flooring"
	desc = "Fine stone flooring, tainted by endless time."
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_base = "church_marble"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))


/datum/prototype/flooring/roguetown/blocks
	name = "stone flooring"
	desc = "Stone flooring, shaped into blocked grids."
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_base = "blocks"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))


/datum/prototype/flooring/roguetown/greenstone
	name = "green stone flooring"
	desc = "Stone brick with a weathered green appeareance."
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_base = "greenstone"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))

/datum/prototype/flooring/roguetown/glyph1
	name = "green stone glyph"
	desc = "Stone brick with a weathered green appeareance. It appears to be painted."
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_base = "glyph1"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))

/datum/prototype/flooring/roguetown/glyph2
	name = "green stone glyph"
	desc = "Stone brick with a weathered green appeareance. It appears to be painted."
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_base = "glyph2"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))

/datum/prototype/flooring/roguetown/glyph3
	name = "green stone glyph"
	desc = "Stone brick with a weathered green appeareance. It appears to be painted."
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_base = "glyph3"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))

/datum/prototype/flooring/roguetown/glyph4
	name = "green stone glyph"
	desc = "Stone brick with a weathered green appeareance. It appears to be painted."
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_base = "glyph4"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))

/datum/prototype/flooring/roguetown/glyph5
	name = "green stone glyph"
	desc = "Stone brick with a weathered green appeareance. It appears to be painted."
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_base = "glyph5"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))

/datum/prototype/flooring/roguetown/glyph6
	name = "green stone glyph"
	desc = "Stone brick with a weathered green appeareance. It appears to be painted."
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_base = "glyph6"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))

/datum/prototype/flooring/roguetown/glyph7
	name = "green stone glyph"
	desc = "Stone brick with a weathered green appeareance. It appears to be painted."
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_base = "glyph7"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))

/datum/prototype/flooring/roguetown/glyph8
	name = "green stone glyph"
	desc = "Stone brick with a weathered green appeareance. It appears to be painted."
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_base = "glyph8"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))

/datum/prototype/flooring/roguetown/glyph9
	name = "green stone glyph"
	desc = "Stone brick with a weathered green appeareance. It appears to be painted."
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_base = "glyph9"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))


/datum/prototype/flooring/roguetown/tempered
	name = "tempered flooring"
	desc = "Floor carved from hardened magma."
	icon = 'icons/turf/flooring/roguetown/castle.dmi'
	icon_base = "lavafloor"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))


/datum/prototype/flooring/roguetown/grass
	name = "grass"
	desc = "Soft, earthy grass."
	icon = 'icons/turf/flooring/roguetown/grass.dmi'
	icon_base = "grass"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/grass1.ogg',
		'sound/effects/footstep/grass2.ogg',
		'sound/effects/footstep/grass3.ogg',
		'sound/effects/footstep/grass4.ogg'))

/datum/prototype/flooring/roguetown/grass_red
	name = "red grass"
	desc = "Soft, earthy red grass."
	icon = 'icons/turf/flooring/roguetown/grass.dmi'
	icon_base = "grass_red"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/grass1.ogg',
		'sound/effects/footstep/grass2.ogg',
		'sound/effects/footstep/grass3.ogg',
		'sound/effects/footstep/grass4.ogg'))

/datum/prototype/flooring/roguetown/grass_yellow
	name = "yellow grass"
	desc = "Soft, earthy yellow grass."
	icon = 'icons/turf/flooring/roguetown/grass.dmi'
	icon_base = "grass_yellow"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/grass1.ogg',
		'sound/effects/footstep/grass2.ogg',
		'sound/effects/footstep/grass3.ogg',
		'sound/effects/footstep/grass4.ogg'))

/datum/prototype/flooring/roguetown/grass_cold
	name = "grass"
	desc = "Soft, earthy and cold grass."
	icon = 'icons/turf/flooring/roguetown/grass.dmi'
	icon_base = "grass_cold"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/grass1.ogg',
		'sound/effects/footstep/grass2.ogg',
		'sound/effects/footstep/grass3.ogg',
		'sound/effects/footstep/grass4.ogg'))

/datum/prototype/flooring/roguetown/grass_odd
	name = "odd grass"
	desc = "Something about the grass beneath your feet feels wrong."
	icon = 'icons/turf/flooring/roguetown/grass.dmi'
	icon_base = "grass_odd"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/grass1.ogg',
		'sound/effects/footstep/grass2.ogg',
		'sound/effects/footstep/grass3.ogg',
		'sound/effects/footstep/grass4.ogg'))


/datum/prototype/flooring/roguetown/mud
	name = "mud"
	desc = "A mix of soft and hardened mud."
	icon = 'icons/turf/flooring/roguetown/mud.dmi'
	icon_base = "mud1"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/datum/prototype/flooring/roguetown/mud2
	name = "mud"
	desc = "A mix of soft and hardened mud."
	icon = 'icons/turf/flooring/roguetown/mud.dmi'
	icon_base = "mud2"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/datum/prototype/flooring/roguetown/mud3
	name = "mud"
	desc = "A mix of soft and hardened mud."
	icon = 'icons/turf/flooring/roguetown/mud.dmi'
	icon_base = "mud3"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/datum/prototype/flooring/roguetown/dirt
	name = "dirt"
	desc = "Soft dirt."
	icon = 'icons/turf/flooring/roguetown/dirt.dmi'
	icon_base = "dirt"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/datum/prototype/flooring/roguetown/rock
	name = "hardened rock"
	desc = "Hardened rock that rests beneath your feet."
	icon = 'icons/turf/flooring/roguetown/rock.dmi'
	icon_base = "rock"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))


