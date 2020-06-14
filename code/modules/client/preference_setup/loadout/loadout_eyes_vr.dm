/datum/gear/eyes/medical
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist", "Field Medic")

/datum/gear/eyes/meson
	display_name = "Optical Meson Scanners (Engineering, Science)"
	allowed_roles = list("Station Engineer","Chief Engineer","Atmospheric Technician", "Scientist", "Research Director", "Explorer", "Pathfinder")

/datum/gear/eyes/arglasses
	display_name = "AR glasses"
	path = /obj/item/clothing/glasses/omnihud

/datum/gear/eyes/arglassespres
	display_name = "AR glasses, prescription"
	path = /obj/item/clothing/glasses/omnihud/prescription

/datum/gear/eyes/spiffygogs
	display_name = "slick orange goggles"
	path = /obj/item/clothing/glasses/fluff/spiffygogs

/datum/gear/eyes/science_proper
	display_name = "science goggles (no overlay)"
	path = /obj/item/clothing/glasses/fluff/science_proper

/datum/gear/eyes/security/secpatch
	display_name = "security hudpatch"
	path = /obj/item/clothing/glasses/hud/security/eyepatch

/datum/gear/eyes/arglasses/sec
	display_name = "AR-S glasses"
	path = /obj/item/clothing/glasses/omnihud/sec
	allowed_roles = list("Security Officer","Head of Security","Warden","Detective")

/datum/gear/eyes/arglasses/eng
	display_name = "AR-E glasses"
	path = /obj/item/clothing/glasses/omnihud/eng
	allowed_roles = list("Station Engineer","Chief Engineer","Atmospheric Technician")

/datum/gear/eyes/arglasses/med
	display_name = "AR-M glasses"
	path = /obj/item/clothing/glasses/omnihud/med
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist", "Field Medic")

/datum/gear/eyes/arglasses/all
	display_name = "AR-B glasses"
	path = /obj/item/clothing/glasses/omnihud/all
	cost = 2
	allowed_roles = list("Facility Director","Head of Personnel")
