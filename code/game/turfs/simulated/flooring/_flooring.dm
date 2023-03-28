var/list/flooring_types

/proc/populate_flooring_types()
	flooring_types = list()
	for (var/flooring_path in typesof(/singleton/flooring))
		flooring_types["[flooring_path]"] = new flooring_path

/proc/get_flooring_data(var/flooring_path)
	if(!flooring_types)
		flooring_types = list()
	if(!flooring_types["[flooring_path]"])
		flooring_types["[flooring_path]"] = new flooring_path
	return flooring_types["[flooring_path]"]

// State values:
// [icon_base]: initial base icon_state without edges or corners.
// if has_base_range is set, append 0-has_base_range ie.
//   [icon_base][has_base_range]
// [icon_base]_broken: damaged overlay.
// if has_damage_range is set, append 0-damage_range for state ie.
//   [icon_base]_broken[has_damage_range]
// [icon_base]_edges: directional overlays for edges.
// [icon_base]_corners: directional overlays for non-edge corners.

/singleton/flooring
	var/name = "floor"
	var/desc
	var/icon
	var/icon_base

	var/has_base_range
	var/has_damage_range
	var/has_burn_range
	var/damage_temperature
	var/apply_thermal_conductivity
	var/apply_heat_capacity

	var/build_type      // Unbuildable if not set. Must be /obj/item/stack.
	var/build_cost = 1  // Stack units.
	var/build_time = 0  // BYOND ticks.

	var/descriptor = "tiles"
	var/flooring_flags
	var/can_paint = TRUE
	var/list/footstep_sounds = list() // key=species name, value = list of soundss
	var/is_plating = FALSE
	var/list/flooring_cache = list() // Cached overlays for our edges and corners and junk

	//Plating types, can be overridden
	var/plating_type = null

	//Resistance is subtracted from all incoming damage
	//var/resistance = RESISTANCE_FRAGILE

	//Damage the floor can take before being destroyed
	//var/health = 50

	//var/removal_time = WORKTIME_FAST * 0.75

	//Flooring Icon vars
	var/smooth_nothing = FALSE //True/false only, optimisation
	//If true, all smoothing logic is entirely skipped

	//The rest of these x_smooth vars use one of the following options
	//SMOOTH_NONE: Ignore all of type
	//SMOOTH_ALL: Smooth with all of type
	//SMOOTH_WHITELIST: Ignore all except types on this list
	//SMOOTH_BLACKLIST: Smooth with all except types on this list
	//SMOOTH_GREYLIST: Objects only: Use both lists

	//How we smooth with other flooring
	var/floor_smooth = SMOOTH_NONE
	var/list/flooring_whitelist = list() //Smooth with nothing except the contents of this list
	var/list/flooring_blacklist = list() //Smooth with everything except the contents of this list

	//How we smooth with walls
	var/wall_smooth = SMOOTH_NONE
	//There are no lists for walls at this time

	//How we smooth with space and openspace tiles
	var/space_smooth = SMOOTH_NONE
	//There are no lists for spaces

	/*
	How we smooth with movable atoms
	These are checked after the above turf based smoothing has been handled
	SMOOTH_ALL or SMOOTH_NONE are treated the same here. Both of those will just ignore atoms
	Using the white/blacklists will override what the turfs concluded, to force or deny smoothing

	Movable atom lists are much more complex, to account for many possibilities
	Each entry in a list, is itself a list consisting of three items:
		Type: The typepath to allow/deny. This will be checked against istype, so all subtypes are included
		Priority: Used when items in two opposite lists conflict. The one with the highest priority wins out.
		Vars: An associative list of variables (varnames in text) and desired values
			Code will look for the desired vars on the target item and only call it a match if all desired values match
			This can be used, for example, to check that objects are dense and anchored
			there are no safety checks on this, it will probably throw runtimes if you make typos

	Common example:
	Don't smooth with dense anchored objects except airlocks

	smooth_movable_atom = SMOOTH_GREYLIST
	movable_atom_blacklist = list(
		list(/obj, list("density" = TRUE, "anchored" = TRUE), 1)
		)
	movable_atom_whitelist = list(
	list(/obj/machinery/door/airlock, list(), 2)
	)

	*/
	var/smooth_movable_atom = SMOOTH_NONE
	var/list/movable_atom_whitelist = list()
	var/list/movable_atom_blacklist = list()

	/// Same z flags used for turfs, i.e ZMIMIC_DEFAULT etc.
	var/mz_flags = MZ_ATMOS_UP | MZ_OPEN_UP

