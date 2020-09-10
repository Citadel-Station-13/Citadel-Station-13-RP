/*
	Earwear - This could probably be merged with head, seeing as the old comment below would suggest that they don't (or rather, shouldn't) occupy a unique slot.
	Unless someone is able and has the will to bother fixing the bug described below, anyways.
*/
// Stuff worn on the ears. Items here go in the "ears" sort_category but they must not use
// the slot_r_ear or slot_l_ear as the slot, or else players will spawn with no headset.

/datum/gear/ears
	sort_category = "Earwear" // This controls the name of the category in the loadout.
	type_category = /datum/gear/ears // All subtypes of the geartype declared will be associated with this - practically speaking this controls where the items themselves go.
	cost = 1 // Controls how much an item's "cost" is in the loadout point menu. If re-specified on a different item, that value will override this one. This sets the default value.


/datum/gear/ears/earmuffs
	display_name = "earmuffs"
	path = /obj/item/clothing/ears/earmuffs

/datum/gear/ears/headphones
	display_name = "headphones"
	path = /obj/item/clothing/ears/earmuffs/headphones

/datum/gear/ears/circuitry
	display_name = "earwear, circuitry (empty)"
	path = /obj/item/clothing/ears/circuitry

/datum/gear/ears/earrings
	display_name = "earring selection"
	description = "A selection of eye-catching earrings."
	path = /obj/item/clothing/ears/earring

/datum/gear/ears/earrings/New()
	..()
	var/earrings = list()
	earrings["stud, pearl"] = /obj/item/clothing/ears/earring/stud
	earrings["stud, glass"] = /obj/item/clothing/ears/earring/stud/glass
	earrings["stud, wood"] = /obj/item/clothing/ears/earring/stud/wood
	earrings["stud, iron"] = /obj/item/clothing/ears/earring/stud/iron
	earrings["stud, steel"] = /obj/item/clothing/ears/earring/stud/steel
	earrings["stud, silver"] = /obj/item/clothing/ears/earring/stud/silver
	earrings["stud, gold"] = /obj/item/clothing/ears/earring/stud/gold
	earrings["stud, platinum"] = /obj/item/clothing/ears/earring/stud/platinum
	earrings["stud, diamond"] = /obj/item/clothing/ears/earring/stud/diamond
	earrings["dangle, glass"] = /obj/item/clothing/ears/earring/dangle/glass
	earrings["dangle, wood"] = /obj/item/clothing/ears/earring/dangle/wood
	earrings["dangle, iron"] = /obj/item/clothing/ears/earring/dangle/iron
	earrings["dangle, steel"] = /obj/item/clothing/ears/earring/dangle/steel
	earrings["dangle, silver"] = /obj/item/clothing/ears/earring/dangle/silver
	earrings["dangle, gold"] = /obj/item/clothing/ears/earring/dangle/gold
	earrings["dangle, platinum"] = /obj/item/clothing/ears/earring/dangle/platinum
	earrings["dangle, diamond"] = /obj/item/clothing/ears/earring/dangle/diamond
	gear_tweaks += new/datum/gear_tweak/path(earrings)
