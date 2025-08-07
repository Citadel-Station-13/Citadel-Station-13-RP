/**
 * Energy Guns
 *
 * These are guns that generally will only utilize energy to generate their ammunition.
 *
 * * Only /datum/firmeode/energy-typed firemodes are allowed in these guns.
 */
/obj/item/gun/projectile/energy
	name = "energy gun"
	desc = "A basic energy-based gun. Nanotrasen, Hephaestus, Ward-Takahashi, and countless other smaller corporations have their own version of this reliable design."
	icon = 'icons/obj/gun/energy.dmi'
	icon_state = "energy"
	fire_sound_text = "laser blast"

	accuracy = 100
	dispersion = list(0)

	cell_system = TRUE
	cell_type = /obj/item/cell/device/weapon
	firemodes = /datum/firemode/energy

	//* Modular System *//

	/**
	 * Currently selected particle array
	 *
	 * * Only populated if [modular_system] is TRUE
	 * * If null while modular system is on, the gun will misfire until it's enabled.
	 * * The particle array will entirely override firemode `projectile_type`
	 */
	var/obj/item/gun_component/particle_array/modular_particle_array_active

	/**
	 * Particle array selection action
	 *
	 * * Lazy inited when needed
	 */
	var/datum/action/modular_particle_array_swap_action

	//* Safety *//

	/**
	 * Lethal safety action
	 *
	 * * Lazy inited when needed
	 */
	var/datum/action/lethal_safety_action
	/**
	 * Lethal firemodes and particle arrays are locked
	 *
	 * * This only stops the user from selecting in UI, this will not stop
	 * [set_particle_array] or [set_firemode] from manually forcing the gun to that mode!
	 * * Likewise, this will not stop firing cycles from selecting
	 *   a lethal mode / array.
	 */
	var/lethal_safety = FALSE

	//! LEGACY BELOW !//
	// todo: do not use this var, use firemodes
	var/charge_cost = 240 //How much energy is needed to fire.

	projectile_type = /obj/projectile/beam/practice

	var/modifystate
	var/charge_meter = 1	//if set, the icon state will be chosen based on the current charge

	//self-recharging
	var/self_recharge = 0	//if set, the weapon will recharge itself
	var/use_external_power = 0 //if set, the weapon will look for an external power source to draw from, otherwise it recharges magically
	var/use_organic_power = 0 // If set, the weapon will draw from nutrition or blood.
	var/recharge_time = 4
	var/charge_tick = 0
	var/charge_delay = 75	//delay between firing and charging

	var/legacy_battery_lock = 0	//If set, weapon cannot switch batteries

/obj/item/gun/projectile/energy/Initialize(mapload)
	if(self_recharge)
		cell_system = TRUE
		cell_type = cell_type || /obj/item/cell/device/weapon
		START_PROCESSING(SSobj, src)
	. = ..()
	// todo: this isn't necessarily needed
	update_icon()

	reconsider_lethal_safety_action()
	reconsider_particle_array_action()

/obj/item/gun/projectile/energy/Destroy()
	if(self_recharge)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/gun/projectile/energy/update_overlays()
	. = ..()
	if(!(item_flags & ITEM_IN_INVENTORY))
		return
	if(!modular_system)
		return
	add_overlay(image('icons/modules/projectiles/guns/common-overlays.dmi', "lethal-[lethal_safety? "on" : "off"]"))

/obj/item/gun/projectile/energy/process(delta_time)
	if(self_recharge) //Every [recharge_time] ticks, recharge a shot for the battery
		if(world.time > last_fire + charge_delay)	//Doesn't work if you've fired recently
			if(!obj_cell_slot.cell || obj_cell_slot.cell.charge >= obj_cell_slot.cell.maxcharge)
				return 0 // check if we actually need to recharge

			charge_tick++
			if(charge_tick < recharge_time) return 0
			charge_tick = 0

			var/rechargeamt = obj_cell_slot.cell.maxcharge*0.2

			if(use_external_power)
				var/obj/item/cell/external = get_external_power_supply()
				if(!external || !external.use(rechargeamt)) //Take power from the borg...
					return 0

			if(use_organic_power)
				var/mob/living/carbon/human/H
				if(ishuman(loc))
					H = loc

				if(istype(loc, /obj/item/organ))
					var/obj/item/organ/O = loc
					if(O.owner)
						H = O.owner

				if(istype(H))
					H.nutrition -= rechargeamt / 10

			obj_cell_slot.cell.give(rechargeamt) //... to recharge 1/5th the battery
			update_icon()
		else
			charge_tick = 0
	return 1

