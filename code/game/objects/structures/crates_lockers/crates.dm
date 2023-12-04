//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/structure/closet/crate
	name = "crate"
	desc = "A rectangular steel crate."
	icon = 'icons/obj/storage.dmi'
	icon_state = "crate"
	//closet_appearance = /singleton/closet_appearance/crate
	climb_allowed = TRUE
	depth_projected = TRUE
	use_old_icon_update = TRUE
	depth_level = 8
	armor_type = /datum/armor/object/medium
	var/points_per_crate = 5
//	mouse_drag_pointer = MOUSE_ACTIVE_POINTER	//???
	var/rigged = 0

/obj/structure/closet/crate/CanPass(atom/movable/AM, turf/T)
	. = ..()
	if(. || !istype(AM, /obj/item))
		return
	var/obj/item/I = AM
	return I.throwing

/obj/structure/closet/crate/can_open()
	return 1

/obj/structure/closet/crate/can_close()
	return 1

/obj/structure/closet/crate/open()
	if(src.opened)
		return 0
	if(!src.can_open())
		return 0

	if(rigged && locate(/obj/item/radio/electropack) in src)
		if(isliving(usr))
			var/mob/living/L = usr
			if(L.electrocute_act(17, src))
				var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
				s.set_up(5, 1, src)
				s.start()
				if(!CHECK_MOBILITY(usr, MOBILITY_CAN_MOVE))
					return 2

	playsound(src.loc, 'sound/machines/click.ogg', 15, 1, -3)
	for(var/obj/O in src)
		O.forceMove(get_turf(src))
	icon_state = icon_opened
	src.opened = 1
	shake_climbers()
	return 1

/obj/structure/closet/crate/close()
	if(!src.opened)
		return 0
	if(!src.can_close())
		return 0

	playsound(src.loc, 'sound/machines/click.ogg', 15, 1, -3)
	var/itemcount = 0
	for(var/obj/O in get_turf(src))
		if(itemcount >= storage_capacity)
			break
		if(O.density || O.anchored || istype(O,/obj/structure/closet))
			continue
		if(istype(O, /obj/structure/bed)) //This is only necessary because of rollerbeds and swivel chairs.
			var/obj/structure/bed/B = O
			if(B.has_buckled_mobs())
				continue
		O.forceMove(src)
		itemcount++

	icon_state = icon_closed
	src.opened = 0
	return 1

/obj/structure/closet/crate/attackby(obj/item/W as obj, mob/user as mob)
	if(opened)
		if(isrobot(user))
			return
		if(W.loc != user) // This should stop mounted modules ending up outside the module.
			return
		user.transfer_item_to_loc(W, loc)
	else if(istype(W, /obj/item/packageWrap))
		return
	else if(istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = W
		if(rigged)
			to_chat(user, "<span class='notice'>[src] is already rigged!</span>")
			return
		if (C.use(1))
			to_chat(user, "<span class='notice'>You rig [src].</span>")
			rigged = 1
			return
	else if(istype(W, /obj/item/radio/electropack))
		if(rigged)
			if(!user.attempt_insert_item_for_installation(W, src))
				return
			to_chat(user, "<span class='notice'>You attach [W] to [src].</span>")
			return
	else if(W.is_wirecutter())
		if(rigged)
			to_chat(user, "<span class='notice'>You cut away the wiring.</span>")
			playsound(src.loc, W.tool_sound, 100, 1)
			rigged = 0
			return
	else if(istype(W, /obj/item/extraction_pack))
		src.close()
		return

	else return attack_hand(user)

/obj/structure/closet/crate/legacy_ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/obj/O in src.contents)
				qdel(O)
			qdel(src)
			return
		if(2.0)
			for(var/obj/O in src.contents)
				if(prob(50))
					qdel(O)
			qdel(src)
			return
		if(3.0)
			if (prob(50))
				qdel(src)
			return
		else
	return

/obj/structure/closet/crate/update_icon_old()
	if(!opened)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]open"

