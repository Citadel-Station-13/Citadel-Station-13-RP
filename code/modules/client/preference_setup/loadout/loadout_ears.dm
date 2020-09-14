// Stuff worn on the ears. Items here go in the "ears" sort_category but they must not use
// the slot_r_ear or slot_l_ear as the slot, or else players will spawn with no headset.
/datum/gear/ears
	display_name = "Earmuffs"
	path = /obj/item/clothing/ears/earmuffs
	sort_category = "Earwear"

/datum/gear/ears/headphones
	display_name = "Headphones"
	path = /obj/item/clothing/ears/earmuffs/headphones

/datum/gear/ears/circuitry
	display_name = "Earwear - Circuitry"
	path = /obj/item/clothing/ears/circuitry


/datum/gear/ears/earrings
	display_name = "Earring Selection"
	description = "A selection of eye-catching earrings."
	path = /obj/item/clothing/ears/earring

/datum/gear/ears/earrings/New()
	..()
	var/earrings = list()
	earrings["Stud - Pearl"] = /obj/item/clothing/ears/earring/stud
	earrings["Stud - Glass"] = /obj/item/clothing/ears/earring/stud/glass
	earrings["Stud - Wood"] = /obj/item/clothing/ears/earring/stud/wood
	earrings["Stud - Iron"] = /obj/item/clothing/ears/earring/stud/iron
	earrings["Stud - Steel"] = /obj/item/clothing/ears/earring/stud/steel
	earrings["Stud - Silver"] = /obj/item/clothing/ears/earring/stud/silver
	earrings["Stud - Gold"] = /obj/item/clothing/ears/earring/stud/gold
	earrings["Stud - Platinum"] = /obj/item/clothing/ears/earring/stud/platinum
	earrings["Stud - Diamond"] = /obj/item/clothing/ears/earring/stud/diamond
	earrings["Dangle - Glass"] = /obj/item/clothing/ears/earring/dangle/glass
	earrings["Dangle - Wood"] = /obj/item/clothing/ears/earring/dangle/wood
	earrings["Dangle - Iron"] = /obj/item/clothing/ears/earring/dangle/iron
	earrings["Dangle - Steel"] = /obj/item/clothing/ears/earring/dangle/steel
	earrings["Dangle - Silver"] = /obj/item/clothing/ears/earring/dangle/silver
	earrings["Dangle - Gold"] = /obj/item/clothing/ears/earring/dangle/gold
	earrings["Dangle - Platinum"] = /obj/item/clothing/ears/earring/dangle/platinum
	earrings["Dangle - Diamond"] = /obj/item/clothing/ears/earring/dangle/diamond
	gear_tweaks += new/datum/gear_tweak/path(earrings)
