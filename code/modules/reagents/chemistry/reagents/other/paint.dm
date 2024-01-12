/datum/reagent/crayon_dust
	name = "Crayon dust"
	id = "crayon_dust"
	description = "Intensely coloured powder obtained by grinding crayons."
	taste_description = "powdered wax"
	reagent_state = REAGENT_LIQUID
	color = "#888888"
	bloodstream_overdose_threshold = 5
	dermal_overdose_threshold = 10
	dermal_overdose_metabolism_multiplier = 2
	dermal_overdose_toxin_scaling = 0.5

/datum/reagent/crayon_dust/red
	name = "Red crayon dust"
	id = "crayon_dust_red"
	color = "#FE191A"

/datum/reagent/crayon_dust/orange
	name = "Orange crayon dust"
	id = "crayon_dust_orange"
	color = "#FFBE4F"

/datum/reagent/crayon_dust/yellow
	name = "Yellow crayon dust"
	id = "crayon_dust_yellow"
	color = "#FDFE7D"

/datum/reagent/crayon_dust/green
	name = "Green crayon dust"
	id = "crayon_dust_green"
	color = "#18A31A"

/datum/reagent/crayon_dust/blue
	name = "Blue crayon dust"
	id = "crayon_dust_blue"
	color = "#247CFF"

/datum/reagent/crayon_dust/purple
	name = "Purple crayon dust"
	id = "crayon_dust_purple"
	color = "#CC0099"

/datum/reagent/crayon_dust/grey //Mime
	name = "Grey crayon dust"
	id = "crayon_dust_grey"
	color = "#808080"

/datum/reagent/crayon_dust/brown //Rainbow
	name = "Brown crayon dust"
	id = "crayon_dust_brown"
	color = "#846F35"

/datum/reagent/marker_ink
	name = "Marker ink"
	id = "marker_ink"
	description = "Intensely coloured ink used in markers."
	taste_description = "extremely bitter"
	reagent_state = REAGENT_LIQUID
	color = "#888888"
	bloodstream_overdose_threshold = 5
	dermal_overdose_threshold = 10
	dermal_overdose_metabolism_multiplier = 2
	dermal_overdose_toxin_scaling = 0.5

/datum/reagent/marker_ink/black
	name = "Black marker ink"
	id = "marker_ink_black"
	color = "#000000"

/datum/reagent/marker_ink/red
	name = "Red marker ink"
	id = "marker_ink_red"
	color = "#FE191A"

/datum/reagent/marker_ink/orange
	name = "Orange marker ink"
	id = "marker_ink_orange"
	color = "#FFBE4F"

/datum/reagent/marker_ink/yellow
	name = "Yellow marker ink"
	id = "marker_ink_yellow"
	color = "#FDFE7D"

/datum/reagent/marker_ink/green
	name = "Green marker ink"
	id = "marker_ink_green"
	color = "#18A31A"

/datum/reagent/marker_ink/blue
	name = "Blue marker ink"
	id = "marker_ink_blue"
	color = "#247CFF"

/datum/reagent/marker_ink/purple
	name = "Purple marker ink"
	id = "marker_ink_purple"
	color = "#CC0099"

/datum/reagent/marker_ink/grey //Mime
	name = "Grey marker ink"
	id = "marker_ink_grey"
	color = "#808080"

/datum/reagent/marker_ink/brown //Rainbow
	name = "Brown marker ink"
	id = "marker_ink_brown"
	color = "#846F35"

/datum/reagent/chalk_dust
	name = "chalk dust"
	id = "chalk_dust"
	description = "Dusty powder obtained by grinding chalk."
	taste_description = "powdered chalk"
	reagent_state = REAGENT_LIQUID
	color = "#FFFFFF"
	bloodstream_overdose_threshold = 5
	dermal_overdose_threshold = 10
	dermal_overdose_metabolism_multiplier = 2
	dermal_overdose_toxin_scaling = 0.5

/datum/reagent/chalk_dust/red
	name = "red chalk dust"
	id = "chalk_dust_red"
	color = "#aa0000"

/datum/reagent/chalk_dust/black
	name = "black chalk dust"
	id = "chalk_dust_black"
	color = "#180000"

/datum/reagent/chalk_dust/blue
	name = "blue chalk dust"
	id = "chalk_dust_blue"
	color = "#000370"

/datum/reagent/paint
	name = "Paint"
	id = "paint"
	description = "This paint will stick to almost any object."
	taste_description = "chalk"
	reagent_state = REAGENT_LIQUID
	color = "#808080"
	bloodstream_overdose_threshold = 5
	dermal_overdose_threshold = 10
	dermal_overdose_metabolism_multiplier = 2
	dermal_overdose_toxin_scaling = 0.5
	color_weight = 20

/datum/reagent/paint/contact_expose_turf(turf/target, volume, temperature, list/data, vapor)
	. = ..()

	var/turf/T = target
	if(istype(T) && !istype(T, /turf/space))
		T.color = color

/datum/reagent/paint/contact_expose_obj(obj/target, volume, list/data, vapor)
	. = ..()

	var/obj/O = target
	if(istype(O))
		O.color = color

/datum/reagent/paint/init_data(datum/reagent_holder/holder, amount, list/given_data)
	return list("color" = given_data?["color"] || "#ffffff")

/datum/reagent/paint/mix_data(datum/reagent_holder/holder, list/current_data, current_amount, list/new_data, new_amount)
	var/existing = current_data["color"]
	var/incoming = new_data?["color"] || "#ffffff"

	return list(
		"color" = BlendRGB(existing, incoming, new_amount / (current_amount + new_amount)),
	)
