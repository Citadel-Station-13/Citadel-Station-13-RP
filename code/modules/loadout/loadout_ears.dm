// Stuff worn on the ears. Items here go in the "ears" sort_category but they must not use
// the SLOT_ID_RIGHT_EAR or SLOT_ID_LEFT_EAR as the slot, or else players will spawn with no headset.
/datum/loadout_entry/ears
	name = "Earmuffs"
	path = /obj/item/clothing/ears/earmuffs
	category = LOADOUT_CATEGORY_EARS
	slot = SLOT_ID_RIGHT_EAR

/datum/loadout_entry/ears/headphones
	name = "Headphones"
	path = /obj/item/clothing/ears/earmuffs/headphones

/datum/loadout_entry/ears/circuitry
	name = "Earwear - Circuitry"
	path = /obj/item/clothing/ears/circuitry


/datum/loadout_entry/ears/earrings
	name = "Earring Selection"
	description = "A selection of eye-catching earrings."
	path = /obj/item/clothing/ears/earring

/datum/loadout_entry/ears/earrings/New()
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
	tweaks += new/datum/loadout_tweak/path(earrings)


/datum/loadout_entry/ears/laurel
	name = "Laurel Wreath Selection"
	description = "A selection of leaf-like headwear."
	path = /obj/item/clothing/ears/laurel

/datum/loadout_entry/ears/laurel/New()
	..()
	var/laurel = list()
	laurel["Laurel Wreath - Leaf"] = /obj/item/clothing/ears/laurel
	laurel["Laurel Wreath - Silver"] = /obj/item/clothing/ears/laurel/silver
	laurel["Laurel Wreath - Gold"] = /obj/item/clothing/ears/laurel/gold
	tweaks += new/datum/loadout_tweak/path(laurel)
