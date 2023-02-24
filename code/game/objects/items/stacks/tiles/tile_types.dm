/* Diffrent misc types of tiles
 * Contains:
 *		Prototype
 *		Grass
 *		Wood
 *		Carpet
 * 		Blue Carpet
 *		Linoleum
 *
 * Put your stuff in fifty_stacks_tiles.dm as well.
 */

/obj/item/stack/tile
	name = "tile"
	singular_name = "tile"
	desc = "A non-descript floor tile"
	w_class = ITEMSIZE_NORMAL
	max_amount = 60
	drop_sound = 'sound/items/drop/axe.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'

/obj/item/stack/tile/Initialize(mapload, new_amount, merge)
	. = ..()
	pixel_x = rand(-7, 7)
	pixel_y = rand(-7, 7)

/*
 * Grass
 */
/obj/item/stack/tile/grass
	name = "grass tile"
	singular_name = "grass floor tile"
	desc = "A patch of grass like they often use on golf courses."
	icon_state = "tile_grass"
	force = 1.0
	throw_force = 1.0
	throw_speed = 5
	throw_range = 20
	origin_tech = list(TECH_BIO = 1)
	no_variants = FALSE
	drop_sound = 'sound/items/drop/herb.ogg'
	pickup_sound = 'sound/items/pickup/herb.ogg'

/obj/item/stack/tile/grass/Initialize(mapload, new_amount, merge)
	. = ..()
	recipes = grass_recipes
	update_icon()

var/global/list/datum/stack_recipe/grass_recipes = list( \
	new/datum/stack_recipe("bush", /obj/structure/flora/ausbushes, 1, one_per_turf = 0, on_floor = 1),
	new/datum/stack_recipe("reeds", /obj/structure/flora/ausbushes/reedbush, 1, one_per_turf = 0, on_floor = 1),
	new/datum/stack_recipe("leafy bush", /obj/structure/flora/ausbushes/leafybush, 1, one_per_turf = 0, on_floor = 1),
	new/datum/stack_recipe("sparse bush", /obj/structure/flora/ausbushes/palebush, 1, one_per_turf = 0, on_floor = 1),
	new/datum/stack_recipe("stalks", /obj/structure/flora/ausbushes/stalkybush, 1, one_per_turf = 0, on_floor = 1),
	new/datum/stack_recipe("ferns", /obj/structure/flora/ausbushes/fernybush, 1, one_per_turf = 0, on_floor = 1),
	new/datum/stack_recipe("sapling", /obj/structure/flora/ausbushes/sunnybush, 1, one_per_turf = 0, on_floor = 1),
	new/datum/stack_recipe("leafy sapling", /obj/structure/flora/ausbushes/genericbush, 1, one_per_turf = 0, on_floor = 1),
	new/datum/stack_recipe("needled sapling", /obj/structure/flora/ausbushes/pointybush, 1, one_per_turf = 0, on_floor = 1),
	new/datum/stack_recipe("sparse flowers", /obj/structure/flora/ausbushes/lavendergrass, 1, one_per_turf = 0, on_floor = 1),
	new/datum/stack_recipe("yellow flowers", /obj/structure/flora/ausbushes/ywflowers, 1, one_per_turf = 0, on_floor = 1),
	new/datum/stack_recipe("colorful flowers", /obj/structure/flora/ausbushes/brflowers, 1, one_per_turf = 0, on_floor = 1),
	new/datum/stack_recipe("purple flowers", /obj/structure/flora/ausbushes/ppflowers, 1, one_per_turf = 0, on_floor = 1),
	new/datum/stack_recipe("lush grass", /obj/structure/flora/ausbushes/grassybush, 1, one_per_turf = 0, on_floor = 1),
	new/datum/stack_recipe("grass", /obj/structure/flora/ausbushes/fullgrass, 1, one_per_turf = 0, on_floor = 1),
	new/datum/stack_recipe("sparse grass", /obj/structure/flora/ausbushes/sparsegrass, 1, one_per_turf = 0, on_floor = 1))

/*
 * Wood
 */
/obj/item/stack/tile/wood
	name = "wood floor tile"
	singular_name = "wood floor tile"
	desc = "An easy to fit wooden floor tile."
	icon_state = "tile-wood"
	force = 1.0
	throw_force = 1.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE
	drop_sound = 'sound/items/drop/wooden.ogg'
	pickup_sound = 'sound/items/pickup/wooden.ogg'

/obj/item/stack/tile/wood/sif
	name = "alien wood tile"
	singular_name = "alien wood tile"
	desc = "An easy to fit wooden floor tile. It's blue!"
	icon_state = "tile-sifwood"

/obj/item/stack/tile/wood/cyborg
	name = "wood floor tile synthesizer"
	desc = "A device that makes wood floor tiles."
	uses_charge = 1
	charge_costs = list(250)
	stacktype = /obj/item/stack/tile/wood
	build_type = /obj/item/stack/tile/wood

