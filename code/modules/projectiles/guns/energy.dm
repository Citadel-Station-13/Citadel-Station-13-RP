/obj/item/gun/energy
	name = "energy gun"
	desc = "A basic energy-based gun."
	icon_state = "energy"

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

/obj/item/gun/energy/Initialize()
	. = ..()
	if(ispath(cell_type))
		cell = new cell_type
	else
		cell = new /obj/item/weapon/cell/device/weapon
	if(self_recharge)
		START_PROCESSING(SSobj, src)
	if(!dead_cell)
		cell.give(cell.maxcharge)
	recharge_newshot(TRUE)

/obj/item/gun/energy/Destroy()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(cell)
	return ..()

/obj/item/gun/energy/vv_edit_var(var_name, var_value)
	. = ..()
	if(. && (var_name == NAMEOF(src, self_recharge)))
		self_recharge? START_PROCESSING(SSobj, src) : STOP_PROCESSING(SSobj, src)

/obj/item/gun/energy/get_cell()
	return power_supply

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
	process_chamber()
	update_icon()
	return ..()

/obj/item/gun/energy/set_firemode()
	. = ..()
	if(.)
		process_chamber()
		recharge_newshot(TRUE)
		update_icon(TRUE)

/obj/item/gun/energy/emp_act(severity)
	. = ..()
	if(!(. & EMP_PROTECT_CONTENTS))
		cell.use(round(cell.charge / severity))
		clear_chamber(FALSE, FALSE)		//we empty the chamber
		recharge_newshot() //and try to charge a new shot
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
	if(!chambered && can_shoot())
		process_chamber()
	return ..()

/obj/item/gun/energy/process_chamber()
	if(chambered && chambered.is_spent())
		cell.use(firemode.e_cost)
	clear_chamber(FALSE, FALSE)
	recharge_newshot()

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






/obj/item/gun/energy/proc/load_ammo(var/obj/item/C, mob/user)
	if(istype(C, /obj/item/weapon/cell))
		if(self_recharge || battery_lock)
			user << "<span class='notice'>[src] does not have a battery port.</span>"
			return
		if(istype(C, accept_cell_type))
			var/obj/item/weapon/cell/P = C
			if(power_supply)
				user << "<span class='notice'>[src] already has a power cell.</span>"
			else
				user.visible_message("[user] is reloading [src].", "<span class='notice'>You start to insert [P] into [src].</span>")
				if(do_after(user, 5 * P.w_class))
					user.remove_from_mob(P)
					power_supply = P
					P.loc = src
					user.visible_message("[user] inserts [P] into [src].", "<span class='notice'>You insert [P] into [src].</span>")
					playsound(src.loc, 'sound/weapons/flipblade.ogg', 50, 1)
					update_icon()
					update_held_icon()
		else
			user << "<span class='notice'>This cell is not fitted for [src].</span>"
	return

/obj/item/gun/energy/proc/unload_ammo(mob/user)
	if(self_recharge || battery_lock)
		user << "<span class='notice'>[src] does not have a battery port.</span>"
		return
	if(power_supply)
		user.put_in_hands(power_supply)
		power_supply.update_icon()
		user.visible_message("[user] removes [power_supply] from [src].", "<span class='notice'>You remove [power_supply] from [src].</span>")
		power_supply = null
		playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
		update_icon()
		update_held_icon()
	else
		user << "<span class='notice'>[src] does not have a power cell.</span>"

/obj/item/gun/energy/attackby(var/obj/item/A as obj, mob/user as mob)
	..()
	load_ammo(A, user)



/obj/item/gun/energy/update_icon(var/ignore_inhands)
	if(power_supply == null)
		if(modifystate)
			icon_state = "[modifystate]_open"
		else
			icon_state = "[initial(icon_state)]_open"
		return
	else if(charge_meter)
		var/ratio = power_supply.charge / power_supply.maxcharge

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

	if(!ignore_inhands) update_held_icon()

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




/obj/item/gun/energy
	icon_state = "energy"
	name = "energy gun"
	desc = "A basic energy-based gun."
	icon = 'icons/obj/guns/energy.dmi'

	var/modifystate = 0
	var/list/ammo_type = list(/obj/item/ammo_casing/energy)
	var/can_charge = 1 //Can it be charged in a recharger?
	var/automatic_charge_overlays = TRUE	//Do we handle overlays with base update_icon()?
	var/charge_sections = 4
	ammo_x_offset = 2
	var/shaded_charge = FALSE //if this gun uses a stateful charge bar for more detail
	var/old_ratio = 0 // stores the gun's previous ammo "ratio" to see if it needs an updated icon
	var/dead_cell = FALSE //set to true so the gun is given an empty cell

/obj/item/gun/energy/Initialize()
	. = ..()
	update_ammo_types()

/obj/item/gun/energy/proc/update_ammo_types()
	var/obj/item/ammo_casing/energy/shot
	for (var/i = 1, i <= ammo_type.len, i++)
		var/shottype = ammo_type[i]
		shot = new shottype(src)
		ammo_type[i] = shot
	shot = ammo_type[select]
	fire_sound = shot.fire_sound
	fire_delay = shot.delay

/obj/item/gun/energy/attack_self(mob/living/user as mob)
	if(ammo_type.len > 1)
		select_fire(user)
		update_icon()

/obj/item/gun/energy/can_shoot()
	var/obj/item/ammo_casing/energy/shot = ammo_type[select]
	return !QDELETED(cell) ? (cell.charge >= shot.e_cost) : FALSE

/obj/item/gun/energy/recharge_newshot(no_cyborg_drain)
	if (!ammo_type || !cell)
		return
	if(use_cyborg_cell && !no_cyborg_drain)
		if(iscyborg(loc))
			var/mob/living/silicon/robot/R = loc
			if(R.cell)
				var/obj/item/ammo_casing/energy/shot = ammo_type[select] //Necessary to find cost of shot
				if(R.cell.use(shot.e_cost)) 		//Take power from the borg...
					cell.give(shot.e_cost)	//... to recharge the shot
	if(!chambered)
		var/obj/item/ammo_casing/energy/AC = ammo_type[select]
		if(cell.charge >= AC.e_cost) //if there's enough power in the cell cell...
			chambered = AC //...prepare a new shot based on the current ammo type selected
			if(!chambered.BB)
				chambered.newshot()


/obj/item/gun/energy/proc/select_fire(mob/living/user)
	select++
	if (select > ammo_type.len)
		select = 1
	var/obj/item/ammo_casing/energy/shot = ammo_type[select]
	fire_sound = shot.fire_sound
	fire_delay = shot.delay
	if (shot.select_name)
		to_chat(user, "<span class='notice'>[src] is now set to [shot.select_name].</span>")
	chambered = null
	recharge_newshot(TRUE)
	update_icon(TRUE)

/obj/item/gun/energy/update_icon(force_update)
	if(QDELETED(src))
		return
	..()
	if(!automatic_charge_overlays)
		return
	var/ratio = CEILING(CLAMP(cell.charge / cell.maxcharge, 0, 1) * charge_sections, 1)
	if(ratio == old_ratio && !force_update)
		return
	old_ratio = ratio
	cut_overlays()
	var/obj/item/ammo_casing/energy/shot = ammo_type[select]
	var/iconState = "[icon_state]_charge"
	var/itemState = null
	if(!initial(item_state))
		itemState = icon_state
	if (modifystate)
		add_overlay("[icon_state]_[shot.select_name]")
		iconState += "_[shot.select_name]"
		if(itemState)
			itemState += "[shot.select_name]"
	if(cell.charge < shot.e_cost)
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