/obj/structure/closet/crate/secure
	desc = "A secure crate."
	name = "Secure crate"
	icon_state = "securecrate"
	var/redlight = "securecrater"
	var/greenlight = "securecrateg"
	var/sparks = "securecratesparks"
	var/emag = "securecrateemag"
	broken = 0
	locked = 1
	//closet_appearance = /singleton/closet_appearance/crate/secure
	var/tamper_proof = 0

/obj/structure/closet/crate/secure/Initialize(mapload)
	. = ..()

	if(locked)
		set_overlays(redlight)
	else
		set_overlays(greenlight)

/obj/structure/closet/crate/secure/can_open()
	return !locked

/obj/structure/closet/crate/secure/togglelock(mob/user as mob)
	if(src.opened)
		to_chat(user, "<span class='notice'>Close the crate first.</span>")
		return
	if(src.broken)
		to_chat(user, "<span class='warning'>The crate appears to be broken.</span>")
		return
	if(src.allowed(user))
		set_locked(!locked, user)
	else
		to_chat(user, "<span class='notice'>Access Denied</span>")

/obj/structure/closet/crate/secure/proc/set_locked(var/newlocked, mob/user = null)
	if(locked == newlocked)
		return

	locked = newlocked
	if(user)
		for(var/mob/O in viewers(user, 3))
			O.show_message( "<span class='notice'>The crate has been [locked ? null : "un"]locked by [user].</span>", 1)

	set_overlays(locked ? redlight : greenlight)

/obj/structure/closet/crate/secure/verb_togglelock()
	set src in oview(1) // One square distance
	set category = "Object"
	set name = "Toggle Lock"

	if(!CHECK_MOBILITY(usr, MOBILITY_CAN_USE)) // Don't use it if you're not able to! Checks for stuns, ghost and restrain
		return

	if(ishuman(usr) || isrobot(usr))
		src.add_fingerprint(usr)
		src.togglelock(usr)
	else
		to_chat(usr, "<span class='warning'>This mob type can't use this verb.</span>")

/obj/structure/closet/crate/secure/attack_hand(mob/user, list/params)
	src.add_fingerprint(user)
	if(locked)
		src.togglelock(user)
	else
		src.toggle(user)

/obj/structure/closet/crate/secure/attackby(obj/item/W as obj, mob/user as mob)
	if(is_type_in_list(W, list(/obj/item/packageWrap, /obj/item/stack/cable_coil, /obj/item/radio/electropack, /obj/item/tool/wirecutters)))
		return ..()
	if(istype(W, /obj/item/melee/energy/blade))
		emag_act(INFINITY, user)
	if(!opened)
		src.togglelock(user)
		return
	return ..()

/obj/structure/closet/crate/secure/emag_act(remaining_charges, mob/user)
	if(!broken)
		cut_overlays()
		var/list/overlays_to_add = list()
		overlays_to_add += emag
		overlays_to_add += sparks
		add_overlay(overlays_to_add)
		compile_overlays()
		spawn(6)
			cut_overlay(sparks) //Tried lots of stuff but nothing works right. so i have to use this *sadface*
			compile_overlays()
		playsound(src.loc, "sparks", 60, 1)
		locked = 0
		broken = 1
		to_chat(user, "<span class='notice'>You unlock \the [src].</span>")
		update_icon()
		return 1

/obj/structure/closet/crate/secure/emp_act(severity)
	for(var/obj/O in src)
		O.emp_act(severity)
	if(!broken && !opened  && prob(50/severity))
		cut_overlays()
		if(!locked)
			locked = 1
			add_overlay(redlight)
		else
			add_overlay(list(emag, sparks))
			compile_overlays()
			spawn(6)
				cut_overlay(sparks) //Tried lots of stuff but nothing works right. so i have to use this *sadface*
				compile_overlays()
			playsound(src.loc, 'sound/effects/sparks4.ogg', 75, 1)
			locked = 0
			update_icon()
	if(!opened && prob(20/severity))
		if(!locked)
			open()
		else
			req_access = list()
			req_access += pick(get_all_station_access())
	..()

