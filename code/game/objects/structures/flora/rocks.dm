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
	var/outcropdrop = /obj/item/stack/ore/glass

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
		var/obj/item/pickaxe/P = W
		to_chat(user, "<span class='notice'>[user] begins to hack away at \the [src].</span>")
		if(do_after(user,P.digspeed))
			to_chat(user, "<span class='notice'>You have finished digging!</span>")
			GetDrilled()
			return
		return
	. = ..()

/obj/structure/flora/rock/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_TARGET_ABORT)
		return
	if(proj.damage_flag == ARMOR_BOMB) //Intended for kinetic accelerators/daggers to just get rid of this stuff quickly. They're rocks.
		GetDrilled()

/obj/structure/flora/rock/proc/GetDrilled()
	new outcropdrop(get_turf(src),rand(mindrop,upperdrop))
	qdel(src)