/singleton/flooring/proc/get_plating_type(turf/T)
	return plating_type

/singleton/flooring/proc/get_flooring_overlay(cache_key, base_state, icon_dir = 0, layer = FLOOR_DECAL_LAYER)
	if(!flooring_cache[cache_key])
		var/image/I = image(icon = icon, icon_state = base_state, dir = icon_dir)
		I.layer = layer
		flooring_cache[cache_key] = I
	return flooring_cache[cache_key]

/singleton/flooring/proc/drop_product(atom/A)
	if(ispath(build_type, /obj/item/stack))
		new build_type(A, build_cost)
	else
		for(var/i in 1 to min(build_cost, 50))
			new build_type(A)

/singleton/flooring/grass
	name = "grass"
	desc = "Do they smoke grass out in space, Bowie? Or do they smoke AstroTurf?"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_base = "grass"
	has_base_range = 3
	damage_temperature = T0C+80
	flooring_flags = TURF_HAS_EDGES | TURF_REMOVE_SHOVEL
	build_type = /obj/item/stack/tile/grass

/singleton/flooring/asteroid
	name = "coarse sand"
	desc = "Gritty and unpleasant."
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_base = "asteroid"
	flooring_flags = TURF_HAS_EDGES | TURF_REMOVE_SHOVEL
	build_type = null

/singleton/flooring/snow
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

/singleton/flooring/snow/gravsnow
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

/singleton/flooring/snow/snow2
	name = "snow"
	desc = "A layer of many tiny bits of frozen water. It's hard to tell how deep it is."
	icon = 'icons/turf/snow.dmi'
	icon_base = "snow"
	flooring_flags = TURF_HAS_EDGES

/singleton/flooring/snow/gravsnow2
	name = "gravsnow"
	icon = 'icons/turf/snow.dmi'
	icon_base = "gravsnow"

/singleton/flooring/snow/plating
	name = "snowy plating"
	desc = "Steel plating coated with a light layer of snow."
	icon_base = "snowyplating"
	flooring_flags = null

/singleton/flooring/snow/ice
	name = "ice"
	desc = "Looks slippery."
	icon_base = "ice"

/singleton/flooring/snow/plating/drift
	icon_base = "snowyplayingdrift"

/singleton/flooring/carpet
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

/singleton/flooring/carpet/bcarpet
	name = "black carpet"
	icon_base = "bcarpet"
	build_type = /obj/item/stack/tile/carpet/bcarpet

/singleton/flooring/carpet/blucarpet
	name = "blue carpet"
	icon_base = "blucarpet"
	build_type = /obj/item/stack/tile/carpet/blucarpet

/singleton/flooring/carpet/turcarpet
	name = "tur carpet"
	icon_base = "turcarpet"
	build_type = /obj/item/stack/tile/carpet/turcarpet

/singleton/flooring/carpet/sblucarpet
	name = "silver blue carpet"
	icon_base = "sblucarpet"
	build_type = /obj/item/stack/tile/carpet/sblucarpet

/singleton/flooring/carpet/gaycarpet
	name = "clown carpet"
	icon_base = "gaycarpet"
	build_type = /obj/item/stack/tile/carpet/gaycarpet

/singleton/flooring/carpet/purcarpet
	name = "purple carpet"
	icon_base = "purcarpet"
	build_type = /obj/item/stack/tile/carpet/purcarpet

