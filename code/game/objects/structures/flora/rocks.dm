/obj/structure/flora/rock
	name = "rock"
	desc = "A large rock"
	density = 1
	plane = MOB_PLANE // You know what, let's play it safe.
	layer = ABOVE_MOB_LAYER
	icon = 'icons/obj/flora/rocks.dmi'
	icon_state = "basalt1"
	randomize_size = TRUE
	var/mindrop = 0
	var/upperdrop = 4
	var/outcropdrop = /obj/item/ore/glass

/obj/structure/flora/rock/alternative_1
	icon_state = "basalt2"

/obj/structure/flora/rock/alternative_2
	icon_state = "basalt3"

/obj/structure/flora/rock/ice
	color = "#afe7fa"

/obj/structure/flora/rock/ice/alternative_1
	icon_state = "basalt2"

/obj/structure/flora/rock/ice/alternative_2
	icon_state = "basalt3"


/obj/structure/flora/rock/attackby(obj/item/W as obj, mob/user as mob)		//Shamelessly copied from mine_outcrops.dm
	if (istype(W, /obj/item/pickaxe))
		to_chat(user, "<span class='notice'>[user] begins to hack away at \the [src].</span>")
		if(do_after(user,40))
			to_chat(user, "<span class='notice'>You have finished digging!</span>")
			for(var/i=0;i<(rand(mindrop,upperdrop));i++)
				new outcropdrop(get_turf(src))
			qdel(src)
			return
