// Gloves
/datum/gear/gloves
	name = "Gloves - Black"
	path = /obj/item/clothing/gloves/black
	slot = slot_gloves
	sort_category = "Gloves and Handwear"

/datum/gear/gloves/blue
	name = "Gloves - Blue"
	path = /obj/item/clothing/gloves/blue

/datum/gear/gloves/brown
	name = "Gloves - Brown"
	path = /obj/item/clothing/gloves/brown

/datum/gear/gloves/light_brown
	name = "Gloves - Light-Brown"
	path = /obj/item/clothing/gloves/light_brown

/datum/gear/gloves/green
	name = "Gloves - Green"
	path = /obj/item/clothing/gloves/green

/datum/gear/gloves/grey
	name = "Gloves - Grey"
	path = /obj/item/clothing/gloves/grey

/datum/gear/gloves/latex
	name = "Gloves - Latex"
	path = /obj/item/clothing/gloves/sterile/latex

/datum/gear/gloves/nitrile
	name = "Gloves - Nitrile"
	path = /obj/item/clothing/gloves/sterile/nitrile

/datum/gear/gloves/orange
	name = "Gloves - Orange"
	path = /obj/item/clothing/gloves/orange

/datum/gear/gloves/purple
	name = "Gloves - Purple"
	path = /obj/item/clothing/gloves/purple

/datum/gear/gloves/rainbow
	name = "Gloves - Rainbow"
	path = /obj/item/clothing/gloves/rainbow

/datum/gear/gloves/red
	name = "Gloves - Red"
	path = /obj/item/clothing/gloves/red

/datum/gear/gloves/white
	name = "Gloves - White"
	path = /obj/item/clothing/gloves/white

/datum/gear/gloves/evening
	name = "Evening Gloves"
	path = /obj/item/clothing/gloves/evening

/datum/gear/gloves/evening/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/gloves/duty
	name = "Gloves - Work"
	path = /obj/item/clothing/gloves/duty
	cost = 3

/datum/gear/gloves/forensic
	name = "Detective Gloves - Forensic"
	path = /obj/item/clothing/gloves/forensic
	allowed_roles = list("Detective")

/datum/gear/gloves/fingerless
	name = "Gloves - Fingerless"
	path = /obj/item/clothing/gloves/fingerless

/datum/gear/gloves/ring
	name = "Ring Selection"
	description = "Choose from a number of rings."
	path = /obj/item/clothing/gloves/ring
	cost = 1

/datum/gear/gloves/ring/New()
	..()
	var/ringtype = list()
	ringtype["CTI Ring"] = /obj/item/clothing/gloves/ring/cti
	ringtype["Mariner University Ring"] = /obj/item/clothing/gloves/ring/mariner
	ringtype["Engagement Ring"] = /obj/item/clothing/gloves/ring/engagement
	ringtype["Signet Ring"] = /obj/item/clothing/gloves/ring/seal/signet
	ringtype["Masonic Ring"] = /obj/item/clothing/gloves/ring/seal/mason
	ringtype["Ring - Steel"] = /obj/item/clothing/gloves/ring/material/steel
	ringtype["Ring - Iron"] = /obj/item/clothing/gloves/ring/material/iron
	ringtype["Ring - Silver"] = /obj/item/clothing/gloves/ring/material/silver
	ringtype["Ring - Gold"] = /obj/item/clothing/gloves/ring/material/gold
	ringtype["Ring - Platinum"] = /obj/item/clothing/gloves/ring/material/platinum
	ringtype["Ring - Glass"] = /obj/item/clothing/gloves/ring/material/glass
	ringtype["Ring - Wood"] = /obj/item/clothing/gloves/ring/material/wood
	ringtype["Ring - Plastic"] = /obj/item/clothing/gloves/ring/material/plastic
	ringtype["Ring - Uranium"] = /obj/item/clothing/gloves/ring/material/uranium
	ringtype["Ring - Osmium"] = /obj/item/clothing/gloves/ring/material/osmium
	ringtype["Ring - Mhydrogen"] = /obj/item/clothing/gloves/ring/material/mhydrogen
	ringtype["Ring - Custom"] = /obj/item/clothing/gloves/ring/custom
	gear_tweaks += new/datum/gear_tweak/path(ringtype)


/datum/gear/gloves/circuitry
	name = "Gloves - Circuitry"
	path = /obj/item/clothing/gloves/circuitry

/datum/gear/gloves/goldring
	name = "Wedding Ring - Gold"
	path = /obj/item/clothing/gloves/ring/wedding

/datum/gear/gloves/silverring
	name = "Wedding Ring - Silver"
	path = /obj/item/clothing/gloves/ring/wedding/silver

/datum/gear/gloves/colored
	name = "Gloves - Colorable"
	path = /obj/item/clothing/gloves/color

/datum/gear/gloves/colored/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice


/datum/gear/gloves/latex/colorable
	name = "Gloves - Latex - Colorable"
	path = /obj/item/clothing/gloves/sterile/latex

/datum/gear/gloves/latex/colorable/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/gloves/siren
	name = "Gloves - Siren"
	path = /obj/item/clothing/gloves/fluff/siren

/datum/gear/gloves/bountyskin
	name = "Bounty Hunter's Gloves"
	path = /obj/item/clothing/gloves/bountyskin

/datum/gear/gloves/hasie
	name = "Hasie Fingerless Gloves"
	path = /obj/item/clothing/gloves/hasie

/datum/gear/gloves/utility_fur_gloves
	name = "Utility Fur Gloves"
	path = /obj/item/clothing/gloves/utility_fur_gloves
