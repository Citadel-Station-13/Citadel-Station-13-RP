/**********
 *! Grass *
 **********/

/obj/structure/flora/grass
	name = "grass"
	desc = "A patch of overgrown grass."
	icon = 'icons/obj/flora/snowflora.dmi'
	gender = PLURAL //"this is grass" not "this is a grass"
	// product_types = list(/obj/item/food/grown/grass = 10, /obj/item/seeds/grass = 1)
	// harvest_with_hands = TRUE
	// harvest_amount_low = 0
	// harvest_amount_high = 2
	// harvest_message_low = "You uproot the grass from the ground, just for the fun of it."
	// harvest_message_med = "You gather up some grass."
	// harvest_message_high = "You gather up a handful grass."
	// can_uproot = TRUE
	// flora_flags = FLORA_HERBAL

/obj/structure/flora/grass/brown
	icon_state = "snowgrass1bb"
/obj/structure/flora/grass/brown/style_2
	icon_state = "snowgrass2bb"
/obj/structure/flora/grass/brown/style_3
	icon_state = "snowgrass2bb"
/obj/structure/flora/grass/brown/style_random/Initialize(mapload)
	. = ..()
	icon_state = "snowgrass[rand(1, 3)]bb"

/obj/structure/flora/grass/green
	icon_state = "snowgrass1gb"
/obj/structure/flora/grass/green/style_2
	icon_state = "snowgrass2gb"
/obj/structure/flora/grass/green/style_3
	icon_state = "snowgrass3gb"
/obj/structure/flora/grass/green/style_random/Initialize(mapload)
	. = ..()
	icon_state = "snowgrass[rand(1, 3)]gb"

/obj/structure/flora/grass/both
	icon_state = "snowgrassall1"
/obj/structure/flora/grass/both/style_2
	icon_state = "snowgrassall2"
/obj/structure/flora/grass/both/style_3
	icon_state = "snowgrassall3"
/obj/structure/flora/grass/both/style_random/Initialize(mapload)
	. = ..()
	icon_state = "snowgrassall[rand(1, 3)]"

/obj/structure/flora/grass/jungle
	name = "jungle grass"
	desc = "Thick alien flora."
	icon = 'icons/obj/flora/jungleflora.dmi'
	icon_state = "grassa1"

/obj/structure/flora/grass/jungle/a/style_2
	icon_state = "grassa2"
/obj/structure/flora/grass/jungle/a/style_3
	icon_state = "grassa3"
/obj/structure/flora/grass/jungle/a/style_4
	icon_state = "grassa4"
/obj/structure/flora/grass/jungle/a/style_5
	icon_state = "grassa5"
/obj/structure/flora/grass/jungle/a/style_random/Initialize(mapload)
	. = ..()
	icon_state = "grassa[rand(1, 5)]"

/obj/structure/flora/grass/jungle/b
	icon_state = "grassb1"
/obj/structure/flora/grass/jungle/b/style_2
	icon_state = "grassb2"
/obj/structure/flora/grass/jungle/b/style_3
	icon_state = "grassb3"
/obj/structure/flora/grass/jungle/b/style_4
	icon_state = "grassb4"
/obj/structure/flora/grass/jungle/b/style_5
	icon_state = "grassb5"
/obj/structure/flora/grass/jungle/b/style_random/Initialize(mapload)
	. = ..()
	icon_state = "grassb[rand(1, 5)]"
