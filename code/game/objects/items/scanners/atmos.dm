/obj/item/analyzer
	name = "analyzer"
	desc = "A hand-held environmental scanner which reports current gas levels."
	icon = 'icons/obj/device.dmi'
	icon_state = "atmos"
	item_state = "analyzer"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	throw_force = 5
	throw_speed = 4
	throw_range = 20

	materials = list(MAT_STEEL = 30, MAT_GLASS = 20)

	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)

/obj/item/analyzer/apidean
	name = "\improper Apidean analyzer"
	desc = "This analyzer has a strange, soft exterior and seems to faintly breathe."
	icon_state = "apidae-analyzer"

/obj/item/analyzer/longrange
	name = "long-range analyzer"
	desc = "A hand-held environmental scanner which reports current gas levels. This one uses bluespace technology."
	icon = 'icons/obj/device.dmi'
	icon_state = "atmos"
	item_state = "analyzer"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	throw_force = 5
	throw_speed = 4
	throw_range = 20
	materials = list(MAT_STEEL = 30, MAT_GLASS = 20)
	origin_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)

/obj/item/analyzer/atmosanalyze(var/mob/user)
	var/air = user.return_air()
	if (!air)
		return

	return atmosanalyzer_scan(src, air, user)

/obj/item/analyzer/attack_self(mob/user)
	. = ..()
	if(.)
		return

	analyze_gases(src, user)
	return

/obj/item/analyzer/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY)
		if(istype(target, /obj/item/tank)) // don't double post what atmosanalyzer_scan returns
			return
		analyze_gases(target, user)
	return

/obj/item/analyzer/longrange/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(istype(target, /obj/item/tank)) // don't double post what atmosanalyzer_scan returns
		return
	analyze_gases(target, user)
	return
