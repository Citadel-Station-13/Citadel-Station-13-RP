// Hooded suits

//Hoods for winter coats and chaplain hoodie etc

/obj/item/clothing/suit/storage/hooded
	var/obj/item/clothing/head/hood
	var/hoodtype = null //so the chaplain hoodie or other hoodies can override this
	var/hood_up = FALSE
	var/toggleicon
	action_button_name = "Toggle Hood"

/obj/item/clothing/suit/storage/hooded/New()
	toggleicon = "[initial(icon_state)]"
	MakeHood()
	..()

/obj/item/clothing/suit/storage/hooded/Destroy()
	qdel(hood)
	return ..()

/obj/item/clothing/suit/storage/hooded/proc/MakeHood()
	if(!hood)
		var/obj/item/clothing/head/hood/H = new hoodtype(src)
		hood = H

/obj/item/clothing/suit/storage/hooded/ui_action_click()
	ToggleHood()

/obj/item/clothing/suit/storage/hooded/equipped(mob/user, slot)
	if(slot != slot_wear_suit)
		RemoveHood()
	..()

/obj/item/clothing/suit/storage/hooded/proc/RemoveHood()
	icon_state = toggleicon
	hood_up = FALSE
	hood.canremove = TRUE // This shouldn't matter anyways but just incase.
	if(ishuman(hood.loc))
		var/mob/living/carbon/H = hood.loc
		H.unEquip(hood, 1)
		H.update_inv_wear_suit()
	hood.forceMove(src)

/obj/item/clothing/suit/storage/hooded/dropped()
	RemoveHood()

/obj/item/clothing/suit/storage/hooded/proc/ToggleHood()
	if(!hood_up)
		if(ishuman(loc))
			var/mob/living/carbon/human/H = src.loc
			if(H.wear_suit != src)
				to_chat(H, "<span class='warning'>You must be wearing [src] to put up the hood!</span>")
				return
			if(H.head)
				to_chat(H, "<span class='warning'>You're already wearing something on your head!</span>")
				return
			else
				H.equip_to_slot_if_possible(hood,slot_head,0,0,1)
				hood_up = TRUE
				hood.canremove = FALSE
				icon_state = "[toggleicon]_t"
				H.update_inv_wear_suit()
	else
		RemoveHood()

/obj/item/clothing/suit/storage/hooded/carp_costume
	name = "carp costume"
	desc = "A costume made from 'synthetic' carp scales, it smells."
	icon_state = "carp_casual"
	item_state_slots = list(slot_r_hand_str = "carp_casual", slot_l_hand_str = "carp_casual") //Does not exist -S2-
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	flags_inv = HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE	//Space carp like space, so you should too
	action_button_name = "Toggle Carp Hood"
	hoodtype = /obj/item/clothing/head/hood/carp_hood

/obj/item/clothing/suit/storage/hooded/ian_costume	//It's Ian, rub his bell- oh god what happened to his inside parts?
	name = "corgi costume"
	desc = "A costume that looks like someone made a human-like corgi, it won't guarantee belly rubs."
	icon_state = "ian"
	item_state_slots = list(slot_r_hand_str = "ian", slot_l_hand_str = "ian") //Does not exist -S2-
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	flags_inv = HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	action_button_name = "Toggle Ian Hood"
	hoodtype = /obj/item/clothing/head/hood/ian_hood

/obj/item/clothing/suit/storage/hooded/techpriest /// TO DO - FIND A WAY TO HIDE FEET PROPERLY
	name = "tech priest robe"
	desc = "A robe for those that worship the Omnissiah. Also toasters.. for.. some reason."
	icon_state = "techpriest"
	action_button_name = "Toggle Priest Hood"
	body_parts_covered = LOWER_TORSO|UPPER_TORSO|ARMS|LEGS|FEET
	flags_inv = HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	item_state_slots = list(slot_r_hand_str = "techpriest", slot_l_hand_str = "techpriest")
	hoodtype = /obj/item/clothing/head/hood/techpriest

/obj/item/clothing/suit/storage/hooded/wintercoat
	name = "winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs."
	icon_state = "coatwinter"
	item_state_slots = list(slot_r_hand_str = "coatwinter", slot_l_hand_str = "coatwinter")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	flags_inv = HIDEHOLSTER
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	hoodtype = /obj/item/clothing/head/hood/winter
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit)

