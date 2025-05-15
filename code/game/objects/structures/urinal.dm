/obj/structure/urinal
	name = "urinal"
	desc = "The HU-452, an experimental urinal."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "urinal"
	density = 0
	anchored = 1

/obj/structure/urinal/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I
		if(isliving(G.affecting))
			var/mob/living/GM = G.affecting
			if(G.state>1)
				if(!GM.loc == get_turf(src))
					to_chat(user, "<span class='notice'>[GM.name] needs to be on the urinal.</span>")
					return
				user.visible_message("<span class='danger'>[user] slams [GM.name] into the [src]!</span>", "<span class='notice'>You slam [GM.name] into the [src]!</span>")
				GM.adjustBruteLoss(8)
			else
				to_chat(user, "<span class='notice'>You need a tighter grip.</span>")

// todo: consider removing this; there's no "no.. unless", there's just "no".
/obj/item/reagent_containers/food/urinalcake
	name = "urinal cake"
	desc = "A small, pleasant smelling air freshener keeping the bathroom smelling clean. It looks tasty... but, no, you shouldn't... Unless?"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "urinalcake"
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/urinalcake/New()
	. = ..()
	reagents.add_reagent("chlorine", 3)
	reagents.add_reagent("ammonia", 1)

/obj/item/reagent_containers/food/urinalcake/attack_self(mob/user, datum/event_args/actor/actor)
	user.visible_message("<span class='notice'>[user] squishes [src]!</span>", "<span class='notice'>You squish [src].</span>", "<i>You hear a squish.</i>")
	icon_state = "urinalcake_squish"
	addtimer(VARSET_CALLBACK(src, icon_state, "urinalcake"), 8)
