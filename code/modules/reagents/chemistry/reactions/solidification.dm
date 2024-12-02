// todo: why don't we stop doing this stupid shit and have a proper chemical crystallizer machine?

/* Solidification */
/datum/chemical_reaction/solidification
	name = "Solid Iron"
	id = "solidiron"
	required_reagents = list("frostoil" = 5, MAT_IRON = REAGENTS_PER_SHEET)
	require_whole_numbers = TRUE
	important_for_logging = TRUE
	var/sheet_to_give = /obj/item/stack/material/iron

/datum/chemical_reaction/solidification/on_reaction_instant(datum/reagent_holder/holder, multiplier)
	. = ..()
	new sheet_to_give(get_turf(holder.my_atom), multiplier)

/datum/chemical_reaction/solidification/phoron
	name = "Solid Phoron"
	id = "solidphoron"
	required_reagents = list("frostoil" = 5, MAT_PHORON = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/phoron


/datum/chemical_reaction/solidification/silver
	name = "Solid Silver"
	id = "solidsilver"
	required_reagents = list("frostoil" = 5, MAT_SILVER = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/silver


/datum/chemical_reaction/solidification/gold
	name = "Solid Gold"
	id = "solidgold"
	required_reagents = list("frostoil" = 5, MAT_GOLD = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/gold


/datum/chemical_reaction/solidification/platinum
	name = "Solid Platinum"
	id = "solidplatinum"
	required_reagents = list("frostoil" = 5, MAT_PLATINUM = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/platinum


/datum/chemical_reaction/solidification/uranium
	name = "Solid Uranium"
	id = "soliduranium"
	required_reagents = list("frostoil" = 5, MAT_URANIUM = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/uranium


/datum/chemical_reaction/solidification/hydrogen
	name = "Solid Hydrogen"
	id = "solidhydrogen"
	required_reagents = list("frostoil" = 100, "hydrogen" = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/mhydrogen


// These are from Xenobio.
/datum/chemical_reaction/solidification/steel
	name = "Solid Steel"
	id = "solidsteel"
	required_reagents = list("frostoil" = 5, MAT_STEEL = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/steel


/datum/chemical_reaction/solidification/plasteel
	name = "Solid Plasteel"
	id = "solidplasteel"
	required_reagents = list("frostoil" = 10, MAT_PLASTEEL = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/plasteel
