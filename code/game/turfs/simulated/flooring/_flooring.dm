GLOBAL_LIST_EMPTY(flooring_types)

/proc/populate_flooring_types()
	GLOB.flooring_types = list()
	for(var/flooring_path in GET_SINGLETON_TYPE_LIST(/singleton/flooring))
		GLOB.flooring_types["[flooring_path]"] = flooring_path

/proc/get_flooring_data(flooring_path)
	if(!GLOB.flooring_types)
		GLOB.flooring_types = list()
	if(!GLOB.flooring_types["[flooring_path]"])
		GLOB.flooring_types["[flooring_path]"] = flooring_path
	return GLOB.flooring_types["[flooring_path]"]

/**
 * State values:
 * [base_icon_state]: initial base icon_state without edges or corners.
 * if has_base_range is set, append 0-has_base_range ie.
 *   [base_icon_state][has_base_range]
 * [base_icon_state]_broken: damaged overlay.
 * if has_damage_range is set, append 0-damage_range for state ie.
 *   [base_icon_state]_broken[has_damage_range]
 * [base_icon_state]_edges: directional overlays for edges.
 * [base_icon_state]_corners: directional overlays for non-edge corners.
 */
/singleton/flooring
	var/name = "floor"
	var/desc
	var/icon
	var/base_icon_state
	var/color

	var/has_base_range
	var/has_damage_range
	var/has_burn_range
	var/damage_temperature
	var/apply_thermal_conductivity
	var/apply_heat_capacity

	var/decal_layer = DECAL_LAYER

	var/height = 0

	/// Unbuildable if not set. Must be /obj/item/stack.
	var/build_type
	/// Stack units.
	var/build_cost = 1
	/// BYOND ticks.
	var/build_time = 0

	var/descriptor = "tiles"
	var/flags
	var/can_paint
	/// key=species name, value = list of sounds.
	var/list/footstep_sounds = list()
	var/is_plating = FALSE

	/// Plating types, can be overridden.
	var/plating_type = null

	/// Resistance is subtracted from all incoming damage.
	// var/resistance = RESISTANCE_FRAGILE

	/// Damage the floor can take before being destroyed.
	// var/health = 50

	// var/removal_time = WORKTIME_FAST * 0.75

	//! Flooring Icon vars
	/**
	 * True/false only, optimisation.
	 * If true, all smoothing logic is entirely skipped.
	 */
	var/smooth_nothing = FALSE

	/**
	 *! The rest of these x_smooth vars use one of the following options
	 *? SMOOTH_NONE: Ignore all of type
	 *? SMOOTH_ALL: Smooth with all of type
	 *? SMOOTH_WHITELIST: Ignore all except types on this list
	 *? SMOOTH_BLACKLIST: Smooth with all except types on this list
	 *? SMOOTH_GREYLIST: Objects only: Use both lists
	 */

	/// How we smooth with other flooring.
	var/floor_smooth = SMOOTH_NONE
	/// Smooth with nothing except the contents of this list.
	var/list/flooring_whitelist = list()
	/// Smooth with everything except the contents of this list.
	var/list/flooring_blacklist = list()

	/// How we smooth with walls.
	var/wall_smooth = SMOOTH_NONE
	/// There are no lists for walls at this time.

	/**
	 * How we smooth with space and openspace tiles.
	 * There are no lists for spaces.
	 */
	var/space_smooth = SMOOTH_NONE

	/**
	 *	How we smooth with movable atoms
	 *	These are checked after the above turf based smoothing has been handled
	 *	SMOOTH_ALL or SMOOTH_NONE are treated the same here. Both of those will just ignore atoms
	 *	Using the white/blacklists will override what the turfs concluded, to force or deny smoothing
	 *
	 *	Movable atom lists are much more complex, to account for many possibilities
	 *	Each entry in a list, is itself a list consisting of three items:
	 *		Type: The typepath to allow/deny. This will be checked against istype, so all subtypes are included
	 *		Priority: Used when items in two opposite lists conflict. The one with the highest priority wins out.
	 *		Vars: An associative list of variables (varnames in text) and desired values
	 *			Code will look for the desired vars on the target item and only call it a match if all desired values match
	 *			This can be used, for example, to check that objects are dense and anchored
	 *			there are no safety checks on this, it will probably throw runtimes if you make typos
	 *
	 *	Common example:
	 *	Don't smooth with dense anchored objects except airlocks
	 *
	 *	smooth_movable_atom = SMOOTH_GREYLIST
	 *	movable_atom_blacklist = list(
	 *		list(/obj, list("density" = TRUE, "anchored" = TRUE), 1)
	 *		)
	 *	movable_atom_whitelist = list(
	 *	list(/obj/machinery/door/airlock, list(), 2)
	 *	)
	 *
	 */
	var/smooth_movable_atom = SMOOTH_NONE
	var/list/movable_atom_whitelist = list()
	var/list/movable_atom_blacklist = list()

