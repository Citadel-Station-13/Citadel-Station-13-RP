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
	damage_force = 1.0
	throw_force = 1.0
	throw_speed = 5
	throw_range = 20
	origin_tech = list(TECH_BIO = 1)
	no_variants = FALSE
	drop_sound = 'sound/items/drop/herb.ogg'
	pickup_sound = 'sound/items/pickup/herb.ogg'

/obj/item/stack/tile/grass/generate_explicit_recipes()
	. = list()
	. += create_stack_recipe_datum(name = "bush", product = /obj/structure/flora/ausbushes, cost = 1)
	. += create_stack_recipe_datum(name = "reeds", product = /obj/structure/flora/ausbushes/reedbush, cost = 1)
	. += create_stack_recipe_datum(name = "leafy bush", product = /obj/structure/flora/ausbushes/leafybush, cost = 1)
	. += create_stack_recipe_datum(name = "sparse bush", product = /obj/structure/flora/ausbushes/palebush, cost = 1)
	. += create_stack_recipe_datum(name = "stalks", product = /obj/structure/flora/ausbushes/stalkybush, cost = 1)
	. += create_stack_recipe_datum(name = "ferns", product = /obj/structure/flora/ausbushes/fernybush, cost = 1)
	. += create_stack_recipe_datum(name = "sapling", product = /obj/structure/flora/ausbushes/sunnybush, cost = 1)
	. += create_stack_recipe_datum(name = "leafy sapling", product = /obj/structure/flora/ausbushes/genericbush, cost = 1)
	. += create_stack_recipe_datum(name = "needled sapling", product = /obj/structure/flora/ausbushes/pointybush, cost = 1)
	. += create_stack_recipe_datum(name = "sparse flowers", product = /obj/structure/flora/ausbushes/lavendergrass, cost = 1)
	. += create_stack_recipe_datum(name = "yellow flowers", product = /obj/structure/flora/ausbushes/ywflowers, cost = 1)
	. += create_stack_recipe_datum(name = "colorful flowers", product = /obj/structure/flora/ausbushes/brflowers, cost = 1)
	. += create_stack_recipe_datum(name = "purple flowers", product = /obj/structure/flora/ausbushes/ppflowers, cost = 1)
	. += create_stack_recipe_datum(name = "lush grass", product = /obj/structure/flora/ausbushes/grassybush, cost = 1)
	. += create_stack_recipe_datum(name = "grass", product = /obj/structure/flora/ausbushes/fullgrass, cost = 1)
	. += create_stack_recipe_datum(name = "sparse grass", product = /obj/structure/flora/ausbushes/sparsegrass, cost = 1)

/*
 * Wood
 */
/obj/item/stack/tile/wood
	name = "wood floor tile"
	singular_name = "wood floor tile"
	desc = "An easy to fit wooden floor tile."
	icon_state = "tile-wood"
	damage_force = 1.0
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
	damage_force = 1.0
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

/obj/item/stack/tile/carpet/patterned
	no_variants = TRUE

/obj/item/stack/tile/carpet/patterned/brown
	name = "brown patterned carpet"
	singular_name = "brown patterned carpet"
	desc = "A piece of brown carpet with a fetching light brown pattern. It is the same size as a normal floor tile!"
	icon_state = "tile-carpetbrown"

/obj/item/stack/tile/carpet/patterned/green
	name = "green patterned carpet"
	singular_name = "green patterned carpet"
	desc = "A piece of green carpet with a fetching light green pattern. It is the same size as a normal floor tile!"
	icon_state = "tile-carpetgreen"

/obj/item/stack/tile/carpet/patterned/red
	name = "red patterned carpet"
	singular_name = "red patterned carpet"
	desc = "A piece of red carpet with a fetching gold pattern. It is the same size as a normal floor tile!"
	icon_state = "tile-carpetred"

/obj/item/stack/tile/carpet/patterned/blue
	name = "blue patterned carpet"
	singular_name = "blue patterned carpet"
	desc = "A piece of brown carpet with a fetching gold pattern. It is the same size as a normal floor tile!"
	icon_state = "tile-carpetblue"

/obj/item/stack/tile/carpet/patterned/blue/alt
	name = "blue patterned carpet"
	singular_name = "blue patterned carpet"
	desc = "A piece of blue carpet with a fetching white pattern. It is the same size as a normal floor tile!"
	icon_state = "tile-carpetblue2"

/obj/item/stack/tile/carpet/patterned/blue/alt2
	name = "blue patterned carpet"
	singular_name = "blue patterned carpet"
	desc = "A piece of blue carpet with a fetching seafoam green pattern. It is the same size as a normal floor tile!"
	icon_state = "tile-carpetblue3"

/obj/item/stack/tile/carpet/patterned/magenta
	name = "magenta patterned carpet"
	singular_name = "magenta patterned carpet"
	desc = "A piece of magenta carpet with a fetching gold pattern. It is the same size as a normal floor tile!"
	icon_state = "tile-carpetmagenta"

/obj/item/stack/tile/carpet/patterned/purple
	name = "purple patterned carpet"
	singular_name = "purple patterned carpet"
	desc = "A piece of purple carpet with a fetching gold pattern. It is the same size as a normal floor tile!"
	icon_state = "tile-carpetpurple"