/obj/item/gun/projectile/energy/emp_act(severity)
	..()
	update_icon()

/obj/item/gun/projectile/energy/consume_next_projectile(datum/gun_firing_cycle/cycle)
	if(modular_system)
		return modular_particle_array_active ? modular_particle_array_active.consume_next_projectile(cycle) : GUN_FIRED_FAIL_INERT
	var/datum/firemode/energy/energy_firemode = firemode
	if(!istype(energy_firemode))
		return GUN_FIRED_FAIL_INERT
	var/effective_power_use = isnull(energy_firemode.charge_cost) ? charge_cost : energy_firemode.charge_cost
	if(effective_power_use)
		if(!obj_cell_slot?.checked_use(effective_power_use))
			return GUN_FIRED_FAIL_EMPTY
	return energy_firemode.instance_projectile()

/obj/item/gun/projectile/energy/proc/get_external_power_supply()
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		return R.cell
	if(istype(src.loc, /obj/item/hardsuit_module))
		var/obj/item/hardsuit_module/module = src.loc
		if(module.holder && module.holder.wearer)
			var/mob/living/carbon/human/H = module.holder.wearer
			if(istype(H) && H.back)
				var/obj/item/hardsuit/suit = H.back
				if(istype(suit))
					return suit.cell
	return null

/obj/item/gun/projectile/energy/examine(mob/user, dist)
	. = ..()
	if(obj_cell_slot.cell)
		if(!modular_system)
			// todo: proper modular system handling for estimation
			var/shots_remaining = get_estimated_shots_remaining()
			if(shots_remaining != INFINITY)
				. += "Has [shots_remaining] shot\s remaining."
			else
				. += "Has infinite shots remaining."
	else
		. += "Does not have a power cell."

/obj/item/gun/projectile/energy/update_icon()
	. = ..()
	if(!(item_renderer || mob_renderer) && render_use_legacy_by_default)
		if(obj_cell_slot.cell == null)
			if(modifystate)
				icon_state = "[modifystate]_open"
			else
				icon_state = "[initial(icon_state)]_open"
			return
		else if(charge_meter)
			var/ratio = obj_cell_slot.cell.percent() * 0.01

			//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
			if(obj_cell_slot.cell.charge < charge_cost)
				ratio = 0
			else
				ratio = max(round(ratio, 0.25) * 100, 25)

			if(modifystate)
				icon_state = "[modifystate][ratio]"
			else
				icon_state = "[initial(icon_state)][ratio]"

		else if(obj_cell_slot.cell)
			if(modifystate)
				icon_state = "[modifystate]"
			else
				icon_state = "[initial(icon_state)]"

		update_worn_icon()

	modular_particle_array_swap_action?.update_buttons()
	lethal_safety_action?.update_buttons()

//* Actions *//

/obj/item/gun/projectile/energy/register_item_actions(mob/user)
	. = ..()
	lethal_safety_action?.grant(user.inventory.actions)
	modular_particle_array_swap_action?.grant(user.inventory.actions)

/obj/item/gun/projectile/energy/unregister_item_actions(mob/user)
	. = ..()
	lethal_safety_action?.revoke(user.inventory.actions)
	modular_particle_array_swap_action?.revoke(user.inventory.actions)

/obj/item/gun/projectile/energy/proc/reconsider_particle_array_action()
	if(!modular_system)
		QDEL_NULL(modular_particle_array_swap_action)
	else
		if(!modular_particle_array_swap_action)
			lethal_safety_action = new /datum/action/item_action/gun_particle_array_swap(src)
			if(inv_inside)
				lethal_safety_action.grant(inv_inside.actions)

/obj/item/gun/projectile/energy/proc/reconsider_lethal_safety_action()
	var/has_lethal_modes = modular_system || has_mixed_lethality_firemodes()

	if(!has_lethal_modes)
		QDEL_NULL(lethal_safety_action)
		// flip lethal safety off, just in case we have all lethal firemodes
		lethal_safety = FALSE
	else
		if(!lethal_safety_action)
			lethal_safety_action = new /datum/action/item_action/gun_particle_array_safety(src)
			if(inv_inside)
				lethal_safety_action.grant(inv_inside.actions)

//* Ammo *//

/obj/item/gun/projectile/energy/get_ammo_ratio(rounded)
	var/obj/item/cell/cell = obj_cell_slot.cell
	if(!cell)
		return 0
	var/estimated_cost = get_estimated_charge_cost()
	if(!estimated_cost)
		return 1
	if(rounded)
		var/full_shots = floor(cell.maxcharge / estimated_cost)
		if(!full_shots)
			return 0
		return min(1, floor(cell.charge / estimated_cost) / full_shots)
	return min(1, cell.maxcharge ? cell.charge / cell.maxcharge : 0)

