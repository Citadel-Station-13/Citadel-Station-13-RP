/obj/machinery/photocopier
	name = "photocopier"
	desc = "Copy all your important papers here!"
	icon = 'icons/obj/library.dmi'
	icon_state = "bigscanner"
	var/insert_anim = "bigscanner1"
	anchored = 1
	density = 1
	use_power = USE_POWER_IDLE
	idle_power_usage = 30
	active_power_usage = 200
	power_channel = EQUIP
	circuit = /obj/item/circuitboard/photocopier
	buckle_allowed = TRUE
	buckle_max_mobs = 1
	var/obj/item/copyitem = null	//what's in the copier!
	var/copies = 1	//how many copies to print!
	var/toner = 30 //how much toner is left! woooooo~
	var/maxcopies = 10	//how many copies can be copied at once- idea shamelessly stolen from bs12's copier!
	var/copying = FALSE // Is the printer busy with something? Sanity check variable.

/obj/machinery/photocopier/Initialize(mapload)
	. = ..()
	default_apply_parts()

/obj/machinery/photocopier/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		. += "The screen shows there's [toner ? "[toner]" : "no"] toner left in the printer."

/obj/machinery/photocopier/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/photocopier/attack_hand(mob/user as mob)
	user.set_machine(src)

	nano_ui_interact(user)

/**
 *  Display the NanoUI window for the photocopier.
 *
 *  See NanoUI documentation for details.
 */
/obj/machinery/photocopier/nano_ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/list/data = list()
	data["copyItem"] = copyitem
	data["assPresent"] = has_buckled_mobs()
	data["toner"] = toner
	data["copies"] = copies
	data["maxCopies"] = maxcopies
	if(istype(user,/mob/living/silicon))
		data["isSilicon"] = 1
	else
		data["isSilicon"] = null

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "photocopier.tmpl", src.name, 300, 250)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(10)

/obj/machinery/photocopier/proc/copy_operation(var/mob/user)
	if(copying)
		return FALSE
	copying = TRUE
	for(var/i = 0, i < copies, i++)
		if(toner <= 0)
			break

		if (istype(copyitem, /obj/item/paper))
			playsound(loc, "sound/machines/copier.ogg", 100, 1)
			sleep(11)
			copy(copyitem)
			audible_message("<span class='notice'>You can hear [src] whirring as it finishes printing.</span>")
			playsound(loc, "sound/machines/buzzbeep.ogg", 30)
		else if (istype(copyitem, /obj/item/photo))
			playsound(loc, "sound/machines/copier.ogg", 100, 1)
			sleep(11)
			photocopy(copyitem)
			audible_message("<span class='notice'>You can hear [src] whirring as it finishes printing.</span>")
			playsound(loc, "sound/machines/buzzbeep.ogg", 30)
		else if (istype(copyitem, /obj/item/paper_bundle))
			sleep(11)
			playsound(loc, "sound/machines/copier.ogg", 100, 1)
			var/obj/item/paper_bundle/B = bundlecopy(copyitem)
			sleep(11*B.pages.len)
			audible_message("<span class='notice'>You can hear [src] whirring as it finishes printing.</span>")
			playsound(loc, "sound/machines/buzzbeep.ogg", 30)
		else if (has_buckled_mobs()) // For ass-copying.
			playsound(loc, "sound/machines/copier.ogg", 100, 1)
			audible_message("<span class='notice'>You can hear [src] whirring as it attempts to scan.</span>")
			sleep(rand(20,45)) // Sit with your bare ass on the copier for a random time, feel like a fool, get stared at.
			copyass(user)
			sleep(15)
			audible_message("<span class='notice'>You can hear [src] whirring as it finishes printing.</span>")
			playsound(loc, "sound/machines/buzzbeep.ogg", 30)
		else
			to_chat(user, "<span class='warning'>\The [copyitem] can't be copied by [src].</span>")
			playsound(loc, "sound/machines/buzz-two.ogg", 100)
			break

		use_power(USE_POWER_ACTIVE)
	copying = FALSE

