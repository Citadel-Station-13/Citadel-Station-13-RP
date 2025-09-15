/datum/chemical_reaction/paint
	abstract_type = /datum/chemical_reaction/paint
	var/result_color

/datum/chemical_reaction/paint/compute_result_data_initializer(datum/reagent_holder/holder, multiplier)
	return result_color

/datum/chemical_reaction/paint/red
	name = "Red paint"
	id = "red_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "marker_ink_red" = 1)
	result_amount = 5
	result_color = "#FE191A"

/datum/chemical_reaction/paint/orange
	name = "Orange paint"
	id = "orange_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "marker_ink_orange" = 1)
	result_amount = 5
	result_color = "#FFBE4F"

/datum/chemical_reaction/paint/yellow
	name = "Yellow paint"
	id = "yellow_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "marker_ink_yellow" = 1)
	result_amount = 5
	result_color = "#FDFE7D"

/datum/chemical_reaction/paint/green
	name = "Green paint"
	id = "green_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "marker_ink_green" = 1)
	result_amount = 5
	result_color = "#18A31A"

/datum/chemical_reaction/paint/blue
	name = "Blue paint"
	id = "blue_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "marker_ink_blue" = 1)
	result_amount = 5
	result_color = "#247CFF"

/datum/chemical_reaction/paint/purple
	name = "Purple paint"
	id = "purple_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "marker_ink_purple" = 1)
	result_amount = 5
	result_color = "#CC0099"

/datum/chemical_reaction/paint/grey //mime
	name = "Grey paint"
	id = "grey_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "marker_ink_grey" = 1)
	result_amount = 5
	result_color = "#808080"

/datum/chemical_reaction/paint/brown
	name = "Brown paint"
	id = "brown_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "marker_ink_brown" = 1)
	result_amount = 5
	result_color = "#846F35"

/datum/chemical_reaction/paint/blood
	name = "Blood paint"
	id = "blood_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "blood" = 2)
	result_amount = 5

/datum/chemical_reaction/paint/blood/compute_result_data_initializer(datum/reagent_holder/holder, multiplier)
	var/datum/blood_mixture/blood_mixture = holder.reagent_datas?[/datum/reagent/blood::id]
	if(!blood_mixture)
		return "#ffffff"
	return blood_mixture.get_color()

/datum/chemical_reaction/paint/milk
	name = "Milk paint"
	id = "milk_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "milk" = 5)
	result_amount = 5
	result_color = "#F0F8FF"

/datum/chemical_reaction/paint/orange_juice
	name = "Orange juice paint"
	id = "orange_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "orangejuice" = 5)
	result_amount = 5
	result_color = "#E78108"

/datum/chemical_reaction/paint/tomato_juice
	name = "Tomato juice paint"
	id = "tomato_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "tomatojuice" = 5)
	result_amount = 5
	result_color = "#731008"

/datum/chemical_reaction/paint/lime_juice
	name = "Lime juice paint"
	id = "lime_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "limejuice" = 5)
	result_amount = 5
	result_color = "#365E30"

/datum/chemical_reaction/paint/carrot_juice
	name = "Carrot juice paint"
	id = "carrot_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "carrotjuice" = 5)
	result_amount = 5
	result_color = "#973800"

/datum/chemical_reaction/paint/berry_juice
	name = "Berry juice paint"
	id = "berry_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "berryjuice" = 5)
	result_amount = 5
	result_color = "#990066"

/datum/chemical_reaction/paint/grape_juice
	name = "Grape juice paint"
	id = "grape_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "grapejuice" = 5)
	result_amount = 5
	result_color = "#863333"

/datum/chemical_reaction/paint/poisonberry_juice
	name = "Poison berry juice paint"
	id = "poisonberry_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "poisonberryjuice" = 5)
	result_amount = 5
	result_color = "#863353"

/datum/chemical_reaction/paint/watermelon_juice
	name = "Watermelon juice paint"
	id = "watermelon_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "watermelonjuice" = 5)
	result_amount = 5
	result_color = "#B83333"

/datum/chemical_reaction/paint/lemon_juice
	name = "Lemon juice paint"
	id = "lemon_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "lemonjuice" = 5)
	result_amount = 5
	result_color = "#AFAF00"

/datum/chemical_reaction/paint/banana_juice
	name = "Banana juice paint"
	id = "banana_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "banana" = 5)
	result_amount = 5
	result_color = "#C3AF00"

/datum/chemical_reaction/paint/potato_juice
	name = "Potato juice paint"
	id = "potato_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "potatojuice" = 5)
	result_amount = 5
	result_color = "#302000"

/datum/chemical_reaction/paint/carbon
	name = "Carbon paint"
	id = "carbon_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, MAT_CARBON = 1)
	result_amount = 5
	result_color = "#333333"

/datum/chemical_reaction/paint/aluminum
	name = "Aluminum paint"
	id = "aluminum_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "aluminum" = 1)
	result_amount = 5
	result_color = "#F0F8FF"
