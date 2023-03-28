/datum/prototype/loot_pack/clothing
	abstract_type = /datum/prototype/loot_pack/clothing

/datum/prototype/loot_pack/clothing/chaotic
	always = list(
		/obj/item/storage/box/syndie_kit/chameleon,
	)
	amt = 10

/datum/prototype/loot_pack/clothing/chaotic/draw(amount = amt)
	. = list()
	var/list/paths = subtypesof(/obj/item/clothing)
	for(var/i in 1 to amt)
		var/obj/item/clothing/got = pick(paths)
		if(initial(got.abstract_type) == got)
			continue // just skip
		.[got] += 1