/// Use this to apply or remove turf data when this flooring is removed.
/singleton/flooring/proc/on_remove()
	return

/singleton/flooring/proc/get_plating_type(turf/T)
	return plating_type

/singleton/flooring/proc/get_flooring_overlay(cache_key, base_icon_state, icon_dir = 0, external = FALSE)
	if(!GLOB.flooring_cache[cache_key])
		var/image/I = image(icon = icon, icon_state = base_icon_state, dir = icon_dir)
		I.turf_decal_layerise()

		//External overlays will be offset out of this tile
		if (external)
			if (icon_dir & NORTH)
				I.pixel_y = world.icon_size
			else if (icon_dir & SOUTH)
				I.pixel_y = -world.icon_size

			if (icon_dir & WEST)
				I.pixel_x = -world.icon_size
			else if (icon_dir & EAST)
				I.pixel_x = world.icon_size
		I.layer = decal_layer

		GLOB.flooring_cache[cache_key] = I
	return GLOB.flooring_cache[cache_key]

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
	base_icon_state = "grass"
	has_base_range = 3
	damage_temperature = T0C+80
	flags = TURF_HAS_EDGES | TURF_HAS_CORNERS | TURF_REMOVE_SHOVEL
	build_type = /obj/item/stack/tile/grass
	// can_engrave = FALSE
	floor_smooth = SMOOTH_NONE
	wall_smooth = SMOOTH_ALL
	space_smooth = SMOOTH_NONE
	decal_layer = ABOVE_WIRE_LAYER

/singleton/flooring/dirt
	name = "dirt"
	desc = "Extra dirty."
	icon = 'icons/turf/flooring/grass.dmi'
	base_icon_state = "dirt"
	has_base_range = 3
	damage_temperature = T0C+80
	// can_engrave = FALSE

/singleton/flooring/asteroid
	name = "coarse sand"
	desc = "Gritty and unpleasant."
	icon = 'icons/turf/flooring/asteroid.dmi'
	base_icon_state = "asteroid"
	flags = TURF_HAS_EDGES | TURF_REMOVE_SHOVEL
	build_type = null
	// can_engrave = FALSE

/singleton/flooring/snow
	name = "snow"
	desc = "A layer of many tiny bits of frozen water. It's hard to tell how deep it is."
	icon = 'icons/turf/snow_new.dmi'
	base_icon_state = "snow"
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
	base_icon_state = "gravsnow"
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
	base_icon_state = "snow"
	flags = TURF_HAS_EDGES

/singleton/flooring/snow/gravsnow2
	name = "gravsnow"
	icon = 'icons/turf/snow.dmi'
	base_icon_state = "gravsnow"

/singleton/flooring/snow/plating
	name = "snowy plating"
	desc = "Steel plating coated with a light layer of snow."
	base_icon_state = "snowyplating"
	flags = null

/singleton/flooring/snow/ice
	name = "ice"
	desc = "Looks slippery."
	base_icon_state = "ice"

/singleton/flooring/snow/plating/drift
	base_icon_state = "snowyplayingdrift"

/singleton/flooring/carpet
	name = "carpet"
	desc = "Comfy and fancy carpeting."
	icon = 'icons/turf/flooring/carpet.dmi'
	base_icon_state = "red"
	build_type = /obj/item/stack/tile/carpet
	damage_temperature = T0C+200
	flags = TURF_HAS_EDGES | TURF_HAS_CORNERS | TURF_REMOVE_CROWBAR | TURF_CAN_BURN
	floor_smooth = SMOOTH_NONE
	wall_smooth = SMOOTH_NONE
	space_smooth = SMOOTH_NONE
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/carpet1.ogg',
		'sound/effects/footstep/carpet2.ogg',
		'sound/effects/footstep/carpet3.ogg',
		'sound/effects/footstep/carpet4.ogg',
		'sound/effects/footstep/carpet5.ogg'))

