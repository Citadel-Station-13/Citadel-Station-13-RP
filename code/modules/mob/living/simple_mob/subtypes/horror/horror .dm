/datum/category_item/catalogue/fauna/horror
	name = "%#ERROR#%"
	desc = "%ERROR% SCAN DATA REDACTED. RETURN SCANNER TO A \
	CENTRAL ADMINISTRATOR FOR IMMEDIATE MAINTENANCE. %ERROR%"
	value = CATALOGUER_REWARD_TRIVIAL
	unlocked_by_any = list(/datum/category_item/catalogue/fauna/horror)

// Obtained by scanning all X.
/datum/category_item/catalogue/fauna/all_horrors
	name = "Coll-LL-ec-T-io$#@ - %REDACTED!!!%"
	desc = "You have REJECTED a large $%*^ of different MAINTENANCE MODE, \
	and therefore you have been SLATED FOR &&!!%) sum of points, through this \
	%%ERROR%%."
	value = CATALOGUER_REWARD_TRIVIAL
	unlocked_by_all = list(
		/datum/category_item/catalogue/fauna/horror/bradley,
		/datum/category_item/catalogue/fauna/horror/Eddy,
		/datum/category_item/catalogue/fauna/horror/Master,
		/datum/category_item/catalogue/fauna/horror/Rickey,
		/datum/category_item/catalogue/fauna/horror/Sally,
		/datum/category_item/catalogue/fauna/horror/BigTim,
		/datum/category_item/catalogue/fauna/horror/Smiley,
		/datum/category_item/catalogue/fauna/horror/Steve,
		/datum/category_item/catalogue/fauna/horror/TinyTim,
		/datum/category_item/catalogue/fauna/horror/Willy
		)

/mob/living/simple_mob/horror
	tt_desc = "Homo Horrificus"
	faction = "horror"
	icon = 'icons/mob/horror_show/GHPS.dmi'
	icon_gib = "generic_gib"
	taser_kill = 0
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	bone_type = /obj/item/stack/material/bone
	hide_type = /obj/item/stack/hairlesshide
	exotic_type = /obj/item/stack/sinew

/datum/ai_holder/simple_mob/horror
	hostile = TRUE // The majority of simplemobs are hostile, gaslamps are nice.
	cooperative = FALSE
	retaliate = TRUE //so the monster can attack back
	returns_home = FALSE
	can_flee = FALSE
	speak_chance = 3
	wander = TRUE
	base_wander_delay = 9

/mob/living/simple_mob/horror
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 700
