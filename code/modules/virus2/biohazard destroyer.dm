/obj/machinery/disease2/biodestroyer
	name = "Biohazard destroyer"
	icon = 'icons/obj/pipes/disposal.dmi'
	icon_state = "disposalbio"
	var/list/accepts = list(/obj/item/clothing,/obj/item/virusdish/,/obj/item/diseasedisk,/obj/item/reagent_containers)
	density = 1
	anchored = 1

/obj/machinery/disease2/biodestroyer/attackby(var/obj/I as obj, var/mob/user as mob)
	// if you see me in git blame, trust me, what was here before was worse ~silicons
	for(var/path in accepts)
		if(I.type in typesof(path))
			qdel(I)
			overlays += image('icons/obj/pipes/disposal.dmi', "dispover-handle")
			for(var/mob/O in hearers(src, null))
				O.show_message("[icon2html(thing = src, target = O)] <font color=#4F49AF>The [src.name] beeps.</font>", 2)
			return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