/*
 * Carpets
 */
/obj/item/stack/tile/carpet
	name = "carpet"
	singular_name = "carpet"
	desc = "A piece of carpet. It is the same size as a normal floor tile!"
	icon_state = "tile-carpet"
	force = 1.0
	throw_force = 1.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'

/obj/item/stack/tile/carpet/teal
	name = "teal carpet"
	singular_name = "teal carpet"
	desc = "A piece of teal carpet. It is the same size as a normal floor tile!"
	icon_state = "tile-tealcarpet"
	no_variants = FALSE

/obj/item/stack/tile/carpet/bcarpet
	name = "black carpet"
	singular_name = "black carpet"
	desc = "A piece of black carpet. It is the same size as a normal floor tile!"
	icon_state = "tile-bcarpet"
/obj/item/stack/tile/carpet/blucarpet
	name = "blue carpet"
	singular_name = "blue carpet"
	desc = "A piece of blue carpet. It is the same size as a normal floor tile!"
	icon_state = "tile-blucarpet"
/obj/item/stack/tile/carpet/turcarpet
	name = "tur carpet"
	singular_name = "tur carpet"
	desc = "A piece of turquoise carpet. It is the same size as a normal floor tile!"
	icon_state = "tile-turcarpet"
/obj/item/stack/tile/carpet/sblucarpet
	name = "silver-blue carpet"
	singular_name = "silver-blue carpet"
	desc = "A piece of silver-blue carpet. It is the same size as a normal floor tile!"
	icon_state = "tile-sblucarpet"
/obj/item/stack/tile/carpet/gaycarpet
	name = "funny carpet"
	singular_name = "funny carpet"
	desc = "A piece of funny carpet. Perfect for clowning around on."
	icon_state = "tile-gaycarpet"
/obj/item/stack/tile/carpet/purcarpet
	name = "purple carpet"
	singular_name = "purple carpet"
	desc = "A piece of purple carpet. It is the same size as a normal floor tile!"
	icon_state = "tile-purcarpet"
/obj/item/stack/tile/carpet/oracarpet
	name = "orange carpet"
	singular_name = "orange carpet"
	desc = "A piece of orange carpet. It is the same size as a normal floor tile!"
	icon_state = "tile-oracarpet"
/obj/item/stack/tile/carpet/arcadecarpet
	name = "arcadey carpet"
	singular_name = "arcadey carpet"
	desc = "A piece of arcadey carpet. It is the same size as a normal floor tile!"
	icon_state = "tile-carpet-arcade"

/obj/item/stack/tile/floor
	name = "floor tile"
	singular_name = "floor tile"
	desc = "A metal tile fit for covering a section of floor."
	icon_state = "tile"
	force = 6.0
	matter = list(MAT_STEEL = SHEET_MATERIAL_AMOUNT / 4)
	throw_force = 15.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE

/obj/item/stack/tile/floor/red
	name = "red floor tile"
	singular_name = "red floor tile"
	color = COLOR_RED_GRAY
	icon_state = "tile_white"
	no_variants = FALSE

/obj/item/stack/tile/floor/techgrey
	name = "grey techfloor tile"
	singular_name = "grey techfloor tile"
	icon_state = "techtile_grey"
	no_variants = FALSE

/obj/item/stack/tile/floor/techgrid
	name = "grid techfloor tile"
	singular_name = "grid techfloor tile"
	icon_state = "techtile_grid"
	no_variants = FALSE

/obj/item/stack/tile/floor/steel_dirty
	name = "steel floor tile"
	singular_name = "steel floor tile"
	icon_state = "tile_steel"
	matter = list(MAT_PLASTEEL = SHEET_MATERIAL_AMOUNT / 4)
	no_variants = FALSE

/obj/item/stack/tile/floor/steel
	name = "steel floor tile"
	singular_name = "steel floor tile"
	icon_state = "tile_steel"
	matter = list(MAT_PLASTEEL = SHEET_MATERIAL_AMOUNT / 4)
	no_variants = FALSE

/obj/item/stack/tile/floor/white
	name = "white floor tile"
	singular_name = "white floor tile"
	icon_state = "tile_white"
	matter = list(MAT_PLASTIC = SHEET_MATERIAL_AMOUNT / 4)
	no_variants = FALSE

/obj/item/stack/tile/floor/yellow
	name = "yellow floor tile"
	singular_name = "yellow floor tile"
	color = COLOR_BROWN
	icon_state = "tile_white"
	no_variants = FALSE

/obj/item/stack/tile/floor/dark
	name = "dark floor tile"
	singular_name = "dark floor tile"
	icon_state = "tile_steel"
	matter = list(MAT_PLASTEEL = SHEET_MATERIAL_AMOUNT / 4)
	no_variants = FALSE