/obj/machinery/photocopier/Topic(href, href_list)
	if(href_list["copy"])
		if(machine_stat & (BROKEN|NOPOWER))
			return
		addtimer(CALLBACK(src, .proc/copy_operation, usr), 0)

	else if(href_list["remove"])
		if(copyitem)
			copyitem.loc = usr.loc
			usr.put_in_hands(copyitem)
			to_chat(usr, "<span class='notice'>You take \the [copyitem] out of \the [src].</span>")
			copyitem = null
		else if(has_buckled_mobs())
			to_chat(buckled_mobs[1], "<span class='notice'>You feel a slight pressure on your ass.</span>") // It can't eject your asscheeks, but it'll try.
			return PREFERENCES_REFRESH
	else if(href_list["min"])
		if(copies > 1)
			copies--
	else if(href_list["add"])
		if(copies < maxcopies)
			copies++
	else if(href_list["aipic"])
		if(!istype(usr,/mob/living/silicon))
			return
		if(machine_stat & (BROKEN|NOPOWER))
			return

		if(toner >= 5)
			var/mob/living/silicon/tempAI = usr
			var/obj/item/camera/siliconcam/camera = tempAI.aiCamera

			if(!camera)
				return
			var/obj/item/photo/selection = camera.selectpicture()
			if (!selection)
				return

			var/obj/item/photo/p = photocopy(selection)
			if (p.desc == "")
				p.desc += "Copied by [tempAI.name]"
			else
				p.desc += " - Copied by [tempAI.name]"
			toner -= 5
			sleep(15)

	SSnanoui.update_uis(src)

/obj/machinery/photocopier/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/paper) || istype(O, /obj/item/photo) || istype(O, /obj/item/paper_bundle))
		if(!copyitem)
			if(!user.attempt_insert_item_for_installation(O, src))
				return
			copyitem = O
			to_chat(user, "<span class='notice'>You insert \the [O] into \the [src].</span>")
			playsound(loc, "sound/machines/click.ogg", 100, 1)
			flick(insert_anim, src)
		else
			to_chat(user, "<span class='notice'>There is already something in \the [src].</span>")
	else if(istype(O, /obj/item/toner))
		if(toner <= 10) //allow replacing when low toner is affecting the print darkness
			if(!user.attempt_consume_item_for_construction(O))
				return
			to_chat(user, "<span class='notice'>You insert the toner cartridge into \the [src].</span>")
			var/obj/item/toner/T = O
			toner += T.toner_amount
			qdel(T)
		else
			to_chat(user, "<span class='notice'>This cartridge is not yet ready for replacement! Use up the rest of the toner.</span>")
	else if(O.is_wrench())
		playsound(loc, O.tool_sound, 50, 1)
		anchored = !anchored
		to_chat(user, "<span class='notice'>You [anchored ? "wrench" : "unwrench"] \the [src].</span>")
	else if(default_deconstruction_screwdriver(user, O))
		return
	else if(default_deconstruction_crowbar(user, O))
		return

	return

/obj/machinery/photocopier/legacy_ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if(prob(50))
				qdel(src)
			else
				if(toner > 0)
					new /obj/effect/debris/cleanable/blood/oil(get_turf(src))
					toner = 0
		else
			if(prob(50))
				if(toner > 0)
					new /obj/effect/debris/cleanable/blood/oil(get_turf(src))
					toner = 0
	return

/obj/machinery/photocopier/proc/copy(var/obj/item/paper/copy, var/need_toner=1)
	var/obj/item/paper/c = new /obj/item/paper (loc)
	if(toner > 10)	//lots of toner, make it dark
		c.info = "<font color = #101010>"
	else			//no toner? shitty copies for you!
		c.info = "<font color = #808080>"
	var/copied = html_decode(copy.info)
	copied = replacetext(copied, "<font face=\"[c.deffont]\" color=", "<font face=\"[c.deffont]\" nocolor=")	//state of the art techniques in action
	copied = replacetext(copied, "<font face=\"[c.crayonfont]\" color=", "<font face=\"[c.crayonfont]\" nocolor=")	//This basically just breaks the existing color tag, which we need to do because the innermost tag takes priority.
	c.info += copied
	c.info += "</font>"//</font>
	c.name = copy.name // -- Doohl
	c.fields = copy.fields
	c.stamps = copy.stamps
	c.stamped = copy.stamped
	c.ico = copy.ico
	c.offset_x = copy.offset_x
	c.offset_y = copy.offset_y
	var/list/temp_overlays = copy.overlays     //Iterates through stamps
	var/image/img                                //and puts a matching
	for (var/j = 1, j <= min(temp_overlays.len, copy.ico.len), j++) //gray overlay onto the copy
		if (findtext(copy.ico[j], "cap") || findtext(copy.ico[j], "cent"))
			img = image('icons/obj/bureaucracy.dmi', "paper_stamp-circle")
		else if (findtext(copy.ico[j], "deny"))
			img = image('icons/obj/bureaucracy.dmi', "paper_stamp-x")
		else
			img = image('icons/obj/bureaucracy.dmi', "paper_stamp-dots")
		img.pixel_x = copy.offset_x[j]
		img.pixel_y = copy.offset_y[j]
		c.add_overlay(img)
	c.updateinfolinks()
	if(need_toner)
		toner--
	if(toner == 0)
		playsound(loc, "sound/machines/buzz-sigh.ogg", 100)
		visible_message("<span class='notice'>A red light on \the [src] flashes, indicating that it is out of toner.</span>")
	return c


