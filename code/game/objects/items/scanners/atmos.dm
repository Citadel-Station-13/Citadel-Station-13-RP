/obj/item/atmos_analyzer
	name = "analyzer"
	desc = "A hand-held environmental scanner which reports current gas levels."
	icon = 'icons/obj/device.dmi'
	icon_state = "atmos"
	item_state = "analyzer"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = SLOT_BELT
	throw_force = 5
	throw_speed = 4
	throw_range = 20
	materials_base = list(MAT_STEEL = 30, MAT_GLASS = 20)
	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)
	suit_storage_class = SUIT_STORAGE_CLASS_SOFTWEAR | SUIT_STORAGE_CLASS_HARDWEAR

/obj/item/atmos_analyzer/apidean
	name = "\improper Apidean analyzer"
	desc = "This analyzer has a strange, soft exterior and seems to faintly breathe."
	icon_state = "apidae-analyzer"

/obj/item/atmos_analyzer/longrange
	name = "long-range analyzer"
	desc = "A hand-held environmental scanner which reports current gas levels. This one uses bluespace technology."
	icon = 'icons/obj/device.dmi'
	icon_state = "atmos"
	item_state = "analyzer"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = SLOT_BELT
	throw_force = 5
	throw_speed = 4
	throw_range = 20
	materials_base = list(MAT_STEEL = 30, MAT_GLASS = 20)
	origin_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)

/obj/item/atmos_analyzer/atmosanalyze(var/mob/user)
	var/air = user.return_air()
	if (!air)
		return

	return atmosanalyzer_scan(src, air, user)

/obj/item/atmos_analyzer/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

	analyze_gases(src, user)
	return

/obj/item/atmos_analyzer/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY)
		if(istype(target, /obj/item/tank)) // don't double post what atmosanalyzer_scan returns
			return
		analyze_gases(target, user)
	return

/obj/item/atmos_analyzer/longrange/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(istype(target, /obj/item/tank)) // don't double post what atmosanalyzer_scan returns
		return
	analyze_gases(target, user)
	return
