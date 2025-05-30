/obj/structure/shrine_seal
	name = "shrine seal"
	desc = "Ornately twisted rope holding up a religious seal."
	icon = 'icons/obj/decals.dmi'
	icon_state = "shrine_seal"
	layer = ABOVE_WINDOW_LAYER
	integrity = 40
	integrity_max = 40
	integrity_failure = 30

/obj/structure/shrine_seal/attackby(obj/item/P, mob/user)
	if(P.is_wirecutter())
		playsound(src, P.tool_sound, 50, 1)
		to_chat(user, "<span class='notice'>You start to cut the hanging rope.</span>")
		if(do_after(user, 10))
			to_chat(user, "<span class='notice'>You cut the hanging rope.</span>")
			var/obj/item/stack/material/cloth/A = new /obj/item/stack/material/cloth( src.loc )
			A.amount = 3
			qdel(src)
		return
	else
		src.attack_hand(user)
	return
