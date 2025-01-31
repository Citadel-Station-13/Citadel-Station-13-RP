/**
 * Energy Guns
 *
 * These are guns that generally will only utilize energy to generate their ammunition.
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
	#warn impl
	var/datum/action/modular_particle_array_swap_action
	/**
	 * Particle array lethal safety action
	 *
	 * * Lazy inited when needed
	 */
	#warn impl
	var/datum/action/modular_particle_array_safety_action

	/**
	 * Lethal arrays are locked
	 *
	 * * This only stops the user from selecting in UI, this will not stop
	 * [set_particle_array] from manually forcing the gun to that mode!
	 * * Likewise, this will not stop firing cycles from selecting
	 *   a lethal mode.
	 */
	var/modular_particle_array_safety = FALSE

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
	update_icon()

/obj/item/gun/projectile/energy/Destroy()
	if(self_recharge)
		STOP_PROCESSING(SSobj, src)
	return ..()

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
					var/start_nutrition = H.nutrition
					var/end_nutrition = 0

					H.nutrition -= rechargeamt / 10

					end_nutrition = H.nutrition

					if(start_nutrition - max(0, end_nutrition) < rechargeamt / 10)
						H.remove_blood((rechargeamt / 10) - (start_nutrition - max(0, end_nutrition)))

			obj_cell_slot.cell.give(rechargeamt) //... to recharge 1/5th the battery
			update_icon()
		else
			charge_tick = 0
	return 1

/obj/item/gun/projectile/energy/attackby(var/obj/item/A as obj, mob/user as mob)
	..()

/obj/item/gun/projectile/energy/switch_firemodes(mob/user)
	if(..())
		update_icon()

/obj/item/gun/projectile/energy/emp_act(severity)
	..()
	update_icon()

/obj/item/gun/projectile/energy/consume_next_projectile(datum/gun_firing_cycle/cycle)
	if(modular_system)
		return modular_particle_array_active ? modular_particle_array_active.consume_next_projectile(cycle) : GUN_FIRED_FAIL_INERT
	var/datum/firemode/energy/energy_firemode = legacy_get_firemode()
	if(!istype(energy_firemode))
		return null
	var/effective_power_use = isnull(energy_firemode.charge_cost) ? charge_cost : energy_firemode.charge_cost
	if(effective_power_use)
		if(!obj_cell_slot?.checked_use(effective_power_use))
			return null
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
		if(charge_cost)
			var/shots_remaining = round(obj_cell_slot.cell.charge / max(1, charge_cost))	// Paranoia
			. += "Has [shots_remaining] shot\s remaining."
		else
			. += "Has infinite shots remaining."
	else
		. += "Does not have a power cell."

/obj/item/gun/projectile/energy/update_icon(ignore_inhands)
	. = ..()
	if((item_renderer || mob_renderer) || !render_use_legacy_by_default)
		return // using new system
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

	if(!ignore_inhands)
		update_worn_icon()

//* Actions *//

/obj/item/gun/energy/register_item_actions(mob/user)
	. = ..()
	modular_particle_array_safety_action?.grant(user.inventory.actions)
	modular_particle_array_swap_action?.grant(user.inventory.actions)

/obj/item/gun/energy/unregister_item_actions(mob/user)
	. = ..()
	modular_particle_array_safety_action?.revoke(user.inventory.actions)
	modular_particle_array_swap_action?.revoke(user.inventory.actions)

//* Ammo *//

/obj/item/gun/projectile/energy/get_ammo_ratio()
	var/obj/item/cell/cell = obj_cell_slot.cell
	if(!cell)
		return 0
	return cell.charge / cell.maxcharge


//* Power *//

/obj/item/gun/projectile/energy/object_cell_slot_mutable(mob/user, datum/object_system/cell_slot/slot)
	if(legacy_battery_lock)
		return FALSE
	return ..()
