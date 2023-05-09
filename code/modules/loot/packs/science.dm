/datum/prototype/simple/loot_pack/science
	abstract_type = /datum/prototype/simple/loot_pack/science

/datum/prototype/simple/loot_pack/science/stock_parts
	abstract_type = /datum/prototype/simple/loot_pack/science/stock_parts

/datum/prototype/simple/loot_pack/science/stock_parts/chaotic
	amt = 20

/datum/prototype/simple/loot_pack/science/stock_parts/chaotic/draw(amount = amt)
	return chaotic_draw(typesof(/obj/item/stock_parts), amount)
