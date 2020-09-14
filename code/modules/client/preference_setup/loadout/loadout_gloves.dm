// Gloves
/datum/gear/gloves
	display_name = "Gloves - Black"
	path = /obj/item/clothing/gloves/black
	cost = 2
	slot = slot_gloves
	sort_category = "Gloves and Handwear"

/datum/gear/gloves/blue
	display_name = "Gloves - Blue"
	path = /obj/item/clothing/gloves/blue

/datum/gear/gloves/brown
	display_name = "Gloves - Brown"
	path = /obj/item/clothing/gloves/brown

/datum/gear/gloves/light_brown
	display_name = "Gloves - Light-Brown"
	path = /obj/item/clothing/gloves/light_brown

/datum/gear/gloves/green
	display_name = "Gloves - Green"
	path = /obj/item/clothing/gloves/green

/datum/gear/gloves/grey
	display_name = "Gloves - Grey"
	path = /obj/item/clothing/gloves/grey

/datum/gear/gloves/latex
	display_name = "Gloves - Latex"
	path = /obj/item/clothing/gloves/sterile/latex

/datum/gear/gloves/nitrile
	display_name = "Gloves - Nitrile"
	path = /obj/item/clothing/gloves/sterile/nitrile

/datum/gear/gloves/orange
	display_name = "Gloves - Orange"
	path = /obj/item/clothing/gloves/orange

/datum/gear/gloves/purple
	display_name = "Gloves - Purple"
	path = /obj/item/clothing/gloves/purple

/datum/gear/gloves/rainbow
	display_name = "Gloves - Rainbow"
	path = /obj/item/clothing/gloves/rainbow

/datum/gear/gloves/red
	display_name = "Gloves - Red"
	path = /obj/item/clothing/gloves/red

/datum/gear/gloves/white
	display_name = "Gloves - White"
	path = /obj/item/clothing/gloves/white

/datum/gear/gloves/evening
	display_name = "evening Gloves"
	path = /obj/item/clothing/gloves/evening

/datum/gear/gloves/evening/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/gloves/duty
	display_name = "Gloves - Work"
	path = /obj/item/clothing/gloves/duty
	cost = 3

/datum/gear/gloves/forensic
	display_name = "Detective Gloves - Forensic"
	path = /obj/item/clothing/gloves/forensic
	allowed_roles = list("Detective")

/datum/gear/gloves/fingerless
	display_name = "Gloves - Fingerless"
	path = /obj/item/clothing/gloves/fingerless

/datum/gear/gloves/ring
	display_name = "Ring Selection"
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
	display_name = "Gloves - Circuitry"
	path = /obj/item/clothing/gloves/circuitry

/datum/gear/gloves/goldring
	display_name = "Wedding Ring - Gold"
	path = /obj/item/clothing/gloves/ring/wedding

/datum/gear/gloves/silverring
	display_name = "Wedding Ring - Silver"
	path = /obj/item/clothing/gloves/ring/wedding/silver

/datum/gear/gloves/colored
	display_name = "Gloves - Colorable"
	path = /obj/item/clothing/gloves/color

/datum/gear/gloves/colored/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)


/datum/gear/gloves/latex/colorable
	display_name = "Gloves - Latex - Colorable"
	path = /obj/item/clothing/gloves/sterile/latex

/datum/gear/gloves/latex/colorable/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/gloves/siren
	display_name = "Gloves - Siren"
	path = /obj/item/clothing/gloves/fluff/siren
