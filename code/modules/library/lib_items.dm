/* Library Items
 *
 * Contains:
 *		Bookcase
 *		Book
 *		Barcode Scanner
 */


/*
 * Bookcase
 */

/obj/structure/bookcase
	name = "bookcase"
	icon = 'icons/obj/library.dmi'
	icon_state = "book-0"
	anchored = 1
	density = 1
	opacity = 1

/obj/structure/bookcase/Initialize(mapload)
	. = ..()
	for(var/obj/item/I in loc)
		if(istype(I, /obj/item/book))
			I.loc = src
	update_icon()

/obj/structure/bookcase/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/book))
		if(!user.attempt_insert_item_for_installation(O, src))
			return
		update_icon()
	else if(istype(O, /obj/item/pen))
		var/newname = sanitizeSafe(input("What would you like to title this bookshelf?"), MAX_NAME_LEN)
		if(!newname)
			return
		else
			name = ("bookcase ([newname])")
	else if(O.is_wrench())
		playsound(loc, O.tool_sound, 100, 1)
		to_chat(user, (anchored ? "<span class='notice'>You unfasten \the [src] from the floor.</span>" : "<span class='notice'>You secure \the [src] to the floor.</span>"))
		anchored = !anchored
	else if(O.is_screwdriver())
		playsound(loc, O.tool_sound, 75, 1)
		to_chat(user, "<span class='notice'>You begin dismantling \the [src].</span>")
		if(do_after(user,25 * O.tool_speed))
			to_chat(user, "<span class='notice'>You dismantle \the [src].</span>")
			new /obj/item/stack/material/wood(get_turf(src), 3)
			for(var/obj/item/book/b in contents)
				b.loc = (get_turf(src))
			qdel(src)

	else
		..()

/obj/structure/bookcase/attack_hand(mob/user, list/params, datum/event_args/clickchain/e_args)
	if(contents.len)
		var/obj/item/book/choice = input("Which book would you like to remove from the shelf?") as null|obj in contents
		if(choice)
			if(!CHECK_MOBILITY(user, MOBILITY_CAN_USE) || !in_range(loc, user))
				return
			if(ishuman(user))
				if(!user.get_active_held_item())
					user.put_in_hands(choice)
			else
				choice.loc = get_turf(src)
			update_icon()

/obj/structure/bookcase/legacy_ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/obj/item/book/b in contents)
				qdel(b)
			qdel(src)
			return
		if(2.0)
			for(var/obj/item/book/b in contents)
				if (prob(50)) b.loc = (get_turf(src))
				else qdel(b)
			qdel(src)
			return
		if(3.0)
			if (prob(50))
				for(var/obj/item/book/b in contents)
					b.loc = (get_turf(src))
				qdel(src)
			return
		else
	return

/obj/structure/bookcase/update_icon()
	if(contents.len < 5)
		icon_state = "book-[contents.len]"
	else
		icon_state = "book-5"



/obj/structure/bookcase/manuals/medical
	name = "Medical Manuals bookcase"

/obj/structure/bookcase/manuals/medical/New()
	..()
	new /obj/item/book/manual/medical_cloning(src)
	new /obj/item/book/manual/medical_diagnostics_manual(src)
	new /obj/item/book/manual/medical_diagnostics_manual(src)
	new /obj/item/book/manual/medical_diagnostics_manual(src)
	update_icon()


/obj/structure/bookcase/manuals/engineering
	name = "Engineering Manuals bookcase"

/obj/structure/bookcase/manuals/engineering/New()
	..()
	new /obj/item/book/manual/engineering_construction(src)
	new /obj/item/book/manual/engineering_particle_accelerator(src)
	new /obj/item/book/manual/engineering_hacking(src)
	new /obj/item/book/manual/engineering_guide(src)
	new /obj/item/book/manual/atmospipes(src)
	new /obj/item/book/manual/engineering_singularity_safety(src)
	new /obj/item/book/manual/evaguide(src)
	update_icon()

/obj/structure/bookcase/manuals/research_and_development
	name = "R&D Manuals bookcase"

/obj/structure/bookcase/manuals/research_and_development/New()
	..()
	new /obj/item/book/manual/research_and_development(src)
	update_icon()

/obj/structure/bookcase/legal/sop
	name = "Legal Manuals bookcase"
	icon_state = "legalbook-0"

