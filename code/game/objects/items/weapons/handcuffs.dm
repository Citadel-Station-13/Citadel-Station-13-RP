/obj/item/handcuffs
	name = "handcuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "handcuff"
	slot_flags = SLOT_BELT
	throw_force = 5
	w_class = ITEMSIZE_SMALL
	throw_speed = 2
	throw_range = 5
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(MAT_STEEL = 500)
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'
	var/elastic
	var/dispenser = 0
	var/breakouttime = 1200 //Deciseconds = 120s = 2 minutes
	var/cuff_sound = 'sound/weapons/handcuffs.ogg'
	var/cuff_type = "handcuffs"
	var/use_time = 30

/obj/item/handcuffs/attack(var/mob/living/carbon/C, var/mob/living/user)

	if(!user.IsAdvancedToolUser())
		return

	if ((MUTATION_CLUMSY in user.mutations) && prob(50))
		to_chat(user, "<span class='warning'>Uh ... how do those things work?!</span>")
		place_handcuffs(user, user)
		return

	if(!C.handcuffed)
		if (C == user)
			place_handcuffs(user, user)
			return

		//check for an aggressive grab (or robutts)
		if(can_place(C, user))
			place_handcuffs(C, user)
		else
			to_chat(user, "<span class='danger'>You need to have a firm grip on [C] before you can put \the [src] on!</span>")

/obj/item/handcuffs/proc/can_place(var/mob/target, var/mob/user)
	if(user == target)
		return 1
	if(istype(user, /mob/living/silicon/robot))
		if(user.Adjacent(target))
			return 1
	else
		for(var/obj/item/grab/G in target.grabbed_by)
			if(G.loc == user && G.state >= GRAB_AGGRESSIVE)
				return 1
	return 0

/obj/item/handcuffs/proc/place_handcuffs(var/mob/living/carbon/target, var/mob/user)

	var/mob/living/carbon/human/H = target
	if(!istype(H))
		return 0

	if(!H.can_equip(src, SLOT_ID_HANDCUFFED, user = user))
		return FALSE

	playsound(src.loc, cuff_sound, 30, 1, -2)

	if(istype(H.gloves,/obj/item/clothing/gloves/gauntlets/rig) && !elastic) // Can't cuff someone who's in a deployed hardsuit.
		to_chat(user, "<span class='danger'>\The [src] won't fit around \the [H.gloves]!</span>")
		return 0

	user.visible_message("<span class='danger'>\The [user] is attempting to put [cuff_type] on \the [H]!</span>")

	if(!do_after(user,use_time))
		return 0

	if(!can_place(target, user)) //victim may have resisted out of the grab in the meantime
		return 0

	if(!dispenser && !user.attempt_void_item_for_installation(src))
		return

	add_attack_logs(user,H,"Handcuffed (attempt)")
	feedback_add_details("handcuffs","H")

	user.setClickCooldown(user.get_attack_speed(src))
	user.do_attack_animation(H)

	user.visible_message("<span class='danger'>\The [user] has put [cuff_type] on \the [H]!</span>")

	// Apply cuffs.
	var/obj/item/handcuffs/cuffs = src
	if(dispenser)
		cuffs = new(target)
	if(!target.force_equip_to_slot(cuffs, SLOT_ID_HANDCUFFED, user = user))
		forceMove(user.drop_location())
	return 1

/obj/item/handcuffs/equipped(mob/living/user, slot, accessory)
	. = ..()
	if(slot == SLOT_ID_HANDCUFFED)
		user.drop_all_held_items()
		user.stop_pulling()

var/last_chew = 0
/mob/living/carbon/human/RestrainedClickOn(var/atom/A)
	if (A != src) return ..()
	if (last_chew + 26 > world.time) return

	var/mob/living/carbon/human/H = A
	if (!H.handcuffed) return
	if (H.a_intent != INTENT_HARM) return
	if (H.zone_sel.selecting != O_MOUTH) return
	if (H.wear_mask) return
	if (istype(H.wear_suit, /obj/item/clothing/suit/straight_jacket)) return

	var/obj/item/organ/external/O = H.organs_by_name[(H.hand ? BP_L_HAND : BP_R_HAND)]
	if (!O) return

	var/datum/gender/T = GLOB.gender_datums[H.get_visible_gender()]

	var/s = "<span class='warning'>[H.name] chews on [T.his] [O.name]!</span>"
	H.visible_message(s, "<span class='warning'>You chew on your [O.name]!</span>")
	add_attack_logs(H,H,"chewed own [O.name]")

	if(O.take_damage(3,0,1,1,"teeth marks"))
		H:UpdateDamageIcon()

	last_chew = world.time

