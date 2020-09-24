//Dance pole
/obj/structure/dancepole
	name = "dance pole"
	desc = "Engineered for your entertainment"
	icon = 'icons/obj/objects.dmi'
	icon_state = "dancepole"
	density = 0
	anchored = 1

/obj/structure/dancepole/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(O.is_wrench())
		anchored = !anchored
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		if(anchored)
			to_chat(user, "<font color='blue'>You secure \the [src].</font>")
		else
			to_chat(user, "<font color='blue'>You unsecure \the [src].</font>")

	if(istype(O, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = O
		if(WT.remove_fuel(0, user))
			playsound(src, WT.usesound, 25, 1)
			for (var/mob/M in viewers(src))
				M.show_message("<span class='notice'>[user.name] deconstructed \the [src].</span>", 3, "<span class='notice'>You hear welding.</span>", 2)
			new /obj/item/stack/material/steel(loc)
			qdel(src)

/obj/structure/dancepole/get_description_interaction()
	var/list/results = list()
	results += "[desc_panel_image("welder")] to deconstruct."
	if(anchored)
		results += "[desc_panel_image("wrench")] to unbolt from the floor."
	else
		results += "[desc_panel_image("wrench")] to anchor to the floor."
	return results