/singleton/flooring/carpet/oracarpet
	name = "orange carpet"
	icon_base = "oracarpet"
	build_type = /obj/item/stack/tile/carpet/oracarpet

/singleton/flooring/carpet/tealcarpet
	name = "teal carpet"
	icon_base = "tealcarpet"
	build_type = /obj/item/stack/tile/carpet/teal

/singleton/flooring/carpet/arcadecarpet
	name = "arcade carpet"
	icon_base = "arcade"
	build_type = /obj/item/stack/tile/carpet/arcadecarpet

/singleton/flooring/tiling
	name = "floor"
	desc = "Scuffed from the passage of countless greyshirts."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "tiled"
	has_damage_range = 2
	damage_temperature = T0C+1400
	flooring_flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK | TURF_CAN_BURN
	build_type = /obj/item/stack/tile/floor
	can_paint = 1
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))

/singleton/flooring/tiling/tech
	desc = "Scuffed from the passage of countless greyshirts."
	icon = 'icons/turf/flooring/techfloor.dmi'
	icon_base = "techfloor_gray"
	build_type = /obj/item/stack/tile/floor/techgrey
	can_paint = null

/singleton/flooring/tiling/tech/grid
	icon_base = "techfloor_grid"
	build_type = /obj/item/stack/tile/floor/techgrid

/singleton/flooring/tiling/new_tile
	name = "floor"
	icon_base = "tile_full"
	flooring_flags = TURF_CAN_BREAK | TURF_CAN_BURN | TURF_IS_FRAGILE
	build_type = null

/singleton/flooring/tiling/new_tile/cargo_one
	icon_base = "cargo_one_full"

/singleton/flooring/tiling/new_tile/kafel
	icon_base = "kafel_full"

/singleton/flooring/tiling/new_tile/techmaint
	icon_base = "techmaint"

/singleton/flooring/tiling/new_tile/monofloor
	icon_base = "monofloor"

/singleton/flooring/tiling/new_tile/monotile
	icon_base = "monotile"

/singleton/flooring/tiling/new_tile/monowhite
	icon_base = "monowhite"

/singleton/flooring/tiling/new_tile/steel_grid
	icon_base = "steel_grid"

/singleton/flooring/tiling/new_tile/steel_ridged
	icon_base = "steel_ridged"

/singleton/flooring/linoleum
	name = "linoleum"
	desc = "It's like the 2390's all over again."
	icon = 'icons/turf/flooring/linoleum.dmi'
	icon_base = "lino"
	can_paint = 1
	build_type = /obj/item/stack/tile/linoleum
	flooring_flags = TURF_REMOVE_SCREWDRIVER

/singleton/flooring/tiling/red
	name = "floor"
	icon_base = "white"
	has_damage_range = null
	flooring_flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor/red

/singleton/flooring/tiling/steel
	name = "floor"
	icon_base = "steel"
	build_type = /obj/item/stack/tile/floor/steel

/singleton/flooring/tiling/steel_dirty
	name = "floor"
	icon_base = "steel_dirty"
	build_type = /obj/item/stack/tile/floor/steel_dirty

/singleton/flooring/tiling/asteroidfloor
	name = "floor"
	icon_base = "asteroidfloor"
	has_damage_range = null
	flooring_flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor/steel

/singleton/flooring/tiling/white
	name = "floor"
	desc = "How sterile."
	icon_base = "white"
	build_type = /obj/item/stack/tile/floor/white

/singleton/flooring/tiling/yellow
	name = "floor"
	icon_base = "white"
	has_damage_range = null
	flooring_flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor/yellow

/singleton/flooring/tiling/dark
	name = "floor"
	desc = "How ominous."
	icon_base = "dark"
	has_damage_range = null
	flooring_flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor/dark

/singleton/flooring/tiling/hydro
	name = "floor"
	icon_base = "hydrofloor"
	build_type = /obj/item/stack/tile/floor/steel

