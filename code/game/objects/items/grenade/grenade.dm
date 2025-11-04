/**
 * A thing you can throw that goes boom. Simple, really, but not always.
 *
 * TODO: /datum/grenade_effect, much like reagent / projectile effects for composition-based
 *       grenades
 */
/obj/item/grenade
	name = "grenade"
	desc = "A hand held grenade, with an adjustable timer."
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/grenade.dmi'
	icon_state = "grenade"
	item_state = "grenade"
	throw_speed = 4
	throw_range = 20
	slot_flags = SLOT_MASK|SLOT_BELT
	suit_storage_class = SUIT_STORAGE_CLASS_SOFTWEAR | SUIT_STORAGE_CLASS_HARDWEAR

	// todo: legacy var
	var/loadable = TRUE

/obj/item/grenade/on_attack_self(datum/event_args/actor/e_args)
	. = ..()
	if(.)
		return
	if(activate_inhand(e_args))
		return CLICKCHAIN_DID_SOMETHING

/**
 * @return TRUE to stop further inhand actions
 */
/obj/item/grenade/proc/activate_inhand(datum/event_args/actor/actor)
	on_activate_inhand(actor)
	return TRUE

/obj/item/grenade/proc/on_activate_inhand(datum/event_args/actor/actor)
	activate(actor)

/obj/item/grenade/proc/activate_shot_from_gun(obj/item/gun/gun, datum/gun_firing_cycle/cycle)
	on_activate_shot_from_gun(gun, cycle)

/obj/item/grenade/proc/on_activate_shot_from_gun(obj/item/gun/gun, datum/gun_firing_cycle/cycle)
	activate(cycle.firing_actor)

/obj/item/grenade/proc/activate(datum/event_args/actor/actor)
	on_activate(actor)

/obj/item/grenade/proc/on_activate(datum/event_args/actor/actor)
	SHOULD_CALL_PARENT(TRUE)
