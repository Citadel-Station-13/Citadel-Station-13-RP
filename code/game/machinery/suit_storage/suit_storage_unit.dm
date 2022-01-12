//////////////////////////////////////
// SUIT STORAGE UNIT /////////////////
//////////////////////////////////////

/obj/machinery/suit_storage_unit
	name = "Suit Storage Unit"
	desc = "An industrial U-Stor-It Storage unit designed to accomodate all kinds of space suits. Its on-board equipment also allows the user to decontaminate the contents through a UV-ray purging cycle. There's a warning label dangling from the control pad, reading \"STRICTLY NO BIOLOGICALS IN THE CONFINES OF THE UNIT\"."
	icon = 'icons/obj/suitstorage.dmi'
	icon_state = "suitstorage000000100" //order is: [has helmet][has suit][has human][is open][is locked][is UV cycling][is powered][is dirty/broken] [is superUVcycling]
	anchored = 1
	density = 1
	var/mob/living/carbon/human/OCCUPANT = null
	var/obj/item/clothing/suit/space/SUIT = null
	var/SUIT_TYPE = null
	var/obj/item/clothing/head/helmet/space/HELMET = null
	var/HELMET_TYPE = null
	var/obj/item/clothing/mask/MASK = null  //All the stuff that's gonna be stored insiiiiiiiiiiiiiiiiiiide, nyoro~n
	var/MASK_TYPE = null //Erro's idea on standarising SSUs whle keeping creation of other SSU types easy: Make a child SSU, name it something then set the TYPE vars to your desired suit output. New() should take it from there by itself.
	var/obj/item/clothing/shoes/magboots/BOOT = null
	var/BOOT_TYPE = null
	var/isopen = 0
	var/islocked = 0
	var/isUV = 0
	var/ispowered = 1 //starts powered
	var/isbroken = 0
	var/issuperUV = 0
	var/panelopen = 0
	var/safetieson = 1
	var/cycletime_left = 0


/obj/machinery/suit_storage_unit/Initialize(mapload, newdir)
	. = ..()
	update_icon()
	if(SUIT_TYPE)
		SUIT = new SUIT_TYPE(src)
	if(HELMET_TYPE)
		HELMET = new HELMET_TYPE(src)
	if(MASK_TYPE)
		MASK = new MASK_TYPE(src)
	if(BOOT_TYPE)
		BOOT = new BOOT_TYPE(src)

/obj/machinery/suit_storage_unit/update_icon()
	var/hashelmet = 0
	var/hassuit = 0
	var/hashuman = 0
	if(HELMET)
		hashelmet = 1
	if(SUIT)
		hassuit = 1
	if(OCCUPANT)
		hashuman = 1
	icon_state = text("suitstorage[][][][][][][][][]", hashelmet, hassuit, hashuman, isopen, islocked, isUV, ispowered, isbroken, issuperUV)

/obj/machinery/suit_storage_unit/power_change()
	..()
	if(!(stat & NOPOWER))
		ispowered = 1
		update_icon()
	else
		spawn(rand(0, 15))
			ispowered = 0
			islocked = 0
			isopen = 1
			dump_everything()
			update_icon()

/obj/machinery/suit_storage_unit/ex_act(severity)
	switch(severity)
		if(1.0)
			if(prob(50))
				dump_everything() //So suits dont survive all the time
			qdel(src)
		if(2.0)
			if(prob(50))
				dump_everything()
				qdel(src)

/obj/machinery/suit_storage_unit/attack_hand(mob/user as mob)
	if(..())
		return
	if(stat & NOPOWER)
		return
	if(!user.IsAdvancedToolUser())
		return 0
	ui_interact(user)

/obj/machinery/suit_storage_unit/ui_state(mob/user)
	return GLOB.notcontained_state

/obj/machinery/suit_storage_unit/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SuitStorageUnit", name)
		ui.open()

/obj/machinery/suit_storage_unit/ui_data()
	var/list/data = list()

	data["broken"] = isbroken
	data["panelopen"] = panelopen

	data["locked"] = islocked
	data["open"] = isopen
	data["safeties"] = safetieson
	data["uv_active"] = isUV
	data["uv_super"] = issuperUV
	if(HELMET)
		data["helmet"] = HELMET.name
	else
		data["helmet"] = null
	if(SUIT)
		data["suit"] = SUIT.name
	else
		data["suit"] = null
	if(MASK)
		data["mask"] = MASK.name
	else
		data["mask"] = null
	if(BOOT)
		data["boots"] = BOOT.name
	else
		data["boots"] = null
	data["storage"] = null
	if(OCCUPANT)
		data["occupied"] = TRUE
	else
		data["occupied"] = FALSE
	return data