/obj/item/stack/tile/floor/freezer
	name = "freezer floor tile"
	singular_name = "freezer floor tile"
	icon_state = "tile_freezer"
	matter = list(MAT_PLASTIC = SHEET_MATERIAL_AMOUNT / 4)
	no_variants = FALSE

/obj/item/stack/tile/floor/cyborg
	name = "floor tile synthesizer"
	desc = "A device that makes floor tiles."
	gender = NEUTER
	matter = null
	uses_charge = 1
	charge_costs = list(250)
	stacktype = /obj/item/stack/tile/floor
	build_type = /obj/item/stack/tile/floor

/obj/item/stack/tile/floor/sandstone
	name = "sandstone tile"
	singular_name = "sandstone tile"
	desc = "Hardened sand compacted into a brick akin to stone in toughness."
	icon_state = "tile-sandstone"
	matter = list("sandstone" = SHEET_MATERIAL_AMOUNT / 4)
	no_variants = FALSE

/obj/item/stack/tile/linoleum
	name = "linoleum"
	singular_name = "linoleum"
	desc = "A piece of linoleum. It is the same size as a normal floor tile!"
	icon_state = "tile-linoleum"
	force = 1.0
	throw_force = 1.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE

/obj/item/stack/tile/wmarble
	name = "light marble tile"
	singular_name = "light marble tile"
	desc = "Some white marble tiles used for flooring."
	icon_state = "tile-wmarble"
	force = 6.0
	throw_force = 15.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE

/obj/item/stack/tile/bmarble
	name = "dark marble tile"
	singular_name = "dark marble tile"
	desc = "Some black marble tiles used for flooring."
	icon_state = "tile-bmarble"
	force = 6.0
	throw_force = 15.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE

/obj/item/stack/tile/roofing
	name = "roofing"
	singular_name = "roofing"
	desc = "A section of roofing material. You can use it to repair the ceiling, or expand it."
	icon_state = "techtile_grid"

/obj/item/stack/tile/roofing/cyborg
	name = "roofing synthesizer"
	desc = "A device that makes roofing tiles."
	uses_charge = 1
	charge_costs = list(250)
	stacktype = /obj/item/stack/tile/roofing
	build_type = /obj/item/stack/tile/roofing

/obj/item/stack/tile/roofing/wood
	name = "wood roofing"
	singular_name = "wood roofing"
	icon_state = "tile-wood"

/obj/item/stack/tile/roofing/bone
	name = "bone roofing"
	singular_name = "bone roofing"
	icon_state = "tile-white"

/obj/item/stack/tile/bananium
	name = "bananium tile"
	singular_name = "bananium tile"
	desc = "The pinnacle of trolling."
	icon_state = "tile-bananium"
	force = 6.0
	throw_force = 10.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE

/obj/item/stack/tile/silencium
	name = "silencium tile"
	singular_name = "silencium tile"
	desc = "If a tear falls off a mime, and no one's around to see it, does it still not make a sound?"
	icon_state = "tile-silencium"
	force = 6.0
	throw_force = 10.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE

/obj/item/stack/tile/plasteel
	name = "plasteel tile"
	singular_name = "plasteel tile"
	icon_state = "tile-plasteel"
	force = 6.0
	throw_force = 15.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE

/obj/item/stack/tile/durasteel
	name = "durasteel tile"
	singular_name = "durasteel tile"
	icon_state = "tile-durasteel"
	force = 6.0
	throw_force = 15.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE

/obj/item/stack/tile/silver
	name = "silver tile"
	singular_name = "silver tile"
	icon_state = "tile-silver"
	force = 6.0
	throw_force = 15.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE

/obj/item/stack/tile/gold
	name = "gold tile"
	singular_name = "gold tile"
	icon_state = "tile-gold"
	force = 6.0
	throw_force = 15.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE

/obj/item/stack/tile/phoron
	name = "phoron tile"
	singular_name = "phoron tile"
	icon_state = "tile-phoron"
	force = 6.0
	throw_force = 15.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE

/obj/item/stack/tile/uranium
	name = "uranium tile"
	singular_name = "uranium tile"
	icon_state = "tile-uranium"
	force = 6.0
	throw_force = 15.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE

/obj/item/stack/tile/diamond
	name = "diamond tile"
	singular_name = "diamond tile"
	icon_state = "tile-diamond"
	force = 6.0
	throw_force = 15.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE

/obj/item/stack/tile/brass
	name = "brass tile"
	singular_name = "brass tile"
	icon_state = "tile-brass"
	force = 6.0
	throw_force = 15.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE

/obj/item/stack/tile/wax
	name = "wax tile"
	singular_name = "wax tile"
	icon_state = "tile-wax"
	force = 1
	throw_force = 1
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE

/obj/item/stack/tile/honeycomb
	name = "honeycomb tile"
	singular_name = "honeycomb tile"
	icon_state = "tile-honeycomb"
	force = 1
	throw_force = 1
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE
