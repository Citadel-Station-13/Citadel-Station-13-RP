//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/structure/closet/crate
	name = "crate"
	desc = "A rectangular steel crate."
	icon = 'icons/obj/storage.dmi'
	icon_state = "crate"
	icon_opened = "crateopen"
	icon_closed = "crate"
	climbable = 1
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
				if(usr.stunned)
					return 2

	playsound(src.loc, 'sound/machines/click.ogg', 15, 1, -3)
	for(var/obj/O in src)
		O.forceMove(get_turf(src))
	icon_state = icon_opened
	src.opened = 1

	if(climbable)
		structure_shaken()
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

/obj/structure/closet/crate/secure
	desc = "A secure crate."
	name = "Secure crate"
	icon_state = "securecrate"
	icon_opened = "securecrateopen"
	icon_closed = "securecrate"
	var/redlight = "securecrater"
	var/greenlight = "securecrateg"
	var/sparks = "securecratesparks"
	var/emag = "securecrateemag"
	var/broken = 0
	var/locked = 1
	var/tamper_proof = 0

/obj/structure/closet/crate/secure/Initialize(mapload)
	. = ..()
	if(locked)
		overlays.Cut()
		overlays += redlight
	else
		overlays.Cut()
		overlays += greenlight

/obj/structure/closet/crate/secure/can_open()
	return !locked

/obj/structure/closet/crate/secure/proc/togglelock(mob/user as mob)
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
	if(locked == newlocked) return

	locked = newlocked
	if(user)
		for(var/mob/O in viewers(user, 3))
			O.show_message( "<span class='notice'>The crate has been [locked ? null : "un"]locked by [user].</span>", 1)
	overlays.Cut()
	overlays += locked ? redlight : greenlight

/obj/structure/closet/crate/secure/verb/verb_togglelock()
	set src in oview(1) // One square distance
	set category = "Object"
	set name = "Toggle Lock"

	if(!usr.canmove || usr.stat || usr.restrained()) // Don't use it if you're not able to! Checks for stuns, ghost and restrain
		return

	if(ishuman(usr) || isrobot(usr))
		src.add_fingerprint(usr)
		src.togglelock(usr)
	else
		to_chat(usr, "<span class='warning'>This mob type can't use this verb.</span>")

/obj/structure/closet/crate/secure/attack_hand(mob/user as mob)
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

/obj/structure/closet/crate/secure/emag_act(var/remaining_charges, var/mob/user)
	if(!broken)
		overlays.Cut()
		overlays += emag
		overlays += sparks
		spawn(6) overlays -= sparks //Tried lots of stuff but nothing works right. so i have to use this *sadface*
		playsound(src.loc, "sparks", 60, 1)
		src.locked = 0
		src.broken = 1
		to_chat(user, "<span class='notice'>You unlock \the [src].</span>")
		return 1

/obj/structure/closet/crate/secure/emp_act(severity)
	for(var/obj/O in src)
		O.emp_act(severity)
	if(!broken && !opened  && prob(50/severity))
		if(!locked)
			src.locked = 1
			overlays.Cut()
			overlays += redlight
		else
			overlays.Cut()
			overlays += emag
			overlays += sparks
			spawn(6) overlays -= sparks //Tried lots of stuff but nothing works right. so i have to use this *sadface*
			playsound(src.loc, 'sound/effects/sparks4.ogg', 75, 1)
			src.locked = 0
	if(!opened && prob(20/severity))
		if(!locked)
			open()
		else
			src.req_access = list()
			src.req_access += pick(get_all_station_access())
	..()

