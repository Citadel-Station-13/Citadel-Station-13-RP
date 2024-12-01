//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/storage_numerical_display
	var/obj/item/rendered_object
	var/amount

/datum/storage_numerical_display/New(obj/item/sample, amount = 0)
	src.rendered_object = sample
	src.amount = amount

/proc/cmp_storage_numerical_displays_name_asc(datum/storage_numerical_display/A, datum/storage_numerical_display/B)
	return sorttext(B.rendered_object.name, A.rendered_object.name) || sorttext(B.rendered_object.type, A.rendered_object.type)
