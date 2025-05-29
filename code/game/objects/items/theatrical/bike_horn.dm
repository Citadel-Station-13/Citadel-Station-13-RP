// todo: /bike_horn
/obj/item/bikehorn
	name = "bike horn"
	desc = "A horn off of a bicycle."
	icon = 'icons/obj/items.dmi'
	icon_state = "bike_horn"
	item_state = "bike_horn"
	throw_force = 3
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = SLOT_HOLSTER
	throw_speed = 3
	throw_range = 15
	attack_verb = list("HONKED")

	var/last_honk = 0
	var/honk_cooldown = 2 SECONDS

	var/honk_sound = 'sound/items/bikehorn.ogg'
	var/honk_volume = 50
	var/honk_vary = TRUE

/obj/item/bikehorn/on_attack_self(datum/event_args/actor/e_args)
	. = ..()
	if(.)
		return
	if(last_honk > world.time - honk_cooldown)
		return
	last_honk = world.time
	honk(clickchain, clickchain_flags)
	return TRUE

/obj/item/bikehorn/proc/honk(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	playsound(
		src,
		honk_sound,
		honk_volume,
		honk_vary,
	)
	add_fingerprint(clickchain.performer)

/obj/item/bikehorn/golden
	name = "golden bike horn"
	desc = "Golden? Clearly, it's made with bananium! Honk!"
	icon_state = "gold_horn"
	item_state = "gold_horn"

/obj/item/bikehorn/rubberducky
	name = "rubber ducky"
	desc = "Rubber ducky you're so fine, you make bathtime lots of fuuun. Rubber ducky I'm awfully fooooond of yooooouuuu~"	//thanks doohl
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky"
