// todo: /obj/item/stun_baton?
/obj/item/melee/baton
	name = "stunbaton"
	desc = "A stun baton for incapacitating people with."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "stunbaton"
	item_state = "baton"
	rad_flags = RAD_BLOCK_CONTENTS
	slot_flags = SLOT_BELT
	damage_force = 15
	throw_force = 7
	atom_flags = NOCONDUCT
	w_class = WEIGHT_CLASS_NORMAL
	drop_sound = 'sound/items/drop/metalweapon.ogg'
	pickup_sound = 'sound/items/pickup/metalweapon.ogg'
	origin_tech = list(TECH_COMBAT = 2)
	attack_verb = list("beaten")
	worth_intrinsic = 75

	/// Starting cell type
	var/cell_type

	/// Shock stun power
	var/stun_power = 60
	/// Electrocute act flags
	var/stun_electrocute_flags = ELECTROCUTE_ACT_FLAG_DO_NOT_STUN
	/// Sound for the stun
	var/stun_sound = 'sound/weapons/Egloves.ogg'

	/// Charge cost per hit in cell units
	var/charge_cost = 240

	/// Are we on?
	var/active = FALSE
	/// Glow color when on
	var/active_color = "#FF6A00"

	// todo: use item mounts
	var/legacy_use_external_power = FALSE

/obj/item/melee/baton/Initialize(mapload)
	. = ..()
	var/datum/object_system/cell_slot/cell_slot = init_cell_slot(cell_type)
	cell_slot.legacy_use_device_cells = TRUE
	cell_slot.remove_yank_context = TRUE
	cell_slot.remove_yank_offhand = TRUE
	cell_slot.receive_inducer = TRUE
	cell_slot.primary = TRUE
	cell_slot.receive_emp = TRUE
	update_icon()

/obj/item/melee/baton/object_cell_slot_mutable(mob/user, datum/object_system/cell_slot/slot)
	return ..() && !legacy_use_external_power

/**
 * Turn off if we're out of charge
 */
/obj/item/melee/baton/proc/update_charge()
	if(check_charge(charge_cost))
		return TRUE
	deactivate()
	return FALSE

/obj/item/melee/baton/proc/check_charge(amount)
	if(legacy_use_external_power)
		var/mob/living/silicon/robot/robot = loc
		if(!istype(robot))
			return FALSE
		return robot.cell?.charge >= amount
	if(amount > obj_cell_slot.cell?.charge)
		return FALSE
	return TRUE

/**
 * Try to use charge for a hit
 */
/obj/item/melee/baton/proc/use_charge(amount)
	if(legacy_use_external_power)
		var/mob/living/silicon/robot/robot = loc
		if(!istype(robot))
			return FALSE
		return robot.cell?.checked_use(amount)
	return obj_cell_slot.cell?.checked_use(amount)

/obj/item/melee/baton/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	if(user_clickchain_toggle_active(actor))
		return CLICKCHAIN_DID_SOMETHING

/obj/item/melee/baton/proc/activate(silent, force)
	if(active)
		return TRUE
	if(!force && !check_charge(charge_cost))
		return FALSE
	active = TRUE
	if(!silent)
		playsound(src, /datum/soundbyte/sparks, 75, TRUE)
	update_icon()
	return TRUE

/obj/item/melee/baton/proc/deactivate(silent)
	if(!active)
		return TRUE
	active = FALSE
	if(!silent)
		playsound(src, /datum/soundbyte/sparks, 75, TRUE)
	update_icon()
	return TRUE

/obj/item/melee/baton/proc/user_clickchain_toggle_active(datum/event_args/actor/actor)
	if(!update_charge())
		actor.chat_feedback(
			SPAN_WARNING("[src] is out of charge, or lacks a power source."),
			target = src,
		)
		return TRUE
	if(!active)
		if(activate())
			actor.chat_feedback(
				SPAN_WARNING("[src] is now on."),
				target = src,
			)
	else
		if(deactivate())
			actor.chat_feedback(
				SPAN_NOTICE("[src] is now off."),
				target = src,
			)
	return TRUE