/obj/item/clothing/suit/storage/hooded/wintercoat/captain
	name = "Facility Director's winter coat"
	desc = "A heavy jacket made from the most expensive animal furs on the market, hand skinned by the finest of hunters, sewed with the finest of jewels, truly a coat befitting the Director."
	icon_state = "coatcaptain"
	item_state_slots = list(slot_r_hand_str = "coatcaptain", slot_l_hand_str = "coatcaptain")
	armor = list(melee = 20, bullet = 15, laser = 20, energy = 10, bomb = 15, bio = 0, rad = 0)
	hoodtype = /obj/item/clothing/head/hood/winter/captain
	allowed =  list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit, /obj/item/gun/energy,
	/obj/item/reagent_containers/spray/pepper,/obj/item/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,
	/obj/item/handcuffs,/obj/item/clothing/head/helmet)

/obj/item/clothing/suit/storage/hooded/wintercoat/security
	name = "security winter coat"
	desc = "A heavy jacket made from greyshirt hide, there seems to be a sewed in holster, as well as a thin weave of protection against most damage.'"
	icon_state = "coatsecurity"
	item_state_slots = list(slot_r_hand_str = "coatsecurity", slot_l_hand_str = "coatsecurity")
	armor = list(melee = 25, bullet = 20, laser = 20, energy = 15, bomb = 20, bio = 0, rad = 0)
	hoodtype = /obj/item/clothing/head/hood/winter/security
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit, /obj/item/gun/energy,
	/obj/item/reagent_containers/spray/pepper,/obj/item/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,
	/obj/item/handcuffs,/obj/item/clothing/head/helmet)

/obj/item/clothing/suit/storage/hooded/wintercoat/medical
	name = "medical winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs, there's a thick weave of sterile material, good for virus outbreaks!"
	icon_state = "coatmedical"
	item_state_slots = list(slot_r_hand_str = "coatmedical", slot_l_hand_str = "coatmedical")
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)
	hoodtype = /obj/item/clothing/head/hood/winter/medical
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit, /obj/item/analyzer,/obj/item/stack/medical,
	/obj/item/dnainjector,/obj/item/reagent_containers/dropper,/obj/item/reagent_containers/syringe,/obj/item/reagent_containers/hypospray,
	/obj/item/healthanalyzer,/obj/item/reagent_containers/glass/bottle,/obj/item/reagent_containers/glass/beaker,
	/obj/item/reagent_containers/pill,/obj/item/storage/pill_bottle)

/obj/item/clothing/suit/storage/hooded/wintercoat/science
	name = "science winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs, a small tag says 'Bomb Proof! (not fully bomb proof)'."
	icon_state = "coatscience"
	item_state_slots = list(slot_r_hand_str = "coatscience", slot_l_hand_str = "coatscience")
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)
	hoodtype = /obj/item/clothing/head/hood/winter/science
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit, /obj/item/analyzer,/obj/item/stack/medical,
	/obj/item/dnainjector,/obj/item/reagent_containers/dropper,/obj/item/reagent_containers/syringe,/obj/item/reagent_containers/hypospray,
	/obj/item/healthanalyzer,/obj/item/reagent_containers/glass/bottle,/obj/item/reagent_containers/glass/beaker,
	/obj/item/reagent_containers/pill,/obj/item/storage/pill_bottle)

/obj/item/clothing/suit/storage/hooded/wintercoat/engineering
	name = "engineering winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs, there seems to be a thin weave of lead on the inside."
	icon_state = "coatengineer"
	item_state_slots = list(slot_r_hand_str = "coatengineer", slot_l_hand_str = "coatengineer")
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 20)
	hoodtype = /obj/item/clothing/head/hood/winter/engineering
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit, /obj/item/analyzer, /obj/item/flashlight,
	/obj/item/multitool, /obj/item/pipe_painter, /obj/item/radio, /obj/item/t_scanner, /obj/item/tool/crowbar, /obj/item/tool/screwdriver,
	/obj/item/weldingtool, /obj/item/tool/wirecutters, /obj/item/tool/wrench, /obj/item/tank/emergency/oxygen, /obj/item/clothing/mask/gas,
	/obj/item/barrier_tape_roll/engineering, /obj/item/weapon/rcd, /obj/item/weapon/pipe_dispenser)

/obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos
	name = "atmospherics winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs, seems to have burn makes on the inside from a phoron fire."
	icon_state = "coatatmos"
	item_state_slots = list(slot_r_hand_str = "coatatmos", slot_l_hand_str = "coatatmos")
	hoodtype = /obj/item/clothing/head/hood/winter/engineering/atmos

/obj/item/clothing/suit/storage/hooded/wintercoat/hydro
	name = "hydroponics winter coat"
	desc = "A heavy jacket made from synthetic animal furs, there's a small tag that says 'Made in China, Vegan Friendly'."
	icon_state = "coathydro"
	item_state_slots = list(slot_r_hand_str = "coathydro", slot_l_hand_str = "coathydro")
	hoodtype = /obj/item/clothing/head/hood/winter/hydro
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit, /obj/item/reagent_containers/spray/plantbgone,
	/obj/item/analyzer/plant_analyzer, /obj/item/seeds, /obj/item/reagent_containers/glass/bottle, /obj/item/material/minihoe)

/obj/item/clothing/suit/storage/hooded/wintercoat/cargo
	name = "cargo winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs, it seems to be rather rugged, from backbreaking work of pushing crates."
	icon_state = "coatcargo"
	item_state_slots = list(slot_r_hand_str = "coatcargo", slot_l_hand_str = "coatcargo")
	hoodtype = /obj/item/clothing/head/hood/winter/cargo

/obj/item/clothing/suit/storage/hooded/wintercoat/miner
	name = "mining winter coat"
	icon_state = "coatminer"
	desc = "A heavy jacket made from real animal furs, the miner who made this must have been through the Underdark."
	item_state_slots = list(slot_r_hand_str = "coatminer", slot_l_hand_str = "coatminer")
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	hoodtype = /obj/item/clothing/head/hood/winter/miner
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight, /obj/item/storage/fancy/cigarettes, /obj/item/storage/box/matches,
	/obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit, /obj/item/tank, /obj/item/radio, /obj/item/pickaxe, /obj/item/storage/bag/ore)

/obj/item/clothing/suit/storage/hooded/wintercoat/bar
	name = "bartender winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs, it smells of booze."
	icon_state = "coatbar"
	item_state_slots = list(slot_r_hand_str = "coatwinter", slot_l_hand_str = "coatwinter")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	flags_inv = HIDEHOLSTER
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	hoodtype = /obj/item/clothing/head/hood/winter
	allowed = list (/obj/item/gun/projectile/sec/flash, /obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes, /obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask)

/obj/item/clothing/suit/storage/hooded/wintercoat/para
	name = "paramedic winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs, it has an aura of underappreciation."
	icon_state = "coatpara"
	item_state_slots = list(slot_r_hand_str = "coatwinter", slot_l_hand_str = "coatwinter")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	flags_inv = HIDEHOLSTER
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)
	hoodtype = /obj/item/clothing/head/hood/winter
	allowed = list (/obj/item/gun/projectile/sec/flash, /obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes, /obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask)

/obj/item/clothing/suit/storage/hooded/explorer
	name = "explorer suit"
	desc = "An armoured suit for exploring harsh environments."
	icon_state = "explorer"
	item_state = "explorer"
	flags = THICKMATERIAL
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	cold_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	hoodtype = /obj/item/clothing/head/hood/explorer
	siemens_coefficient = 0.9
	armor = list(melee = 30, bullet = 20, laser = 20, energy = 20, bomb = 35, bio = 75, rad = 35) // Inferior to sec vests in bullet/laser but better for environmental protection.
	allowed = list(
		/obj/item/flashlight,
		/obj/item/gun,
		/obj/item/ammo_magazine,
		/obj/item/melee,
		/obj/item/material/knife,
		/obj/item/tank,
		/obj/item/radio,
		/obj/item/pickaxe,
		/obj/item/gun/projectile/sec/flash
		)

/obj/item/clothing/suit/storage/hooded/ronincoat
	name = "ronin coat"
	desc = "Outfitted with integrated heating coils, this fashionable coat is a favorite of gangsters and mercenaries alike."
	icon_state = "ronin_coat"
	item_state_slots = list(slot_r_hand_str = "brown_jacket", slot_l_hand_str = "brown_jacket")
	flags_inv = HIDEHOLSTER
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	hoodtype = /obj/item/clothing/head/hood/winter/ronin
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit)
