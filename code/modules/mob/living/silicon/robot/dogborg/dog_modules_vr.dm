/obj/item/dogborg/jaws/big
	name = "combat jaws"
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "jaws"
	desc = "The jaws of the law."
	force = 10
	throw_force = 0
	hitsound = 'sound/weapons/bite.ogg'
	attack_verb = list("chomped", "bit", "ripped", "mauled", "enforced")
	w_class = ITEMSIZE_NORMAL

/obj/item/dogborg/jaws/small
	name = "puppy jaws"
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "smalljaws"
	desc = "The jaws of a small dog."
	force = 5
	throw_force = 0
	hitsound = 'sound/weapons/bite.ogg'
	attack_verb = list("nibbled", "bit", "gnawed", "chomped", "nommed")
	w_class = ITEMSIZE_NORMAL
	var/emagged = 0

/obj/item/dogborg/jaws/small/attack_self(mob/user)
	var/mob/living/silicon/robot/R = user
	if(R.emagged || R.emag_items)
		emagged = !emagged
		if(emagged)
			name = "combat jaws"
			icon = 'icons/mob/dogborg_vr.dmi'
			icon_state = "jaws"
			desc = "The jaws of the law."
			force = 10
			throw_force = 0
			hitsound = 'sound/weapons/bite.ogg'
			attack_verb = list("chomped", "bit", "ripped", "mauled", "enforced")
			w_class = ITEMSIZE_NORMAL
		else
			name = "puppy jaws"
			icon = 'icons/mob/dogborg_vr.dmi'
			icon_state = "smalljaws"
			desc = "The jaws of a small dog."
			force = 5
			throw_force = 0
			hitsound = 'sound/weapons/bite.ogg'
			attack_verb = list("nibbled", "bit", "gnawed", "chomped", "nommed")
			w_class = ITEMSIZE_NORMAL
		update_icon()

//Boop //Newer and better, can sniff reagents, tanks, and boop people!
/obj/item/dogborg/boop_module
	name = "boop module"
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "nose"
	desc = "The BOOP module, a simple reagent and atmosphere sniffer."
	force = 0
	item_flags = ITEM_NOBLUDGEON
	throw_force = 0
	attack_verb = list("nuzzled", "nosed", "booped")
	w_class = ITEMSIZE_TINY

/obj/item/dogborg/boop_module/attack_self(mob/user)
	if (!( istype(user.loc, /turf) ))
		return

	var/datum/gas_mixture/environment = user.loc.return_air()

	var/pressure = environment.return_pressure()
	var/total_moles = environment.total_moles

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.visible_message("<span class='notice'>[user] sniffs the air.</span>", "<span class='notice'>You sniff the air...</span>")

	to_chat(user, "<span class='notice'><B>Smells like:</B></span>")
	if(abs(pressure - ONE_ATMOSPHERE) < 10)
		to_chat(user, "<span class='notice'>Pressure: [round(pressure,0.1)] kPa</span>")
	else
		to_chat(user, "<span class='warning'>Pressure: [round(pressure,0.1)] kPa</span>")
	if(total_moles)
		for(var/g in environment.gas)
			to_chat(user, "<span class='notice'>[GLOB.meta_gas_names[g]]: [round((environment.gas[g] / total_moles) * 100)]%</span>")
		to_chat(user, "<span class='notice'>Temperature: [round(environment.temperature-T0C,0.1)]&deg;C ([round(environment.temperature,0.1)]K)</span>")

