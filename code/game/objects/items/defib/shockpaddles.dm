// todo: /datum/item_interface? this should be able to naturally draw from arbitary things like
//       rigsuits with minimal code shimming.

/obj/item/shockpaddles
	name = "defibrillator paddles"
	desc = "A pair of plastic-gripped paddles with flat metal surfaces that are used to deliver powerful electric shocks."
	icon = 'icons/obj/medical/defibrillator.dmi'
	icon_state = "defibpaddles"
	item_state = "defibpaddles"
	gender = PLURAL
	damage_force = 2
	throw_force = 6
	w_class = WEIGHT_CLASS_BULKY

	var/safety = 1 //if you can zap people with the paddles on harm mode
	var/combat = 0 //If it can be used to revive people wearing thick clothing (e.g. spacesuits)
	var/cooldowntime = (6 SECONDS) // How long in deciseconds until the defib is ready again after use.
	var/chargetime = (2 SECONDS)
	var/chargecost = 1250 //units of charge per zap	//With the default APC level cell, this allows 4 shocks
	var/burn_damage_amt = 5

	var/wielded = 0
	var/cooldown = 0
	var/busy = 0

/obj/item/shockpaddles/proc/set_cooldown(var/delay)
	cooldown = 1
	update_icon()

	spawn(delay)
		if(cooldown)
			cooldown = 0
			update_icon()

			make_announcement("beeps, \"Unit is re-energized.\"", "notice")
			playsound(src, 'sound/machines/defib_ready.ogg', 50, 0)

/obj/item/shockpaddles/update_worn_icon()
	var/mob/living/M = loc
	if(istype(M) && M.is_holding(src) && !M.are_usable_hands_full())
		wielded = 1
		name = "[initial(name)] (wielded)"
	else
		wielded = 0
		name = initial(name)
	update_icon()
	..()

/obj/item/shockpaddles/update_icon()
	. = ..()
	icon_state = "defibpaddles[wielded]"
	item_state = "defibpaddles[wielded]"
	if(cooldown)
		icon_state = "defibpaddles[wielded]_cooldown"

/obj/item/shockpaddles/proc/can_use(mob/user, mob/M)
	update_worn_icon()
	if(busy)
		return 0
	if(!check_charge(chargecost))
		to_chat(user, "<span class='warning'>\The [src] doesn't have enough charge left to do that.</span>")
		return 0
	if(!wielded && !isrobot(user))
		to_chat(user, "<span class='warning'>You need to wield the paddles with both hands before you can use them on someone!</span>")
		return 0
	if(cooldown)
		to_chat(user, "<span class='warning'>\The [src] are re-energizing!</span>")
		return 0
	return 1

//Checks for various conditions to see if the mob is revivable
/obj/item/shockpaddles/proc/can_defib(mob/living/carbon/human/H) //This is checked before doing the defib operation
	if((H.species.species_flags & NO_DEFIB))
		return "buzzes, \"Alien physiology. Operation aborted. Consider alternative resucitation methods.\""

	if(H.stat != DEAD)
		return "buzzes, \"Patient is not in a valid state. Operation aborted.\""

	if(!check_contact(H))
		return "buzzes, \"Patient's chest is obstructed. Operation aborted.\""

	return null

/obj/item/shockpaddles/proc/can_revive(mob/living/carbon/human/H) //This is checked right before attempting to revive

	H.update_health()

	if(H.isSynthetic())
		if(H.health + H.getOxyLoss() + H.getToxLoss() <= H.getMinHealth())
			return "buzzes, \"Resuscitation failed - Severe damage detected. Begin manual repair.\""

	else if(H.health + H.getOxyLoss() <= H.getMinHealth() || (MUTATION_HUSK in H.mutations) || !H.can_defib)
		// TODO: REFACTOR DEFIBS AND HEALTH
		return "buzzes, \"Resuscitation failed - Severe tissue damage makes recovery of patient impossible via defibrillator.\""

	var/bad_vital_organ = check_vital_organs(H)
	if(bad_vital_organ)
		return bad_vital_organ

	//this needs to be last since if any of the 'other conditions are met their messages take precedence
	// if(!H.client && !H.teleop)
	//		return "buzzes, \"Resuscitation failed - Mental interface error. Further attempts may be successful.\""
	//! we allow braindead revivals now ~silicons

	return null