/obj/structure/closet/crate/secure/bullet_act(var/obj/item/projectile/Proj)
	if(!(Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		return

	if(locked && tamper_proof && health <= Proj.damage)
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
	icon_opened = "plasticcrateopen"
	icon_closed = "plasticcrate"
	points_per_crate = 1	//5 crates per ordered crate, +5 for the crate it comes in.

/obj/structure/closet/crate/internals
	name = "internals crate"
	desc = "A internals crate."
	icon_state = "o2crate"
	icon_opened = "o2crateopen"
	icon_closed = "o2crate"

/obj/structure/closet/crate/trashcart
	name = "trash cart"
	desc = "A heavy, metal trashcart with wheels."
	icon_state = "trashcart"
	icon_opened = "trashcartopen"
	icon_closed = "trashcart"

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
	icon_opened = "medicalcrateopen"
	icon_closed = "medicalcrate"

/obj/structure/closet/crate/rcd
	name = "\improper RCD crate"
	desc = "A crate with rapid construction device."
	icon_state = "engi_crate"
	icon_opened = "engi_crateopen"
	icon_closed = "engi_crate"

	starts_with = list(
		/obj/item/rcd_ammo = 3,
		/obj/item/rcd)

/obj/structure/closet/crate/solar
	name = "solar pack crate"
	icon_state = "engi_crate"
	icon_opened = "engi_crateopen"
	icon_closed = "engi_crate"

	starts_with = list(
		/obj/item/solar_assembly = 21,
		/obj/item/circuitboard/solar_control,
		/obj/item/tracker_electronics,
		/obj/item/paper/solar)

/obj/structure/closet/crate/freezer
	name = "freezer"
	desc = "A freezer."
	icon_state = "freezer"
	icon_opened = "freezeropen"
	icon_closed = "freezer"
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
	icon_opened = "largebinopen"
	icon_closed = "largebin"

/obj/structure/closet/crate/bin/attackby(obj/item/W as obj, mob/user as mob)
	if(W.is_wrench() && !src.opened)
		if(anchored)
			user.show_message(text("<span class='notice'>[src] can now be moved.</span>"))
			playsound(src, W.tool_sound, 50, 1)
			anchored = FALSE

		else if(!anchored)
			user.show_message(text("<span class='notice'>[src] is now secured.</span>"))
			playsound(src, W.tool_sound, 50, 1)
			anchored = TRUE
	else
		..()

/obj/structure/closet/crate/radiation
	name = "radioactive gear crate"
	desc = "A crate with a radiation sign on it."
	icon_state = "radiation"
	icon_opened = "radiationopen"
	icon_closed = "radiation"

	starts_with = list(
		/obj/item/clothing/suit/radiation = 4,
		/obj/item/clothing/head/radiation = 4)


/obj/structure/closet/crate/secure/weapon
	name = "weapons crate"
	desc = "A secure weapons crate."
	icon_state = "weaponcrate"
	icon_opened = "weaponcrateopen"
	icon_closed = "weaponcrate"


/obj/structure/closet/crate/secure/phoron
	name = "phoron crate"
	desc = "A secure phoron crate."
	icon_state = "phoroncrate"
	icon_opened = "phoroncrateopen"
	icon_closed = "phoroncrate"


/obj/structure/closet/crate/secure/gear
	name = "gear crate"
	desc = "A secure gear crate."
	icon_state = "secgearcrate"
	icon_opened = "secgearcrateopen"
	icon_closed = "secgearcrate"


/obj/structure/closet/crate/secure/hydrosec
	name = "secure hydroponics crate"
	desc = "A crate with a lock on it, painted in the scheme of the station's botanists."
	icon_state = "hydrosecurecrate"
	icon_opened = "hydrosecurecrateopen"
	icon_closed = "hydrosecurecrate"


/obj/structure/closet/crate/secure/engineering
	desc = "A crate with a lock on it, painted in the scheme of the station's engineers."
	name = "secure engineering crate"
	icon_state = "engi_secure_crate"
	icon_opened = "engi_secure_crateopen"
	icon_closed = "engi_secure_crate"


/obj/structure/closet/crate/secure/science
	name = "secure science crate"
	desc = "A crate with a lock on it, painted in the scheme of the station's scientists."
	icon_state = "scisecurecrate"
	icon_opened = "scisecurecrateopen"
	icon_closed = "scisecurecrate"


/obj/structure/closet/crate/secure/bin
	name = "secure bin"
	desc = "A secure bin."
	icon = 'icons/obj/storage.dmi'
	icon_state = "largebins"
	icon_opened = "largebinsopen"
	icon_closed = "largebins"
	redlight = "largebinr"
	greenlight = "largebing"
	sparks = "largebinsparks"
	emag = "largebinemag"


/obj/structure/closet/crate/large
	name = "large crate"
	desc = "A hefty metal crate."
	icon = 'icons/obj/storage.dmi'
	icon_state = "largemetal"
	icon_opened = "largemetalopen"
	icon_closed = "largemetal"


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
	icon_opened = "largemetalsecureopen"
	icon_closed = "largemetalsecure"
	redlight = "largemetalr"
	greenlight = "largemetalg"


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
	icon_opened = "largermetalopen"
	icon_closed = "largermetal"

/obj/structure/closet/crate/engineering
	name = "engineering crate"
	icon_state = "engi_crate"
	icon_opened = "engi_crateopen"
	icon_closed = "engi_crate"

/obj/structure/closet/crate/engineering/electrical
	icon_state = "engi_e_crate"
	icon_opened = "engi_crateopen"
	icon_closed = "engi_e_crate"

/obj/structure/closet/crate/science
	name = "science crate"
	icon_state = "scicrate"
	icon_opened = "scicrateopen"
	icon_closed = "scicrate"

/obj/structure/closet/crate/hydroponics
	name = "hydroponics crate"
	desc = "All you need to destroy those pesky weeds and pests."
	icon_state = "hydrocrate"
	icon_opened = "hydrocrateopen"
	icon_closed = "hydrocrate"


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
	icon_opened = "bloodopen"
	icon_closed = "blood"

//TSCs
//Add in icons instead of this declare thing? Sort out what's causing this.

/obj/structure/closet/crate/aether
	desc = "A crate painted in the colours of Aether Atmospherics and Recycling."
	icon_state = "aether"
	icon_opened = "aetheropen"
	icon_closed = "aether"

/obj/structure/closet/crate/centauri
	desc = "A crate decorated with the logo of Centauri Provisions."
	icon_state = "centauri"
	icon_opened = "centauriopen"
	icon_closed = "centauri"

/obj/structure/closet/crate/einstein
	desc = "A crate labelled with an Einstein Engines sticker, the company has since been bought out by Hephaestus Industries."
	icon_state = "ee"
	icon_opened = "eeopen"
	icon_closed = "ee"

/obj/structure/closet/crate/focalpoint
	desc = "A crate marked with the decal of Focal Point Energistics, now a subsidiary of Aether Atmospherics and Recycling."
	icon_state = "fp"
	icon_opened = "fpopen"
	icon_closed = "fp"

/obj/structure/closet/crate/gilthari
	desc = "A crate embossed with the logo of Gilthari Exports."
	icon_state = "gilthari"
	icon_opened = "gilthariopen"
	icon_closed = "gilthari"

/obj/structure/closet/crate/grayson
	desc = "A bare metal crate spraypainted with the decals of Grayson Manufactories an NT subsidiary. The purchase of Grayson by NT helped them secure their phoron monoply."
	icon_state = "grayson"
	icon_opened = "graysonopen"
	icon_closed = "grayson"

/obj/structure/closet/crate/heph
	desc = "A sturdy crate marked with the logo of Hephaestus Industries."
	icon_state = "heph"
	icon_opened = "hephopen"
	icon_closed = "heph"

/obj/structure/closet/crate/morpheus
	desc = "A crate crudely imprinted with 'MORPHEUS CYBERKINETICS' 'primier' off brand prosthetics manufactuer."
	icon_state = "morpheus"
	icon_opened = "morpheusopen"
	icon_closed = "morpheus"

/obj/structure/closet/crate/nanotrasen
	desc = "A crate emblazoned with the standard NanoTrasen livery."
	icon_state = "nt"
	icon_opened = "ntopen"
	icon_closed = "nt"

/obj/structure/closet/crate/nanothreads
	desc = "A crate emblazoned with the NanoThreads Garments livery, a subsidary of the NanoTrasen Corporation."
	icon_state = "nt"
	icon_opened = "ntopen"
	icon_closed = "nt"

/obj/structure/closet/crate/nanomed
	desc = "A crate emblazoned with the NanoMed Medical livery, a subsidary of the NanoTrasen Corporation."
	icon_state = "ntmed"
	icon_opened = "ntmedopen"
	icon_closed = "ntmed"

/obj/structure/closet/crate/oculum
	desc = "A crate minimally decorated with the logo of media giant Oculum Broadcast."
	icon_state = "oculum"
	icon_opened = "oculumopen"
	icon_closed = "oculum"

/obj/structure/closet/crate/veymed
	desc = "A sterile crate extensively detailed in Veymed colours."
	icon_state = "vmed"
	icon_opened = "vmedopen"
	icon_closed = "vmed"

/obj/structure/closet/crate/ward
	desc = "A crate decaled with the logo of Ward-Takahashi."
	icon_state = "wt"
	icon_opened = "wtopen"
	icon_closed = "wt"

/obj/structure/closet/crate/xion
	desc = "A crate painted in the orange of the former Xion Manufacturing Group, now a subsidiary of Aether Atmospherics and Recycling."
	icon_state = "xion"
	icon_opened = "xionopen"
	icon_closed = "xion"

/obj/structure/closet/crate/zenghu
	desc = "A sterile crate marked with the logo of Zeng-Hu Pharmaceuticals."
	icon_state = "zh"
	icon_opened = "zhopen"
	icon_closed = "zh"

// Brands/subsidiaries

/obj/structure/closet/crate/allico
	desc = "A crate painted in the distinctive cheerful colours of AlliCo. Ltd."
	icon_state = "allico"
	icon_opened = "allicoopen"
	icon_closed = "allico"

/obj/structure/closet/crate/carp
	desc = "A crate painted with the garish livery of Consolidated Agricultural Resources Plc. Centauri Provisions (in)famous space carp ranching subsidairy."
	icon_state = "carp"
	icon_opened = "carpopen"
	icon_closed = "carp"

/obj/structure/closet/crate/hedberg
	name = "weapons crate"
	desc = "A weapons crate stamped with the logo of Hedberg-Hammarstrom and the lock conspicuously absent."

/obj/structure/closet/crate/galaksi
	desc = "A crate printed with the markings of Ward-Takahashi's Galaksi Appliance branding."
	icon_state = "wt"
	icon_opened = "wtopen"
	icon_closed = "wt"

/obj/structure/closet/crate/thinktronic
	desc = "A crate printed with the markings of Thinktronic Systems."
	icon_state = "wt"
	icon_opened = "wtopen"
	icon_closed = "wt"

/obj/structure/closet/crate/ummarcar
	desc = "A flimsy crate marked labelled 'UmMarcar Office Supply'."

/obj/structure/closet/crate/unathi
	name = "import crate"
	desc = "A crate painted with the markings of Moghes Imported Sissalik Jerky, currently distributed by the Naramadi megacorporation Onkhera Synthetic Solutions."
	icon_state = "oss"
	icon_opened = "ossopen"
	icon_closed = "oss"

//Secure crates

/obj/structure/closet/crate/secure/aether
	desc = "A secure crate painted in the colours of Aether Atmospherics and Recycling."
	icon_state = "aethersecure"
	icon_opened = "aethersecureopen"
	icon_closed = "aethersecure"

/obj/structure/closet/crate/secure/bishop
	desc = "A secure crate finely decorated with the emblem of Bishop Cybernetics, former Vey-Med rival now Vey-Med subsidiary."
	icon_state = "bishopsecure"
	icon_opened = "bishopsecureopen"
	icon_closed = "bishopsecure"

/obj/structure/closet/crate/secure/cybersolutions
	desc = "An unadorned secure metal crate labelled 'Cyber Solutions'."

/obj/structure/closet/crate/secure/einstein
	desc = "A secure crate labelled with an Einstein Engines sticker, the company has since been bought out by Hephaestus Industries."
	icon_state = "eesecure"
	icon_opened = "eesecureopen"
	icon_closed = "eesecure"

/obj/structure/closet/crate/secure/focalpoint
	desc = "A secure crate marked with the decal of Focal Point Energistics, now a subsidiary of Aether Atmospherics and Recycling."
	icon_state = "fpsecure"
	icon_opened = "fpsecureopen"
	icon_closed = "fpsecure"

/obj/structure/closet/crate/secure/gilthari
	desc = "A secure crate embossed with the logo of Gilthari Exports."
	icon_state = "giltharisecure"
	icon_opened = "giltharisecureopen"
	icon_closed = "giltharisecure"

/obj/structure/closet/crate/secure/grayson
	desc = "A secure bare metal crate spraypainted with decals of Grayson Manufactories an NT subsidiary. The purchase of Grayson by NT helped them secure their phoron monoply."
	icon_state = "graysonsecure"
	icon_opened = "graysonsecureopen"
	icon_closed = "graysonsecure"

/obj/structure/closet/crate/secure/hedberg
	name = "weapons crate"
	desc = "A secure weapons crate stamped with the logo of Hedberg-Hammarstrom."

/obj/structure/closet/crate/secure/heph
	name = "weapons crate"
	desc = "A secure weapons crate marked with the logo of Hephaestus Industries."
	icon_state = "hephsecure"
	icon_opened = "hephsecureopen"
	icon_closed = "hephsecure"

/obj/structure/closet/crate/secure/lawson
	name = "weapons crate"
	desc = "A secure weapons crate marked with the logo of Lawson Arms."

/obj/structure/closet/crate/secure/morpheus
	desc = "A secure crate crudely imprinted with 'MORPHEUS CYBERKINETICS', 'primier' off brand prosthetics manufactuer."
	icon_state = "morpheussecure"
	icon_opened = "morpheussecureopen"
	icon_closed = "morpheussecure"


/obj/structure/closet/crate/secure/nanotrasen
	desc = "A secure crate emblazoned with the standard NanoTrasen livery."
	icon_state = "ntsecure"
	icon_opened = "ntsecureopen"
	icon_closed = "ntsecure"

/obj/structure/closet/crate/secure/nanomed
	desc = "A secure crate emblazoned with the NanoMed Medical livery, a subsidary of the NanoTrasen Corporation."
	icon_state = "ntmedsecure"
	icon_opened = "ntmedsecureopen"
	icon_closed = "ntmedsecure"

/obj/structure/closet/crate/secure/oricon
	name = "weapons crate"
	desc = "A secure crate in the official colours of the Orion Confederation."
	icon_state = "oriconsecure"
	icon_opened = "oriconsecureopen"
	icon_closed = "oriconsecure"

/obj/structure/closet/crate/secure/saare
	desc = "A secure weapons crate plainly stamped with the logo of Stealth Assault Enterprises. A Blackstar Legion susidiary that is one of the few groups that still transport \
	hard currency."
	icon_state = "saaresecure"
	icon_opened = "saaresecureopen"
	icon_closed = "saaresecure"

/obj/structure/closet/crate/secure/veymed
	desc = "A secure sterile crate extensively detailed in Veymed colours."
	icon_state = "vmedsecure"
	icon_opened = "vmedsecureopen"
	icon_closed = "vmedsecure"

/obj/structure/closet/crate/secure/ward
	desc = "A secure crate decaled with the logo of Ward-Takahashi."
	icon_state = "wtsecure"
	icon_opened = "wtsecureopen"
	icon_closed = "wtsecure"

/obj/structure/closet/crate/secure/xion
	desc = "A secure crate painted in the orange of the former Xion Manufacturing Group, now a subsidiary of Aether Atmospherics and Recycling."
	icon_state = "xionsecure"
	icon_opened = "xionsecureopen"
	icon_closed = "xionsecure"

/obj/structure/closet/crate/secure/zenghu
	desc = "A secure sterile crate marked with the logo of Zeng-Hu Pharmaceuticals."
	icon_state = "zhsecure"
	icon_opened = "zhsecureopen"
	icon_closed = "zhsecure"
