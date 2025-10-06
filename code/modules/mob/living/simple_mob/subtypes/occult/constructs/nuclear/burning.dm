////////////////////////////
//		Burning Runner
////////////////////////////

/datum/category_item/catalogue/fauna/nuclear_spirits/burning
	name = "Paranatural Entity - Burning Runner"
	desc = "A paranatural creature resembling a burning humanoid. \
	More energy then anything solid it aborbs heat into its body \
	however it has a low tolerance for kinectic energy and quickly \
	falls apart into a charred husk from blunt attacks. The Burning \
	Runner charges its foes fearlessly attempting to spread its blaze \
	to its victims. Perhaps it seeks to share its eternal agony."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/construct/nuclear/burning
	name = "Burning Runner"
	real_name = "Burning Runner"
	desc = "The burning man shares its fire with all."
	icon_state = "burning"
	icon_living = "burning"
	icon_dead = "burning_dead"
	maxHealth = 50
	health = 50
	legacy_melee_damage_lower = 10
	legacy_melee_damage_upper = 10
	attacktext = list("swipes")
	friendly = list("caresses")
	movement_base_speed = 5

	catalogue_data = list(/datum/category_item/catalogue/fauna/nuclear_spirits/burning)

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/evasive

	armor_legacy_mob = list( 				//Mob Gimmick, highly resistant to E weapons			//Mob Gimmick, absorbs normal burn damage,
				"melee" = -0,
				"bullet" = 0,
				"laser" = 90,
				"energy" = 90,
				"bomb" = 0,
				"bio" = 100,
				"rad" = 100)

/mob/living/simple_mob/construct/nuclear/burning/handle_light()
	. = ..()
	if(. == 0 && !is_dead())
		set_light(2.5, 1, COLOR_ORANGE)
		return 1

/mob/living/simple_mob/construct/nuclear/burning/apply_melee_effects(mob/living/carbon/M, alien, removed)
	if(M.fire_stacks <= 2)
		M.adjust_fire_stacks(1)
		M.IgniteMob()
