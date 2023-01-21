//As part of the Phase 3 expansions, Ashlanders are receiving some dedicated structures.
//One of these is a functional forge where they can produce metal rods and lead sheets.
//Another is a bricklayer that will compress sandstone blocks for construction.
/obj/structure/ashlander
	name = "ashlander structure"
	desc = "Woah! You shouldn't be seeing me, outlander! Report me to the Buried Ones at once!"
	icon = 'icons/obj/lavaland.dmi'
	density = TRUE
	anchored = TRUE

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
	if(istype(O, /obj/item/ore/glass))
		to_chat(user, "<span class='danger'>You pour the [O] into the [src]! It starts melt in the crucible.</span>")
		qdel(O)
		var/turf/T = get_turf(src)
		new /obj/item/ore/slag(T)

//This is a child of the Hydroponics seed extractor, and was originally in that file. But I've moved it here since it's an Ashlander "machine".
/obj/machinery/seed_extractor/press
	name = "primitive press"
	desc = "A hand crafted press and sieve designed to extract seeds from fruit."
	icon = 'icons/obj/lavaland.dmi'
	icon_state = "press"
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

//This is a child of the juicer/all-in-one grinder/reagent grinder. Just for some fun alchemy.

/obj/machinery/reagentgrinder/ashlander

	name = "basic alchemical station"
	desc = "A primitive assembly designed to hold a mortar and pestle."
	icon = 'icons/obj/lavaland.dmi'
	icon_state = "alchemy1"
	density = FALSE
	anchored = FALSE
	use_power = USE_POWER_OFF
	circuit = null
	no_panel = TRUE

/obj/machinery/reagentgrinder/ashlander/Initialize(mapload, newdir)
	. = ..()
	beaker = new /obj/item/reagent_containers/glass/stone(src)

/obj/machinery/reagentgrinder/ashlander/update_icon()
	icon_state = "alchemy"+num2text(!isnull(beaker))
	return

/obj/machinery/reagentgrinder/ashlander/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(beaker)
		if(default_deconstruction_screwdriver(user, O))
			return
		if(default_deconstruction_crowbar(user, O))
			return

	if (istype(O,/obj/item/reagent_containers/glass) || \
		istype(O,/obj/item/reagent_containers/food/drinks/glass2) || \
		istype(O,/obj/item/reagent_containers/food/drinks/shaker))

		if (beaker)
			return 1
		else
			if(!user.attempt_insert_item_for_installation(O, src))
				return
			beaker = O
			update_icon()
			updateUsrDialog()
			return 0

	if(holdingitems && holdingitems.len >= limit)
		to_chat(user, "The assembly cannot hold anymore items.")
		return 1

	if(!istype(O))
		return

	if(istype(O,/obj/item/storage/bag/plants))
		var/obj/item/storage/bag/plants/bag = O
		var/failed = 1
		for(var/obj/item/G in O.contents)
			if(!G.reagents || !G.reagents.total_volume)
				continue
			failed = 0
			bag.remove_from_storage(G, src)
			holdingitems += G
			if(holdingitems && holdingitems.len >= limit)
				break

		if(failed)
			to_chat(user, "Nothing in the plant bag is usable.")
			return 1

		if(!O.contents.len)
			to_chat(user, "You empty \the [O] into \the [src].")
		else
			to_chat(user, "You fill \the [src] from \the [O].")

		src.updateUsrDialog()
		return 0

	if(!sheet_reagents[O.type] && (!O.reagents || !O.reagents.total_volume))
		to_chat(user, "\The [O] is not suitable for reduction.")
		return 1
	if(!user.attempt_insert_item_for_installation(O, src))
		return

	holdingitems += O
	src.updateUsrDialog()
	return 0

/obj/machinery/reagentgrinder/ashlander/grind()

	// Sanity check.
	if (!beaker || (beaker && beaker.reagents.total_volume >= beaker.reagents.maximum_volume))
		return

	playsound(src, 'sound/effects/stonedoor_openclose.ogg', 50, 1)
	inuse = 1

	// Reset the machine.
	spawn(60)
		inuse = 0

	// Process.
	for (var/obj/item/O in holdingitems)

		var/remaining_volume = beaker.reagents.maximum_volume - beaker.reagents.total_volume
		if(remaining_volume <= 0)
			break

		if(sheet_reagents[O.type])
			var/obj/item/stack/stack = O
			if(istype(stack))
				var/list/sheet_components = sheet_reagents[stack.type]
				var/amount_to_take = max(0,min(stack.amount,round(remaining_volume/REAGENTS_PER_SHEET)))
				if(amount_to_take)
					stack.use(amount_to_take)
					if(QDELETED(stack))
						holdingitems -= stack
					if(islist(sheet_components))
						amount_to_take = (amount_to_take/(sheet_components.len))
						for(var/i in sheet_components)
							beaker.reagents.add_reagent(i, (amount_to_take*REAGENTS_PER_SHEET))
					else
						beaker.reagents.add_reagent(sheet_components, (amount_to_take*REAGENTS_PER_SHEET))
					continue

		if(O.reagents)
			O.reagents.trans_to_obj(beaker, min(O.reagents.total_volume, remaining_volume))
			if(O.reagents.total_volume == 0)
				holdingitems -= O
				qdel(O)
			if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
				break
