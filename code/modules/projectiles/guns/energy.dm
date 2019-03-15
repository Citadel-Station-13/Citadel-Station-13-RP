/obj/item/gun/energy
	name = "energy gun"
	desc = "A basic energy-based gun."
	icon_state = "energy"
	icon = 'icons/obj/item/guns/energy.dmi'

	//PENDING STOCK PART CELL REFACTOR AND STUFF.
	var/obj/item/weapon/cell/cell
	var/cell_type = /obj/item/weapon/cell/device/weapon
	var/accept_cell_type = /obj/item/weapon/cell/device
	//	//accept_cell_types = CELLTYPE_DEVICE_SMALL | CELLTYPE_DEVICE_MEDIUM ...
	var/removable_battery = TRUE		//can remove battery by hand.

	var/self_recharge = FALSE
	var/recharge_last = 0			//last world.time
	var/recharge_fire_delay = 75	//time before it starts charging from firing
	var/recharge_amount = 3			//amount to charge per decisecond.

	var/use_external_cell = ENERGY_GUN_EXTERNAL_CHARGE
	var/external_cell_min_percent = 20				//0-100
	var/show_cell_charge = ENERGY_GUN_SHOW_SHOTS | ENERGY_GUN_SHOW_CHARGE
	var/starts_dead_cell = FALSE

	ammo_x_offset = 2
	var/automatic_charge_overlays = TRUE
	var/charge_sections = 4					//how many sections spritewise to divide gun charge to. 4 is 25, 50, 75, 100. empty = "empty"
	var/shaded_charge = FALSE				//This gun uses predefined sectioned sprites rather than dynamic generation
	var/old_ratio = 0						//old ammo ratio to see if it needs to update icon

/obj/item/gun/energy/Initialize()
	. = ..()
	chambered = new /obj/item/ammu_casing/energy
	if(ispath(cell_type))
		cell = new cell_type
	else
		cell = new /obj/item/weapon/cell/device/weapon
	if(self_recharge)
		START_PROCESSING(SSobj, src)
	if(!starts_dead_cell)
		cell.give(cell.maxcharge)
	else
		cell.charge = 0
	update_icon()

/obj/item/gun/energy/Destroy()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(cell)
	return ..()

/obj/item/gun/energy/vv_edit_var(var_name, var_value)
	. = ..()
	if(. && (var_name == NAMEOF(src, self_recharge)))
		if(self_recharge)
			START_PROCESSING(SSobj, src)
		else
			STOP_PROCESSING(SSobj, src)

/obj/item/gun/energy/get_cell()
	return power_supply

/obj/item/gun/energy/handle_atom_del(atom/A)
	if(A == cell)
		cell = null
		chambered?.clear_projectile()
		update_icon()
	return ..()

/obj/item/gun/energy/process()
	if(!self_recharge)
		return PROCESS_KILL
	if((world.time < (last_fire_time + recharge_fire_delay)) || !istype(cell))
		return ..()
	var/delay = world.time - recharge_last
	recharge_last = world.time
	if(use_external_power == ENERGY_GUN_EXTERNAL_CHARGE)
		var/obj/item/weapon/cell/ext = get_external_power_supply()
		if(!ext || (ext.percent() < external_cell_min_percent))
			return ..()
		var/used = ext.use(delay * recharge_amount)
		cell.give(used)
	else
		cell.give(delay * recharge_amount)
	update_icon()
	return ..()

/obj/item/gun/energy/emp_act(severity)
	. = ..()
	if(!(. & EMP_PROTECT_CONTENTS))
		cell.use(round(cell.charge / severity))
		update_icon()

/obj/item/gun/energy/examine(mob/user)
	. = ..()
	if(cell)
		if(show_cell_charge & ENERGY_GUN_SHOW_SHOTS)
			to_chat(user, "Has [round(cell.charge / firemode.e_cost)] shot\s remaining.")
		if(show_cell_charge & ENERGY_GUN_SHOW_CHARGE)
			to_chat(user, "Its power cell has [cell.charge]/[cell.maxcharge] kJ ([cell.percent()]) remaining.")
	else
		to_chat(user, "It does not seem to have a power cell.")