/obj/item/shockpaddles/proc/check_contact(mob/living/carbon/human/H)
	if(!combat)
		for(var/obj/item/clothing/cloth in H.inventory.get_slots_unsafe(
			/datum/inventory_slot/inventory/uniform,
			/datum/inventory_slot/inventory/suit,
		))
			if((cloth.body_cover_flags & UPPER_TORSO) && (cloth.clothing_flags & CLOTHING_THICK_MATERIAL))
				return FALSE
	return TRUE

/obj/item/shockpaddles/proc/check_vital_organs(mob/living/carbon/human/H)
	for(var/organ_tag in H.species.has_organ)
		var/obj/item/organ/O = H.species.has_organ[organ_tag]
		var/name = initial(O.name)
		var/vital = initial(O.vital) //check for vital organs
		if(vital)
			O = H.internal_organs_by_name[organ_tag]
			if(!O)
				return "buzzes, \"Resuscitation failed - Patient is missing vital organ ([name]).\""
			if(O.is_dead())
				return "buzzes, \"Resuscitation failed - Excessive damage to vital organ ([name]).\""
	return null

/obj/item/shockpaddles/proc/check_blood_level(mob/living/carbon/human/H)
	if(!H.should_have_organ(O_HEART))
		return FALSE

	var/obj/item/organ/internal/heart/heart = H.internal_organs_by_name[O_HEART]
	if(!heart)
		return TRUE

	var/blood_volume = H.blood_holder.get_total_volume()
	if(!heart || heart.is_broken())
		blood_volume *= 0.3
	else if(heart.is_bruised())
		blood_volume *= 0.7
	else if(heart.damage > 1)
		blood_volume *= 0.8
	return blood_volume < H.species.blood_volume*H.species.blood_level_fatal

/obj/item/shockpaddles/proc/check_charge(var/charge_amt)
	return 0

/obj/item/shockpaddles/proc/checked_use(var/charge_amt)
	return 0

