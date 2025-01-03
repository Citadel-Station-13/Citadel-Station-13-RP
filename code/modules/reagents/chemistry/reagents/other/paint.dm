/**
 * data: #ffffffff 7-9 character rgb/rgba color string
 */
/datum/reagent/paint
	name = "Paint"
	id = "paint"
	holds_data = TRUE
	description = "This paint will stick to almost any object."
	taste_description = "chalk"
	reagent_state = REAGENT_LIQUID
	color = "#808080"
	overdose = REAGENTS_OVERDOSE * 0.5
	color_weight = 20

// todo: rework
/datum/reagent/paint/on_touch_turf(turf/target, remaining, allocated, data)
	target.color = compute_color_with_data(data)
	. = allocated
	allocated -= allocated
	. += ..()

// todo: rework
/datum/reagent/paint/on_touch_obj(obj/target, remaining, allocated, data)
	target.color = compute_color_with_data(data)
	. = allocated
	allocated -= allocated
	. += ..()

// todo: rework
/datum/reagent/paint/on_touch_mob(mob/target, remaining, allocated, data, zone)
	target.color = compute_color_with_data(data)
	. = allocated
	allocated -= allocated
	. += ..()

/datum/reagent/paint/compute_color_with_data(data)
	return data || "#ffffff"

/datum/reagent/paint/make_copy_data_initializer(data)
	return data

/datum/reagent/paint/preprocess_data(data_initializer)
	return data_initializer

/datum/reagent/paint/mix_data(old_data, old_volume, new_data, new_volume, datum/reagent_holder/holder)
	var/total_volume = old_volume + new_volume
	var/old_hex = uppertext(old_data || "#ffffff")
	var/new_hex = uppertext(new_data || "#ffffff")
	return rgb(
		((hex2num(copytext(old_hex, 2, 4)) * old_volume) + (hex2num(copytext(new_hex, 2, 4)))) / total_volume,
		((hex2num(copytext(old_hex, 4, 6)) * old_volume) + (hex2num(copytext(new_hex, 4, 6)))) / total_volume,
		((hex2num(copytext(old_hex, 6, 8)) * old_volume) + (hex2num(copytext(new_hex, 6, 8)))) / total_volume,
		((hex2num(length(old_hex) > 7 ? copytext(old_hex, 8, 10) : 255) * old_volume) + (hex2num(length(new_hex) > 7 ? copytext(new_hex, 8, 10) : 255))) / total_volume,
	)
