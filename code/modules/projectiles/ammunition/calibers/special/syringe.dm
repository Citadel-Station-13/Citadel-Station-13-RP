/datum/ammo_caliber/syringe
	id = "syringe"
	caliber = "syringe"

/obj/item/ammo_casing/syringe
	name = "syringe gun cartridge"
	desc = "An impact-triggered compressed gas cartridge that can be fitted to a syringe for rapid injection."
	icon = 'icons/modules/projectiles/casings/syringe.dmi'
	icon_state = "syringe-cartridge"
	materials_base = list(MAT_STEEL = 125, MAT_GLASS = 375)
	slot_flags = SLOT_BELT | SLOT_EARS
	throw_force = 3
	damage_force = 3
	casing_flags = CASING_DELETE
	w_class = WEIGHT_CLASS_TINY

	projectile_type = /obj/projectile/syringe

	var/obj/item/reagent_containers/syringe/syringe


/obj/item/ammo_casing/syringe/expend()
	var/obj/projectile/syringe/maybe_syringe = ..()
	if(!istype(maybe_syringe))
		return maybe_syringe
	if(syringe)
		syringe.forceMove(maybe_syringe)
		maybe_syringe.syringe = syringe
		syringe = null
	return maybe_syringe

/obj/item/ammo_casing/syringe/update_icon()
	underlays.Cut()
	. = ..()
	if(syringe)
		underlays += image(syringe.icon, src, syringe.icon_state)
		underlays += syringe.filling

/obj/item/ammo_casing/syringe/using_item_on(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(.)
		return
	if(istype(using, /obj/item/reagent_containers/syringe))
		if(!clickchain.performer.attempt_insert_item_for_installation(using, src))
			return TRUE
		syringe = using
		clickchain.chat_feedback(SPAN_NOTICE("You carefully insert [using] into [src]"), target = src)
		damage_mode |= DAMAGE_MODE_SHARP
		update_icon()
		return TRUE

/obj/item/ammo_casing/syringe/on_attack_hand(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(.)
		return
	if(!clickchain.performer.is_holding_inactive(src))
		return
	if(!syringe)
		return
	clickchain.chat_feedback(SPAN_NOTICE("You remove [syringe] from [src]."))
	clickchain.performer.grab_item_from_interacted_with(syringe, src)
	syringe = null
	playsound(src, 'sound/weapons/empty.ogg', 50, TRUE)
	damage_mode &= ~DAMAGE_MODE_SHARP
	update_icon()

/obj/projectile/syringe
	name = "syringe"
	icon = 'icons/modules/projectiles/projectile-misc.dmi'
	icon_state = "syringe"
	impact_sound = PROJECTILE_IMPACT_SOUNDS_KINETIC
	var/obj/item/reagent_containers/syringe/syringe

/obj/projectile/syringe/proc/set_syringe(obj/item/reagent_containers/syringe/syringe)
	src.syringe = syringe
	src.name = syringe.name
	src.desc = syringe.desc

/obj/projectile/syringe/expire(impacting)
	syringe?.forceMove(drop_location())
	syringe = null
	return ..()

/obj/projectile/syringe/on_impact(atom/target, impact_flags, def_zone, efficiency)
	if(!syringe)
		return ..()
	var/units_injected = 0
	impact_flags = syringe.handle_impact_as_projectile(target, impact_flags, def_zone, efficiency, &units_injected)
	if(units_injected)
		add_attack_logs(firer, target, "Shot with [src.name] transferring [units_injected] units")
	return ..()