/obj/item/dogborg/boop_module/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return
	if (user.stat)
		return
	if(!istype(target) && !ismob(target))
		return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)


	if(ismob(target))
		user.visible_message("<span class='notice'>\the [user] boops \the [target.name]!</span>", "<span class='notice'>You boop \the [target.name]!</span>")
		playsound(src, 'sound/weapons/thudswoosh.ogg', 25, 1, -1)
	else
		user.visible_message("<span class='notice'>[user] sniffs at \the [target.name].</span>", "<span class='notice'>You sniff \the [target.name]...</span>")
		if(!isnull(target.reagents))
			var/dat = ""
			if(target.reagents.reagent_list.len > 0)
				for (var/datum/reagent/R in target.reagents.reagent_list)
					dat += "\n \t <span class='notice'>[R]</span>"
			if(dat)
				to_chat(user, "<span class='notice'>Your BOOP module indicates: [dat]</span>")
			else
				to_chat(user, "<span class='notice'>No active chemical agents smelled in [target].</span>")
		else
			if(istype(target, /obj/item/tank)) // don't double post what atmosanalyzer_scan returns
				analyze_gases(target, user)
			else
				to_chat(user, "<span class='notice'>No significant chemical agents smelled in [target].</span>")
	return


//Delivery
/*
/obj/item/storage/bag/borgdelivery
	name = "fetching storage"
	desc = "Fetch the thing!"
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "dbag"
	w_class = ITEMSIZE_HUGE
	max_w_class = ITEMSIZE_SMALL
	max_combined_w_class = ITEMSIZE_SMALL
	storage_slots = 1
	collection_mode = 0
	can_hold = list() // any
	cant_hold = list(/obj/item/disk/nuclear)
*/

/obj/item/shockpaddles/robot/hound
	name = "paws of life"
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "defibpaddles0"
	desc = "Zappy paws. For fixing cardiac arrest."
	combat = 1
	attack_verb = list("batted", "pawed", "bopped", "whapped")
	chargecost = 500

/obj/item/shockpaddles/robot/hound/jumper
	name = "jumper paws"
	desc = "Zappy paws. For rebooting a full body prostetic."
	use_on_synthetic = 1

/obj/item/reagent_containers/borghypo/hound
	name = "MediHound hypospray"
	desc = "An advanced chemical synthesizer and injection system utilizing carrier's reserves, designed for heavy-duty medical equipment."
	charge_cost = 10
	var/datum/matter_synth/water = null
	reagent_ids = list("bicaridine", "kelotane", "alkysine", "imidazoline", "tricordrazine", "inaprovaline", "dexalin", "anti_toxin", "tramadol", "spaceacillin", "paracetamol")

/obj/item/reagent_containers/borghypo/hound/process(delta_time) //Recharges in smaller steps and uses the water reserves as well.
	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		if(R && R.cell)
			for(var/T in reagent_ids)
				if(reagent_volumes[T] < volume && water.energy >= charge_cost)
					R.cell.use(charge_cost)
					water.use_charge(charge_cost)
					reagent_volumes[T] = min(reagent_volumes[T] + 1, volume)
	return 1

/obj/item/reagent_containers/borghypo/hound/lost
	name = "Hound hypospray"
	desc = "An advanced chemical synthesizer and injection system utilizing carrier's reserves."
	reagent_ids = list("bicaridine", "kelotane", "alkysine", "imidazoline", "tricordrazine", "inaprovaline", "dexalin", "anti_toxin", "tramadol", "spaceacillin", "paracetamol")


//Tongue stuff
/obj/item/dogborg/tongue
	name = "synthetic tongue"
	desc = "Useful for slurping mess off the floor before affectionally licking the crew members in the face."
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "synthtongue"
	hitsound = 'sound/effects/attackblob.ogg'
	item_flags = ITEM_NOBLUDGEON
	var/emagged = 0
	var/datum/matter_synth/water = null

/obj/item/dogborg/tongue/examine(user)
	. = ..()
	if(water.energy)
		. += "<span class='notice'>[src] is wet.</span>"
	if(water.energy < 5)
		. += "<span class='notice'>[src] is dry.</span>"

