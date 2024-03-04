/obj/item/computer_hardware/nano_printer
	name = "nano printer"
	desc = "Small integrated printer with paper recycling module."
	power_usage = 100
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	critical = 0
	icon_state = "printer"
	w_class = WEIGHT_CLASS_TINY
	device_type = MC_PRINT
	expansion_hw = TRUE
	var/stored_paper = 20
	var/max_paper = 30

/obj/item/computer_hardware/nano_printer/diagnostics(mob/living/user)
	..()
	to_chat(user, SPAN_NOTICE("Paper level: [stored_paper]/[max_paper]."))

/obj/item/computer_hardware/nano_printer/examine(mob/user)
	. = ..()
	. += SPAN_NOTICE("Paper level: [stored_paper]/[max_paper].")

/obj/item/computer_hardware/nano_printer/proc/print_text(text_to_print, paper_title = "")
	if(!stored_paper)
		return FALSE
	if(!check_functionality())
		return FALSE

	var/obj/item/paper/P = new/obj/item/paper(holder.drop_location())

	// Damaged printer causes the resulting paper to be somewhat harder to read.
	if(damage > damage_malfunction)
		P.info = stars(text_to_print, 100-malfunction_probability)
	else
		P.info = text_to_print
	if(paper_title)
		P.name = paper_title
	P.update_appearance()
	// OLDPAPER
	P.fields = count_fields(P.info)
	P.updateinfolinks()
	// END OLDPAPER
	stored_paper--
	return TRUE

// OLDPAPER FIELDS
/obj/item/computer_hardware/nano_printer/proc/count_fields(info)
	var/fields = 0
	var/t = info
	var/laststart = 1
	while(1)
		var/i = findtext(t, "<span class=\"paper_field\">", laststart)	//</span>
		if(i==0)
			break
		laststart = i+1
		fields++
	return fields

/obj/item/computer_hardware/nano_printer/try_insert(obj/item/I, mob/living/user = null)
	if(istype(I, /obj/item/paper))
		if(stored_paper >= max_paper)
			to_chat(user, SPAN_WARNING("You try to add \the [I] into [src], but its paper bin is full!"))
			return FALSE

		if(user && !user.temporarily_remove_from_inventory(I))
			return FALSE
		to_chat(user, SPAN_NOTICE("You insert \the [I] into [src]'s paper recycler."))
		qdel(I)
		stored_paper++
		return TRUE
	else if(istype(I, /obj/item/paper_bundle))
		var/obj/item/paper_bundle/B = I
		var/num_of_pages_added = 0
		if(stored_paper >= max_paper)
			to_chat(user, SPAN_WARNING("You try to add \the [I] into [src], but its paper bin is full!"))
			return FALSE
		for(var/obj/item/bundleitem in B) //loop through items in bundle
			if(istype(bundleitem, /obj/item/paper)) //if item is paper (and not photo), add into the bin
				B.pages.Remove(bundleitem)
				qdel(bundleitem)
				num_of_pages_added++
				stored_paper++
			if(stored_paper >= max_paper) //check if the printer is full yet
				to_chat(user, SPAN_NOTICE("The printer has been filled to full capacity."))
				break
		if(B.pages.len == 0) //if all its papers have been put into the printer, delete bundle
			qdel(I)
		else if(B.pages.len == 1) //if only one item left, extract item and delete the one-item bundle
			if(!user.attempt_consume_item_for_construction(B))
				return FALSE
			user.put_in_hands(B[1])
		else //if at least two items remain, just update the bundle icon
			B.update_icon()
		to_chat(user, SPAN_NOTICE("You add [num_of_pages_added] papers from \the [I] into \the [src]."))
		return TRUE
	return FALSE