/obj/item/gun/energy/process_shot()
	charge_chamber()
	return ..()

/obj/item/gun/energy/can_shoot()
	return !QDELETED(cell) ? (cell.charge >= firemode.e_cost) : FALSE

//probably needs recoding at some point, but this ensures the chamber is charged with the right projectile type.
/obj/item/gun/energy/proc/charge_chamber()
	if(!chambered)
		return
	var/spent = chambered.is_spent()
	chambered.clear_projectile()
	if(!spent || drain_power(firemoode.e_cost))
		chambered.initialize_projectile()

/obj/item/gun/energy/proc/drain_power(amount)
	var/obj/item/weapon/power_cell/C = (use_external_cell == ENERGY_GUN_EXTERNAL_DIRECT)? get_external_power_supply() : cell
	if(!C || !C.check_charge(amount))
		return FALSE
	C.use(amount)
	return TRUE

/obj/item/gun/energy/attack_hand(mob/user as mob)
	. = ..()
	if(. & COMPONENT_NO_INTERACT)
		return
	if(user.get_inactive_hand() == src)
		unload_ammo(user)

/obj/item/gun/energy/AltClick(mob/uesr)
	. = ..()
	unload_ammo(user)

/obj/item/gun/energy/proc/get_external_power_supply()
	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		return R.cell
	//this needs reworking. rig rewrite not soon enough!
	if(istype(loc, /obj/item/rig_module))
		var/obj/item/rig_module/module = loc
		if(module.holder && module.holder.wearer)
			var/mob/living/carbon/human/H = module.holder.wearer
			if(istype(H) && H.back)
				var/obj/item/weapon/rig/suit = H.back
				if(istype(suit))
					return suit.cell
	else if(isitem(loc))
		var/obj/item/I = loc
		return I.get_cell()

//both of these return the old cell if it's removed, and do NOT have sanity checks/checks for types!
/obj/item/gun/energy/proc/insert_cell(obj/item/weapon/cell/C)
	. = cell
	if(.)
		cell.forceMove(drop_location())
	cell = C
	C.forceMove(src)
	process_chamber()
	update_icon()

/obj/item/gun/energy/proc/remove_cell()
	chambered?.clear_projectile()			//just in case..
	if(!cell)
		return
	cell.forceMove(drop_location())
	. = cell
	cell = null

/obj/item/gun/energy/proc/load_ammo(obj/item/weapon/cell/C, mob/user)
	if(!istype(C))
		return
	if(!removable_battery)
		to_chat(user, "<span class='warning'>[src] doesn't have a battery port!</span>")
		return
	if(!istype(C, accept_cell_type))
		to_chat(user, "<span class='warning'>[C] won't fit in [src]!</span>")
		return
	if(cell)
		to_chat(user, "<span class='warning'>[src] already has a power cell!</span>")
		return
	if(!user)
		return insert_cell(C)
	else
		user.visible_message("<span class='notice'>[user] starts to slot [C] into [src]...</span>")
		if(do_after(user, 5 * P.w_class))			//NEEDS TO BE CHANGED TO A LOAD SPEED OR SOMETHING SYSTEM LATER!
			user.remove_from_mob(C)
			load_cell(C)
			user.visible_message("[user] inserts [C] into [src].")
			playsound(src, 'sound/weapons/flipblade.ogg', 50, 1)
			process_chamber()
			update_icon()

/obj/item/gun/energy/proc/unload_ammo(mob/user)
	if(!removable_battery)
		to_chat(user, "<span class='warning'>[src] does not have a battery port.</span>")
		return
	if(!cell)
		to_chat(user, "<span class='warning'>[src] does not have a power cell.</span>")
		return
	. = remove_cell()
	playsound(src, 'sound/weapons/empty.ogg', 50, 1)
	update_icon()
	if(!.)
		return
	if(user)
		user.put_in_hands(.)
		user.visible_message("[user] removes [.] from [src].")

/obj/item/gun/energy/attackby(obj/item/I, mob/living/L)
	. = ..()
	load_ammo(I, L)

