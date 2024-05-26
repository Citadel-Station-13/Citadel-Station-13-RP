/datum/firemode/energy
	/// projectile type
	var/projectile_type = /obj/projectile/beam
	/// charge cost in cell units
	var/charge_cost = 240


/datum/object_system/cell_slot/energy_gun
	insert_sound = 'sound/weapons/flipblade.ogg'
	remove_sound = 'sound/weapons/empty.ogg'

/obj/item/gun/projectile/energy
	name = "energy gun"
	desc = "A basic energy-based gun. Nanotrasen, Hephaestus, Ward-Takahashi, and countless other smaller corporations have their own version of this reliable design."
	icon = 'icons/obj/gun/energy.dmi'
	icon_state = "energy"
	fire_sound_text = "laser blast"

	accuracy = 100
	dispersion = list(0)

	//* Rendering
	rendered_projectile_type = /obj/projectile/beam

	/// starting cell type
	/// this is spawned into our object cell slot system on init.
	var/cell_initial = /obj/item/cell/device/weapon
	/// only accepts device cells?
	/// this affects our object cell slot system, change that at runtime instead of this or make a wrapper.
	var/cell_device_only = TRUE
	/// cell is removable
	var/cell_removable = TRUE

	/// lazy way to set self recharging without setting it on the cell
	var/self_charging = FALSE
	/// charge rate in cell units per second
	var/self_charging_rate = 24

	/// use external source for self charging
	//  todo: this is shit, we need item mount system
	var/charge_external_draw = FALSE
	/// use organic source for self charging
	//  todo: this is shit, we need item mount system
	var/charge_organic_draw = FALSE

/obj/item/gun/projectile/energy/Initialize(mapload)
	reload_cell_slot()
	if(self_charging)
		START_PROCESSING(SSobj, src)
	return ..()

/obj/item/gun/projectile/energy/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/gun/projectile/energy/vv_edit_var(var_name, var_value, mass_edit, raw_edit)
	#warn impl

/obj/item/gun/projectile/energy/object_cell_slot_mutable(mob/user, datum/object_system/cell_slot/slot)
	return ..() && cell_removable

/obj/item/gun/projectile/energy/proc/reload_cell_slot(creating)
	var/datum/object_system/cell_slot/slot
	if(isnull(obj_cell_slot))
		slot = init_cell_slot(/datum/object_system/cell_slot/energy_gun)
	else
		slot = obj_cell_slot
	if(creating)
		var/obj/item/cell/existing = obj_cell_slot.remove_cell()
		if(!isnull(existing))
			qdel(existing)
		obj_cell_slot.insert_cell(new cell_initial(src))
	obj_cell_slot.legacy_use_device_cells = cell_device_only

/obj/item/gun/projectile/energy/get_ammo_percent()
	var/datum/firemode/energy/firemode = src.firemode
	if(!firemode.charge_cost)
		return 1
	return obj_cell_slot.cell.charge / obj_cell_slot.cell.maxcharge

/obj/item/gun/projectile/energy/get_ammo_amount()
	var/datum/firemode/energy/firemode = src.firemode
	if(!firemode.charge_cost)
		return INFINITY
	return obj_cell_slot.cell.charge / firemode.charge_cost

/obj/item/gun/projectile/energy/proc/draw_power(units, allow_partial = FALSE)
	#warn impl

/obj/item/gun/projectile/energy/consume_next_projectile()
	if(isnull(src.firemode))
		return
	var/datum/firemode/energy/firemode = src.firmode
	if(!draw_power(firemode.charge_cost))
		return
	return new firemode.projectile_type

/obj/item/gun/projectile/energy/emp_act(severity)
	. = ..()
	update_icon()

/obj/item/gun/projectile/energy/process(delta_time)
	if(!self_charging)
		return PROCESS_KILL
	var/amount = self_charging_rate * delta_time
	if(charge_external_draw)
		var/obj/item/cell/external = get_external_power_supply()
		amount = external?.use(amount) || 0
	else if(charge_organic_draw)
		var/mob/living/carbon/human/external
		if(ishuman(loc))
			external = loc
		if(isorgan(loc))
			var/obj/item/organ/external_organ = loc
			external = external_organ.owner
		if(isnull(external))
			amount = 0
		else
			amount = min(amount, external.nutrition * 10)
			external.adjust_nutrition(-amount * 0.1)
	if(!amount)
		return
	obj_cell_slot?.cell?.give(amount)

/obj/item/gun/projectile/energy/inducer_scan(obj/item/inducer/I, list/things_to_induce, inducer_flags)
	if(inducer_flags & INDUCER_NO_GUNS)
		return
	return ..()

#warn below

/obj/item/gun/projectile/energy
	var/modifystate

/obj/item/gun/projectile/energy/proc/load_ammo(var/obj/item/C, mob/user)
	if(istype(C, /obj/item/cell))
		if(self_recharge || battery_lock)
			to_chat(user, "<span class='notice'>[src] does not have a battery port.</span>")
			return
		if(istype(C, accept_cell_type))
			var/obj/item/cell/P = C
			if(power_supply)
				to_chat(user, "<span class='notice'>[src] already has a power cell.</span>")
			else
				user.visible_message("[user] is reloading [src].", "<span class='notice'>You start to insert [P] into [src].</span>")
				if(do_after(user, 5 * P.w_class))
					if(!user.attempt_insert_item_for_installation(P, src))
						return
					power_supply = P
					user.visible_message("[user] inserts [P] into [src].", "<span class='notice'>You insert [P] into [src].</span>")
					playsound(src, 'sound/weapons/flipblade.ogg', 50, 1)
					update_icon()
					update_held_icon()
		else
			to_chat(user, "<span class='notice'>This cell is not fitted for [src].</span>")
	return

/obj/item/gun/projectile/energy/proc/unload_ammo(mob/user)
	if(self_recharge || battery_lock)
		to_chat(user, "<span class='notice'>[src] does not have a battery port.</span>")
		return
	if(power_supply)
		user.put_in_hands(power_supply)
		power_supply.update_icon()
		user.visible_message("[user] removes [power_supply] from [src].", "<span class='notice'>You remove [power_supply] from [src].</span>")
		power_supply = null
		playsound(src, 'sound/weapons/empty.ogg', 50, 1)
		update_icon()
		update_held_icon()
	else
		to_chat(user, "<span class='notice'>[src] does not have a power cell.</span>")

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

/obj/item/gun/projectile/energy/update_icon(ignore_inhands)
	. = ..()
	if(power_supply == null)
		if(modifystate)
			icon_state = "[modifystate]_open"
		else
			icon_state = "[initial(icon_state)]_open"
		return
	else if(charge_meter)
		var/ratio = power_supply.percent() * 0.01

		//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
		if(power_supply.charge < charge_cost)
			ratio = 0
		else
			ratio = max(round(ratio, 0.25) * 100, 25)

		if(modifystate)
			icon_state = "[modifystate][ratio]"
		else
			icon_state = "[initial(icon_state)][ratio]"

	else if(power_supply)
		if(modifystate)
			icon_state = "[modifystate]"
		else
			icon_state = "[initial(icon_state)]"

	if(!ignore_inhands)
		update_held_icon()
