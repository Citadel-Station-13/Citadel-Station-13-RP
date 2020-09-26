// Eyes
/datum/gear/eyes
	display_name = "Civilian - Eyepatch"
	path = /obj/item/clothing/glasses/eyepatch
	slot = slot_glasses
	sort_category = "Glasses and Eyewear"

/datum/gear/eyes/eyepatchwhite
	display_name = "Civilian - Eyepatch (recolorable)"
	path = /obj/item/clothing/glasses/eyepatchwhite
	slot = slot_glasses
	sort_category = "Glasses and Eyewear"

/datum/gear/eyes/eyepatchwhite/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/eyes/glasses
	display_name = "Civilian - Glasses - Prescription"
	path = /obj/item/clothing/glasses/regular

/datum/gear/eyes/glasses/green
	display_name = "Civilian - Glasses - Green"
	path = /obj/item/clothing/glasses/gglasses

/datum/gear/eyes/glasses/prescriptionhipster
	display_name = "Civilian - Glasses - Hipster"
	path = /obj/item/clothing/glasses/regular/hipster

/datum/gear/eyes/glasses/monocle
	display_name = "Civilian - Monocle"
	path = /obj/item/clothing/glasses/monocle

/datum/gear/eyes/goggles
	display_name = "Civilian - Plain Goggles"
	path = /obj/item/clothing/glasses/goggles

/datum/gear/eyes/goggles/scanning
	display_name = "Civilian - Scanning Goggles"
	path = /obj/item/clothing/glasses/regular/scanners

/datum/gear/eyes/goggles/science
	display_name = "Civilian - Science Goggles"
	path = /obj/item/clothing/glasses/science

/datum/gear/eyes/security
	display_name = "Security - Security HUD"
	path = /obj/item/clothing/glasses/hud/security
	allowed_roles = list("Security Officer","Head of Security","Warden", "Detective")

/datum/gear/eyes/security/prescriptionsec
	display_name = "Security - Security HUD - Prescription"
	path = /obj/item/clothing/glasses/hud/security/prescription

/datum/gear/eyes/security/sunglasshud
	display_name = "Security - Security HUD - Sunglasses"
	path = /obj/item/clothing/glasses/sunglasses/sechud

/datum/gear/eyes/security/aviator
	display_name = "Security - Security HUD - Aviators"
	path = /obj/item/clothing/glasses/sunglasses/sechud/aviator

/datum/gear/eyes/security/aviator/prescription
	display_name = "Security - Security HUD - Aviators - Prescription"
	path = /obj/item/clothing/glasses/sunglasses/sechud/aviator/prescription

/datum/gear/eyes/medical
	display_name = "Medical - Medical HUD"
	path = /obj/item/clothing/glasses/hud/health
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist", "Field Medic")

/datum/gear/eyes/medical/prescriptionmed
	display_name = "Medical - Medical HUD - Prescription"
	path = /obj/item/clothing/glasses/hud/health/prescription

/datum/gear/eyes/medical/aviator
	display_name = "Medical - Medical HUD - Aviators"
	path = /obj/item/clothing/glasses/hud/health/aviator

/datum/gear/eyes/medical/aviator/prescription
	display_name = "Medical - Medical HUD - Aviators - Prescription"
	path = /obj/item/clothing/glasses/hud/health/aviator/prescription

/datum/gear/eyes/meson
	display_name = "EngSci & Mining Optical Meson Scanners"
	path = /obj/item/clothing/glasses/meson
	allowed_roles = list("Station Engineer","Chief Engineer","Atmospheric Technician", "Scientist", "Research Director", "Shaft Miner")

/datum/gear/eyes/meson/prescription
	display_name = "EngSci & Mining Optical Meson Scanners - Prescription"
	path = /obj/item/clothing/glasses/meson/prescription

/datum/gear/eyes/material
	display_name = "Mining Optical Material Scanners"
	path = /obj/item/clothing/glasses/material
	allowed_roles = list("Shaft Miner")

/datum/gear/eyes/material/prescription
	display_name = "Mining Optical Material Scanners - Prescription"
	path = /obj/item/clothing/glasses/material/prescription

/datum/gear/eyes/meson/aviator
	display_name = "EngSci & Mining Optical Meson - Aviators"
	path = /obj/item/clothing/glasses/meson/aviator

/datum/gear/eyes/meson/aviator/prescription
	display_name = "EngSci & Mining Optical Meson - Aviators - Prescription"
	path = /obj/item/clothing/glasses/meson/aviator/prescription

