/**
 * Carpet Dye-ing
 */
/datum/chemical_reaction/carpetdye
	name = "Black Carpet Dyeing"
	id = "carpetdyeblack"
	result = "liquidcarpetb"
	required_reagents = list("liquidcarpet" = 5, "carbon" = 1)
	result_amount = 5

/datum/chemical_reaction/carpetdye/blue
	name = "Blue Carpet Dyeing"
	id = "carpetdyeblue"
	result = "liquidcarpetblu"
	required_reagents = list("liquidcarpet" = 5, "frostoil" = 1)

/datum/chemical_reaction/carpetdye/tur
	name = "Turqouise Carpet Dyeing"
	id = "carpetdyetur"
	result = "liquidcarpettur"
	required_reagents = list("liquidcarpet" = 5, "water" = 1)

/datum/chemical_reaction/carpetdye/sblu
	name = "Silver Blue Carpet Dyeing"
	id = "carpetdyesblu"
	result = "liquidcarpetsblu"
	required_reagents = list("liquidcarpet" = 5, "ice" = 1)

/datum/chemical_reaction/carpetdye/clown
	name = "Clown Carpet Dyeing"
	id = "carpetdyeclown"
	result = "liquidcarpetc"
	required_reagents = list("liquidcarpet" = 5, "banana" = 1)

/datum/chemical_reaction/carpetdye/purple
	name = "Purple Carpet Dyeing"
	id = "carpetdyepurple"
	result = "liquidcarpetp"
	required_reagents = list("liquidcarpet" = 5, "berryjuice" = 1)

/datum/chemical_reaction/carpetdye/orange
	name = "Orange Carpet Dyeing"
	id = "carpetdyeorange"
	result = "liquidcarpeto"
	required_reagents = list("liquidcarpet" = 5, "orangejuice" = 1)

/**
 * Carpet Creation
 */
/datum/chemical_reaction/carpetify
	name = "Carpet"
	id = "redcarpet"
	required_reagents = list("liquidcarpet" = 2, "plasticide" = 1)
	require_whole_numbers = 1
	important_for_logging = TRUE
	var/carpet_type = /obj/item/stack/tile/carpet

/datum/chemical_reaction/carpetify/on_reaction_instant(datum/reagent_holder/holder, multiplier)
	. = ..()
	new carpet_type(get_turf(holder.my_atom), multiplier * 2)

/datum/chemical_reaction/carpetify/bcarpet
	name = "Black Carpet"
	id = "blackcarpet"
	required_reagents = list("liquidcarpetb" = 2, "plasticide" = 1)
	carpet_type = /obj/item/stack/tile/carpet/bcarpet

/datum/chemical_reaction/carpetify/blucarpet
	name = "Blue Carpet"
	id = "bluecarpet"
	required_reagents = list ("liquidcarpetblu" = 2, "plasticide" = 1)
	carpet_type = /obj/item/stack/tile/carpet/blucarpet

/datum/chemical_reaction/carpetify/turcarpet
	name = "Turquise Carpet"
	id = "turcarpet"
	required_reagents = list("liquidcarpettur" = 2, "plasticide" = 1)
	carpet_type = /obj/item/stack/tile/carpet/turcarpet

/datum/chemical_reaction/carpetify/sblucarpet
	name = "Silver Blue Carpet"
	id = "sblucarpet"
	required_reagents = list("liquidcarpetsblu" = 2, "plasticide" = 1)
	carpet_type = /obj/item/stack/tile/carpet/sblucarpet

/datum/chemical_reaction/carpetify/clowncarpet
	name = "Clown Carpet"
	id = "clowncarpet"
	required_reagents = list("liquidcarpetc" = 2, "plasticide" = 1)
	carpet_type = /obj/item/stack/tile/carpet/gaycarpet

/datum/chemical_reaction/carpetify/pcarpet
	name = "Purple Carpet"
	id = "Purplecarpet"
	required_reagents = list("liquidcarpetp" = 2, "plasticide" = 1)
	carpet_type = /obj/item/stack/tile/carpet/purcarpet

/datum/chemical_reaction/carpetify/ocarpet
	name = "Orange Carpet"
	id = "orangecarpet"
	required_reagents = list("liquidcarpeto" = 2, "plasticide" = 1)
	carpet_type = /obj/item/stack/tile/carpet/oracarpet
