/datum/loadout_entry/accessory/insignia
	name = "Insignia Selection"
	path = /obj/item/clothing/accessory/oricon/department

/datum/loadout_entry/accessory/insignia/New()
	..()
	var/insignia = list()
	insignia["Command - Crew"] = /obj/item/clothing/accessory/oricon/department/command/crew
	insignia["Command - Crew Short"] = /obj/item/clothing/accessory/oricon/department/command/service
	insignia["Command - Bands"] = /obj/item/clothing/accessory/oricon/department/command/fleet
	insignia["Command - Echelons"] = /obj/item/clothing/accessory/oricon/department/command/marine
	insignia["Blueshield - Crew"] = /obj/item/clothing/accessory/oricon/department/blueshield/crew
	insignia["Blueshield - Crew Short"] = /obj/item/clothing/accessory/oricon/department/blueshield/service
	insignia["Blueshield - Bands"] = /obj/item/clothing/accessory/oricon/department/blueshield/fleet
	insignia["Blueshield - Echelons"] = /obj/item/clothing/accessory/oricon/department/blueshield/marine
	insignia["Security - Crew"] = /obj/item/clothing/accessory/oricon/department/security/crew
	insignia["Security - Crew Short"] = /obj/item/clothing/accessory/oricon/department/security/service
	insignia["Security - Bands"] = /obj/item/clothing/accessory/oricon/department/security/fleet
	insignia["Security - Echelons"] = /obj/item/clothing/accessory/oricon/department/security/marine
	insignia["Medical - Crew"] = /obj/item/clothing/accessory/oricon/department/medical/crew
	insignia["Medical - Crew Short"] = /obj/item/clothing/accessory/oricon/department/medical/service
	insignia["Medical - Bands"] = /obj/item/clothing/accessory/oricon/department/medical/fleet
	insignia["Medical - Echelons"] = /obj/item/clothing/accessory/oricon/department/medical/marine
	insignia["Science - Crew"] = /obj/item/clothing/accessory/oricon/department/research/crew
	insignia["Science - Crew Short"] = /obj/item/clothing/accessory/oricon/department/research/service
	insignia["Science - Bands"] = /obj/item/clothing/accessory/oricon/department/research/fleet
	insignia["Science - Echelons"] = /obj/item/clothing/accessory/oricon/department/research/marine
	insignia["Engineering - Crew"] = /obj/item/clothing/accessory/oricon/department/engineering/crew
	insignia["Engineering - Crew Short"] = /obj/item/clothing/accessory/oricon/department/engineering/service
	insignia["Engineering - Bands"] = /obj/item/clothing/accessory/oricon/department/engineering/fleet
	insignia["Engineering - Echelons"] = /obj/item/clothing/accessory/oricon/department/engineering/marine
	insignia["Supply - Crew"] = /obj/item/clothing/accessory/oricon/department/supply/crew
	insignia["Supply - Crew Short"] = /obj/item/clothing/accessory/oricon/department/supply/service
	insignia["Supply - Bands"] = /obj/item/clothing/accessory/oricon/department/supply/fleet
	insignia["Supply - Echelons"] = /obj/item/clothing/accessory/oricon/department/supply/marine
	insignia["Service - Crew"] = /obj/item/clothing/accessory/oricon/department/service/crew
	insignia["Service - Crew Short"] = /obj/item/clothing/accessory/oricon/department/service/service
	insignia["Service - Bands"] = /obj/item/clothing/accessory/oricon/department/service/fleet
	insignia["Service - Echelons"] = /obj/item/clothing/accessory/oricon/department/service/marine
	tweaks += new/datum/loadout_tweak/path(insignia)

/datum/loadout_entry/accessory/insigniacolored
	name = "Insignia - Colorable"
	path = /obj/item/clothing/accessory/oricon/department/colorable

/datum/loadout_entry/accessory/insigniacolored/New()
	..()
	var/insignia = list()
	insignia["Colorable - Crew"] = /obj/item/clothing/accessory/oricon/department/colorable
	insignia["Colorable - Crew Short"] = /obj/item/clothing/accessory/oricon/department/colorable/service
	insignia["Colorable - Bands"] = /obj/item/clothing/accessory/oricon/department/colorable/fleet
	insignia["Colorable - Echelons"] = /obj/item/clothing/accessory/oricon/department/colorable/marine
	tweaks += new/datum/loadout_tweak/path(insignia)