/obj/item/gun/energy/update_icon(force_update)
	if(QDELETED(src))
		return
	. = ..()
	if(!automatic_charge_overlays)
		return
	var/ratio = CEILING(CLAMP(cell.charge / cell.maxcharge, 0, 1) * charge_sections, 1)
	if(ratio == old_ratio && !force_update)
		return
	old_ratio = ratio
	cut_overlays()
	if(!cell)
		add_overlay("[icon_state]_open")
	var/iconState = "[icon_state]_charge"
	var/itemState = initial(item_state) || icon_state
	if(firemode.mode_icon_state)
		add_overlay("[icon_state]_[firemode.mode_icon_state]")
		iconState += "_[firemode.mode_icon_state]"
		if(itemState)
			itemState += "[firemode.mode_icon_state]"
	if(cell.charge < firemode.e_cost)
		add_overlay("[icon_state]_empty")
	else
		if(!shaded_charge)
			var/mutable_appearance/charge_overlay = mutable_appearance(icon, iconState)
			for(var/i = ratio, i >= 1, i--)
				charge_overlay.pixel_x = ammo_x_offset * (i - 1)
				charge_overlay.pixel_y = ammo_y_offset * (i - 1)
				add_overlay(charge_overlay)
		else
			add_overlay("[icon_state]_charge[ratio]")
	if(itemState)
		itemState += "[ratio]"
		item_state = itemState
	update_held_icon()

///////////////////////







/obj/item/gun/energy/get_description_interaction()
	var/list/results = list()

	if(!battery_lock && !self_recharge)
		if(power_supply)
			results += "[desc_panel_image("offhand")]to remove the weapon cell."
		else
			results += "[desc_panel_image("weapon cell")]to add a new weapon cell."

	results += ..()

	return results



////////////////




/*
/obj/item/gun/energy/suicide_act(mob/living/user)
	if (istype(user) && can_shoot() && can_trigger_gun(user) && user.get_bodypart(BODY_ZONE_HEAD))
		user.visible_message("<span class='suicide'>[user] is putting the barrel of [src] in [user.p_their()] mouth.  It looks like [user.p_theyre()] trying to commit suicide!</span>")
		sleep(25)
		if(user.is_holding(src))
			user.visible_message("<span class='suicide'>[user] melts [user.p_their()] face off with [src]!</span>")
			playsound(loc, fire_sound, 50, 1, -1)
			var/obj/item/ammo_casing/energy/shot = ammo_type[select]
			cell.use(shot.e_cost)
			update_icon()
			return(FIRELOSS)
		else
			user.visible_message("<span class='suicide'>[user] panics and starts choking to death!</span>")
			return(OXYLOSS)
	else
		user.visible_message("<span class='suicide'>[user] is pretending to melt [user.p_their()] face off with [src]! It looks like [user.p_theyre()] trying to commit suicide!</b></span>")
		playsound(src, dry_fire_sound, 30, TRUE)
		return (OXYLOSS)
*/


/*
/obj/item/gun/energy/ignition_effect(atom/A, mob/living/user)
	if(!can_shoot() || !ammo_type[select])
		shoot_with_empty_chamber()
		. = ""
	else
		var/obj/item/ammo_casing/energy/E = ammo_type[select]
		var/obj/item/projectile/energy/BB = E.BB
		if(!BB)
			. = ""
		else if(BB.nodamage || !BB.damage || BB.damage_type == STAMINA)
			user.visible_message("<span class='danger'>[user] tries to light [user.p_their()] [A.name] with [src], but it doesn't do anything. Dumbass.</span>")
			playsound(user, E.fire_sound, 50, 1)
			playsound(user, BB.hitsound, 50, 1)
			cell.use(E.e_cost)
			. = ""
		else if(BB.damage_type != BURN)
			user.visible_message("<span class='danger'>[user] tries to light [user.p_their()] [A.name] with [src], but only succeeds in utterly destroying it. Dumbass.</span>")
			playsound(user, E.fire_sound, 50, 1)
			playsound(user, BB.hitsound, 50, 1)
			cell.use(E.e_cost)
			qdel(A)
			. = ""
		else
			playsound(user, E.fire_sound, 50, 1)
			playsound(user, BB.hitsound, 50, 1)
			cell.use(E.e_cost)
			. = "<span class='danger'>[user] casually lights their [A.name] with [src]. Damn.</span>"
*/