/obj/item/melee/baton/melee_override(atom/target, mob/user, intent, zone, efficiency, datum/event_args/actor/actor)
	var/harm_penalty = intent == INTENT_HARM ? 0.5 : 1
	attempt_powered_melee_impact(target, user, actor, zone, harm_penalty)
	if(intent != INTENT_HARM)
		return TRUE
	return ..()

/**
 * Basically [powered_melee_impact()] but checks for charge.
 *
 * @return TRUE if handled, FALSE otherwise
 */
/obj/item/melee/baton/proc/attempt_powered_melee_impact(atom/target, mob/attacker, datum/event_args/actor/actor, use_target_zone, efficiency = 1)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!active || !use_charge(charge_cost))
		update_charge()
		var/obj/item/organ/external/affecting
		if(iscarbon(target))
			var/mob/living/carbon/carbon_target = target
			affecting = carbon_target.get_bodypart_for_zone(use_target_zone)
		attacker?.visible_message(
			SPAN_WARNING("[target] has been prodded [affecting ? "in \the [affecting]" : ""] with [src] by [attacker]. Luckily it was off."),
		)
		return TRUE
	powered_melee_impact(target, attacker, actor, use_target_zone, efficiency)
	update_charge()
	return TRUE

/**
 * Does not affect the normal hit, this only performs the stun.
 *
 * Calls [apply_powered_melee_impact()]. That's the one you can override.
 *
 * @params
 * * target - what to hit
 * * attacker - (optional) attacking user
 * * clickchain - (optional) clickchain data
 * * use_target_zone - (optional) target that zone
 */
/obj/item/melee/baton/proc/powered_melee_impact(atom/target, mob/attacker, datum/event_args/actor/actor, use_target_zone, efficiency = 1)
	SHOULD_NOT_OVERRIDE(TRUE)
	actor?.data[ACTOR_DATA_STUNBATON_LOG] = "[efficiency]x[stun_power] f-[stun_electrocute_flags] z-[use_target_zone]"
	apply_powered_melee_impact(target, attacker, actor, use_target_zone, efficiency)

/**
 * Does not affect the normal hit, this only performs the stun.
 *
 * Should be only called from [powered_melee_impact()]
 *
 * @params
 * * target - what to hit
 * * attacker - (optional) attacking user
 * * clickchain - (optional) clickchain data
 * * use_target_zone - (optional) target that zone
 */
/obj/item/melee/baton/proc/apply_powered_melee_impact(atom/target, mob/attacker, datum/event_args/actor/actor, use_target_zone, efficiency)
	PROTECTED_PROC(TRUE)
	var/obj/item/organ/external/affecting
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		affecting = carbon_target.get_bodypart_for_zone(use_target_zone)
	attacker?.visible_message(
		SPAN_DANGER("[target] has been prodded [affecting ? "in \the [affecting]" : ""] with [src] by [attacker]."),
	)
	playsound(src, stun_sound, 75, TRUE)
	target.electrocute(
		DYNAMIC_CELL_UNITS_TO_KJ(charge_cost) * efficiency,
		0,
		stun_power * efficiency,
		stun_electrocute_flags,
		use_target_zone || BP_TORSO,
		src,
	)

/obj/item/melee/baton/update_icon()
	. = ..()
	if(active)
		icon_state = "[initial(icon_state)]_active"
	else if(!obj_cell_slot?.cell)
		icon_state = "[initial(icon_state)]_nocell"
	else
		icon_state = "[initial(icon_state)]"

	if(icon_state == "[initial(icon_state)]_active")
		set_light(2, 1, active_color)
	else
		set_light(0)

/obj/item/melee/baton/examine(mob/user, dist)
	. = ..()
	if(obj_cell_slot?.cell)
		. += SPAN_NOTICE("[src] is [obj_cell_slot.cell.percent()]% charged.")
	else
		. += SPAN_NOTICE("[src] does not have a power source installed.")

/obj/item/melee/baton/loaded
	cell_type = /obj/item/cell/device/weapon

//secborg stun baton module
/obj/item/melee/baton/robot
	charge_cost = 500
	legacy_use_external_power = TRUE