/**
 * Estimates how many shots the gun's power supply has charge for
 *
 * todo: no consideration for firing charge modifiers imparted by modular components
 */
/obj/item/gun/projectile/energy/proc/get_estimated_charge_cost()
	if(modular_system)
		return modular_particle_array_active?.base_charge_cost
	var/datum/firemode/energy/energy_firemode = firemode
	return energy_firemode.charge_cost

/**
 * Estimates how many shots the gun's power supply has charge for
 *
 * todo: no consideration for mounting
 *
 * @return estimated shot amount, or INFINITY if we do not use charge or are in an invalid state
 */
/obj/item/gun/projectile/energy/proc/get_estimated_shots_remaining()
	var/obj/item/cell/cell = obj_cell_slot.cell
	if(!cell)
		return 0
	var/estimated_cost = get_estimated_charge_cost()
	if(!estimated_cost)
		return INFINITY
	return floor(cell.charge / estimated_cost)

/**
 * Estimates how many shots the gun's power supply can hold, total
 *
 * todo: no consideration for mounting
 *
 * @return estimated shot amount, or INFINITY if we do not use charge or are in an invalid state
 */
/obj/item/gun/projectile/energy/proc/get_estimated_shots_capacity()
	var/obj/item/cell/cell = obj_cell_slot.cell
	if(!cell)
		return 0
	var/estimated_cost = get_estimated_charge_cost()
	if(!estimated_cost)
		return INFINITY
	return floor(cell.maxcharge / estimated_cost)

//* Power *//

/obj/item/gun/projectile/energy/object_cell_slot_mutable(mob/user, datum/object_system/cell_slot/slot)
	if(legacy_battery_lock)
		return FALSE
	return ..()

//* Rendering *//

/obj/item/gun/projectile/energy/get_firemode_color()
	return modular_particle_array_active ? modular_particle_array_active.render_color : ..()

//* Safety *//

/obj/item/gun/projectile/energy/proc/user_swap_lethal_safety(datum/event_args/actor/actor)
	lethal_safety = !lethal_safety
	if(lethal_safety)
		actor.chat_feedback(
			SPAN_NOTICE("You enable [src]'s lethal-mode safety."),
			target = src,
		)
	else
		actor.chat_feedback(
			SPAN_WARNING("You disable [src]'s lethal-mode safety."),
			target = src,
		)

	if(modular_particle_array_active?.considered_lethal)
		user_swap_particle_array(actor)
	var/datum/firemode/energy/current_firemode = firemode
	if(current_firemode?.considered_lethal)
		user_switch_firemodes(actor)

//* Action Datums *//

/datum/action/item_action/gun_particle_array_safety
	name = "Toggle Lethal Arrays"
	desc = "Toggle being able to swap to installed particle arrays that are considered lethal."
	target_type = /obj/item/gun/projectile/energy
	check_mobility_flags = MOBILITY_CAN_USE

/datum/action/item_action/gun_particle_array_safety/pre_render_hook()
	. = ..()
	var/image/item_overlay = button_additional_overlay
	var/image/symbol_overlay = image('icons/screen/actions/generic-overlays.dmi', "lock")
	symbol_overlay.color = "#ccaa00"
	item_overlay.add_overlay(symbol_overlay)

/datum/action/item_action/gun_particle_array_safety/invoke_target(obj/item/gun/projectile/energy/target, datum/event_args/actor/actor)
	. = ..()
	target.user_swap_lethal_safety(actor)

/datum/action/item_action/gun_particle_array_swap
	name = "Toggle Particle Array"
	desc = "Toggle the active particle array being used."
	target_type = /obj/item/gun/projectile/energy
	check_mobility_flags = MOBILITY_CAN_USE

/datum/action/item_action/gun_particle_array_swap/pre_render_hook()
	. = ..()
	var/image/item_overlay = button_additional_overlay
	var/image/symbol_overlay = image('icons/modules/projectiles/components/particle_array.dmi', "stock")
	symbol_overlay.pixel_x = 10
	symbol_overlay.pixel_y = 8
	item_overlay.add_overlay(symbol_overlay)
	target_type = /obj/item/gun/projectile/energy

/datum/action/item_action/gun_particle_array_swap/invoke_target(obj/item/gun/projectile/energy/target, datum/event_args/actor/actor)
	. = ..()
	target.user_swap_particle_array(actor)
