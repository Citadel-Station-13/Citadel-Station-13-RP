/datum/prototype/loot_pack/toys
	abstract_type = /datum/prototype/loot_pack/toys

/datum/prototype/loot_pack/toys/chaotic
	amt = 20

/datum/prototype/loot_pack/toys/chaotic/draw(amount = amt)
	. = list()
	var/list/toy_types = subtypesof(/obj/item/toy)
	for(var/i in 1 to amount)
		var/obj/item/toy/path = pick(toy_types)
		if(initial(path.abstract_type) == path)
			continue // just skip lmao
		.[path] += 1
