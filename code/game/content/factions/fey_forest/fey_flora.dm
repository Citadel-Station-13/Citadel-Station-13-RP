/datum/prototype/material/alienalloy/denseforest
	id = "denseforest"
	name = "denseforest"

	// Becomes "[display_name] wall" in the UI.
	display_name = "Dense Forest"

	icon_base = 'code/game/content/factions/fey_forest/fey_forest.dmi/fey_jungle_walls.dmi'
	icon_colour = "#37a52d"
	wall_stripe_icon = null // leave null

/turf/simulated/wall/fey/forest_wall
	icon = 'code/game/content/factions/fey_forest/fey_forest.dmi/fey_jungle_walls.dmi'
	material_outer = /datum/prototype/material/alienalloy/denseforest
	name = "Dense Forest"
	desc = "Hundreds of thousand years of unkempt forest growth has forged this impenetrable wall of roots, leaves, bark and other materials. Good luck getting through that."
	description_info = "No way you can get past this..."
	block_tele = TRUE
	integrity_enabled = 0


/obj/structure/flora/tree/fey/large_tree
	icon = 'code/game/content/factions/fey_forest/fey_forest.dmi/fey_trees.dmi'
	pixel_x = -49
	pixel_y = -19
	bounds = "16,16"
	name = "Large Tree"
	desc = "A large tree that extends into the sky, joining with the gargantuan canopy. Looks too thick to reasonably cut down."
	integrity_max = 1000
	integrity = 1000

/obj/structure/flora/tree/fey/large_tree/tree1
	icon_state = "tree_complete"

/obj/structure/flora/tree/fey/large_tree/tree2
	icon_state = "tree1_complete"

/obj/structure/flora/tree/fey/large_tree/tree3
	icon_state = "tree2_complete"

/obj/structure/flora/tree/fey/large_tree/tree4
	icon_state = "tree3_complete"

/obj/structure/flora/tree/fey/large_tree/tree5
	icon_state = "tree4_complete"

/obj/structure/flora/tree/fey/large_tree/tree6
	icon_state = "tree5_complete"

/obj/structure/flora/tree/fey/large_tree/tree7
	icon_state = "tree6_complete"

/obj/structure/flora/tree/fey/small_tree
	icon = 'code/game/content/factions/fey_forest/fey_forest.dmi/fey_trees_small.dmi'
	pixel_x = -25
	bounds = "16,16"
	name = "Small Tree"
	desc = "A small tree, compared to the others atleast. Despite its height, its trunk is far too thick to cut down."
	integrity_max = 600
	integrity = 600

/obj/structure/flora/tree/fey/small_tree/tree1
	icon_state = "tree1complet"

/obj/structure/flora/tree/fey/small_tree/tree2
	icon_state = "tree2complet"

/obj/structure/flora/tree/fey/small_tree/tree3
	icon_state = "tree3complet"

/obj/structure/flora/tree/fey/small_tree/tree4
	icon_state = "tree4complet"

/obj/structure/flora/tree/fey/small_tree/tree5
	icon_state = "tree5complet"

/obj/structure/flora/tree/fey/small_tree/tree6
	icon_state = "tree6complet"

/obj/structure/flora/tree/fey/small_tree/tree7
	icon_state = "treecomplet"

/turf/simulated/floor/fey/forest_grass
	icon = 'code/game/content/factions/fey_forest/fey_forest.dmi/fey_flora.dmi'
	icon_state = "forest_floor"
	name = "Forest Floor"
	desc = "The hardy forest floor, you can see the occasional root sticking out along with a variety of rocks and twigs."
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/turf/simulated/floor/fey/dry_grass
	icon = 'code/game/content/factions/fey_forest/fey_forest.dmi/fey_flora.dmi'
	icon_state = "dry_grass"
	name = "Dry Grass"
	desc = "A patch of dried forest grass that's been exposed to the sun far too long."
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))


/obj/structure/flora/rock/fey
	icon = 'code/game/content/factions/fey_forest/fey_forest.dmi/fey_flora.dmi'
	name = "Rock Cluster"
	desc = "A cluster of hardy rocks."
	density = 0

/obj/structure/flora/rock/fey/rock1
	icon_state = "rock1"

/obj/structure/flora/rock/fey/rock2
	icon_state = "rock2"

/obj/structure/flora/rock/fey/rock3
	icon_state = "rock3"

/obj/structure/flora/rock/fey/rock4
	icon_state = "rock4"

/obj/structure/flora/rock/fey/rock5
	icon_state = "rock5"

/obj/structure/flora/grass/fey/bush
	icon = 'code/game/content/factions/fey_forest/fey_forest.dmi/fey_flora.dmi'
	name = "Bush"
	desc = "A cluster of bushes and grass."
	density = 0

// Colfer change, these randomizations are for grass buildings in tile_types.dm
/obj/structure/flora/grass/fey/bush/florarandom
	icon_state = "busha1"

/obj/structure/flora/grass/fey/bush/florarandom/Initialize(mapload)
	. = ..()
	icon_state = "busha[rand(1, 3)]"

/obj/structure/flora/grass/fey/bush/bushrandom
	icon_state = "bushb1"