/obj/machinery/suit_storage_unit/ui_act(action, params) //I fucking HATE this proc
	if(..() || isUV || isbroken)
		return TRUE

	switch(action)
		if("door")
			toggle_open(usr)
			. = TRUE
		if("dispense")
			switch(params["item"])
				if("helmet")
					dispense_helmet(usr)
				if("mask")
					dispense_mask(usr)
				if("suit")
					dispense_suit(usr)
				if("boots")
					dispense_boots(usr)
			. = TRUE
		if("uv")
			start_UV(usr)
			. = TRUE
		if("lock")
			toggle_lock(usr)
			. = TRUE
		if("eject_guy")
			eject_occupant(usr)
			. = TRUE

	// Panel Open stuff
	if(!. && panelopen)
		switch(action)
			if("toggleUV")
				toggleUV(usr)
				. = TRUE
			if("togglesafeties")
				togglesafeties(usr)
				. = TRUE

	update_icon()
	add_fingerprint(usr)



/obj/machinery/suit_storage_unit/proc/toggleUV(mob/user as mob)
//	var/protected = 0
//	var/mob/living/carbon/human/H = user
	if(!panelopen)
		return

	/*if(istype(H)) //Let's check if the guy's wearing electrically insulated gloves
		if(H.gloves)
			var/obj/item/clothing/gloves/G = H.gloves
			if(istype(G,/obj/item/clothing/gloves/yellow))
				protected = 1

	if(!protected)
		playsound(src.loc, "sparks", 75, 1, -1)
		to_chat(user, "<font color='red'>You try to touch the controls but you get zapped. There must be a short circuit somewhere.</font>")
		return*/
	else  //welp, the guy is protected, we can continue
		if(issuperUV)
			to_chat(user, "You slide the dial back towards \"185nm\".")
			issuperUV = 0
		else
			to_chat(user, "You crank the dial all the way up to \"15nm\".")
			issuperUV = 1
		return


/obj/machinery/suit_storage_unit/proc/togglesafeties(mob/user as mob)
//	var/protected = 0
//	var/mob/living/carbon/human/H = user
	if(!panelopen) //Needed check due to bugs
		return

	/*if(istype(H)) //Let's check if the guy's wearing electrically insulated gloves
		if(H.gloves)
			var/obj/item/clothing/gloves/G = H.gloves
			if(istype(G,/obj/item/clothing/gloves/yellow))
				protected = 1

	if(!protected)
		playsound(src.loc, "sparks", 75, 1, -1)
		to_chat(user, "<font color='red'>You try to touch the controls but you get zapped. There must be a short circuit somewhere.</font>")
		return*/
	else
		to_chat(user, "You push the button. The coloured LED next to it changes.")
		safetieson = !safetieson


/obj/machinery/suit_storage_unit/proc/dispense_helmet(mob/user as mob)
	if(!HELMET)
		return //Do I even need this sanity check? Nyoro~n
	else
		HELMET.loc = src.loc
		HELMET = null
		return


/obj/machinery/suit_storage_unit/proc/dispense_suit(mob/user as mob)
	if(!SUIT)
		return
	else
		SUIT.loc = src.loc
		SUIT = null
		return


/obj/machinery/suit_storage_unit/proc/dispense_mask(mob/user as mob)
	if(!MASK)
		return
	else
		MASK.loc = src.loc
		MASK = null
		return

/obj/machinery/suit_storage_unit/proc/dispense_boots(mob/user as mob)
	if(!BOOT)
		return
	else
		BOOT.loc = src.loc
		BOOT = null
		return

/obj/machinery/suit_storage_unit/proc/dump_everything()
	islocked = 0 //locks go free
	if(SUIT)
		SUIT.loc = src.loc
		SUIT = null
	if(HELMET)
		HELMET.loc = src.loc
		HELMET = null
	if(MASK)
		MASK.loc = src.loc
		MASK = null
	if(BOOT)
		BOOT.loc = src.loc
		BOOT = null
	if(OCCUPANT)
		eject_occupant(OCCUPANT)
	return


/obj/machinery/suit_storage_unit/proc/toggle_open(mob/user as mob)
	if(islocked || isUV)
		to_chat(user, "<font color='red'>Unable to open unit.</font>")
		return
	if(OCCUPANT)
		eject_occupant(user)
		return  // eject_occupant opens the door, so we need to return
	isopen = !isopen
	return