/singleton/flooring/tiling/neutral
	name = "floor"
	icon_base = "neutral"
	build_type = /obj/item/stack/tile/floor/steel

/singleton/flooring/tiling/freezer
	name = "floor"
	desc = "Don't slip."
	icon_base = "freezer"
	build_type = /obj/item/stack/tile/floor/freezer

/singleton/flooring/wmarble
	name = "marble floor"
	desc = "Very regal white marble flooring."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "lightmarble"
	build_type = /obj/item/stack/tile/wmarble
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/bmarble
	name = "marble floor"
	desc = "Very regal black marble flooring."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "darkmarble"
	build_type = /obj/item/stack/tile/bmarble
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/bananium
	name = "bananium floor"
	desc = "Have you ever seen a clown frown?"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "bananium"
	build_type = /obj/item/stack/tile/bananium
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/silencium
	name = "silencium floor"
	desc = "Surprisingly, doesn't mask your footsteps."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "silencium"
	build_type = /obj/item/stack/tile/silencium
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/silencium
	name = "silencium floor"
	desc = "Surprisingly, doesn't mask your footsteps."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "silencium"
	build_type = /obj/item/stack/tile/silencium
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/plasteel
	name = "plasteel floor"
	desc = "Sturdy metal flooring. Almost certainly a waste."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "plasteel"
	build_type = /obj/item/stack/tile/plasteel
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/durasteel
	name = "durasteel floor"
	desc = "Incredibly sturdy metal flooring. Definitely a waste."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "durasteel"
	build_type = /obj/item/stack/tile/durasteel
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/silver
	name = "silver floor"
	desc = "This opulent flooring reminds you of the ocean. Almost certainly a waste."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "silver"
	build_type = /obj/item/stack/tile/silver
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/gold
	name = "gold floor"
	desc = "This richly tooled flooring makes you feel powerful."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "gold"
	build_type = /obj/item/stack/tile/gold
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/phoron
	name = "phoron floor"
	desc = "Although stable for now, this solid phoron flooring radiates danger."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "phoron"
	build_type = /obj/item/stack/tile/phoron
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/uranium
	name = "uranium floor"
	desc = "This flooring literally radiates danger."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "uranium"
	build_type = /obj/item/stack/tile/uranium
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/diamond
	name = "diamond floor"
	desc = "This flooring proves that you are a king among peasants. It's virtually impossible to scuff."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "diamond"
	build_type = /obj/item/stack/tile/diamond
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/brass
	name = "brass floor"
	desc = "There's something strange about this tile. If you listen closely, it sounds like it's ticking."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "clockwork_floor"
	build_type = /obj/item/stack/tile/brass
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/wood
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

/singleton/flooring/wood/sif
	name = "alien wooden floor"
	desc = "Polished alien wood planks."
	icon_base = "sifwood"
	build_type = /obj/item/stack/tile/wood/sif

/singleton/flooring/reinforced
	name = "reinforced floor"
	desc = "Heavily reinforced with steel rods."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "reinforced"
	flooring_flags = TURF_REMOVE_WRENCH | TURF_ACID_IMMUNE
	build_type = /obj/item/stack/rods
	build_cost = 2
	build_time = 30
	apply_thermal_conductivity = 0.025
	apply_heat_capacity = 325000
	can_paint = 1

/singleton/flooring/reinforced/circuit
	name = "processing strata"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_base = "bcircuit"
	build_type = null
	flooring_flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_REMOVE_CROWBAR
	can_paint = 1

/singleton/flooring/reinforced/circuit/green
	name = "processing strata"
	icon_base = "gcircuit"

/singleton/flooring/reinforced/cult
	name = "engraved floor"
	desc = "Unsettling whispers waver from the surface..."
	icon = 'icons/turf/flooring/cult.dmi'
	icon_base = "cult"
	build_type = null
	has_damage_range = 6
	flooring_flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK
	can_paint = null