/singleton/flooring/carpet/blue
	name = "blue carpet"
	base_icon_state = "blue1"
	// build_type = /obj/item/stack/tile/carpetblue
	build_type = /obj/item/stack/tile/carpet/blucarpet

/singleton/flooring/carpet/blue2
	name = "pale blue carpet"
	base_icon_state = "blue2"
	// build_type = /obj/item/stack/tile/carpetblue2
	build_type = /obj/item/stack/tile/carpet/sblucarpet

/singleton/flooring/carpet/blue3
	name = "sea blue carpet"
	base_icon_state = "blue3"
	// build_type = /obj/item/stack/tile/carpetblue3
	build_type = /obj/item/stack/tile/carpet/teal

/singleton/flooring/carpet/magenta
	name = "magenta carpet"
	base_icon_state = "purple"
	// build_type = /obj/item/stack/tile/carpetmagenta
	build_type = /obj/item/stack/tile/carpet/gaycarpet

/singleton/flooring/carpet/purple
	name = "purple carpet"
	base_icon_state = "purple"
	// build_type = /obj/item/stack/tile/carpetpurple
	build_type = /obj/item/stack/tile/carpet/purcarpet

/singleton/flooring/carpet/orange
	name = "orange carpet"
	base_icon_state = "orange"
	// build_type = /obj/item/stack/tile/carpetorange
	build_type = /obj/item/stack/tile/carpet/oracarpet

/singleton/flooring/carpet/green
	name = "green carpet"
	base_icon_state = "green"
	// build_type = /obj/item/stack/tile/carpetgreen

/singleton/flooring/carpet/brown
	name = "brown carpet"
	base_icon_state = "brown"
	// build_type = /obj/item/stack/tile/carpetred

//! Old Carpets
/singleton/flooring/carpet/bcarpet
	name = "black carpet"
	icon = 'icons/turf/flooring/carpet_old.dmi'
	base_icon_state = "bcarpet"
	build_type = /obj/item/stack/tile/carpet/bcarpet

/singleton/flooring/carpet/turcarpet
	name = "tur carpet"
	icon = 'icons/turf/flooring/carpet_old.dmi'
	base_icon_state = "turcarpet"
	build_type = /obj/item/stack/tile/carpet/turcarpet

/singleton/flooring/carpet/arcadecarpet
	name = "arcade carpet"
	icon = 'icons/turf/flooring/carpet_old.dmi'
	base_icon_state = "arcade"
	build_type = /obj/item/stack/tile/carpet/arcadecarpet

/singleton/flooring/tiling
	name = "floor"
	desc = "A solid, heavy set of flooring plates."
	icon = 'icons/turf/flooring/tiles.dmi'
	base_icon_state = "tiled"
	color = COLOR_DEFAULT_FLOOR
	has_damage_range = 4
	damage_temperature = T0C+1400
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK | TURF_CAN_BURN
	build_type = /obj/item/stack/tile/floor
	can_paint = 1
	footstep_sounds = list(
		"human" = list(
			'sound/effects/footstep/floor1.ogg',
			'sound/effects/footstep/floor2.ogg',
			'sound/effects/footstep/floor3.ogg',
			'sound/effects/footstep/floor4.ogg',
			'sound/effects/footstep/floor5.ogg',
		),
	)

/singleton/flooring/tiling/mono
	base_icon_state = "steel_monotile"
	build_type = null
	// build_type = /obj/item/stack/tile/mono

/singleton/flooring/tiling/mono/dark
	color = COLOR_DARK_GRAY
	build_type = null
	// build_type = /obj/item/stack/tile/mono/dark

/singleton/flooring/tiling/mono/white
	base_icon_state = "monotile_light"
	color = COLOR_VERY_LIGHT_GRAY
	build_type = null
	// build_type = /obj/item/stack/tile/mono/white

/singleton/flooring/tiling/white
	base_icon_state = "tiled_light"
	color = COLOR_VERY_LIGHT_GRAY
	build_type = /obj/item/stack/tile/floor/white

/singleton/flooring/tiling/dark
	color = COLOR_DARK_GRAY
	build_type = /obj/item/stack/tile/floor/dark

/singleton/flooring/tiling/dark/mono
	base_icon_state = "monotile"
	build_type = null

/singleton/flooring/tiling/tech
	icon = 'icons/turf/flooring/techfloor.dmi'
	base_icon_state = "techfloor_gray"
	build_type = /obj/item/stack/tile/floor/techgrey
	can_paint = null