/obj/item/handcuffs/fuzzy
	name = "fuzzy cuffs"
	icon_state = "fuzzycuff"
	desc = "Use this to keep... 'prisoners' in line."
	breakouttime = 30 //3sec breakout time. why did this not exist before. bruh moment.

/obj/item/handcuffs/sinew
	name = "sinew cuffs"
	icon = 'icons/obj/mining.dmi'
	icon_state = "sinewcuff"
	desc = "A complex weave of sinew repurposed as handcuffs."

/obj/item/handcuffs/cable
	name = "cable restraints"
	desc = "Looks like some cables tied together. Could be used to tie something up."
	icon_state = "cuff_white"
	breakouttime = 300 //Deciseconds = 30s
	cuff_sound = 'sound/weapons/cablecuff.ogg'
	cuff_type = "cable restraints"
	elastic = 0 //citadel change, why would cable be better than actual handcuffs? who knows.

/obj/item/handcuffs/cable/red
	color = "#DD0000"

/obj/item/handcuffs/cable/yellow
	color = "#DDDD00"

/obj/item/handcuffs/cable/blue
	color = "#0000DD"

/obj/item/handcuffs/cable/green
	color = "#00DD00"

/obj/item/handcuffs/cable/pink
	color = "#DD00DD"

/obj/item/handcuffs/cable/orange
	color = "#DD8800"

/obj/item/handcuffs/cable/cyan
	color = "#00DDDD"

/obj/item/handcuffs/cable/white
	color = "#FFFFFF"

/obj/item/handcuffs/cable/attackby(var/obj/item/I, mob/user as mob)
	..()
	if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = I
		if (R.use(1))
			var/obj/item/material/wirerod/W = new(get_turf(user))
			user.put_in_hands(W)
			to_chat(user, "<span class='notice'>You wrap the cable restraint around the top of the rod.</span>")
			qdel(src)
			update_icon(user)

/obj/item/handcuffs/cyborg
	dispenser = 1

/obj/item/handcuffs/cable/tape
	name = "tape restraints"
	desc = "DIY!"
	icon_state = "tape_cross"
	item_state = null
	icon = 'icons/obj/bureaucracy.dmi'
	breakouttime = 200
	cuff_type = "duct tape"

/obj/item/handcuffs/cable/tape/cyborg
	dispenser = TRUE

/obj/item/handcuffs/disruptor
	name = "disruptor cuffs"
	icon_state = "disruptorcuff"
	desc = "These cutting edge handcuffs were originally designed by the PMD. Commonly deployed to restrain anomalous lifeforms, disruptor cuffs employ a form of acausal logic engine disruption, in tandem with morphogenic resonance, to neutralize the abilities of technological and biological threats."

/obj/item/handcuffs/disruptor/equipped(var/mob/living/user,var/slot)
	. = ..()
	if(slot == SLOT_ID_HANDCUFFED)
		ADD_TRAIT(user, TRAIT_DISRUPTED, CLOTHING_TRAIT)

//Legcuffs. Not /really/ handcuffs, but its close enough.
/obj/item/handcuffs/legcuffs
	name = "legcuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "legcuff"
	throw_force = 0
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 1)
	breakouttime = 300	//Deciseconds = 30s = 0.5 minute
	cuff_type = "legcuffs"
	elastic = 0
	cuff_sound = 'sound/weapons/handcuffs.ogg' //This shold work for now.

/obj/item/handcuffs/legcuffs/attack(var/mob/living/carbon/C, var/mob/living/user)
	if(!user.IsAdvancedToolUser())
		return

	if ((MUTATION_CLUMSY in user.mutations) && prob(50))
		to_chat(user, "<span class='warning'>Uh ... how do those things work?!</span>")
		place_legcuffs(user, user)
		return

	if(!C.legcuffed)
		if (C == user)
			place_legcuffs(user, user)
			return

		//check for an aggressive grab (or robutts)
		if(can_place(C, user))
			place_legcuffs(C, user)
		else
			to_chat(user, "<span class='danger'>You need to have a firm grip on [C] before you can put \the [src] on!</span>")

