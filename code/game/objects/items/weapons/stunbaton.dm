//replaces our stun baton code with /tg/station's code
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
	var/stun_soud = 'sound/weapons/Egloves.ogg'

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

/obj/item/melee/baton/suicide_act(mob/user)
	var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
	user.visible_message("<span class='suicide'>\The [user] is putting the live [name] in [TU.his] mouth! It looks like [TU.he] [TU.is] trying to commit suicide.</span>")
	return (FIRELOSS)

/**
 * Turn off if we're out of charge
 */
/obj/item/melee/baton/proc/update_charge()
	if(check_charge(charge_cost))
		return
	deactivate()

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

/obj/item/melee/baton/proc/activate()
	#warn impl

/obj/item/melee/baton/proc/deactivate()
	#warn impl

/**
 * Basically [powered_melee_impact()] but checks for charge.
 *
 * @return TRUE if handled, FALSE otherwise
 */
/obj/item/melee/baton/proc/attempt_powered_melee_impact(atom/target, mob/attacker, datum/event_args/actor/clickchain/clickchain, use_target_zone)
	if(!use_charge(charge_cost))
		return TRUE
	powered_melee_impact(target, attacker, clickchain, use_target_zone)
	check_charge(charge_cost)
	return TRUE

/**
 * Does not affect the normal hit, this only performs the stun.
 *
 * @return TRUE if handled, FALSE otherwise
 */
/obj/item/melee/baton/proc/powered_melee_impact(atom/target, mob/attacker, datum/event_args/actor/clickchain/clickchain, use_target_zone)
	playsound(src, stun_sound, 75, TRUE)
	target.electrocute(computed_kilojoules, 0, stun_power, stun_electrocute_flags, use_target_zone || BP_TORSO, src)
	#warn impl


/obj/item/melee/baton/update_icon()
	. = ..()
	if(status)
		icon_state = "[initial(icon_state)]_active"
	else if(!bcell)
		icon_state = "[initial(icon_state)]_nocell"
	else
		icon_state = "[initial(icon_state)]"

	if(icon_state == "[initial(icon_state)]_active")
		set_light(2, 1, lightcolor)
	else
		set_light(0)

/obj/item/melee/baton/examine(mob/user, dist)
	. = ..()
	if(bcell)
		. += "<span class='notice'>The [src] is [round(bcell.percent())]% charged.</span>"
	if(!bcell)
		. += "<span class='warning'>The [src] does not have a power source installed.</span>"

/obj/item/melee/baton/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	if(use_external_power)
		//try to find our power cell
		var/mob/living/silicon/robot/R = loc
		if (istype(R))
			bcell = R.cell
	if(bcell && bcell.charge > charge_cost)
		status = !status
		to_chat(user, "<span class='notice'>[src] is now [status ? "on" : "off"].</span>")
		playsound(loc, /datum/soundbyte/grouped/sparks, 75, 1, -1)
		update_icon()
	else
		status = 0
		if(!bcell)
			to_chat(user, "<span class='warning'>[src] does not have a power source!</span>")
		else
			to_chat(user, "<span class='warning'>[src] is out of charge.</span>")
	add_fingerprint(user)

#warn much like bottles we need a way to override melee

/obj/item/melee/baton/legacy_mob_melee_hook(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(status && (MUTATION_CLUMSY in user.mutations) && prob(50))
		to_chat(user, "<span class='danger'>You accidentally hit yourself with the [src]!</span>")
		user.afflict_paralyze(20 * 30)
		deductcharge(charge_cost)
		return
	deductcharge(charge_cost)
	return ..()

/obj/item/melee/baton/melee_mob_hit(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	var/mob/living/L = target
	if(!istype(L))
		return
	if(isrobot(L))
		return ..()

	var/agony = agonyforce
	var/stun = stunforce
	var/obj/item/organ/external/affecting = null
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		affecting = H.get_organ(target_zone)

	if(user.a_intent == INTENT_HARM)
		. = ..()
		//whacking someone causes a much poorer electrical contact than deliberately prodding them.
		agony *= 0.5
		stun *= 0.5
	else if(!status)
		if(affecting)
			L.visible_message("<span class='warning'>[L] has been prodded in the [affecting.name] with [src] by [user]. Luckily it was off.</span>")
		else
			L.visible_message("<span class='warning'>[L] has been prodded with [src] by [user]. Luckily it was off.</span>")
	else
		if(affecting)
			L.visible_message("<span class='danger'>[L] has been prodded in the [affecting.name] with [src] by [user]!</span>")
		else
			L.visible_message("<span class='danger'>[L] has been prodded with [src] by [user]!</span>")

	//stun effects
	if(status)
		L.electrocute(0, 0, agony, NONE, target_zone, src)
		msg_admin_attack("[key_name(user)] stunned [key_name(L)] with the [src].")

/obj/item/melee/baton/loaded
	cell_type = /obj/item/cell/device/weapon

//secborg stun baton module
/obj/item/melee/baton/robot
	charge_cost = 500
	use_external_power = TRUE

//Makeshift stun baton. Replacement for stun gloves.
/obj/item/melee/baton/cattleprod
	name = "stunprod"
	desc = "An improvised stun baton."
	icon_state = "stunprod"
	item_state = "prod"
	damage_force = 3
	throw_force = 5
	stunforce = 0
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
	stunforce = 0
	stun_power = 60	//same force as a stunbaton, but uses way more charge.
	charge_cost = 2500
	attack_verb = list("poked")
	slot_flags = null

/obj/item/melee/baton/cattleprod/teleprod/powered_melee_impact(atom/target, mob/attacker, datum/event_args/actor/clickchain/clickchain, use_target_zone)
	. = ..()
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

/obj/item/melee/baton/shocker/powered_melee_impact(atom/target, mob/attacker, datum/event_args/actor/clickchain/clickchain, use_target_zone)
	. = ..()
	if(!isliving(target))
		return
	var/mob/living/L = target
	if(status && L.has_polaris_AI())
		L.taunt(user)

// Borg version, for the lost module.
/obj/item/melee/baton/shocker/robot
	use_external_power = TRUE

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
	stunforce = 5
	throw_force = 2
	stun_power = 120	//one-hit
	charge_cost = 1150
	stun_soud = 'sound/effects/lightningshock.ogg'

/obj/item/melee/baton/loaded/mini/object_cell_slot_mutable(mob/user, datum/object_system/cell_slot/slot)
	return FALSE