/obj/structure/bookcase/legal/sop/New()
	..()
	new /obj/item/book/manual/legal/sop_vol1
	new /obj/item/book/manual/legal/sop_vol2
	new /obj/item/book/manual/legal/sop_vol3
	new /obj/item/book/manual/legal/sop_vol4
	new /obj/item/book/manual/legal/sop_vol5_1
	new /obj/item/book/manual/legal/sop_vol5_2
	new /obj/item/book/manual/legal/sop_vol5_3
	new /obj/item/book/manual/legal/sop_vol5_4
	new /obj/item/book/manual/legal/sop_vol5_5
	new /obj/item/book/manual/legal/sop_vol5_6
	new /obj/item/book/manual/legal/sop_vol5_7
	update_icon()

/obj/structure/bookcase/legal/corpreg
	name = "Corporate Regulations bookcase"
	icon_state = "legalbook-0"

/obj/structure/bookcase/legal/corpreg/New()
	..()
	new /obj/item/book/manual/legal/cr_vol1
	new /obj/item/book/manual/legal/cr_vol2
	new /obj/item/book/manual/legal/cr_vol3
	new /obj/item/book/manual/legal/cr_vol4
	new /obj/item/book/manual/legal/cr_vol5
	update_icon()

/obj/structure/bookcase/legal/combo
	name = "Policy Reference bookcase"
	icon_state = "legalbook-0"

/obj/structure/bookcase/legal/combo/New()
	..()
	new /obj/item/book/manual/legal/sop_vol1
	new /obj/item/book/manual/legal/sop_vol2
	new /obj/item/book/manual/legal/sop_vol3
	new /obj/item/book/manual/legal/sop_vol4
	new /obj/item/book/manual/legal/sop_vol5_1
	new /obj/item/book/manual/legal/sop_vol5_2
	new /obj/item/book/manual/legal/sop_vol5_3
	new /obj/item/book/manual/legal/sop_vol5_4
	new /obj/item/book/manual/legal/sop_vol5_5
	new /obj/item/book/manual/legal/sop_vol5_6
	new /obj/item/book/manual/legal/sop_vol5_7
	new /obj/item/book/manual/legal/cr_vol1
	new /obj/item/book/manual/legal/cr_vol2
	new /obj/item/book/manual/legal/cr_vol3
	new /obj/item/book/manual/legal/cr_vol4
	new /obj/item/book/manual/legal/cr_vol5
	update_icon()

/obj/structure/bookcase/legal/update_icon()
	if(contents.len < 5)
		icon_state = "legalbook-[contents.len]"
	else
		icon_state = "legalbook-5"

/*
 * Barcode Scanner
 */
/obj/item/barcodescanner
	name = "barcode scanner"
	icon = 'icons/modules/library/items/barcode_scanner.dmi'
	icon_state ="scanner"
	worn_render_flags = WORN_RENDER_INHAND_NO_RENDER | WORN_RENDER_SLOT_NO_RENDER
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL
	var/obj/machinery/librarycomp/computer // Associated computer - Modes 1 to 3 use this
	var/obj/item/book/book	 //  Currently scanned book
	var/mode = 0 					// 0 - Scan only, 1 - Scan and Set Buffer, 2 - Scan and Attempt to Check In, 3 - Scan and Attempt to Add to Inventory

/obj/item/barcodescanner/attack_self(mob/user)
	. = ..()
	if(.)
		return
	mode += 1
	if(mode > 3)
		mode = 0
	to_chat(user, "[src] Status Display:")
	var/modedesc
	switch(mode)
		if(0)
			modedesc = "Scan book to local buffer."
		if(1)
			modedesc = "Scan book to local buffer and set associated computer buffer to match."
		if(2)
			modedesc = "Scan book to local buffer, attempt to check in scanned book."
		if(3)
			modedesc = "Scan book to local buffer, attempt to add book to general inventory."
		else
			modedesc = "ERROR"
	to_chat(user, " - Mode [mode] : [modedesc]")
	if(src.computer)
		to_chat(user, "<font color=green>Computer has been associated with this unit.</font>")
	else
		to_chat(user, "<font color=red>No associated computer found. Only local scans will function properly.</font>")
	to_chat(user, "\n")