/obj/item/stack/tile/carpet/patterned/orange
	name = "orange patterned carpet"
	singular_name = "orange patterned carpet"
	desc = "A piece of orange carpet with a fetching gold pattern. It is the same size as a normal floor tile!"
	icon_state = "tile-carpetorange"

/obj/item/stack/tile/floor
	name = "floor tile"
	singular_name = "floor tile"
	desc = "A metal tile fit for covering a section of floor."
	icon_state = "tile"
	materials_base = list(MAT_STEEL = SHEET_MATERIAL_AMOUNT / 4)
	damage_force = 6.0
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
	materials_base = list(MAT_PLASTEEL = SHEET_MATERIAL_AMOUNT / 4)
	no_variants = FALSE

/obj/item/stack/tile/floor/steel
	name = "steel floor tile"
	singular_name = "steel floor tile"
	icon_state = "tile_steel"
	materials_base = list(MAT_PLASTEEL = SHEET_MATERIAL_AMOUNT / 4)
	no_variants = FALSE

/obj/item/stack/tile/floor/white
	name = "white floor tile"
	singular_name = "white floor tile"
	icon_state = "tile_white"
	materials_base = list(MAT_PLASTIC = SHEET_MATERIAL_AMOUNT / 4)
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
	materials_base = list(MAT_PLASTEEL = SHEET_MATERIAL_AMOUNT / 4)
	no_variants = FALSE

/obj/item/stack/tile/floor/freezer
	name = "freezer floor tile"
	singular_name = "freezer floor tile"
	icon_state = "tile_freezer"
	materials_base = list(MAT_PLASTIC = SHEET_MATERIAL_AMOUNT / 4)
	no_variants = FALSE

/obj/item/stack/tile/floor/cyborg
	name = "floor tile synthesizer"
	desc = "A device that makes floor tiles."
	gender = NEUTER
	materials_base = null
	uses_charge = 1
	charge_costs = list(250)
	stacktype = /obj/item/stack/tile/floor
	build_type = /obj/item/stack/tile/floor

/obj/item/stack/tile/floor/sandstone
	name = "sandstone tile"
	singular_name = "sandstone tile"
	desc = "Hardened sand compacted into a brick akin to stone in toughness."
	icon_state = "tile-sandstone"
	materials_base = list("sandstone" = SHEET_MATERIAL_AMOUNT / 4)
	no_variants = FALSE

/obj/item/stack/tile/linoleum
	name = "linoleum"
	singular_name = "linoleum"
	desc = "A piece of linoleum. It is the same size as a normal floor tile!"
	icon_state = "tile-linoleum"
	damage_force = 1.0
	throw_force = 1.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE

/obj/item/stack/tile/wmarble
	name = "light marble tile"
	singular_name = "light marble tile"
	desc = "Some white marble tiles used for flooring."
	icon_state = "tile-wmarble"
	damage_force = 6.0
	throw_force = 15.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE

/obj/item/stack/tile/bmarble
	name = "dark marble tile"
	singular_name = "dark marble tile"
	desc = "Some black marble tiles used for flooring."
	icon_state = "tile-bmarble"
	damage_force = 6.0
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
	damage_force = 6.0
	throw_force = 10.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE

/obj/item/stack/tile/silencium
	name = "silencium tile"
	singular_name = "silencium tile"
	desc = "If a tear falls off a mime, and no one's around to see it, does it still not make a sound?"
	icon_state = "tile-silencium"
	damage_force = 6.0
	throw_force = 10.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE

/obj/item/stack/tile/plasteel
	name = "plasteel tile"
	singular_name = "plasteel tile"
	icon_state = "tile-plasteel"
	damage_force = 6.0
	throw_force = 15.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE

/obj/item/stack/tile/durasteel
	name = "durasteel tile"
	singular_name = "durasteel tile"
	icon_state = "tile-durasteel"
	damage_force = 6.0
	throw_force = 15.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE

/obj/item/stack/tile/silver
	name = "silver tile"
	singular_name = "silver tile"
	icon_state = "tile-silver"
	damage_force = 6.0
	throw_force = 15.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE

/obj/item/stack/tile/gold
	name = "gold tile"
	singular_name = "gold tile"
	icon_state = "tile-gold"
	damage_force = 6.0
	throw_force = 15.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE

/obj/item/stack/tile/phoron
	name = "phoron tile"
	singular_name = "phoron tile"
	icon_state = "tile-phoron"
	damage_force = 6.0
	throw_force = 15.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE

/obj/item/stack/tile/uranium
	name = "uranium tile"
	singular_name = "uranium tile"
	icon_state = "tile-uranium"
	damage_force = 6.0
	throw_force = 15.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE

/obj/item/stack/tile/diamond
	name = "diamond tile"
	singular_name = "diamond tile"
	icon_state = "tile-diamond"
	damage_force = 6.0
	throw_force = 15.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE

/obj/item/stack/tile/brass
	name = "brass tile"
	singular_name = "brass tile"
	icon_state = "tile-brass"
	damage_force = 6.0
	throw_force = 15.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE

/obj/item/stack/tile/wax
	name = "wax tile"
	singular_name = "wax tile"
	icon_state = "tile-wax"
	damage_force = 1
	throw_force = 1
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE

/obj/item/stack/tile/honeycomb
	name = "honeycomb tile"
	singular_name = "honeycomb tile"
	icon_state = "tile-honeycomb"
	damage_force = 1
	throw_force = 1
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE
