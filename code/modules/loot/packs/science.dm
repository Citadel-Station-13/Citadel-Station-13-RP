/datum/prototype/loot_pack/science
	abstract_type = /datum/prototype/loot_pack/science

/datum/prototype/loot_pack/science/stock_parts
	abstract_type = /datum/prototype/loot_pack/science/stock_parts

/datum/prototype/loot_pack/science/stock_parts/chaotic
	amt = 20

/datum/prototype/loot_pack/science/stock_parts/chaotic/draw(amount = amt)
	return chaotic_draw(typesof(/obj/item/stock_parts), amount)