/singleton/flooring/tiling/tech/grid
	base_icon_state = "techfloor_grid"
	build_type = /obj/item/stack/tile/floor/techgrid

/singleton/flooring/tiling/new_tile
	base_icon_state = "tile_full"
	build_type = null

/singleton/flooring/tiling/new_tile/cargo_one
	base_icon_state = "cargo_one_full"
	build_type = null

/singleton/flooring/tiling/new_tile/kafel
	base_icon_state = "kafel_full"
	build_type = null

/singleton/flooring/tiling/stone
	base_icon_state = "stone"
	build_type = null
	// build_type = /obj/item/stack/tile/stone

/singleton/flooring/tiling/new_tile/techmaint
	base_icon_state = "techmaint"
	build_type = null
	// build_type = /obj/item/stack/tile/techmaint

/singleton/flooring/tiling/new_tile/monofloor
	base_icon_state = "monofloor"
	color = COLOR_GUNMETAL

/singleton/flooring/tiling/new_tile/monotile
	base_icon_state = "steel_monotile"

/singleton/flooring/tiling/new_tile/monowhite
	base_icon_state = "monotile_light"

/singleton/flooring/tiling/new_tile/grid
	base_icon_state = "grid"
	color = COLOR_GUNMETAL
	build_type = null
	// build_type = /obj/item/stack/tile/grid

/singleton/flooring/tiling/new_tile/steel_grid
	base_icon_state = "steelgrid"
	build_type = null
	// build_type = /obj/item/stack/tile/grid

/singleton/flooring/tiling/new_tile/steel_ridged
	base_icon_state = "ridged"
	color = COLOR_GUNMETAL
	build_type = null
	// build_type = /obj/item/stack/tile/ridge

/singleton/flooring/linoleum
	name = "linoleum"
	desc = "It's like the 2390's all over again."
	icon = 'icons/turf/flooring/linoleum.dmi'
	base_icon_state = "lino"
	color = null
	can_paint = 1
	build_type = /obj/item/stack/tile/linoleum
	flags = TURF_REMOVE_SCREWDRIVER

/singleton/flooring/tiling/red
	name = "floor"
	base_icon_state = "white"
	color = null
	has_damage_range = null
	flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor/red

/singleton/flooring/tiling/steel
	name = "floor"
	base_icon_state = "tiled"
	color = COLOR_DEFAULT_FLOOR
	build_type = /obj/item/stack/tile/floor/steel

/singleton/flooring/tiling/steel_dirty
	name = "floor"
	base_icon_state = "steel_dirty"
	color = null
	build_type = /obj/item/stack/tile/floor/steel_dirty

/singleton/flooring/tiling/asteroidfloor
	name = "floor"
	base_icon_state = "asteroidfloor"
	has_damage_range = null
	color = null
	flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor/steel

/singleton/flooring/tiling/yellow
	name = "floor"
	base_icon_state = "white"
	has_damage_range = null
	flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor/yellow

/singleton/flooring/tiling/hydro
	name = "floor"
	base_icon_state = "hydrofloor"
	build_type = /obj/item/stack/tile/floor/steel

/singleton/flooring/tiling/neutral
	name = "floor"
	base_icon_state = "neutral"
	build_type = /obj/item/stack/tile/floor/steel

/singleton/flooring/tiling/freezer
	name = "floor"
	desc = "Don't slip."
	base_icon_state = "freezer"
	build_type = /obj/item/stack/tile/floor/freezer

/singleton/flooring/wmarble
	name = "marble floor"
	desc = "Very regal white marble flooring."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "lightmarble"
	build_type = /obj/item/stack/tile/wmarble
	flags = TURF_REMOVE_CROWBAR

/singleton/flooring/bmarble
	name = "marble floor"
	desc = "Very regal black marble flooring."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "darkmarble"
	build_type = /obj/item/stack/tile/bmarble
	flags = TURF_REMOVE_CROWBAR

/singleton/flooring/bananium
	name = "bananium floor"
	desc = "Have you ever seen a clown frown?"
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "bananium"
	build_type = /obj/item/stack/tile/bananium
	flags = TURF_REMOVE_CROWBAR

/singleton/flooring/silencium
	name = "silencium floor"
	desc = "Surprisingly, doesn't mask your footsteps."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "silencium"
	build_type = /obj/item/stack/tile/silencium
	flags = TURF_REMOVE_CROWBAR