//Makeshift stun baton. Replacement for stun gloves.
/obj/item/melee/baton/cattleprod
	name = "stunprod"
	desc = "An improvised stun baton."
	icon_state = "stunprod"
	item_state = "prod"
	damage_force = 3
	throw_force = 5
	stun_power = 60	//same force as a stunbaton, but uses way more charge.
	charge_cost = 2500
	attack_verb = list("poked")
	slot_flags = SLOT_BACK

/obj/item/melee/baton/cattleprod/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/bluespace_crystal))
		if(!obj_cell_slot?.cell)
			var/obj/item/bluespace_crystal/BSC = W
			var/obj/item/melee/baton/cattleprod/teleprod/S = new /obj/item/melee/baton/cattleprod/teleprod
			qdel(src)
			qdel(BSC)
			user.put_in_hands_or_drop(S)
			to_chat(user, "<span class='notice'>You place the bluespace crystal firmly into the igniter.</span>")
		else
			user.visible_message("<span class='warning'>You can't put the crystal onto the stunprod while it has a power cell installed!</span>")

/obj/item/melee/baton/cattleprod/teleprod
	name = "teleprod"
	desc = "An improvised stun baton with a bluespace crystal attached to the tip."
	icon_state = "teleprod"
	item_state = "prod"
	damage_force = 3
	throw_force = 5
	stun_power = 60	//same force as a stunbaton, but uses way more charge.
	charge_cost = 2500
	attack_verb = list("poked")
	slot_flags = null

/obj/item/melee/baton/cattleprod/teleprod/apply_powered_melee_impact(atom/target, mob/attacker, datum/event_args/actor/actor, use_target_zone, efficiency)
	..()
	do_teleport(target, get_turf(target), 15)

// Rare version of a baton that causes lesser lifeforms to really hate the user and attack them.
/obj/item/melee/baton/shocker
	name = "shocker"
	desc = "A device that appears to arc electricity into a target to incapacitate or otherwise hurt them, similar to a stun baton.  It looks inefficient."
	description_info = "Hitting a lesser lifeform with this while it is on will compel them to attack you above other nearby targets.  Otherwise \
	it works like a regular stun baton, just less effectively."
	icon_state = "shocker"
	damage_force = 10
	throw_force = 5
	stun_power = 40
	attack_verb = list("poked")

/obj/item/melee/baton/shocker/apply_powered_melee_impact(atom/target, mob/attacker, datum/event_args/actor/actor, use_target_zone, efficiency)
	..()
	if(!isliving(target))
		return
	var/mob/living/L = target
	if(active && L.has_polaris_AI())
		L.taunt(attacker)

// Borg version, for the lost module.
/obj/item/melee/baton/shocker/robot
	legacy_use_external_power = TRUE

/obj/item/melee/baton/stunsword
	name = "stunsword"
	desc = "Not actually sharp, this sword is functionally identical to its baton counterpart."
	icon_state = "stunsword"
	item_state = "baton"

/obj/item/melee/baton/stunlance
	name = "stun lance"
	desc = "Designed by Nanotrasen for mounted expeditions, the stun lance is useful for running down and incapacitating wildlife for study. Its efficacy on fugitives is tacitly implied."
	icon_state = "stunlance"
	w_class = WEIGHT_CLASS_NORMAL
	reach = 2

/obj/item/melee/baton/stunlance/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/jousting)

/obj/item/melee/baton/loaded/mini
	name = "Personal Defense Baton"
	desc = "A smaller, more potent version of a hand-held tazer, one zap and the target is sure to be on the ground, and the <b>integrated</b> cell empty. Standard issue to Command staff, indentured sex workers and anyone else who might get mobbed by dissatisfied clientele. Do not lick."
	icon_state = "mini_baton"
	item_state = "mini_baton"
	w_class = WEIGHT_CLASS_SMALL
	damage_force = 5
	throw_force = 2
	stun_power = 120
	stun_electrocute_flags = NONE
	charge_cost = 1150
	stun_sound = 'sound/effects/lightningshock.ogg'

/obj/item/melee/baton/loaded/mini/object_cell_slot_mutable(mob/user, datum/object_system/cell_slot/slot)
	return FALSE