/datum/gear/eyes/glasses/fakesun
	display_name = "Civilian - Sunglasses - Stylish"
	path = /obj/item/clothing/glasses/fakesunglasses

/datum/gear/eyes/glasses/fakeaviator
	display_name = "Civilian - Sunglasses - Stylish Aviators"
	path = /obj/item/clothing/glasses/fakesunglasses/aviator

/datum/gear/eyes/sun
	display_name = "SecCom - Sunglasses"
	path = /obj/item/clothing/glasses/sunglasses
	allowed_roles = list("Security Officer","Head of Security","Warden","Facility Director","Head of Personnel","Quartermaster","Internal Affairs Agent","Detective")

/datum/gear/eyes/sun/shades
	display_name = "SecCom - Sunglasses - Fat"
	path = /obj/item/clothing/glasses/sunglasses/big

/datum/gear/eyes/sun/aviators
	display_name = "SecCom - Sunglasses - Aviators"
	path = /obj/item/clothing/glasses/sunglasses/aviator

/datum/gear/eyes/sun/prescriptionsun
	display_name = "SecCom - Sunglasses - Presciption"
	path = /obj/item/clothing/glasses/sunglasses/prescription

/datum/gear/eyes/circuitry
	display_name = "goggles, circuitry (empty)"
	path = /obj/item/clothing/glasses/circuitry

/datum/gear/eyes/glasses/rimless
	display_name = "Civilian - Glasses - rimless"
	path = /obj/item/clothing/glasses/rimless

/datum/gear/eyes/glasses/prescriptionrimless
	display_name = "Civilian - Glasses - prescription rimless"
	path = /obj/item/clothing/glasses/regular/rimless

/datum/gear/eyes/glasses/thin
	display_name = "Civilian - Glasses - thin frame"
	path = /obj/item/clothing/glasses/thin

/datum/gear/eyes/glasses/prescriptionthin
	display_name = "Civilian - Glasses - prescription thin frame"
	path = /obj/item/clothing/glasses/regular/thin

/datum/gear/eyes/glasses/thick
	display_name = "Civilian - Glasses - thick lenses"
	path = /obj/item/clothing/glasses/thick

/datum/gear/eyes/glasses/prescriptionthick
	display_name = "Civilian - Glasses - prescription thick lenses"
	path = /obj/item/clothing/glasses/regular/thick

/datum/gear/eyes/glasses/dark
	display_name = "Civilian - Glasses - dark frame"
	path = /obj/item/clothing/glasses/dark

/datum/gear/eyes/glasses/prescriptiondark
	display_name = "Civilian - Glasses - prescription dark frame"
	path = /obj/item/clothing/glasses/regular/dark

/datum/gear/eyes/glasses/scan
	display_name = "Civilian - Glasses - scanner"
	path = /obj/item/clothing/glasses/scan

/datum/gear/eyes/glasses/prescriptionscan
	display_name = "Civilian - Glasses - prescription scanner"
	path = /obj/item/clothing/glasses/regular/scan

/datum/gear/eyes/jamjar
	display_name = "jamjar glasses"
	path = /obj/item/clothing/glasses/jamjar

/datum/gear/eyes/jensenshades
	display_name = "augmented shades"
	path = /obj/item/clothing/glasses/augmentedshades

/datum/gear/eyes/whiteblindfold
	display_name = "white blindfold"
	path = /obj/item/clothing/glasses/sunglasses/blindfold/whiteblindfold

/datum/gear/eyes/redglasses
	display_name = "red glasses"
	path = /obj/item/clothing/glasses/redglasses

/datum/gear/eyes/badglasses
	display_name = "poorly made glasses"
	path = /obj/item/clothing/glasses/badglasses

/datum/gear/eyes/orangeglasses
	display_name = "orange glasses"
	path = /obj/item/clothing/glasses/orangeglasses

/datum/gear/eyes/medical/eyepatch
	display_name = "Medical HUD Eyepatch"
	path = /obj/item/clothing/glasses/hud/health/eyepatch
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist", "Field Medic")

/datum/gear/eyes/meson/eyepatch
	display_name = "Optical Meson Eyepatch (Engineering, Science, Mining)"
	path = /obj/item/clothing/glasses/hud/health/eyepatch
	allowed_roles = list("Station Engineer","Chief Engineer","Atmospheric Technician", "Scientist", "Research Director", "Shaft Miner")

/datum/gear/eyes/glasses/welding
	display_name = "Welding Goggles"
	path = /obj/item/clothing/glasses/welding

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
