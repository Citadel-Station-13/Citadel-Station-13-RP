/datum/prototype/loot_pack/misc
	abstract_type = /datum/prototype/loot_pack/misc

/datum/prototype/loot_pack/misc/wrestlemania
	always = list(
		/obj/item/clothing/mask/luchador,
		/obj/item/storage/belt/champion,
		/obj/item/clothing/gloves/boxing,
		/obj/item/spacecash/c1000,
		/obj/item/stack/material/gold = 5,
	)

/datum/prototype/loot_pack/misc/clown
	always = list(
		/obj/item/storage/backpack/clown,
		/obj/item/clothing/under/rank/clown,
		/obj/item/clothing/shoes/clown_shoes,
		/obj/item/pda/clown,
		/obj/item/clothing/mask/gas/clown_hat,
		/obj/item/bikehorn,
		/obj/item/pen/crayon/rainbow,
		/obj/item/toy/waterflower,
	)

/datum/prototype/loot_pack/misc/clown/draw(amount)
	return list(
		/obj/item/ore/vaudium = isnull(amount)? rand(15, 25) : amount,
	)

/datum/prototype/loot_pack/misc/clown/is_deterministic()
	return FALSE

/datum/prototype/loot_pack/misc/mime
	always = list(
		/obj/item/clothing/under/mime,
		/obj/item/clothing/shoes/black,
		/obj/item/pda/mime,
		/obj/item/clothing/gloves/white,
		/obj/item/clothing/mask/gas/mime,
		/obj/item/clothing/head/beret,
		/obj/item/clothing/suit/suspenders,
		/obj/item/pen/crayon/mime,
		/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing,
	)