/obj/structure/flora/grass/fey/bush/bushrandom/Initialize(mapload)
	. = ..()
	icon_state = "bushb[rand(1, 3)]"

/obj/structure/flora/grass/fey/bush/lowbushrandom
	icon_state = "bushc1"

/obj/structure/flora/grass/fey/bush/lowbushrandom/Initialize(mapload)
	. = ..()
	icon_state = "bushc[rand(1, 3)]"

/obj/structure/flora/grass/fey/bush/grassrandom
	icon_state = "grassa1"

/obj/structure/flora/grass/fey/bush/grassrandom/Initialize(mapload)
	. = ..()
	icon_state = "grassa[rand(1, 5)]"

/obj/structure/flora/grass/fey/bush/sparcegrassrandom
	icon_state = "grassb1"

/obj/structure/flora/grass/fey/bush/sparcegrassrandom/Initialize(mapload)
	. = ..()
	icon_state = "grassb[rand(1, 2)]"

/obj/structure/flora/fey/large/randombush
	icon_state = "bush1"
	pixel_x = -16

/obj/structure/flora/fey/large/randombush/Initialize(mapload)
	. = ..()
	icon_state = "bush[rand(1, 3)]"
// This makes it so you can tear them apart
/obj/structure/flora/grass/fey/bush/attackby(obj/item/W as obj, mob/user as mob)
	// Dismantle
	if(user.a_intent == INTENT_HARM) // who said you CAN'T touch grass (violently)?
		return ..()
	if(istype(W, /obj/item/shovel))
		playsound(src.loc, W.tool_sound, 50, 1)
		if(do_after(user, 10, src))
			user.visible_message("<span class='notice'>\The [user] digs up \the [src].</span>", "<span class='notice'>You dig up \the [src].</span>")
			new /obj/item/stack/tile/grass(get_turf(usr), 1)
			qdel(src)
			return
// Also have to do the large ones too, but seperately
/obj/structure/flora/fey/large/attackby(obj/item/W as obj, mob/user as mob)
	// Dismantle
	if(user.a_intent == INTENT_HARM) // who said you CAN'T touch grass (violently)?
		return ..()
	if(istype(W, /obj/item/shovel))
		playsound(src.loc, W.tool_sound, 50, 1)
		if(do_after(user, 10, src))
			user.visible_message("<span class='notice'>\The [user] digs up \the [src].</span>", "<span class='notice'>You dig up \the [src].</span>")
			new /obj/item/stack/tile/grass(get_turf(usr), 1)
			qdel(src)
			return

// Still colfer here, I don't want to touch these down here because I don't know if maps use these
/obj/structure/flora/grass/fey/bush/bush1
	icon_state = "busha1"

/obj/structure/flora/grass/fey/bush/bush2
	icon_state = "busha2"

/obj/structure/flora/grass/fey/bush/bush3
	icon_state = "busha3"

/obj/structure/flora/grass/fey/bush/bush4
	icon_state = "bushb1"

/obj/structure/flora/grass/fey/bush/bush5
	icon_state = "bushb2"

/obj/structure/flora/grass/fey/bush/bush6
	icon_state = "bushb3"

/obj/structure/flora/grass/fey/bush/bush7
	icon_state = "bushc1"

/obj/structure/flora/grass/fey/bush/bush8
	icon_state = "bushc2"

/obj/structure/flora/grass/fey/bush/bush9
	icon_state = "bushc3"

/obj/structure/flora/fey/grass
	icon = 'code/game/content/factions/fey_forest/fey_forest.dmi/fey_flora.dmi'
	name = "Grass"
	desc = "A mixture of grass and twigs."
	density = 0

/obj/structure/flora/fey/grass/grass1
	icon_state = "grassa1"

/obj/structure/flora/fey/grass/grass2
	icon_state = "grassa2"

/obj/structure/flora/fey/grass/grass3
	icon_state = "grassa3"

/obj/structure/flora/fey/grass/grass4
	icon_state = "grassa4"

/obj/structure/flora/fey/grass/grass5
	icon_state = "grassa5"

/obj/structure/flora/fey/grass/grass6
	icon_state = "grassa"

/obj/structure/flora/fey/grass/grass7
	icon_state = "grassb1"

/obj/structure/flora/fey/grass/grass8
	icon_state = "grassb2"

/obj/structure/flora/fey/grass/grass9
	icon_state = "grassb"

/obj/structure/flora/fey/large
	icon = 'code/game/content/factions/fey_forest/fey_forest.dmi/fey_flora_64x64.dmi'
	name = "Large Flora"
	desc = "Giganticism at its finest. This part of the endless forest has been alive for centuries, if not thousands of years."
	density = 0
	pixel_x = -16

/obj/structure/flora/fey/large/bush1
	icon_state = "bush1"

/obj/structure/flora/fey/large/bush2
	icon_state = "bush2"

/obj/structure/flora/fey/large/bush3
	icon_state = "bush3"

/obj/structure/flora/fey/large/rock1
	icon_state = "rocks1"

/obj/structure/flora/fey/large/rock2
	icon_state = "rocks2"

/obj/structure/flora/fey/large/rock3
	icon_state = "rocks3"