/singleton/flooring/silencium
	name = "silencium floor"
	desc = "Surprisingly, doesn't mask your footsteps."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "silencium"
	build_type = /obj/item/stack/tile/silencium
	flags = TURF_REMOVE_CROWBAR

/singleton/flooring/plasteel
	name = "plasteel floor"
	desc = "Sturdy metal flooring. Almost certainly a waste."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "plasteel"
	build_type = /obj/item/stack/tile/plasteel
	flags = TURF_REMOVE_CROWBAR

/singleton/flooring/durasteel
	name = "durasteel floor"
	desc = "Incredibly sturdy metal flooring. Definitely a waste."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "durasteel"
	build_type = /obj/item/stack/tile/durasteel
	flags = TURF_REMOVE_CROWBAR

/singleton/flooring/silver
	name = "silver floor"
	desc = "This opulent flooring reminds you of the ocean. Almost certainly a waste."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "silver"
	build_type = /obj/item/stack/tile/silver
	flags = TURF_REMOVE_CROWBAR

/singleton/flooring/gold
	name = "gold floor"
	desc = "This richly tooled flooring makes you feel powerful."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "gold"
	build_type = /obj/item/stack/tile/gold
	flags = TURF_REMOVE_CROWBAR

/singleton/flooring/phoron
	name = "phoron floor"
	desc = "Although stable for now, this solid phoron flooring radiates danger."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "phoron"
	build_type = /obj/item/stack/tile/phoron
	flags = TURF_REMOVE_CROWBAR

/singleton/flooring/uranium
	name = "uranium floor"
	desc = "This flooring literally radiates danger."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "uranium"
	build_type = /obj/item/stack/tile/uranium
	flags = TURF_REMOVE_CROWBAR

/singleton/flooring/diamond
	name = "diamond floor"
	desc = "This flooring proves that you are a king among peasants. It's virtually impossible to scuff."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "diamond"
	build_type = /obj/item/stack/tile/diamond
	flags = TURF_REMOVE_CROWBAR

/singleton/flooring/brass
	name = "brass floor"
	desc = "There's something strange about this tile. If you listen closely, it sounds like it's ticking."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "clockwork_floor"
	build_type = /obj/item/stack/tile/brass
	flags = TURF_REMOVE_CROWBAR

/singleton/flooring/wood
	name = "wooden floor"
	desc = "Polished wood planks."
	icon = 'icons/turf/flooring/wood.dmi'
	base_icon_state = "wood"
	has_damage_range = 6
	damage_temperature = T0C+200
	descriptor = "planks"
	build_type = /obj/item/stack/tile/wood
	flags = TURF_CAN_BREAK | TURF_IS_FRAGILE | TURF_REMOVE_SCREWDRIVER
	color = WOOD_COLOR_GENERIC
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/wood1.ogg',
		'sound/effects/footstep/wood2.ogg',
		'sound/effects/footstep/wood3.ogg',
		'sound/effects/footstep/wood4.ogg',
		'sound/effects/footstep/wood5.ogg'))

/singleton/flooring/wood/mahogany
	name = "mahogany wood floor"
	color = WOOD_COLOR_RICH
	build_type = /obj/item/stack/tile/wood/mahogany

/singleton/flooring/wood/maple
	name = "maple wood floor"
	color = WOOD_COLOR_PALE
	build_type = /obj/item/stack/tile/wood/maple

/singleton/flooring/wood/ebony
	name = "ebony wood floor"
	color = WOOD_COLOR_BLACK
	build_type = /obj/item/stack/tile/wood/ebony

/singleton/flooring/wood/walnut
	name = "walnut wood floor"
	color = WOOD_COLOR_CHOCOLATE
	build_type = /obj/item/stack/tile/wood/walnut

/singleton/flooring/wood/bamboo
	name = "bamboo wood floor"
	color = WOOD_COLOR_PALE2
	build_type = /obj/item/stack/tile/wood/bamboo

/singleton/flooring/wood/yew
	name = "bamboo wood floor"
	color = WOOD_COLOR_YELLOW
	build_type = /obj/item/stack/tile/wood/yew

/singleton/flooring/wood/sif
	name = "alien wood floor"
	desc = "Polished alien wood planks."
	build_type = /obj/item/stack/tile/wood/sif
	color = WOOD_COLOR_SIF