/obj/item/shockpaddles/legacy_mob_melee_hook(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	var/mob/living/carbon/human/H = target
	if(!istype(H) || user.a_intent == INTENT_HARM)
		return ..() //Do a regular attack. Harm intent shocking happens as a hit effect
	. = CLICKCHAIN_DO_NOT_PROPAGATE
	if(can_use(user, H))
		busy = 1
		update_icon()
		do_revive(H, user)
		busy = 0
		update_icon()

/obj/item/shockpaddles/using_as_item(atom/target, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	var/mob/living/L = target
	if(!istype(L))
		return
	if(ishuman(L) && can_use(clickchain.performer, L) && clickchain.using_intent == INTENT_HARM)
		busy = 1
		update_icon()
		do_electrocute(L, clickchain.performer, clickchain.target_zone)
		busy = 0
		update_icon()
		return CLICKCHAIN_DID_SOMETHING

// This proc is used so that we can return out of the revive process while ensuring that busy and update_icon() are handled
/obj/item/shockpaddles/proc/do_revive(mob/living/carbon/human/H, mob/user)
	if(!H.client && !H.teleop)
		for(var/mob/observer/dead/ghost in GLOB.player_list)
			if(ghost.mind == H.mind)
				ghost.notify_revive("Someone is trying to resuscitate you. Re-enter your body if you want to be revived!", 'sound/effects/genetics.ogg')
				break

	//beginning to place the paddles on patient's chest to allow some time for people to move away to stop the process
	user.visible_message("<span class='warning'>\The [user] begins to place [src] on [H]'s chest.</span>", "<span class='warning'>You begin to place [src] on [H]'s chest...</span>")
	if(!do_after(user, 30, H))
		return
	user.visible_message("<span class='notice'>\The [user] places [src] on [H]'s chest.</span>", "<span class='warning'>You place [src] on [H]'s chest.</span>")
	playsound(get_turf(src), 'sound/machines/defib_charge.ogg', 50, 0)

	var/error = can_defib(H)
	if(error)
		make_announcement(error, "warning")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		return

	if(check_blood_level(H))
		make_announcement("buzzes, \"Warning - Patient is in hypovolemic shock.\"", "warning") //also includes heart damage

	//placed on chest and short delay to shock for dramatic effect, revive time is 5sec total
	if(!do_after(user, chargetime, H))
		return

	//deduct charge here, in case the base unit was EMPed or something during the delay time
	if(!checked_use(chargecost))
		make_announcement("buzzes, \"Insufficient charge.\"", "warning")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		return

	H.visible_message("<span class='warning'>\The [H]'s body convulses a bit.</span>")
	playsound(get_turf(src), "bodyfall", 50, 1)
	playsound(get_turf(src), 'sound/machines/defib_zap.ogg', 50, 1, -1)
	set_cooldown(cooldowntime)

	error = can_revive(H)
	if(error)
		make_announcement(error, "warning")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		return

	H.apply_damage(burn_damage_amt, DAMAGE_TYPE_BURN, BP_TORSO)

	//set oxyloss so that the patient is just barely in crit, if possible
	var/barely_in_crit = H.getCritHealth() - 1
	var/adjust_health = barely_in_crit - H.health //need to increase health by this much
	H.adjustOxyLoss(-adjust_health)

	if(H.isSynthetic())
		H.adjustToxLoss(-H.getToxLoss())

	make_announcement("pings, \"Resuscitation successful.\"", "notice")
	playsound(get_turf(src), 'sound/machines/defib_success.ogg', 50, 0)

	make_alive(H)

	// todo: this is at a low value rn ~silicons
	H.Confuse(10)
	// todo: removed until someone can make defib sickness that makes sense and is not ridiculously awful ~silicons
	// var/type_to_give = /datum/modifier/enfeeble/strong
	// H.add_modifier(type_to_give, 10 MINUTES)

	log_and_message_admins("used \a [src] to revive [key_name(H)].")


/obj/item/shockpaddles/proc/do_electrocute(mob/living/carbon/human/H, mob/user, var/target_zone)
	var/obj/item/organ/external/affecting = H.get_organ(target_zone)
	if(!affecting)
		to_chat(user, "<span class='warning'>They are missing that body part!</span>")
		return

	//no need to spend time carefully placing the paddles, we're just trying to shock them
	user.visible_message("<span class='danger'>\The [user] slaps [src] onto [H]'s [affecting.name].</span>", "<span class='danger'>You overcharge [src] and slap them onto [H]'s [affecting.name].</span>")

	//Just stop at awkwardly slapping electrodes on people if the safety is enabled
	if(safety)
		to_chat(user, "<span class='warning'>You can't do that while the safety is enabled.</span>")
		return

	playsound(get_turf(src), 'sound/machines/defib_charge.ogg', 50, 0)
	audible_message("<span class='warning'>\The [src] lets out a steadily rising hum...</span>")

	if(!do_after(user, chargetime, H))
		return

	//deduct charge here, in case the base unit was EMPed or something during the delay time
	if(!checked_use(chargecost))
		make_announcement("buzzes, \"Insufficient charge.\"", "warning")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		return

	user.visible_message("<span class='danger'><i>\The [user] shocks [H] with \the [src]!</i></span>", "<span class='warning'>You shock [H] with \the [src]!</span>")
	playsound(get_turf(src), 'sound/machines/defib_zap.ogg', 100, 1, -1)
	playsound(loc, 'sound/weapons/Egloves.ogg', 100, 1, -1)
	set_cooldown(cooldowntime)

	H.electrocute(0, burn_damage_amt, 120, NONE, target_zone, src)

	add_attack_logs(user,H,"Shocked using [name]")

/obj/item/shockpaddles/proc/make_alive(mob/living/carbon/human/M) //This revives the mob
	. = M.revive()
	if(!.)
		return

	M.emote("gasp")
	M.afflict_paralyze(20 * rand(10,25))

/obj/item/shockpaddles/proc/make_announcement(var/message, var/msg_class)
	audible_message("<b>\The [src]</b> [message]", "\The [src] vibrates slightly.")

/obj/item/shockpaddles/emag_act(mob/user)
	if(safety)
		safety = 0
		to_chat(user, "<span class='warning'>You silently disable \the [src]'s safety protocols with the cryptographic sequencer.</span>")
		update_icon()
		return 1
	else
		safety = 1
		to_chat(user, "<span class='notice'>You silently enable \the [src]'s safety protocols with the cryptographic sequencer.</span>")
		update_icon()
		return 1

/obj/item/shockpaddles/emp_act(severity)
	var/new_safety = rand(0, 1)
	if(safety != new_safety)
		safety = new_safety
		if(safety)
			make_announcement("beeps, \"Safety protocols enabled!\"", "notice")
			playsound(get_turf(src), 'sound/machines/defib_safetyon.ogg', 50, 0)
		else
			make_announcement("beeps, \"Safety protocols disabled!\"", "warning")
			playsound(get_turf(src), 'sound/machines/defib_safetyoff.ogg', 50, 0)
		update_icon()
	..()

/obj/item/shockpaddles/robot
	name = "defibrillator paddles"
	desc = "A pair of advanced shockpaddles powered by a robot's internal power cell, able to penetrate thick clothing."
	chargecost = 50
	combat = 1
	icon_state = "defibpaddles0"
	item_state = "defibpaddles0"
	cooldowntime = (3 SECONDS)

/obj/item/shockpaddles/robot/check_charge(var/charge_amt)
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		return (R.cell && R.cell.check_charge(charge_amt))

/obj/item/shockpaddles/robot/checked_use(var/charge_amt)
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		return (R.cell && R.cell.checked_use(charge_amt))

/obj/item/shockpaddles/robot/combat
	name = "combat defibrillator paddles"
	desc = "A pair of advanced shockpaddles powered by a robot's internal power cell, able to penetrate thick clothing.  This version \
	appears to be optimized for combat situations, foregoing the safety inhabitors in favor of a faster charging time."
	safety = 0
	chargetime = (1 SECONDS)

/*
	Shockpaddles that are linked to a base unit
*/
/obj/item/shockpaddles/linked
	var/obj/item/defib_kit/base_unit

/obj/item/shockpaddles/linked/Initialize(mapload, obj/item/defib_kit/defib)
	. = ..()
	base_unit = defib

/obj/item/shockpaddles/linked/Destroy()
	if(base_unit)
		//ensure the base unit's icon updates
		if(base_unit.paddles == src)
			base_unit.paddles = null
			base_unit.update_icon()
		base_unit = null
	return ..()

/obj/item/shockpaddles/linked/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	if(base_unit)
		base_unit.reattach_paddles(user) //paddles attached to a base unit should never exist outside of their base unit or the mob equipping the base unit
		return ITEM_RELOCATED_BY_DROPPED

/obj/item/shockpaddles/linked/check_charge(var/charge_amt)
	return (base_unit.bcell && base_unit.bcell.check_charge(charge_amt))

/obj/item/shockpaddles/linked/checked_use(var/charge_amt)
	return (base_unit.bcell && base_unit.bcell.checked_use(charge_amt))

/obj/item/shockpaddles/linked/make_announcement(var/message, var/msg_class)
	base_unit.audible_message("<b>\The [base_unit]</b> [message]", "\The [base_unit] vibrates slightly.")

/*
	Standalone Shockpaddles
*/

/obj/item/shockpaddles/standalone
	desc = "A pair of shockpaddles powered by an experimental miniaturized reactor" //Inspired by the advanced e-gun
	var/fail_counter = 0

/obj/item/shockpaddles/standalone/Destroy()
	. = ..()
	if(fail_counter)
		STOP_PROCESSING(SSobj, src)

/obj/item/shockpaddles/standalone/check_charge(var/charge_amt)
	return 1

/obj/item/shockpaddles/standalone/checked_use(var/charge_amt)
	radiation_pulse(src, RAD_INTENSITY_STANDALONE_DEFIB)
	return 1

/obj/item/shockpaddles/standalone/process(delta_time)
	if(fail_counter > 0)
		fail_counter--
		radiation_pulse(src, RAD_INTENSITY_STANDALONE_DEFIB_FAIL)
	else
		STOP_PROCESSING(SSobj, src)

/obj/item/shockpaddles/standalone/emp_act(severity)
	..()
	var/new_fail = 0
	switch(severity)
		if(1)
			new_fail = max(fail_counter, 20)
			visible_message("\The [src]'s reactor overloads!")
		if(2)
			new_fail = max(fail_counter, 8)
			if(ismob(loc))
				to_chat(loc, "<span class='warning'>\The [src] feel pleasantly warm.</span>")

	if(new_fail && !fail_counter)
		START_PROCESSING(SSobj, src)
	fail_counter = new_fail

// Hardsuit Defibs
/obj/item/shockpaddles/standalone/hardsuit
	desc = "You shouldn't be seeing these."
	chargetime = (2 SECONDS)

/obj/item/shockpaddles/standalone/hardsuit/checked_use(var/charge_amt)
	return 1

/obj/item/shockpaddles/standalone/hardsuit/emp_act(severity)
	return

/obj/item/shockpaddles/standalone/hardsuit/can_use(mob/user, mob/M)
	return 1

/obj/item/shockpaddles/linked/combat
	combat = 1
	safety = 0
	chargetime = (1 SECONDS)
