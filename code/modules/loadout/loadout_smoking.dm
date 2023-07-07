
/datum/loadout_entry/pipe
	name = "Pipe"
	path = /obj/item/clothing/mask/smokable/pipe

/datum/loadout_entry/pipe/New()
	..()
	var/list/pipes = list()
	for(var/pipe_style in typesof(/obj/item/clothing/mask/smokable/pipe))
		var/obj/item/clothing/mask/smokable/pipe/pipe = pipe_style
		pipes[initial(pipe.name)] = pipe
	gear_tweaks += new/datum/loadout_entry_tweak/path(tim_sort(pipes, /proc/cmp_text_asc))

/datum/loadout_entry/matchbook
	name = "Matchbook"
	path = /obj/item/storage/box/matches

/datum/loadout_entry/lighter
	name = "Cheap Lighter"
	path = /obj/item/flame/lighter

/datum/loadout_entry/lighter/zippo
	name = "Zippo Selection"
	path = /obj/item/flame/lighter/zippo

/datum/loadout_entry/lighter/zippo/New()
	..()
	var/list/zippos = list()
	for(var/zippo in typesof(/obj/item/flame/lighter/zippo))
		if(ispath(zippo, /obj/item/flame/lighter/zippo/c4detonator))
			continue
		var/obj/item/flame/lighter/zippo/zippo_type = zippo
		zippos[initial(zippo_type.name)] = zippo_type
	gear_tweaks += new/datum/loadout_entry_tweak/path(tim_sort(zippos, /proc/cmp_text_asc))

/datum/loadout_entry/ashtray
	name = "Plastic Ashtray"
	path = /obj/item/material/ashtray/plastic

/datum/loadout_entry/cigar
	name = "Cigar"
	path = /obj/item/clothing/mask/smokable/cigarette/cigar

/datum/loadout_entry/cigarcase
	name = "Cigar Case"
	path = /obj/item/storage/fancy/cigar
	cost = 3

/datum/loadout_entry/cigarettes
	name = "Cigarette Selection"
	path = /obj/item/storage/fancy/cigarettes

/datum/loadout_entry/cigarettes/New()
	..()
	var/list/cigarettes = list()
	for(var/cigarette in (typesof(/obj/item/storage/fancy/cigarettes) - typesof(/obj/item/storage/fancy/cigarettes/killthroat)))
		var/obj/item/storage/fancy/cigarettes/cigarette_brand = cigarette
		cigarettes[initial(cigarette_brand.name)] = cigarette_brand
	gear_tweaks += new/datum/loadout_entry_tweak/path(tim_sort(cigarettes, /proc/cmp_text_asc))
