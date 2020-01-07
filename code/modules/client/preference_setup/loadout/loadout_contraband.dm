/datum/gear/contraband/
	sort_category = "Contraband"
	//category identifier and parent object clean so kevz doesn't murder me in my sleep -buffy

/datum/gear/contraband/poster
	display_name = "Contraband Poster"
	path = /obj/item/weapon/contraband/poster

/datum/gear/contraband/NIFcompliance
	display_name = "NIF Compliance Disk"
	path = /obj/item/weapon/disk/nifsoft/compliance
	cost = 2

/datum/gear/contraband/drugs
	display_name = "Space Drugs"
	path = /obj/item/seeds/ambrosiadeusseed
	description = "Didn't your mother tell you not to accept things from strange cat girls?"

/datum/gear/contraband/drugs/New()
	..()
	var/list/drugs = list()
	drugs["ambrosia deus seed"] = /obj/item/seeds/ambrosiadeusseed
	drugs["ambrosia vulgaris seed"] = /obj/item/seeds/ambrosiavulgarisseed
	drugs["liberty mycelium"] = /obj/item/seeds/libertymycelium
	gear_tweaks += new/datum/gear_tweak/path(drugs)
