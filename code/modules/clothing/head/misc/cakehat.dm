/obj/item/clothing/head/cakehat
	name = "cake-hat"
	desc = "It's tasty looking!"
	icon_state = "cake0"
	body_cover_flags = HEAD
	var/onfire = 0

/obj/item/clothing/head/cakehat/process(delta_time)
	if(!onfire)
		STOP_PROCESSING(SSobj, src)
		return

	var/turf/maybe_turf_location = inv_slot_or_index ? get_turf(inv_inside?.owner) : loc
	if(isturf(maybe_turf_location))
		maybe_turf_location.hotspot_expose(700, 1)

/obj/item/clothing/head/cakehat/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	onfire = !(onfire)
	if (onfire)
		damage_force = 3
		damage_type = DAMAGE_TYPE_BURN
		icon_state = "cake1"
		START_PROCESSING(SSobj, src)
	else
		damage_force = 0
		damage_type = DAMAGE_TYPE_BRUTE
		icon_state = "cake0"