/singleton/flooring/reinforced
	name = "reinforced floor"
	desc = "Heavily reinforced with steel rods."
	icon = 'icons/turf/flooring/tiles.dmi'
	base_icon_state = "reinforced"
	flags = TURF_REMOVE_WRENCH | TURF_ACID_IMMUNE
	build_type = /obj/item/stack/rods
	build_cost = 2
	build_time = 30
	apply_thermal_conductivity = 0.025
	apply_heat_capacity = 325000
	can_paint = 1

/singleton/flooring/reinforced/circuit
	name = "processing strata"
	icon = 'icons/turf/flooring/circuit.dmi'
	base_icon_state = "bcircuit"
	build_type = null
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_REMOVE_CROWBAR
	can_paint = 1

/singleton/flooring/reinforced/circuit/green
	name = "processing strata"
	base_icon_state = "gcircuit"

/singleton/flooring/reinforced/cult
	name = "engraved floor"
	desc = "Unsettling whispers waver from the surface..."
	icon = 'icons/turf/flooring/cult.dmi'
	base_icon_state = "cult"
	build_type = null
	has_damage_range = 6
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK
	can_paint = null

/singleton/flooring/outdoors/lavaland
	name = "ash sand"
	desc = "Soft and ominous."
	icon = 'icons/turf/flooring/asteroid.dmi'
	base_icon_state = "asteroid"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/singleton/flooring/outdoors/classd
	name = "irradiated sand"
	desc = "It literally glows in the dark."
	icon = 'icons/turf/flooring/asteroid.dmi'
	base_icon_state = "asteroid"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/singleton/flooring/outdoors/dirt
	name = "dirt"
	icon = 'icons/turf/outdoors.dmi'
	base_icon_state = "dirt-dark"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))


/singleton/flooring/outdoors/grass
	name = "grass"
	icon = 'icons/turf/outdoors.dmi'
	base_icon_state = "grass"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/grass1.ogg',
		'sound/effects/footstep/grass2.ogg',
		'sound/effects/footstep/grass3.ogg',
		'sound/effects/footstep/grass4.ogg'))

/singleton/flooring/outdoors/grass/sif
	name = "growth"
	icon = 'icons/turf/outdoors.dmi'
	base_icon_state = "grass_sif"

/singleton/flooring/water
	name = "water"
	desc = "Water is wet, gosh, who knew!"
	icon = 'icons/turf/outdoors.dmi'
	base_icon_state = "seashallow"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/water1.ogg',
		'sound/effects/footstep/water2.ogg',
		'sound/effects/footstep/water3.ogg',
		'sound/effects/footstep/water4.ogg'))

/singleton/flooring/outdoors/beach
	name = "beach"
	icon = 'icons/turf/outdoors.dmi'
	base_icon_state = "sand"
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
	base_icon_state = "flesh_floor"

/singleton/flooring/outdoors/beach/sand/desert
	name = "sand"
	icon = 'icons/turf/outdoors.dmi'
	base_icon_state = "sand"
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
	base_icon_state = "plating"
	build_type = null
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK
	can_paint = null

/singleton/flooring/wax
	name = "wax floor"
	desc = "Soft wax sheets shaped into tile sheets. It's a little squishy, and leaves a waxy residue when touched."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "wax"
	damage_temperature = T0C+200
	build_type = /obj/item/stack/tile/wax
	flags = TURF_REMOVE_CROWBAR

/singleton/flooring/honeycomb
	name = "honeycomb floor"
	desc = "A shallow layer of honeycomb. Some pods have been filled with honey and sealed over in wax, while others are vacant."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "honeycomb"
	has_damage_range = 6
	damage_temperature = T0C+200
	build_type = /obj/item/stack/tile/honeycomb
	flags = TURF_CAN_BREAK | TURF_IS_FRAGILE | TURF_REMOVE_SCREWDRIVER

/singleton/flooring/pool
	name = "pool floor"
	desc = "Sunken flooring designed to hold liquids."
	icon = 'icons/turf/flooring/pool.dmi'
	base_icon_state = "pool"
	// build_type = /obj/item/stack/tile/pool
	flags = TURF_HAS_CORNERS | TURF_HAS_INNER_CORNERS | TURF_REMOVE_CROWBAR
	// footstep_type = /singleton/footsteps/tiles
	floor_smooth = SMOOTH_NONE
	wall_smooth = SMOOTH_NONE
	space_smooth = SMOOTH_NONE
	// height = -FLUID_OVER_MOB_HEAD * 2