/obj/machinery/suit_storage_unit/proc/toggle_lock(mob/user as mob)
	if(OCCUPANT && safetieson)
		to_chat(user, "<font color='red'>The Unit's safety protocols disallow locking when a biological form is detected inside its compartments.</font>")
		return
	if(isopen)
		return
	islocked = !islocked
	return


/obj/machinery/suit_storage_unit/proc/start_UV(mob/user as mob)
	if(isUV || isopen) //I'm bored of all these sanity checks
		return
	if(OCCUPANT && safetieson)
		to_chat(user, "<font color='red'><B>WARNING:</B> Biological entity detected in the confines of the Unit's storage. Cannot initiate cycle.</font>")
		return
	if(!HELMET && !MASK && !SUIT && !OCCUPANT) //shit's empty yo
		to_chat(user, "<font color='red'>Unit storage bays empty. Nothing to disinfect -- Aborting.</font>")
		return
	to_chat(user, "You start the Unit's cauterisation cycle.")
	cycletime_left = 20
	isUV = 1
	if(OCCUPANT && !islocked)
		islocked = 1 //Let's lock it for good measure
	update_icon()
	updateUsrDialog()

	var/i //our counter
	for(i=0,i<4,i++)
		sleep(50)
		if(OCCUPANT)
			OCCUPANT.apply_effect(50, IRRADIATE)
			var/obj/item/organ/internal/diona/nutrients/rad_organ = locate() in OCCUPANT.internal_organs
			if(!rad_organ)
				if(OCCUPANT.can_feel_pain())
					OCCUPANT.emote("scream")
				if(issuperUV)
					var/burndamage = rand(28,35)
					OCCUPANT.take_organ_damage(0,burndamage)
				else
					var/burndamage = rand(6,10)
					OCCUPANT.take_organ_damage(0,burndamage)
		if(i==3) //End of the cycle
			if(!issuperUV)
				if(HELMET)
					HELMET.clean_blood()
				if(SUIT)
					SUIT.clean_blood()
				if(MASK)
					MASK.clean_blood()
				if(BOOT)
					BOOT.clean_blood()
			else //It was supercycling, destroy everything
				if(HELMET)
					HELMET = null
				if(SUIT)
					SUIT = null
				if(MASK)
					MASK = null
				if(BOOT)
					BOOT = null
				visible_message("<font color='red'>With a loud whining noise, the Suit Storage Unit's door grinds open. Puffs of ashen smoke come out of its chamber.</font>", 3)
				isbroken = 1
				isopen = 1
				islocked = 0
				eject_occupant(OCCUPANT) //Mixing up these two lines causes bug. DO NOT DO IT.
			isUV = 0 //Cycle ends
	update_icon()
	updateUsrDialog()
	return

/*	spawn(200) //Let's clean dat shit after 20 secs  //Eh, this doesn't work
		if(HELMET)
			HELMET.clean_blood()
		if(SUIT)
			SUIT.clean_blood()
		if(MASK)
			MASK.clean_blood()
		isUV = 0 //Cycle ends
		update_icon()
		updateUsrDialog()

	var/i
	for(i=0,i<4,i++) //Gradually give the guy inside some damaged based on the intensity
		spawn(50)
			if(OCCUPANT)
				if(issuperUV)
					OCCUPANT.take_organ_damage(0,40)
					to_chat(user, "Test. You gave him 40 damage")
				else
					OCCUPANT.take_organ_damage(0,8)
					to_chat(user, "Test. You gave him 8 damage")
	return*/


/obj/machinery/suit_storage_unit/proc/cycletimeleft()
	if(cycletime_left >= 1)
		cycletime_left--
	return cycletime_left


/obj/machinery/suit_storage_unit/proc/eject_occupant(mob/user as mob)
	if(islocked)
		return

	if(!OCCUPANT)
		return
//	for(var/obj/O in src)
//		O.loc = src.loc

	if(OCCUPANT.client)
		if(user != OCCUPANT)
			to_chat(OCCUPANT, "<font color=#4F49AF>The machine kicks you out!</font>")
		if(user.loc != src.loc)
			to_chat(OCCUPANT, "<font color=#4F49AF>You leave the not-so-cozy confines of the SSU.</font>")

		OCCUPANT.client.eye = OCCUPANT.client.mob
		OCCUPANT.client.perspective = MOB_PERSPECTIVE
	OCCUPANT.loc = src.loc
	OCCUPANT = null
	if(!isopen)
		isopen = 1
	update_icon()
	return


/obj/machinery/suit_storage_unit/verb/get_out()
	set name = "Eject Suit Storage Unit"
	set category = "Object"
	set src in oview(1)

	if(usr.stat != 0)
		return
	eject_occupant(usr)
	add_fingerprint(usr)
	updateUsrDialog()
	update_icon()
	return


