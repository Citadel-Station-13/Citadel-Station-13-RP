/obj/item/cell/potato
	name = "potato battery"
	desc = "A rechargable starch based power cell."
	origin_tech = list(TECH_POWER = 1)
	icon = 'icons/obj/power.dmi' //'icons/obj/harvest.dmi'
	icon_state = "potato_cell" //"potato_battery"
	charge = 100
	max_charge = 300
	cell_type = CELL_TYPE_LARGE | CELL_TYPE_MEDIUM | CELL_TYPE_SMALL | CELL_TYPE_WEAPON

// todo: this isn't even a fucking cell get it out of here
//Not actually a cell, but if people look for it, they'll probably look near other cells
/obj/item/fbp_backup_cell
	name = "backup battery"
	desc = "A small one-time-use chemical battery for synthetic crew when they are low on power in emergency situations."
	icon = 'icons/obj/power.dmi'
	icon_state = "fbp_cell"
	w_class = WEIGHT_CLASS_SMALL
	var/amount = 100
	var/used = FALSE

/obj/item/fbp_backup_cell/Initialize(mapload)
	. = ..()
	add_overlay("[icon_state]1")

/obj/item/fbp_backup_cell/using_as_item(atom/target, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	var/mob/user = clickchain.performer
	if(!used && ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.isSynthetic() || fast_is_species_type(H, /datum/species/shapeshifter/holosphere))
			if(H.nutrition <= amount)
				use(user,H)
			else
				to_chat(user,"<span class='warning'>The difference in potential is too great. [user == target ? "You have" : "[H] has"] too much charge to use such a small battery.</span>")
		else if(target == user)
			to_chat(user,"<span class='warning'>You lick the cell, and your tongue tingles slightly.</span>")
		else
			to_chat(user,"<span class='warning'>This cell is meant for use on humanoid synthetics only.</span>")
		return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

/obj/item/fbp_backup_cell/proc/use(mob/living/user, mob/living/target)
	if(used)
		return
	used = TRUE
	desc += " This one has already been used."
	cut_overlays()
	target.nutrition += amount
	user.custom_emote(message = "connects \the [src] to [user == target ? "their" : "[target]'s"] charging port, expending it.")

/obj/item/cell/emergency_light
	name = "miniature power cell"
	desc = "A tiny power cell with a very low power capacity. Used in light fixtures to power them in the event of an outage."
	charge = 120
	max_charge = 120 //Emergency lights use 0.2 W per tick, meaning ~10 minutes of emergency power from a cell
	materials_base = list(MAT_GLASS = 20)
	w_class = WEIGHT_CLASS_TINY

/obj/item/cell/emergency_light/Initialize(mapload)
	. = ..()
	var/area/A = get_area(src)
	if(!A.lightswitch || !A.light_power)
		charge = 0 //For naturally depowered areas, we start with no power
