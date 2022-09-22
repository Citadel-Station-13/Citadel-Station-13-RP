/obj/structure/shrine_seal
	name = "shrine seal"
	desc = "Ornately twisted rope holding up a religious seal."
	icon = 'icons/obj/decals.dmi'
	icon_state = "shrine_seal"
	layer = 3.3 //3.3 so its above windows, not the same as them. anything below 3.3 puts the curtain beneath the window sprite in current build
	opacity = 0

/obj/structure/shrine_seal/bullet_act(obj/item/projectile/P, def_zone)
	if(!P.nodamage)
		visible_message("<span class='warning'>[P] tears [src] down!</span>")
		qdel(src)
	else
		..(P, def_zone)

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