/obj/structure/closet/crate/secure/bullet_act(var/obj/projectile/Proj)
	if(!(Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		return

	if(locked && tamper_proof && integrity <= Proj.damage)
		if(tamper_proof == 2) // Mainly used for events to prevent any chance of opening the box improperly.
			visible_message("<font color='red'><b>The anti-tamper mechanism of [src] triggers an explosion!</b></font>")
			var/turf/T = get_turf(src.loc)
			explosion(T, 0, 0, 0, 1) // Non-damaging, but it'll alert security.
			qdel(src)
			return
		var/open_chance = rand(1,5)
		switch(open_chance)
			if(1)
				visible_message("<font color='red'><b>The anti-tamper mechanism of [src] causes an explosion!</b></font>")
				var/turf/T = get_turf(src.loc)
				explosion(T, 0, 0, 0, 1) // Non-damaging, but it'll alert security.
				qdel(src)
			if(2 to 4)
				visible_message("<font color='red'><b>The anti-tamper mechanism of [src] causes a small fire!</b></font>")
				for(var/atom/movable/A as mob|obj in src) // For every item in the box, we spawn a pile of ash.
					new /obj/effect/debris/cleanable/ash(src.loc)
				new /atom/movable/fire(src.loc)
				qdel(src)
			if(5)
				visible_message("<font color='green'><b>The anti-tamper mechanism of [src] fails!</b></font>")
		return

	..()

	return


/obj/structure/closet/crate/plastic
	name = "plastic crate"
	desc = "A rectangular plastic crate."
	icon_state = "plasticcrate"
	//closet_appearance = /singleton/closet_appearance/crate/plastic
	points_per_crate = 1	//5 crates per ordered crate, +5 for the crate it comes in.

/obj/structure/closet/crate/internals
	name = "internals crate"
	desc = "A internals crate."
	icon_state = "o2crate"
	//closet_appearance = /singleton/closet_appearance/crate/oxygen

/obj/structure/closet/crate/trashcart
	name = "trash cart"
	desc = "A heavy, metal trashcart with wheels."
	icon_state = "trashcart"
	//closet_appearance = /singleton/closet_appearance/cart/trash

/*these aren't needed anymore
/obj/structure/closet/crate/hat
	desc = "A crate filled with Valuable Collector's Hats!."
	name = "Hat Crate"
	icon_state = "crate"
	icon_opened = "crateopen"
	icon_closed = "crate"

/obj/structure/closet/crate/contraband
	name = "Poster crate"
	desc = "A random assortment of posters manufactured by providers NOT listed under NanoTrasen's whitelist."
	icon_state = "crate"
	icon_opened = "crateopen"
	icon_closed = "crate"
*/

/obj/structure/closet/crate/medical
	name = "medical crate"
	desc = "A medical crate."
	icon_state = "medicalcrate"
	//closet_appearance = /singleton/closet_appearance/crate/medical

/obj/structure/closet/crate/rcd
	name = "\improper RCD crate"
	desc = "A crate with rapid construction device."
	icon_state = "engi_crate"
	//closet_appearance = /singleton/closet_appearance/crate/engineering

	starts_with = list(
		/obj/item/rcd_ammo = 3,
		/obj/item/rcd)

/obj/structure/closet/crate/solar
	name = "solar pack crate"
	icon_state = "engi_crate"
	//closet_appearance = /singleton/closet_appearance/crate/engineering

	starts_with = list(
		/obj/item/solar_assembly = 21,
		/obj/item/circuitboard/solar_control,
		/obj/item/tracker_electronics,
		/obj/item/paper/solar)

/obj/structure/closet/crate/freezer
	name = "freezer"
	desc = "A freezer."
	icon_state = "freezer"
	//closet_appearance = /singleton/closet_appearance/crate/freezer
	var/target_temp = T0C - 40
	var/cooling_power = 40

/obj/structure/closet/crate/freezer/return_air()
	var/datum/gas_mixture/gas = (..())
	if(!gas)	return null
	var/datum/gas_mixture/newgas = new/datum/gas_mixture()
	newgas.copy_from(gas)
	if(newgas.temperature <= target_temp)	return

	if((newgas.temperature - cooling_power) > target_temp)
		newgas.temperature -= cooling_power
	else
		newgas.temperature = target_temp
	return newgas

/obj/structure/closet/crate/freezer/Entered(var/atom/movable/AM)
	if(istype(AM, /obj/item/organ))
		var/obj/item/organ/O = AM
		O.preserve(CRATE_FREEZER_TRAIT)
	..()

/obj/structure/closet/crate/freezer/Exited(var/atom/movable/AM)
	if(istype(AM, /obj/item/organ))
		var/obj/item/organ/O = AM
		O.unpreserve(CRATE_FREEZER_TRAIT)
	..()

/obj/structure/closet/crate/freezer/rations //Fpr use in the escape shuttle
	name = "emergency rations"
	desc = "A crate of emergency rations."

	starts_with = list(
		/obj/random/mre = 6)

/obj/structure/closet/crate/freezer/centauri
	name = "centauri co freezer"
	desc = "A box of various sodas."

/obj/structure/closet/crate/bin
	name = "large bin"
	desc = "A large bin."
	icon = 'icons/obj/storage.dmi'
	icon_state = "largebin"
	//closet_appearance = /singleton/closet_appearance/cart/trash

/obj/structure/closet/crate/bin/attackby(obj/item/W as obj, mob/user as mob)
	if(W.is_wrench() && !opened)
		if(anchored)
			user.show_message(SPAN_NOTICE("[src] can now be moved."))
			playsound(src, W.tool_sound, 50, 1)
			anchored = FALSE

		else if(!anchored)
			user.show_message(SPAN_NOTICE("[src] is now secured."))
			playsound(src, W.tool_sound, 50, 1)
			anchored = TRUE
	else
		..()

/obj/structure/closet/crate/radiation
	name = "radioactive gear crate"
	desc = "A crate with a radiation sign on it."
	icon_state = "radiation"
	//closet_appearance = /singleton/closet_appearance/crate/radiation

	starts_with = list(
		/obj/item/clothing/suit/radiation = 4,
		/obj/item/clothing/head/radiation = 4)


/obj/structure/closet/crate/secure/weapon
	name = "weapons crate"
	desc = "A secure weapons crate."
	icon_state = "weaponcrate"
	//closet_appearance = /singleton/closet_appearance/crate/secure/weapon


/obj/structure/closet/crate/secure/phoron
	name = "phoron crate"
	desc = "A secure phoron crate."
	icon_state = "phoroncrate"
	//closet_appearance = /singleton/closet_appearance/crate/secure/hazard


/obj/structure/closet/crate/secure/gear
	name = "gear crate"
	desc = "A secure gear crate."
	icon_state = "secgearcrate"
	//closet_appearance = /singleton/closet_appearance/crate/secure/weapon


/obj/structure/closet/crate/secure/hydrosec
	name = "secure hydroponics crate"
	desc = "A crate with a lock on it, painted in the scheme of the station's botanists."
	icon_state = "hydrosecurecrate"
	//closet_appearance = /singleton/closet_appearance/crate/secure/hydroponics


/obj/structure/closet/crate/secure/engineering
	desc = "A crate with a lock on it, painted in the scheme of the station's engineers."
	name = "secure engineering crate"
	icon_state = "engi_secure_crate"
	//closet_appearance = /singleton/closet_appearance/crate/secure/engineering


/obj/structure/closet/crate/secure/science
	name = "secure science crate"
	desc = "A crate with a lock on it, painted in the scheme of the station's scientists."
	icon_state = "scisecurecrate"
	//closet_appearance = /singleton/closet_appearance/crate/secure/hazard


/obj/structure/closet/crate/secure/bin
	name = "secure bin"
	desc = "A secure bin."
	icon_state = "largebins"
	redlight = "largebinr"
	greenlight = "largebing"
	sparks = "largebinsparks"
	emag = "largebinemag"
	//closet_appearance = /singleton/closet_appearance/cart/secure

/obj/structure/closet/crate/large
	name = "large crate"
	desc = "A hefty metal crate."
	icon = 'icons/obj/storage.dmi'
	icon_state = "largemetal"
	//closet_appearance = /singleton/closet_appearance/large_crate


/obj/structure/closet/crate/large/close()
	. = ..()
	if (.)//we can hold up to one large item
		var/found = 0
		for(var/obj/structure/S in src.loc)
			if(S == src)
				continue
			if(!S.anchored)
				found = 1
				S.forceMove(src)
				break
		if(!found)
			for(var/obj/machinery/M in src.loc)
				if(!M.anchored)
					M.forceMove(src)
					break
	return


/obj/structure/closet/crate/secure/large
	name = "large crate"
	desc = "A hefty metal crate with an electronic locking system."
	icon = 'icons/obj/storage.dmi'
	icon_state = "largemetalsecure"
	redlight = "largemetalr"
	greenlight = "largemetalg"
	//closet_appearance = /singleton/closet_appearance/large_crate/secure


/obj/structure/closet/crate/secure/large/close()
	. = ..()
	if (.)//we can hold up to one large item
		var/found = 0
		for(var/obj/structure/S in src.loc)
			if(S == src)
				continue
			if(!S.anchored)
				found = 1
				S.forceMove(src)
				break
		if(!found)
			for(var/obj/machinery/M in src.loc)
				if(!M.anchored)
					M.forceMove(src)
					break
	return


//fluff variant
/obj/structure/closet/crate/secure/large/reinforced
	desc = "A hefty, reinforced metal crate with an electronic locking system."
	icon_state = "largermetal"

/obj/structure/closet/crate/engineering
	name = "engineering crate"
	icon_state = "engi_crate"
	//closet_appearance = /singleton/closet_appearance/crate/engineering

/obj/structure/closet/crate/engineering/electrical
	icon_state = "engi_e_crate"
	//closet_appearance = /singleton/closet_appearance/crate/engineering

/obj/structure/closet/crate/science
	name = "science crate"
	icon_state = "scicrate"
	//closet_appearance = /singleton/closet_appearance/crate/science

/obj/structure/closet/crate/robotics
	name = "robotics supply crate"
	icon_state = "scicrate"
	//closet_appearance = /singleton/closet_appearance/crate/science

	starts_with = list(
		/obj/item/stack/material/plasteel = 10,
		/obj/fiftyspawner/steel = 5,
		/obj/fiftyspawner/glass = 4,
		/obj/item/cell/high = 4,
		/obj/item/stack/cable_coil = 2,
		/obj/item/flash/synthetic = 8,
		/obj/item/healthanalyzer = 4,
		/obj/item/storage/firstaid = 4)

/obj/structure/closet/crate/hydroponics
	name = "hydroponics crate"
	desc = "All you need to destroy those pesky weeds and pests."
	icon_state = "hydrocrate"
	//closet_appearance = /singleton/closet_appearance/crate/hydroponics

/obj/structure/closet/crate/hydroponics/prespawned
	starts_with = list(
		/obj/item/reagent_containers/spray/plantbgone = 2,
		/obj/item/material/minihoe)

/obj/structure/closet/crate/hydroponics/exotic
	name = "exotic seeds crate"
	desc = "All you need to destroy that pesky planet."

	starts_with = list(
		/obj/item/seeds/random = 6,
		/obj/item/seeds/replicapod = 2,
		/obj/item/seeds/ambrosiavulgarisseed = 2,
		/obj/item/seeds/kudzuseed,
		/obj/item/seeds/libertymycelium,
		/obj/item/seeds/reishimycelium)

/obj/structure/closet/crate/medical/blood
	icon_state = "blood"

//TSCs
//Add in icons instead of this declare thing? Sort out what's causing this.
/obj/structure/closet/crate/corporate
	desc = "YOU SHOULDN'T SEE ME!"
	icon = 'icons/obj/storage.dmi'
	icon_state = "crate"
	use_old_icon_update = TRUE

/obj/structure/closet/crate/corporate/aether
	desc = "A crate painted in the colours of Aether Atmospherics and Recycling."
	icon_state = "aether"
	//closet_appearance = /singleton/closet_appearance/crate/branded/aether

/obj/structure/closet/crate/corporate/centauri
	desc = "A crate decorated with the logo of Centauri Provisions."
	icon_state = "centauri"
	//closet_appearance = /singleton/closet_appearance/crate/branded/centauri

/obj/structure/closet/crate/corporate/einstein
	desc = "A crate labelled with an Einstein Engines sticker, the company has since been bought out by Hephaestus Industries."
	icon_state = "ee"
	//closet_appearance = /singleton/closet_appearance/crate/branded/einstein

/obj/structure/closet/crate/corporate/focalpoint
	desc = "A crate marked with the decal of Focal Point Energistics, now a subsidiary of Aether Atmospherics and Recycling."
	icon_state = "fp"
	//closet_appearance = /singleton/closet_appearance/crate/branded/focal

/obj/structure/closet/crate/corporate/gilthari
	desc = "A crate embossed with the logo of Gilthari Exports."
	icon_state = "gilthari"
	//closet_appearance = /singleton/closet_appearance/crate/branded/gilthari

/obj/structure/closet/crate/corporate/grayson
	desc = "A bare metal crate spraypainted with the decals of Grayson Manufactories an NT subsidiary. The purchase of Grayson by NT helped them secure their phoron monoply."
	icon_state = "grayson"
	//closet_appearance = /singleton/closet_appearance/crate/branded/grayson

/obj/structure/closet/crate/corporate/heph
	desc = "A sturdy crate marked with the logo of Hephaestus Industries."
	icon_state = "heph"
	//closet_appearance = /singleton/closet_appearance/crate/branded/hephaestus

/obj/structure/closet/crate/corporate/morpheus
	desc = "A crate crudely imprinted with 'MORPHEUS CYBERKINETICS' 'primier' off brand prosthetics manufactuer."
	icon_state = "morpheus"
	//closet_appearance = /singleton/closet_appearance/crate/branded/morpheus

/obj/structure/closet/crate/corporate/nanotrasen
	desc = "A crate emblazoned with the standard NanoTrasen livery."
	icon_state = "nt"
	//closet_appearance = /singleton/closet_appearance/crate/branded/nanotrasen

/obj/structure/closet/crate/corporate/nanothreads
	desc = "A crate emblazoned with the NanoThreads Garments livery, a subsidary of the NanoTrasen Corporation."
	icon_state = "nt"
	//closet_appearance = /singleton/closet_appearance/crate/branded/nanotrasen

/obj/structure/closet/crate/corporate/nanomed
	desc = "A crate emblazoned with the NanoMed Medical livery, a subsidary of the NanoTrasen Corporation."
	icon_state = "ntmed"
	//closet_appearance = /singleton/closet_appearance/crate/branded/nanotrasen

/obj/structure/closet/crate/corporate/oculum
	desc = "A crate minimally decorated with the logo of media giant Oculum Broadcast."
	icon_state = "oculum"
	//closet_appearance = /singleton/closet_appearance/crate/branded/oculum

/obj/structure/closet/crate/corporate/veymed
	desc = "A sterile crate extensively detailed in Veymed colours."
	icon_state = "vmed"
	//closet_appearance = /singleton/closet_appearance/crate/branded/veymed

/obj/structure/closet/crate/corporate/ward
	desc = "A crate decaled with the logo of Ward-Takahashi."
	icon_state = "wt"
	//closet_appearance = /singleton/closet_appearance/crate/branded/ward

/obj/structure/closet/crate/corporate/xion
	desc = "A crate painted in the orange of the former Xion Manufacturing Group, now a subsidiary of Aether Atmospherics and Recycling."
	icon_state = "xion"
	//closet_appearance = /singleton/closet_appearance/crate/branded/xion

/obj/structure/closet/crate/corporate/zenghu
	desc = "A sterile crate marked with the logo of Zeng-Hu Pharmaceuticals."
	icon_state = "zh"
	//closet_appearance = /singleton/closet_appearance/crate/branded/zhenghu

// Brands/subsidiaries

/obj/structure/closet/crate/corporate/allico
	desc = "A crate painted in the distinctive cheerful colours of AlliCo. Ltd."
	icon_state = "allico"

/obj/structure/closet/crate/corporate/carp
	desc = "A crate painted with the garish livery of Consolidated Agricultural Resources Plc. Centauri Provisions (in)famous space carp ranching subsidairy."
	icon_state = "carp"

/obj/structure/closet/crate/corporate/hedberg
	name = "weapons crate"
	desc = "A weapons crate stamped with the logo of Hedberg-Hammarstrom and the lock conspicuously absent."
	//closet_appearance = /singleton/closet_appearance/crate/branded/hedberg

/obj/structure/closet/crate/corporate/galaksi
	desc = "A crate printed with the markings of Ward-Takahashi's Galaksi Appliance branding."
	icon_state = "wt"
	//closet_appearance = /singleton/closet_appearance/crate/branded/ward

/obj/structure/closet/crate/corporate/thinktronic
	desc = "A crate printed with the markings of Thinktronic Systems."
	icon_state = "wt"
	//closet_appearance = /singleton/closet_appearance/crate/branded/ward

/obj/structure/closet/crate/corporate/ummarcar
	desc = "A flimsy crate marked labelled 'UmMarcar Office Supply'."

/obj/structure/closet/crate/corporate/unathi
	name = "import crate"
	desc = "A crate painted with the markings of Moghes Imported Sissalik Jerky, currently distributed by the Naramadi megacorporation Onkhera Synthetic Solutions."
	icon_state = "oss"

//Ashie Crate - Sprite isn't stellar, maybe some day we can do a better one.
/obj/structure/closet/crate/ashlander
	name = "bonemold crate"
	desc = "A crate shaped out of fused bone plates. It is held shut by a sturdy hide strap."
	icon = 'icons/obj/storage.dmi'
	icon_state = "ashcrate"
	use_old_icon_update = TRUE

//Secure crates

/obj/structure/closet/crate/secure/corporate
	desc = "YOU SHOULDN'T SEE ME!"
	icon = 'icons/obj/storage.dmi'
	icon_state = "securecrate"
	use_old_icon_update = TRUE

/obj/structure/closet/crate/secure/corporate/aether
	desc = "A secure crate painted in the colours of Aether Atmospherics and Recycling."
	icon_state = "aethersec"
	//closet_appearance = /singleton/closet_appearance/crate/branded/aether/secure

/obj/structure/closet/crate/secure/corporate/bishop
	desc = "A secure crate finely decorated with the emblem of Bishop Cybernetics, former Vey-Med rival now Vey-Med subsidiary."
	icon_state = "bishopsecure"
	//closet_appearance = /singleton/closet_appearance/crate/branded/bishop

/obj/structure/closet/crate/secure/corporate/cybersolutions
	desc = "An unadorned secure metal crate labelled 'Cyber Solutions'."

/obj/structure/closet/crate/secure/corporate/einstein
	desc = "A secure crate labelled with an Einstein Engines sticker, the company has since been bought out by Hephaestus Industries."
	icon_state = "eesecure"
	//closet_appearance = /singleton/closet_appearance/crate/branded/einstein/secure

/obj/structure/closet/crate/secure/corporate/focalpoint
	desc = "A secure crate marked with the decal of Focal Point Energistics, now a subsidiary of Aether Atmospherics and Recycling."
	icon_state = "fpsecure"
	//closet_appearance = /singleton/closet_appearance/crate/branded/focal/secure

/obj/structure/closet/crate/secure/corporate/gilthari
	desc = "A secure crate embossed with the logo of Gilthari Exports."
	icon_state = "giltharisecure"
	//closet_appearance = /singleton/closet_appearance/crate/branded/gilthari/secure

/obj/structure/closet/crate/secure/corporate/grayson
	desc = "A secure bare metal crate spraypainted with decals of Grayson Manufactories an NT subsidiary. The purchase of Grayson by NT helped them secure their phoron monoply."
	icon_state = "graysonsecure"
	//closet_appearance = /singleton/closet_appearance/crate/branded/grayson/secure

/obj/structure/closet/crate/secure/corporate/hedberg
	name = "weapons crate"
	desc = "A secure weapons crate stamped with the logo of Hedberg-Hammarstrom."
	//closet_appearance = /singleton/closet_appearance/crate/branded/hedberg/secure

/obj/structure/closet/crate/secure/corporate/heph
	name = "weapons crate"
	desc = "A secure weapons crate marked with the logo of Hephaestus Industries."
	icon_state = "hephsecure"
	//closet_appearance = /singleton/closet_appearance/crate/branded/hephaestus/secure

/obj/structure/closet/crate/secure/corporate/lawson
	name = "weapons crate"
	desc = "A secure weapons crate marked with the logo of Lawson Arms."
	//closet_appearance = /singleton/closet_appearance/crate/branded/lawson/secure

/obj/structure/closet/crate/secure/corporate/morpheus
	desc = "A secure crate crudely imprinted with 'MORPHEUS CYBERKINETICS', 'primier' off brand prosthetics manufactuer."
	icon_state = "morpheussecure"
	//closet_appearance = /singleton/closet_appearance/crate/branded/morpheus/secure

/obj/structure/closet/crate/secure/corporate/nanotrasen
	desc = "A secure crate emblazoned with the standard NanoTrasen livery."
	icon_state = "ntsecure"
	//closet_appearance = /singleton/closet_appearance/crate/branded/nanotrasen/secure

/obj/structure/closet/crate/secure/corporate/nanomed
	desc = "A secure crate emblazoned with the NanoMed Medical livery, a subsidary of the NanoTrasen Corporation."
	icon_state = "ntmedsecure"
	//closet_appearance = /singleton/closet_appearance/crate/branded/nanotrasen/secure

/obj/structure/closet/crate/secure/corporate/oricon
	name = "weapons crate"
	desc = "A secure crate in the official colours of the Orion Confederation."
	icon_state = "oriconsecure"
	//closet_appearance = /singleton/closet_appearance/crate/branded/oricon/secure

/obj/structure/closet/crate/secure/corporate/saare
	desc = "A secure weapons crate plainly stamped with the logo of Stealth Assault Enterprises. A Blackstar Legion susidiary that is one of the few groups that still transport \
	hard currency."
	icon_state = "saaresecure"

/obj/structure/closet/crate/secure/corporate/veymed
	desc = "A secure sterile crate extensively detailed in Veymed colours."
	icon_state = "vmedsecure"

/obj/structure/closet/crate/secure/corporate/ward
	desc = "A secure crate decaled with the logo of Ward-Takahashi."
	icon_state = "wtsecure"
	//closet_appearance = /singleton/closet_appearance/crate/branded/ward/secure

/obj/structure/closet/crate/secure/corporate/xion
	desc = "A secure crate painted in the orange of the former Xion Manufacturing Group, now a subsidiary of Aether Atmospherics and Recycling."
	icon_state = "xionsecure"
	//closet_appearance = /singleton/closet_appearance/crate/branded/xion/secure

/obj/structure/closet/crate/secure/corporate/zenghu
	desc = "A secure sterile crate marked with the logo of Zeng-Hu Pharmaceuticals."
	icon_state = "zhsecure"
	//closet_appearance = /singleton/closet_appearance/crate/branded/zhenghu/secure

//Brings back the old Biohazard Bin.
/obj/structure/closet/crate/biohazard
	name = "biohazard bin"
	desc = "A large bin for medical and other personnel that deal with bio-grade waste."
	icon = 'icons/obj/storage.dmi'
	icon_state = "biohazard"
	climb_allowed = TRUE
	points_per_crate = 5
	use_old_icon_update = TRUE