/obj/item/dogborg/tongue/attack_self(mob/user)
	var/mob/living/silicon/robot/R = user
	if(R.emagged || R.emag_items)
		emagged = !emagged
		if(emagged)
			name = "hacked tongue of doom"
			desc = "Your tongue has been upgraded successfully. Congratulations."
			icon = 'icons/mob/dogborg_vr.dmi'
			icon_state = "syndietongue"
		else
			name = "synthetic tongue"
			desc = "Useful for slurping mess off the floor before affectionally licking the crew members in the face."
			icon = 'icons/mob/dogborg_vr.dmi'
			icon_state = "synthtongue"
		update_icon()

/obj/item/dogborg/tongue/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(user.client && (target in user.client.screen))
		to_chat(user, "<span class='warning'>You need to take \the [target.name] off before cleaning it!</span>")
	if(istype(target, /obj/structure/sink) || istype(target, /obj/structure/toilet)) //Dog vibes.
		user.visible_message("[user] begins to lap up water from [target.name].", "<span class='notice'>You begin to lap up water from [target.name].</span>")
		if(do_after (user, 50))
			water.add_charge(500)
	else if(water.energy < 5)
		to_chat(user, "<span class='notice'>Your mouth feels dry. You should drink some water.</span>") //fixed annoying grammar and needless space
		return
	else if(istype(target,/obj/effect/debris/cleanable))
		user.visible_message("[user] begins to lick off \the [target.name].", "<span class='notice'>You begin to lick off \the [target.name]...</span>")
		if(do_after (user, 50))
			to_chat(user, "<span class='notice'>You finish licking off \the [target.name].</span>")
			water.use_charge(5)
			qdel(target)
			var/mob/living/silicon/robot/R = user
			R.cell.charge += 50
	else if(istype(target,/obj/item))
		if(istype(target,/obj/item/trash))
			user.visible_message("[user] nibbles away at \the [target.name].", "<span class='notice'>You begin to nibble away at \the [target.name]...</span>")
			if(do_after (user, 50))
				user.visible_message("[user] finishes eating \the [target.name].", "<span class='notice'>You finish eating \the [target.name].</span>")
				to_chat(user, "<span class='notice'>You finish off \the [target.name].</span>")
				qdel(target)
				var/mob/living/silicon/robot/R = user
				R.cell.charge += 250
				water.use_charge(5)
			return
		if(istype(target,/obj/item/cell))
			user.visible_message("[user] begins cramming \the [target.name] down its throat.", "<span class='notice'>You begin cramming \the [target.name] down your throat...</span>")
			if(do_after (user, 50))
				user.visible_message("[user] finishes gulping down \the [target.name].", "<span class='notice'>You finish swallowing \the [target.name].</span>")
				to_chat(user, "<span class='notice'>You finish off \the [target.name], and gain some charge!</span>")
				var/mob/living/silicon/robot/R = user
				var/obj/item/cell/C = target
				R.cell.charge += C.maxcharge / 3
				water.use_charge(5)
				qdel(target)
			return
		user.visible_message("[user] begins to lick \the [target.name] clean...", "<span class='notice'>You begin to lick \the [target.name] clean...</span>")
		if(do_after (user, 50))
			to_chat(user, "<span class='notice'>You clean \the [target.name].</span>")
			water.use_charge(5)
			var/obj/effect/debris/cleanable/C = locate() in target
			qdel(C)
			target.clean_blood()
	else if(ishuman(target))
		if(src.emagged)
			var/mob/living/silicon/robot/R = user
			var/mob/living/L = target
			if(R.cell.charge <= 666)
				return
			L.Stun(1)
			L.Weaken(1)
			L.apply_effect(STUTTER, 1)
			L.visible_message("<span class='danger'>[user] has shocked [L] with its tongue!</span>", \
								"<span class='userdanger'>[user] has shocked you with its tongue! You can feel the betrayal.</span>")
			playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
			R.cell.charge -= 666
		else
			user.visible_message("<span class='notice'>\the [user] affectionally licks all over \the [target]'s face!</span>", "<span class='notice'>You affectionally lick all over \the [target]'s face!</span>")
			playsound(src.loc, 'sound/effects/attackblob.ogg', 50, 1)
			water.use_charge(5)
			var/mob/living/carbon/human/H = target
			if(H.species.lightweight == 1)
				H.Weaken(3)
	else
		user.visible_message("[user] begins to lick \the [target.name] clean...", "<span class='notice'>You begin to lick \the [target.name] clean...</span>")
		if(do_after (user, 50))
			to_chat(user, "<span class='notice'>You clean \the [target.name].</span>")
			var/obj/effect/debris/cleanable/C = locate() in target
			qdel(C)
			target.clean_blood()
			water.use_charge(5)
			if(istype(target, /turf/simulated))
				var/turf/simulated/T = target
				T.dirt = 0
	return

