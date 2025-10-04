/mob/living/simple_mob/animal
	mob_class = MOB_CLASS_ANIMAL
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	bone_type = /obj/item/stack/material/bone
	hide_type = /obj/item/stack/animalhide
	exotic_type = /obj/item/stack/sinew

	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "hits"

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee

	butchery_loot = list(
		/obj/item/stack/animalhide = 3,
	)
