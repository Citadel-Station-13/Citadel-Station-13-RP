//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/clothing/run_examine(datum/event_args/examine/examine, examine_for, examine_from)
	var/datum/event_args/examine_output/output = ..()
	if(examine_for & EXAMINE_FOR_ATTACHED)
		for(var/obj/item/clothing/attached as anything in accessories)
			var/encoded = attached.examine_encoding_as_accessory(examine, examine_for, examine_from)
			if(encoded)
				output.out_worn_descriptors += encoded
	return output

/obj/item/clothing/proc/examine_encoding_as_accessory(datum/event_args/examine/examine, examine_for, examine_from)
	#warn impl
	#warn blood / oil
	return "Attached is a [src]"