/obj/item/pupscrubber
	name = "floor scrubber"
	desc = "Toggles floor scrubbing."
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "scrub0"
	item_flags = ITEM_NOBLUDGEON
	var/enabled = FALSE

/obj/item/pupscrubber/attack_self(mob/user)
	var/mob/living/silicon/robot/R = user
	if(!enabled)
		R.scrubbing = TRUE
		enabled = TRUE
		icon_state = "scrub1"
	else
		R.scrubbing = FALSE
		enabled = FALSE
		icon_state = "scrub0"

/obj/item/gun/energy/taser/mounted/cyborg/ertgun //Not a taser, but it's being used as a base so it takes energy and actually works.
	name = "disabler"
	desc = "A small and nonlethal gun produced by NT.."
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "projgun"
	fire_sound = 'sound/weapons/eLuger.ogg'
	projectile_type = /obj/item/projectile/beam/disable
	charge_cost = 240 //Normal cost of a taser. It used to be 1000, but after some testing it was found that it would sap a borg's battery to quick
	recharge_time = 10 //Takes ten ticks to recharge a shot, so don't waste them all!
	//cell_type = null //Same cell as a taser until edits are made.

/obj/item/dogborg/swordtail
	name = "sword tail"
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "swordtail"
	desc = "A glowing pink dagger normally attached to the end of a cyborg's tail. It appears to be extremely sharp."
	force = 20 //Takes 5 hits to 100-0
	sharp = 1
	edge = 1
	throw_force = 0 //This shouldn't be thrown in the first place.
	hitsound = 'sound/weapons/blade1.ogg'
	attack_verb = list("slashed", "stabbed", "jabbed", "mauled", "sliced")
	w_class = ITEMSIZE_NORMAL

/obj/item/lightreplacer/dogborg
	name = "light replacer"
	desc = "A device to automatically replace lights. This version is capable to produce a few replacements using your internal matter reserves."
	max_uses = 16
	uses = 10
	var/cooldown = 0
	var/datum/matter_synth/glass = null

/obj/item/lightreplacer/dogborg/attack_self(mob/user)//Recharger refill is so last season. Now we recycle without magic!
	if(uses >= max_uses)
		to_chat(user, "<span class='warning'>[src.name] is full.</span>")
		return
	if(uses < max_uses && cooldown == 0)
		if(glass.energy < 125)
			to_chat(user, "<span class='warning'>Insufficient material reserves.</span>")
			return
		to_chat(user, "It has [uses] lights remaining. Attempting to fabricate a replacement. Please stand still.")
		cooldown = 1
		if(do_after(user, 50))
			glass.use_charge(125)
			add_uses(1)
			cooldown = 0
		else
			cooldown = 0
	else
		to_chat(user, "It has [uses] lights remaining.")
		return

//Pounce stuff for K-9
/obj/item/dogborg/pounce
	name = "pounce"
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "pounce"
	desc = "Leap at your target to momentarily stun them."
	force = 0
	item_flags = ITEM_NOBLUDGEON
	throw_force = 0

/obj/item/dogborg/pounce/attack_self(mob/user)
	var/mob/living/silicon/robot/R = user
	R.leap()