/obj/machinery/suit_storage_unit/verb/move_inside()
	set name = "Hide in Suit Storage Unit"
	set category = "Object"
	set src in oview(1)

	if(usr.stat != 0)
		return
	if(!isopen)
		to_chat(usr, "<font color='red'>The unit's doors are shut.</font>")
		return
	if(!ispowered || isbroken)
		to_chat(usr, "<font color='red'>The unit is not operational.</font>")
		return
	if((OCCUPANT) || (HELMET) || (SUIT))
		to_chat(usr, "<font color='red'>It's too cluttered inside for you to fit in!</font>")
		return
	visible_message("[usr] starts squeezing into the suit storage unit!", 3)
	if(do_after(usr, 10))
		usr.stop_pulling()
		usr.client.perspective = EYE_PERSPECTIVE
		usr.client.eye = src
		usr.loc = src
//		usr.metabslow = 1
		OCCUPANT = usr
		isopen = 0 //Close the thing after the guy gets inside
		update_icon()

//		for(var/obj/O in src)
//			qdel(O)

		add_fingerprint(usr)
		updateUsrDialog()
		return
	else
		OCCUPANT = null //Testing this as a backup sanity test
	return


/obj/machinery/suit_storage_unit/attackby(obj/item/I as obj, mob/user as mob)
	if(!ispowered)
		return
	if(I.is_screwdriver())
		panelopen = !panelopen
		playsound(src, I.usesound, 100, 1)
		to_chat(user, "<font color=#4F49AF>You [panelopen ? "open up" : "close"] the unit's maintenance panel.</font>")
		updateUsrDialog()
		return
	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I
		if(!(ismob(G.affecting)))
			return
		if(!isopen)
			to_chat(user, "<font color='red'>The unit's doors are shut.</font>")
			return
		if(!ispowered || isbroken)
			to_chat(user, "<font color='red'>The unit is not operational.</font>")
			return
		if((OCCUPANT) || (HELMET) || (SUIT)) //Unit needs to be absolutely empty
			to_chat(user, "<font color='red'>The unit's storage area is too cluttered.</font>")
			return
		visible_message("[user] starts putting [G.affecting.name] into the Suit Storage Unit.", 3)
		if(do_after(user, 20))
			if(!G || !G.affecting) return //derpcheck
			var/mob/M = G.affecting
			if(M.client)
				M.client.perspective = EYE_PERSPECTIVE
				M.client.eye = src
			M.loc = src
			OCCUPANT = M
			isopen = 0 //close ittt

			//for(var/obj/O in src)
			//	O.loc = src.loc
			add_fingerprint(user)
			qdel(G)
			updateUsrDialog()
			update_icon()
			return
		return
	if(istype(I,/obj/item/clothing/suit/space))
		if(!isopen)
			return
		var/obj/item/clothing/suit/space/S = I
		if(SUIT)
			to_chat(user, "<font color=#4F49AF>The unit already contains a suit.</font>")
			return
		to_chat(user, "You load the [S.name] into the storage compartment.")
		user.drop_item()
		S.loc = src
		SUIT = S
		update_icon()
		updateUsrDialog()
		return
	if(istype(I,/obj/item/clothing/head/helmet))
		if(!isopen)
			return
		var/obj/item/clothing/head/helmet/H = I
		if(HELMET)
			to_chat(user, "<font color=#4F49AF>The unit already contains a helmet.</font>")
			return
		to_chat(user, "You load the [H.name] into the storage compartment.")
		user.drop_item()
		H.loc = src
		HELMET = H
		update_icon()
		updateUsrDialog()
		return
	if(istype(I,/obj/item/clothing/mask))
		if(!isopen)
			return
		var/obj/item/clothing/mask/M = I
		if(MASK)
			to_chat(user, "<font color=#4F49AF>[src] already contains [MASK].</font>")
			return
		to_chat(user, "You load the [M.name] into the storage compartment.")
		user.drop_item()
		M.loc = src
		MASK = M
		update_icon()
		updateUsrDialog()
		return
	if(istype(I,/obj/item/clothing/shoes/magboots))
		if(!isopen)
			return
		var/obj/item/clothing/shoes/magboots/B = I
		if(BOOT)
			to_chat(user, "<font color=#4F49AF>The unit already contains [BOOT].</font>")
			return
		user.drop_item()
		B.loc = src
		BOOT = B
		update_icon()
		updateUsrDialog()
		return
	update_icon()
	updateUsrDialog()
	return


/obj/machinery/suit_storage_unit/attack_ai(mob/user as mob)
	return attack_hand(user)