/obj/machinery/photocopier/proc/photocopy(var/obj/item/photo/photocopy, var/need_toner=1)
	var/obj/item/photo/p = photocopy.copy()
	p.loc = src.loc

	var/icon/I = icon(photocopy.icon, photocopy.icon_state)
	if(toner > 10)	//plenty of toner, go straight greyscale
		I.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))		//I'm not sure how expensive this is, but given the many limitations of photocopying, it shouldn't be an issue.
		p.img.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
		p.tiny.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
	else			//not much toner left, lighten the photo
		I.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(100,100,100))
		p.img.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(100,100,100))
		p.tiny.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(100,100,100))
	p.icon = I
	if(need_toner)
		toner -= 5	//photos use a lot of ink!
	if(toner < 0)
		toner = 0
		playsound(loc, "sound/machines/buzz-sigh.ogg", 100)
		visible_message("<span class='notice'>A red light on \the [src] flashes, indicating that it is out of toner.</span>")

	return p

/obj/machinery/photocopier/proc/copyass(mob/user)
	var/icon/temp_img
	if(!has_buckled_mobs()) // Are there no mobs buckled to the photocopier?
		return
	var/mob/sitter = buckled_mobs[1] // You have to be sitting on the copier/buckled to it and either be a xeno or a human without clothes on that cover your ass.
	if(ishuman(sitter)) // Suit checks are in can_buckle_mobs at the bottom of the file.
		var/mob/living/carbon/human/H = sitter // All human subtypes.
		var/species_to_check = H.species.get_true_name()
		if(species_to_check == SPECIES_CUSTOM || species_to_check == SPECIES_XENOCHIMERA) // Are we a custom species, or Xenochimera? If so, what is the base icon sprite for our species?
			species_to_check = H.species.base_species // Grab the base species and use that as the 'species' for the purpose of printing off your asscheeks.
		switch(species_to_check)
			if(SPECIES_HUMAN)
				temp_img = icon('icons/obj/butts.dmi', "human")
			if(SPECIES_TAJ)
				temp_img = icon('icons/obj/butts.dmi', "tajaran")
			if(SPECIES_UNATHI)
				temp_img = icon('icons/obj/butts.dmi', "unathi")
			if(SPECIES_UNATHI_DIGI)
				temp_img = icon('icons/obj/butts.dmi', "unathi")
			if(SPECIES_SKRELL)
				temp_img = icon('icons/obj/butts.dmi', "skrell")
			if(SPECIES_VOX)
				temp_img = icon('icons/obj/butts.dmi', "vox")
			if(SPECIES_DIONA)
				temp_img = icon('icons/obj/butts.dmi', "diona")
			if(SPECIES_PROMETHEAN)
				temp_img = icon('icons/obj/butts.dmi', "slime")
			if(SPECIES_VULPKANIN)
				temp_img = icon('icons/obj/butts.dmi', "vulp")
			if(SPECIES_PROTEAN)
				temp_img = icon('icons/obj/butts.dmi', "machine")
			if(SPECIES_WEREBEAST)
				temp_img = icon('icons/obj/butts.dmi', "vulp") // Give Werewolves their own thicc'er than a boal of oatmeal ass sprite someday?
			if(SPECIES_XENOHYBRID, SPECIES_XENO, SPECIES_XENO_DRONE, SPECIES_XENO_HUNTER, SPECIES_XENO_QUEEN, SPECIES_XENO_SENTINEL) // Xenos + Xenohybrids have their own asses, thanks to Pybro.
				temp_img = icon('icons/obj/butts.dmi', "xeno")
			if(SPECIES_ZORREN_HIGH)
				temp_img = icon('icons/obj/butts.dmi', "vulp") // placeholder until we get zorren butts.
