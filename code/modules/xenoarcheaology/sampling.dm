/obj/item/rocksliver
	name = "rock sliver"
	desc = "It looks extremely delicate."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "sliver1"
	w_class = WEIGHT_CLASS_TINY
	damage_mode = DAMAGE_MODE_SHARP
	var/datum/geosample/geological_data

/obj/item/rocksliver/Initialize(mapload)
	. = ..()
	icon_state = "sliver[rand(1, 3)]"
	pixel_x = rand(-8, 8)
	pixel_y = rand(-8 ,0)

/datum/geosample

/obj/item/core_sampler
	name = "core sampler"
	desc = "Used to extract geological core samples."
	icon = 'icons/obj/device.dmi'
	icon_state = "sampler0"
	item_state = "screwdriver_brown"
	w_class = WEIGHT_CLASS_TINY
	worth_intrinsic = 50
	suit_storage_class = SUIT_STORAGE_CLASS_SOFTWEAR | SUIT_STORAGE_CLASS_HARDWEAR

	var/sampled_turf = ""
	var/num_stored_bags = 10
	var/obj/item/evidencebag/filled_bag

/obj/item/core_sampler/examine(var/mob/user)
	. = ..()
	. += "<span class='notice'>Used to extract geological core samples - this one is [sampled_turf ? "full" : "empty"], and has [num_stored_bags] bag[num_stored_bags != 1 ? "s" : ""] remaining.</span>"

/obj/item/core_sampler/attackby(var/obj/item/I, var/mob/living/user)
	if(istype(I, /obj/item/evidencebag))
		if(I.contents.len)
			to_chat(user, "<span class='warning'>\The [I] is full.</span>")
			return
		if(num_stored_bags < 10)
			qdel(I)
			num_stored_bags += 1
			to_chat(user, "<span class='notice'>You insert \the [I] into \the [src].</span>")
		else
			to_chat(user, "<span class='warning'>\The [src] can not fit any more bags.</span>")
	else
		return ..()

/obj/item/core_sampler/proc/sample_item(var/item_to_sample, var/mob/user)
	var/datum/geosample/geo_data

	if(istype(item_to_sample, /obj/item/stack/ore))
		var/obj/item/stack/ore/O = item_to_sample
		geo_data = O.geologic_data

	if(geo_data)
		if(filled_bag)
			to_chat(user, "<span class='warning'>The core sampler is full.</span>")
		else if(num_stored_bags < 1)
			to_chat(user, "<span class='warning'>The core sampler is out of sample bags.</span>")
		else
			//create a new sample bag which we'll fill with rock samples
			filled_bag = new /obj/item/evidencebag(src)
			filled_bag.name = "sample bag"
			filled_bag.desc = "a bag for holding research samples."

			icon_state = "sampler1"
			--num_stored_bags

			//put in a rock sliver
			var/obj/item/rocksliver/R = new(filled_bag)
			R.geological_data = geo_data

			//update the sample bag
			filled_bag.icon_state = "evidence"
			var/image/I = image("icon"=R, "layer"=FLOAT_LAYER)
			filled_bag.add_overlay(I)
			filled_bag.add_overlay("evidence")
			filled_bag.set_weight_class(WEIGHT_CLASS_TINY)

			to_chat(user, "<span class='notice'>You take a core sample of the [item_to_sample].</span>")
	else
		to_chat(user, "<span class='warning'>You are unable to take a sample of [item_to_sample].</span>")

/obj/item/core_sampler/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	if(filled_bag)
		to_chat(user, "<span class='notice'>You eject the full sample bag.</span>")
		var/success = 0
		if(istype(src.loc, /mob))
			var/mob/M = src.loc
			success = M.put_in_inactive_hand(filled_bag)
		if(!success)
			filled_bag.loc = get_turf(src)
		filled_bag = null
		icon_state = "sampler0"
	else
		to_chat(user, "<span class='warning'>The core sampler is empty.</span>")