/singleton/flooring/outdoors/lavaland
	name = "ash sand"
	desc = "Soft and ominous."
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_base = "asteroid"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/singleton/flooring/outdoors/classd
	name = "irradiated sand"
	desc = "It literally glows in the dark."
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_base = "asteroid"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/singleton/flooring/outdoors/dirt
	name = "dirt"
	icon = 'icons/turf/outdoors.dmi'
	icon_base = "dirt-dark"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))


/singleton/flooring/outdoors/grass
	name = "grass"
	icon = 'icons/turf/outdoors.dmi'
	icon_base = "grass"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/grass1.ogg',
		'sound/effects/footstep/grass2.ogg',
		'sound/effects/footstep/grass3.ogg',
		'sound/effects/footstep/grass4.ogg'))

/singleton/flooring/outdoors/grass/sif
	name = "growth"
	icon = 'icons/turf/outdoors.dmi'
	icon_base = "grass_sif"

/singleton/flooring/water
	name = "water"
	desc = "Water is wet, gosh, who knew!"
	icon = 'icons/turf/outdoors.dmi'
	icon_base = "seashallow"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/water1.ogg',
		'sound/effects/footstep/water2.ogg',
		'sound/effects/footstep/water3.ogg',
		'sound/effects/footstep/water4.ogg'))

/singleton/flooring/outdoors/beach
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
	initial_flooring = /singleton/flooring/flesh

/turf/simulated/floor/flesh/colour
	icon_state = "c_flesh_floor"
	initial_flooring = /singleton/flooring/flesh

/turf/simulated/floor/flesh/attackby()
	return

/singleton/flooring/flesh
	name = "flesh"
	desc = "This slick flesh ripples and squishes under your touch"
	icon = 'icons/turf/stomach_vr.dmi'
	icon_base = "flesh_floor"

/singleton/flooring/outdoors/beach/sand/desert
	name = "sand"
	icon = 'icons/turf/outdoors.dmi'
	icon_base = "sand"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))
/turf/simulated/floor/tiled/freezer/cold
	temperature = T0C - 5

/singleton/flooring/trap
	name = "suspicious flooring"
	desc = "There's something off about this tile."
	icon = 'icons/turf/flooring/plating.dmi'
	icon_base = "plating"
	build_type = null
	flooring_flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK
	can_paint = null

/singleton/flooring/wax
	name = "wax floor"
	desc = "Soft wax sheets shaped into tile sheets. It's a little squishy, and leaves a waxy residue when touched."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "wax"
	damage_temperature = T0C+200
	build_type = /obj/item/stack/tile/wax
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/honeycomb
	name = "honeycomb floor"
	desc = "A shallow layer of honeycomb. Some pods have been filled with honey and sealed over in wax, while others are vacant."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "honeycomb"
	has_damage_range = 6
	damage_temperature = T0C+200
	build_type = /obj/item/stack/tile/honeycomb
	flooring_flags = TURF_CAN_BREAK | TURF_IS_FRAGILE | TURF_REMOVE_SCREWDRIVER

/singleton/flooring/crystal
	name = "crystal floor"
	icon = 'icons/turf/flooring/crystal.dmi'
	build_type = null
	flooring_flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_REMOVE_CROWBAR
	//color = "#00ffe1"

/singleton/flooring/sandstone
	name = "sandstone floor"
	desc = "A tile made out of sand that has been compacted and hardened until it's nearly as dense as stone."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "sandstone"
	build_type = /obj/item/stack/tile/floor/sandstone
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/bone
	name = "bone floor"
	desc = "A plate of solid bone etched into a subtle tiled pattern."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "bone"
	build_type = null
	flooring_flags = TURF_ACID_IMMUNE

/singleton/flooring/bone/engraved
	name = "engraved bone floor"
	desc = "A plate of solid bone with intricate symbols and patterns engraved into it."
	icon_base = "bonecarve"