/mob/living/silicon/robot/proc/leap()
	if(last_special > world.time)
		to_chat(src, "Your leap actuators are still recharging.")
		return

	if(cell.charge < 1000)
		to_chat(src, "Cell charge too low to continue.")
		return

	if(usr.incapacitated(INCAPACITATION_DISABLED))
		to_chat(src, "You cannot leap in your current state.")
		return

	var/list/choices = list()
	for(var/mob/living/M in view(3,src))
		if(!istype(M,/mob/living/silicon))
			choices += M
	choices -= src

	var/mob/living/T = input(src,"Who do you wish to leap at?") as null|anything in choices

	if(!T || !src || src.stat) return

	if(get_dist(get_turf(T), get_turf(src)) > 3) return

	if(last_special > world.time)
		return

	if(usr.incapacitated(INCAPACITATION_DISABLED))
		to_chat(src, "You cannot leap in your current state.")
		return

	last_special = world.time + 10
	status_flags |= LEAPING
	pixel_y = pixel_y + 10

	src.visible_message("<span class='danger'>\The [src] leaps at [T]!</span>")
	src.throw_at_old(get_step(get_turf(T),get_turf(src)), 4, 1, src)
	playsound(src.loc, 'sound/mecha/mechstep2.ogg', 50, 1)
	pixel_y = base_pixel_y
	cell.charge -= 750

	sleep(5)

	if(status_flags & LEAPING) status_flags &= ~LEAPING

	if(!src.Adjacent(T))
		to_chat(src, "<span class='warning'>You miss!</span>")
		return

	if(ishuman(T))
		var/mob/living/carbon/human/H = T
		if(H.species.lightweight == 1)
			H.Weaken(3)
			return
	var/armor_block = run_armor_check(T, "melee")
	var/armor_soak = get_armor_soak(T, "melee")
	T.apply_damage(20, HALLOSS,, armor_block, armor_soak)
	if(prob(33))
		T.apply_effect(3, WEAKEN, armor_block)

/obj/item/dogborg/mirrortool
	name = "Mirror Installation Tool"
	desc = "A tool for the installation and removal of Mirrors"
	icon = 'icons/obj/device_alt.dmi'
	icon_state = "sleevemate"
	item_state = "healthanalyzer"
	w_class = ITEMSIZE_SMALL
	var/obj/item/implant/mirror/imp = null

/obj/item/dogborg/mirrortool/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	var/mob/living/carbon/human/H = target
	if(!istype(H))
		return
	if(target_zone == BP_TORSO && imp == null)
		for(var/obj/item/organ/I in H.organs)
			for(var/obj/item/implant/mirror/MI in I.contents)
				if(imp == null)
					H.visible_message("<span class='warning'>[user] is attempting remove [H]'s mirror!</span>")
					user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
					user.do_attack_animation(H)
					var/turf/T1 = get_turf(H)
					if (T1 && ((H == user) || do_after(user, 20)))
						if(user && H && (get_turf(H) == T1) && src)
							H.visible_message("<span class='warning'>[user] has removed [H]'s mirror.</span>")
							add_attack_logs(user,H,"Mirror removed by [user]")
							src.imp = MI
							qdel(MI)
	else if (target_zone == BP_TORSO && imp != null)
		if (imp)
			H.visible_message("<span class='warning'>[user] is attempting to implant [H] with a mirror.</span>")
			user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
			user.do_attack_animation(H)
			var/turf/T1 = get_turf(H)
			if (T1 && ((H == user) || do_after(user, 20)))
				if(user && H && (get_turf(H) == T1) && src && src.imp)
					H.visible_message("<span class='warning'>[H] has been implanted by [user].</span>")
					add_attack_logs(user,H,"Implanted with [imp.name] using [name]")
					if(imp.handle_implant(H))
						imp.post_implant(H)
					src.imp = null
	else
		to_chat(usr, "You must target the torso.")

/obj/item/dogborg/mirrortool/afterattack(var/obj/machinery/computer/transhuman/resleeving/target, mob/user)
	target.active_mr = imp.stored_mind
	. = ..()
