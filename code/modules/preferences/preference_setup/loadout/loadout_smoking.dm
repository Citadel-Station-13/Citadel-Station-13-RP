
/datum/gear/pipe
	name = "Pipe"
	path = /obj/item/clothing/mask/smokable/pipe

/datum/gear/pipe/New()
	..()
	var/list/pipes = list()
	for(var/pipe_style in typesof(/obj/item/clothing/mask/smokable/pipe))
		var/obj/item/clothing/mask/smokable/pipe/pipe = pipe_style
		pipes[initial(pipe.name)] = pipe
	gear_tweaks += new/datum/gear_tweak/path(sortTim(pipes, /proc/cmp_text_asc))

/datum/gear/matchbook
	name = "Matchbook"
	path = /obj/item/storage/box/matches

/datum/gear/lighter
	name = "Cheap Lighter"
	path = /obj/item/flame/lighter

/datum/gear/lighter/zippo
	name = "Zippo Selection"
	path = /obj/item/flame/lighter/zippo

/datum/gear/lighter/zippo/New()
	..()
	var/list/zippos = list()
	for(var/zippo in typesof(/obj/item/flame/lighter/zippo))
		var/obj/item/flame/lighter/zippo/zippo_type = zippo
		zippos[initial(zippo_type.name)] = zippo_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(zippos, /proc/cmp_text_asc))

/datum/gear/ashtray
	name = "Plastic Ashtray"
	path = /obj/item/material/ashtray/plastic

/datum/gear/cigar
	name = "Cigar"
	path = /obj/item/clothing/mask/smokable/cigarette/cigar

/datum/gear/cigarcase
	name = "Cigar Case"
	path = /obj/item/storage/fancy/cigar
	cost = 3

/datum/gear/cigarettes
	name = "Cigarette Selection"
	path = /obj/item/storage/fancy/cigarettes

/datum/gear/cigarettes/New()
	..()
	var/list/cigarettes = list()
	for(var/cigarette in (typesof(/obj/item/storage/fancy/cigarettes) - typesof(/obj/item/storage/fancy/cigarettes/killthroat)))
		var/obj/item/storage/fancy/cigarettes/cigarette_brand = cigarette
		cigarettes[initial(cigarette_brand.name)] = cigarette_brand
	gear_tweaks += new/datum/gear_tweak/path(sortTim(cigarettes, /proc/cmp_text_asc))
