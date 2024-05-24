/obj/item/clothing/mask/warmer
	name = "warming mask"
	desc = "A sterile mask designed to help prevent the spread of diseases."
	icon = 'icons/obj/clothing/ties.dmi'
	icon_state = "gaiter_snow_up"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "sterile", SLOT_ID_LEFT_HAND = "sterile")
	w_class = WEIGHT_CLASS_SMALL
	body_cover_flags = FACE
	clothing_flags = FLEXIBLEMATERIAL
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.01
	armor_type = /datum/armor/mask/surgical

//Warms with 1000 watts
/obj/item/clothing/mask/warmer/process_air(datum/gas_mixture/air)
	var/mob/living/carbon/wearer = src.loc
	if(istype(wearer))
		var/energy_to_warm = air.get_thermal_energy_change(wearer.bodytemperature)
		air.adjust_thermal_energy(clamp(energy_to_warm, 0, 1000))


