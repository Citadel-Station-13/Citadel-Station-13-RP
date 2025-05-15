/obj/item/cell/crap
	name = "\improper rechargable AA battery"
	desc = "You can't top the plasma top." //TOTALLY TRADEMARK INFRINGEMENT
	origin_tech = list(TECH_POWER = 0)
	maxcharge = 500
	materials_base = list(MAT_STEEL = 700, MAT_GLASS = 40)

/obj/item/cell/crap/empty
	charge = 0

/obj/item/cell/secborg
	name = "security borg rechargable D battery"
	origin_tech = list(TECH_POWER = 0)
	maxcharge = 600	//600 max charge / 100 charge per shot = six shots
	materials_base = list(MAT_STEEL = 700, MAT_GLASS = 40)

/obj/item/cell/secborg/empty
	charge = 0

/obj/item/cell/apc
	name = "heavy-duty power cell"
	origin_tech = list(TECH_POWER = 1)
	maxcharge = 5000
	materials_base = list(MAT_STEEL = 700, MAT_GLASS = 50)

/obj/item/cell/high
	name = "high-capacity power cell"
	origin_tech = list(TECH_POWER = 2)
	icon_state = "hcell"
	maxcharge = 10000
	materials_base = list(MAT_STEEL = 700, MAT_GLASS = 60)
	rating = 2

/obj/item/cell/high/empty
	charge = 0

/obj/item/cell/super
	name = "super-capacity power cell"
	origin_tech = list(TECH_POWER = 5)
	icon_state = "scell"
	maxcharge = 20000
	materials_base = list(MAT_STEEL = 700, MAT_GLASS = 70)
	rating = 3

/obj/item/cell/super/empty
	charge = 0

/obj/item/cell/hyper
	name = "hyper-capacity power cell"
	origin_tech = list(TECH_POWER = 6)
	icon_state = "hpcell"
	maxcharge = 30000
	materials_base = list(MAT_STEEL = 700, MAT_GLASS = 80)
	rating = 4

/obj/item/cell/hyper/empty
	charge = 0

/obj/item/cell/infinite
	name = "infinite-capacity power cell!"
	icon_state = "icell"
	origin_tech =  null
	maxcharge = 30000 //determines how badly mobs get shocked
	materials_base = list(MAT_STEEL = 700, MAT_GLASS = 80)
	rating = 6

/obj/item/cell/infinite/check_charge()
	return 1

/obj/item/cell/infinite/use()
	return 1

/obj/item/cell/potato
	name = "potato battery"
	desc = "A rechargable starch based power cell."
	origin_tech = list(TECH_POWER = 1)
	icon = 'icons/obj/power.dmi' //'icons/obj/harvest.dmi'
	icon_state = "potato_cell" //"potato_battery"
	charge = 100
	maxcharge = 300
	minor_fault = 1

/obj/item/cell/slime
	name = "charged slime core"
	desc = "A yellow slime core infused with phoron, it crackles with power."
	origin_tech = list(TECH_POWER = 4, TECH_BIO = 5)
	icon = 'icons/mob/slimes.dmi' //'icons/obj/harvest.dmi'
	icon_state = "yellow slime extract" //"potato_battery"
	description_info = "This 'cell' holds a max charge of 10k and self recharges over time."
	maxcharge = 10000
	materials_base = null
	rating = 5
	self_recharge = TRUE
	charge_amount = 750

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
		if(H.isSynthetic() || fast_is_species_type(H, /datum/species/holosphere))
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
	maxcharge = 120 //Emergency lights use 0.2 W per tick, meaning ~10 minutes of emergency power from a cell
	materials_base = list(MAT_GLASS = 20)
	w_class = WEIGHT_CLASS_TINY

/obj/item/cell/emergency_light/Initialize(mapload)
	. = ..()
	var/area/A = get_area(src)
	if(!A.lightswitch || !A.light_power)
		charge = 0 //For naturally depowered areas, we start with no power
