//As part of the Phase 3 expansions, Ashlanders are receiving some dedicated structures.
//One of these is a functional forge where they can produce metal rods and lead sheets.
//Another is a bricklayer that will compress sandstone blocks for construction.

/obj/structure/ashlander/forge
	name = "magma forge"
	desc = "A primitive forge of Scorian design. It is used primarily to convert iron and lead into more workable shapes."
	icon = 'icons/obj/lavaland.dmi'
	icon_state = "forge"

/obj/structure/ashlander/forge/attackby(obj/item/O, mob/user)
	. = ..()
	if(istype(O, /obj/item/ore/lead))
		to_chat(user, "<span class='danger'>You drop the [O] into the [src]! It begins to melt in the crucible.</span>")
		qdel(O)
		var/turf/T = get_turf(src)
		new /obj/item/stack/material/lead(T)
	if(istype(O, /obj/item/ore/iron))
		to_chat(user, "<span class='danger'>You drop the [O] into the [src]! It starts feed through the extruder.</span>")
		qdel(O)
		var/turf/T = get_turf(src)
		new /obj/item/stack/rods(T)

//This is a child of the Hydroponics seed extractor, and was originally in that file. But I've moved it here since it's an Ashlander "machine".
/obj/machinery/seed_extractor/press
	name = "primitive press"
	desc = "A hand crafted press and sieve designed to extract seeds from fruit."
	icon = 'icons/obj/lavaland.dmi'
	icon_state = "press"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_OFF

/obj/structure/ashlander/brickmaker
	name = "brick press"
	desc = "Scorians have been observed using this device to compress sand and clay into hardened bricks."
	icon = 'icons/obj/lavaland.dmi'
	icon_state = "brickmaker"

/obj/structure/ashlander/brickmaker/attackby(obj/item/O, mob/user)
	. = ..()
	if(istype(O, /obj/item/ore/glass))
		to_chat(user, "<span class='danger'>You pour the [O] into the [src]! After some work you compress it into a sturdy brick.</span>")
		qdel(O)
		var/turf/T = get_turf(src)
		new /obj/item/stack/material/sandstone(T)