/obj/item/handcuffs/legcuffs/proc/place_legcuffs(var/mob/living/carbon/target, var/mob/user)
	playsound(src.loc, cuff_sound, 30, 1, -2)

	var/mob/living/carbon/human/H = target
	if(!istype(H))
		return 0

	if(!H.can_equip(src, SLOT_ID_LEGCUFFED, user = user))
		return FALSE

	if(istype(H.shoes,/obj/item/clothing/shoes/magboots/rig) && !elastic) // Can't cuff someone who's in a deployed hardsuit.
		to_chat(user, "<span class='danger'>\The [src] won't fit around \the [H.shoes]!</span>")
		return 0

	user.visible_message("<span class='danger'>\The [user] is attempting to put [cuff_type] on \the [H]!</span>")

	if(!do_after(user,use_time))
		return 0

	if(!can_place(target, user)) //victim may have resisted out of the grab in the meantime
		return 0

	if(!user.attempt_void_item_for_installation(src))
		return

	add_attack_logs(user,H,"Legcuffed (attempt)")
	feedback_add_details("legcuffs","H")

	user.setClickCooldown(user.get_attack_speed(src))
	user.do_attack_animation(H)

	user.visible_message("<span class='danger'>\The [user] has put [cuff_type] on \the [H]!</span>")

	// Apply cuffs.
	var/obj/item/handcuffs/legcuffs/lcuffs = src
	if(dispenser)
		lcuffs = new(get_turf(user))
	if(!target.force_equip_to_slot(lcuffs, SLOT_ID_LEGCUFFED, user = user))
		forceMove(user.drop_location())
	return 1

/obj/item/handcuffs/legcuffs/equipped(var/mob/living/user,var/slot)
	. = ..()
	if(slot == SLOT_ID_LEGCUFFED)
		if(user.m_intent != "walk")
			user.m_intent = "walk"
			if(user.hud_used && user.hud_used.move_intent)
				user.hud_used.move_intent.icon_state = "walking"

/obj/item/handcuffs/legcuffs/fuzzy
	name = "fuzzy legcuffs"
	desc = "Use this to keep... 'prisoners' in line."
	icon = 'icons/obj/items_vr.dmi'
	icon_state = "fuzzylegcuff"
	breakouttime = 30 //3sec


/obj/item/handcuffs/legcuffs/bola
	name = "bola"
	desc = "A ranged snare used to tangle up a target's legs."
	icon_state = "bola"
	elastic = 1
	use_time = 0
	breakouttime = 30
	cuff_sound = 'sound/weapons/towelwipe.ogg' //Is there anything this sound can't do?

/obj/item/handcuffs/legcuffs/bola/can_place(var/mob/target, var/mob/user)
	if(user) //A ranged legcuff, until proper implementation as items it remains a projectile-only thing.
		return 1

/obj/item/handcuffs/legcuffs/bola/throw_impact(var/atom/target, var/mob/user)
	var/mob/living/L = target
	place_legcuffs(L, user)

/obj/item/handcuffs/legcuffs/bola/place_legcuffs(var/mob/living/carbon/target, var/mob/user)
	playsound(src.loc, cuff_sound, 30, 1, -2)

	var/mob/living/carbon/human/H = target
	if(!istype(H))
		return FALSE

	if(!H.equip_to_slot_if_possible(src, SLOT_ID_LEGCUFFED, INV_OP_FLUFFLESS | INV_OP_SUPPRESS_WARNING))
		H.visible_message("<span class='notice'>\The [src] slams into [H], but slides off!</span>")

	H.visible_message("<span class='danger'>\The [H] has been snared by \the [src]!</span>")

	if(target.m_intent != "walk")
		target.m_intent = "walk"
		if(target.hud_used && user.hud_used.move_intent)
			target.hud_used.move_intent.icon_state = "walking"

	return TRUE

/obj/item/handcuffs/legcuffs/bola/tactical
	name = "reinforced bola"
	desc = "A strong bola, made with a long steel chain. It looks heavy, enough so that it could trip somebody."
	icon_state = "bola_r"
	breakouttime = 70

/obj/item/handcuffs/legcuffs/bola/cult
	name = "\improper paranatural bola"
	desc = "A strong bola, bound with dark magic that allows it to pass harmlessly through allied cultists. Throw it to trip and slow your victim."
	icon_state = "bola_cult"
	breakouttime = 60

/obj/item/handcuffs/legcuffs/bola/cult/pickup(mob/user, flags, atom/oldLoc)
	. = ..()
	if(!iscultist(user))
		to_chat(user, "<span class='warning'>The bola seems to take on a life of its own!</span>")
		place_legcuffs(user)

/obj/item/handcuffs/legcuffs/bola/cult/throw_impact(var/atom/target, var/mob/user, mob/living/carbon/human/H)
	if(iscultist(user))
		return
	if(H.mind.isholy)
		return
	. = ..()