//			if(SPECIES_FENNEC) Species not present on Cit RP
//				temp_img = icon('icons/obj/butts.dmi', "vulp") // placeholder until we get fennec butts.
			if(SPECIES_AKULA)
				temp_img = icon('icons/obj/butts.dmi', "xeno") // placeholder until we get proper sharkbutt. AKULA BE THICC ASS SHARKS MMMMMMMMMMMMMMKAY?
			/* // Commented out because no icons exist, BUT if someone wants to sprite some more ASSCHEEKS, then just uncomment these and you have asses for each species. - Rykka.
			if(SPECIES_TESHARI)
				temp_img = icon('icons/obj/butts.dmi', "tesh")
			if(SPECIES_SHADEKIN || SPECIES_SHADEKIN_CREW)
				temp_img = icon('icons/obj/butts.dmi', "shadekin")
			if(SPECIES_ALRAUNE)
				temp_img = icon('icons/obj/butts.dmi', "alraune")
			if(SPECIES_NEVREAN)
				temp_img = icon('icons/obj/butts.dmi', "nevrean")
			if(SPECIES_RAPALA)
				temp_img = icon('icons/obj/butts.dmi', "rapala")
			if(SPECIES_ZADDAT)
				temp_img = icon('icons/obj/butts.dmi', "zaddat")
			if(SPECIES_SERGAL)
				temp_img = icon('icons/obj/butts.dmi', "sergal")
			*/
			if(SPECIES_APIDAEN)
				temp_img = icon('icons/obj/butts.dmi', "human") // placeholder until I make bug butts.
			else // Sanity/Safety check - does their species not show up or not work, or did something fail, but they're DEFINITELY a /human/ subtype? Print the 'default' ass.
				temp_img = icon('icons/obj/butts.dmi', "human")
	else if(istype(sitter,/mob/living/silicon/robot/drone)) // Are we a drone?
		temp_img = icon('icons/obj/butts.dmi', "drone")
	else if(istype(sitter,/mob/living/carbon/alien/diona)) // Are we a nymph, instead of a full-grown Diona?
		temp_img = icon('icons/obj/butts.dmi', "nymph")
	else
		return
	var/obj/item/photo/p = new /obj/item/photo (loc)
	p.desc = "You see [sitter]'s ass on the photo."
	p.pixel_x = rand(-10, 10)
	p.pixel_y = rand(-10, 10)
	p.img = temp_img
	var/icon/small_img = icon(temp_img) // Icon() is needed or else temp_img will be rescaled too >.>
	var/icon/ic = icon('icons/obj/items.dmi',"photo")
	small_img.Scale(8, 8)
	ic.Blend(small_img,ICON_OVERLAY, 10, 13)
	p.icon = ic
	toner -= 10 // PHOTOCOPYING YOUR ASS IS EXPENSIVE (And so you can't just spam it a bunch).
	if(toner < 0)
		toner = 0
		playsound(loc, "sound/machines/buzz-sigh.ogg", 100)
		visible_message("<span class='notice'>A red light on \the [src] flashes, indicating that it is out of toner.</span>")
	return p

//If need_toner is 0, the copies will still be lightened when low on toner, however it will not be prevented from printing. TODO: Implement print queues for fax machines and get rid of need_toner
/obj/machinery/photocopier/proc/bundlecopy(var/obj/item/paper_bundle/bundle, var/need_toner=1)
	var/obj/item/paper_bundle/p = new /obj/item/paper_bundle (src)
	for(var/obj/item/W in bundle.pages)
		if(toner <= 0 && need_toner)
			toner = 0
			playsound(loc, "sound/machines/buzz-sigh.ogg", 100)
			visible_message("<span class='notice'>A red light on \the [src] flashes, indicating that it is out of toner.</span>")
			break

		if(istype(W, /obj/item/paper))
			W = copy(W)
		else if(istype(W, /obj/item/photo))
			W = photocopy(W)
		W.loc = p
		p.pages += W

	p.loc = src.loc
	p.update_icon()
	p.icon_state = "paper_words"
	p.name = bundle.name
	p.pixel_y = rand(-8, 8)
	p.pixel_x = rand(-9, 9)
	return p

/obj/machinery/photocopier/can_buckle_mob(mob/M, flags, mob/user, semantic)
	for(var/obj/item/clothing/C in M)
		if(M.is_holding(C))
			continue
		if((C.body_parts_covered & LOWER_TORSO) && !istype(C,/obj/item/clothing/under/permit))
			to_chat(user, "<span class='warning'>One needs to not be wearing pants to photocopy one's ass...</span>")
			return FALSE
	return ..()

/obj/item/toner
	name = "toner cartridge"
	icon = 'icons/obj/device.dmi'
	icon_state = "tonercartridge"
	var/toner_amount = 30
