/**********
 *! Rocks *
 **********/
// (I know these aren't plants)

/obj/structure/flora/rock
	name = "large rock"
	icon_state = "basalt1"
	desc = "A volcanic rock. Pioneers used to ride these babies for miles."
	icon = 'icons/obj/flora/rocks.dmi'
	density = TRUE
	randomize_size = TRUE

	var/mindrop = 0
	var/upperdrop = 4
	var/outcropdrop = /obj/item/ore/glass
	// resistance_flags = FIRE_PROOF
	// product_types = list(/obj/item/stack/ore/glass/basalt = 1)
	// harvest_amount_low = 10
	// harvest_amount_high = 20
	// harvest_message_med = "You finish mining the rock."
	// harvest_verb = "mine"
	// flora_flags = FLORA_STONE
	// can_uproot = FALSE
	// delete_on_harvest = TRUE

/obj/structure/flora/rock/attackby(obj/item/W as obj, mob/user as mob) //Shamelessly copied from mine_outcrops.dm
	if (istype(W, /obj/item/pickaxe))
		to_chat(user, SPAN_NOTICE("[user] begins to hack away at \the [src]."))
		if(do_after(user,40))
			to_chat(user, SPAN_NOTICE("You have finished digging!"))
			for(var/i=0;i<(rand(mindrop,upperdrop));i++)
				new outcropdrop(get_turf(src))
			qdel(src)
			return

/obj/structure/flora/rock/style_2
	icon_state = "basalt2"
/obj/structure/flora/rock/style_3
	icon_state = "basalt3"
/obj/structure/flora/rock/style_random/Initialize(mapload)
	. = ..()
	icon_state = "basalt[rand(1, 3)]"

/obj/structure/flora/rock/pile
	name = "rock pile"
	desc = "A pile of rocks."
	icon_state = "lavarocks1"
	// harvest_amount_low = 5
	// harvest_amount_high = 10
	// harvest_message_med = "You finish mining the pile of rocks."
	density = FALSE

/obj/structure/flora/rock/pile/style_2
	icon_state = "lavarocks2"
/obj/structure/flora/rock/pile/style_3
	icon_state = "lavarocks3"
/obj/structure/flora/rock/pile/style_random/Initialize(mapload)
	. = ..()
	icon_state = "lavarocks[rand(1, 3)]"

/obj/structure/flora/rock/pile/jungle
	icon_state = "rock1"
	icon = 'icons/obj/flora/jungleflora.dmi'
/obj/structure/flora/rock/pile/jungle/style_2
	icon_state = "rock2"
/obj/structure/flora/rock/pile/jungle/style_3
	icon_state = "rock3"
/obj/structure/flora/rock/pile/jungle/style_4
	icon_state = "rock4"
/obj/structure/flora/rock/pile/jungle/style_5
	icon_state = "rock5"
/obj/structure/flora/rock/pile/jungle/style_random/Initialize(mapload)
	. = ..()
	icon_state = "rock[rand(1, 5)]"

/obj/structure/flora/rock/pile/jungle/large
	name = "pile of large rocks"
	icon_state = "rocks1"
	icon = 'icons/obj/flora/largejungleflora.dmi'
	pixel_x = -16
	pixel_y = -16
	// harvest_amount_low = 9
	// harvest_amount_high = 13

/obj/structure/flora/rock/pile/jungle/large/style_2
	icon_state = "rocks2"
/obj/structure/flora/rock/pile/jungle/large/style_3
	icon_state = "rocks3"
/obj/structure/flora/rock/pile/jungle/large/style_random/Initialize(mapload)
	. = ..()
	icon_state = "rocks[rand(1, 3)]"

//TODO: Make new sprites for these. the pallete in the icons are grey, and a white color here still makes them grey
/obj/structure/flora/rock/icy
	name = "icy rock"
	icon_state = "basalt1"
	color = rgb(204,233,235)

/obj/structure/flora/rock/icy/style_2
	icon_state = "basalt2"
/obj/structure/flora/rock/icy/style_3
	icon_state = "basalt3"
/obj/structure/flora/rock/icy/style_random/Initialize(mapload)
	. = ..()
	icon_state = "basalt[rand(1, 3)]"

/obj/structure/flora/rock/pile/icy
	name = "icy rocks"
	icon_state = "lavarocks1"
	color = rgb(204,233,235)

/obj/structure/flora/rock/pile/icy/style_2
	icon_state = "lavarocks2"
/obj/structure/flora/rock/pile/icy/style_3
	icon_state = "lavarocks3"
/obj/structure/flora/rock/pile/icy/style_random/Initialize(mapload)
	. = ..()
	icon_state = "lavarocks[rand(1, 3)]"
