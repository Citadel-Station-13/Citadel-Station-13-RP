// Hooded suits

//Hoods for winter coats and chaplain hoodie etc

/obj/item/clothing/suit/storage/hooded
	var/obj/item/clothing/head/hood
	var/hoodtype = null //so the chaplain hoodie or other hoodies can override this
	var/hood_up = FALSE
	var/toggleicon
	action_button_name = "Toggle Hood"
	allowed =  list (/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes, /obj/item/storage/box/matches,
	/obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit)

/obj/item/clothing/suit/storage/hooded/Initialize(mapload)
	. = ..()
	toggleicon = "[initial(icon_state)]"
	MakeHood()

/obj/item/clothing/suit/storage/hooded/Destroy()
	qdel(hood)
	return ..()

/obj/item/clothing/suit/storage/hooded/proc/MakeHood()
	if(!hood && hoodtype)
		var/obj/item/clothing/head/hood/H = new hoodtype(src)
		hood = H

/obj/item/clothing/suit/storage/hooded/AltClick()
	ToggleHood()

/obj/item/clothing/suit/storage/hooded/ui_action_click()
	ToggleHood()

/obj/item/clothing/suit/storage/hooded/equipped(mob/user, slot, flags)
	if(slot != SLOT_ID_SUIT)
		RemoveHood()
	..()

/obj/item/clothing/suit/storage/hooded/proc/RemoveHood()
	icon_state = toggleicon
	hood_up = FALSE
	REMOVE_TRAIT(hood, TRAIT_ITEM_NODROP, CLOTHING_TRAIT)
	hood.forceMove(src)
	update_worn_icon()

/obj/item/clothing/suit/storage/hooded/dropped(mob/user, flags, atom/newLoc)
	. = ..()
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
				if(atom_flags & PHORONGUARD)
					hood.atom_flags |= PHORONGUARD
				else
					hood.atom_flags &= ~PHORONGUARD
				hood.set_armor(fetch_armor())
				hood.copy_atom_colour(src)
				// equip after armor / color changes
				H.equip_to_slot_if_possible(hood, SLOT_ID_HEAD)
				hood_up = TRUE
				ADD_TRAIT(hood, TRAIT_ITEM_NODROP, CLOTHING_TRAIT)
				icon_state = "[toggleicon]-t"
				update_worn_icon()
	else
		RemoveHood()

/obj/item/clothing/suit/storage/hooded/carp_costume
	name = "carp costume"
	desc = "A costume made from 'synthetic' carp scales, it smells."
	icon_state = "carp_casual"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "carp_casual", SLOT_ID_LEFT_HAND = "carp_casual") //Does not exist -S2-
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS
	inv_hide_flags = HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE	//Space carp like space, so you should too
	action_button_name = "Toggle Carp Hood"
	hoodtype = /obj/item/clothing/head/hood/carp_hood

/obj/item/clothing/suit/storage/hooded/ian_costume	//It's Ian, rub his bell- oh god what happened to his inside parts?
	name = "corgi costume"
	desc = "A costume that looks like someone made a human-like corgi, it won't guarantee belly rubs."
	icon_state = "ian"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "ian", SLOT_ID_LEFT_HAND = "ian") //Does not exist -S2-
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS
	inv_hide_flags = HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	action_button_name = "Toggle Ian Hood"
	hoodtype = /obj/item/clothing/head/hood/ian_hood

/obj/item/clothing/suit/storage/hooded/bee_costume
	name = "bee costume"
	desc = "A giant bee costume, popular at parties and random bar functions."
	icon_state = "bee"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS
	inv_hide_flags = HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	action_button_name = "Toggle Bee Hood"
	hoodtype = /obj/item/clothing/head/hood/bee_hood

/obj/item/clothing/suit/storage/hooded/flash_costume
	name = "flash costume"
	desc = "Once a common sight at Security hosted balls, this outfit has oddly fallen out of favor recently."
	icon_state = "flashsuit"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS
	inv_hide_flags = HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	action_button_name = "Toggle Flash Top"
	hoodtype = /obj/item/clothing/head/hood/flash_hood

/obj/item/clothing/suit/storage/hooded/techpriest /// TO DO - FIND A WAY TO HIDE FEET PROPERLY
	name = "tech priest robe"
	desc = "A robe for those that worship the Omnissiah. Also toasters.. for.. some reason."
	icon_state = "techpriest"
	action_button_name = "Toggle Priest Hood"
	body_cover_flags = LOWER_TORSO|UPPER_TORSO|ARMS|LEGS|FEET
	inv_hide_flags = HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "techpriest", SLOT_ID_LEFT_HAND = "techpriest")
	hoodtype = /obj/item/clothing/head/hood/techpriest

/obj/item/clothing/suit/storage/hooded/wintercoat
	name = "winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs."
	icon_state = "coatwinter"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "coatwinter", SLOT_ID_LEFT_HAND = "coatwinter")
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	atom_flags = PHORONGUARD
	inv_hide_flags = HIDEHOLSTER
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	armor_type = /datum/armor/civilian/coat
	hoodtype = /obj/item/clothing/head/hood/winter
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit)

/obj/item/clothing/suit/storage/hooded/wintercoat/centcom
	name = "centcom winter coat"
	icon_state = "coatcentcom"
	item_state = "coatcentcom"
	armor_type = /datum/armor/centcom/coat
	hoodtype = /obj/item/clothing/head/hood/winter/centcom

/obj/item/clothing/suit/storage/hooded/wintercoat/olive
	name = "olive green winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs. Has a coloration similar to military jackets."
	icon_state = "coatar"

/obj/item/clothing/suit/storage/hooded/wintercoat/captain
	name = "Facility Director's winter coat"
	desc = "A heavy jacket made from the most expensive animal furs on the market, hand skinned by the finest of hunters, sewed with the finest of jewels, truly a coat befitting the Director."
	icon_state = "coatcaptain"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "coatcaptain", SLOT_ID_LEFT_HAND = "coatcaptain")
	armor_type = /datum/armor/security/light_formalwear
	hoodtype = /obj/item/clothing/head/hood/winter/captain
	allowed =  list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit, /obj/item/gun/energy,
	/obj/item/reagent_containers/spray/pepper,/obj/item/gun/ballistic,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,
	/obj/item/handcuffs,/obj/item/clothing/head/helmet)

/obj/item/clothing/suit/storage/hooded/wintercoat/captain/hop
	name = "head of personnel's winter coat"
	desc = "A cozy winter coat, covered in thick fur. The breast features a proud yellow chevron, reminding everyone that you're the second banana."
	icon_state = "coathop"
	armor_type = /datum/armor/security/light_formalwear
	hoodtype = /obj/item/clothing/head/hood/winter/hop

/obj/item/clothing/suit/storage/hooded/wintercoat/security
	name = "security winter coat"
	desc = "A heavy jacket made from greyshirt hide, there seems to be a sewed in holster, as well as a thin weave of protection against most damage.'"
	icon_state = "coatsecurity"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "coatsecurity", SLOT_ID_LEFT_HAND = "coatsecurity")
	armor_type = /datum/armor/security/light_formalwear
	hoodtype = /obj/item/clothing/head/hood/winter/security
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit, /obj/item/gun/energy,
	/obj/item/reagent_containers/spray/pepper,/obj/item/gun/ballistic,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,
	/obj/item/handcuffs,/obj/item/clothing/head/helmet)

/obj/item/clothing/suit/storage/hooded/wintercoat/security/hos
	name = "head of security's winter coat"
	desc = "A comfortable winter coat with a robust Kevlar underlayer and a built-in holster. The red and gold insignia on the sleeves denote the wearer's position as Head of Security."
	icon_state = "coathos"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "coathos", SLOT_ID_LEFT_HAND = "coathos")
	hoodtype = /obj/item/clothing/head/hood/winter/hos

/obj/item/clothing/suit/storage/hooded/wintercoat/medical
	name = "medical winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs, there's a thick weave of sterile material, good for virus outbreaks!"
	icon_state = "coatmedical"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "coatmedical", SLOT_ID_LEFT_HAND = "coatmedical")
	armor_type = /datum/armor/medical/coat
	hoodtype = /obj/item/clothing/head/hood/winter/medical
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit, /obj/item/atmos_analyzer,/obj/item/stack/medical,
	/obj/item/dnainjector,/obj/item/reagent_containers/dropper,/obj/item/reagent_containers/syringe,/obj/item/reagent_containers/hypospray,
	/obj/item/healthanalyzer,/obj/item/reagent_containers/glass/bottle,/obj/item/reagent_containers/glass/beaker,
	/obj/item/reagent_containers/pill,/obj/item/storage/pill_bottle)

/obj/item/clothing/suit/storage/hooded/wintercoat/medical/genetics
	name = "genetics winter coat"
	desc = "A white winter coat with a DNA helix for the zipper tab. "
	icon_state = "coatgenetics"
	hoodtype = /obj/item/clothing/head/hood/winter/genetics

/obj/item/clothing/suit/storage/hooded/wintercoat/medical/chemistry
	name = "chemistry winter coat"
	desc = "A lab-grade winter coat made with acid resistant polymers. For the enterprising chemist who was exiled to a frozen wasteland on the go."
	icon_state = "coatchemistry"
	hoodtype = /obj/item/clothing/head/hood/winter/chemistry

/obj/item/clothing/suit/storage/hooded/wintercoat/medical/viro
	name = "virology winter coat"
	desc = "A white winter coat with green markings. Warm, but wont fight off the common cold or any other disease. Might make people stand far away from you in the hallway. The zipper tab looks like an oversized bacteriophage."
	icon_state = "coatviro"
	hoodtype = /obj/item/clothing/head/hood/winter/viro

/obj/item/clothing/suit/storage/hooded/wintercoat/medical/cmo
	name = "chief medical officer's winter coat"
	desc = "An arctic white winter coat with a small blue caduceus instead of a plastic zipper tab. The normal liner is replaced with an exceptionally thick, soft layer of fur."
	icon_state = "coatcmo"
	hoodtype = /obj/item/clothing/head/hood/winter/cmo

/obj/item/clothing/suit/storage/hooded/wintercoat/medical/para
	name = "paramedic winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs, it has an aura of underappreciation."
	icon_state = "coatpara"
	hoodtype = /obj/item/clothing/head/hood/winter/paramedic

/obj/item/clothing/suit/storage/hooded/wintercoat/science
	name = "science winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs, a small tag says 'Bomb Proof! (not fully bomb proof)'."
	icon_state = "coatscience"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "coatscience", SLOT_ID_LEFT_HAND = "coatscience")
	armor_type = /datum/armor/science/coat
	hoodtype = /obj/item/clothing/head/hood/winter/science
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit, /obj/item/atmos_analyzer,/obj/item/stack/medical,
	/obj/item/dnainjector,/obj/item/reagent_containers/dropper,/obj/item/reagent_containers/syringe,/obj/item/reagent_containers/hypospray,
	/obj/item/healthanalyzer,/obj/item/reagent_containers/glass/bottle,/obj/item/reagent_containers/glass/beaker,
	/obj/item/reagent_containers/pill,/obj/item/storage/pill_bottle)

/obj/item/clothing/suit/storage/hooded/wintercoat/science/robotics
	name = "robotics winter coat"
	desc = "A black winter coat with a badass flaming robotic skull for the zipper tab. This one has bright red designs and a few useless buttons."
	icon_state = "coatrobotics"
	hoodtype = /obj/item/clothing/head/hood/winter/robotics

/obj/item/clothing/suit/storage/hooded/wintercoat/science/rd
	name = "research director's winter coat"
	desc = "A thick arctic winter coat with an outdated atomic model instead of a plastic zipper tab. Most in the know are heavily aware that Bohr's model of the atom was outdated by the time of the 1930s when the Heisenbergian and Schrodinger models were generally accepted for true. Nevertheless, we still see its use in anachronism, roleplaying, and, in this case, as a zipper tab. At least it should keep you warm on your ivory pillar."
	icon_state = "coatrd"
	hoodtype = /obj/item/clothing/head/hood/winter/rd

/obj/item/clothing/suit/storage/hooded/wintercoat/engineering
	name = "engineering winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs, there seems to be a thin weave of lead on the inside."
	icon_state = "coatengineer"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "coatengineer", SLOT_ID_LEFT_HAND = "coatengineer")
	armor_type = /datum/armor/engineering/coat
	hoodtype = /obj/item/clothing/head/hood/winter/engineering
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit, /obj/item/atmos_analyzer, /obj/item/flashlight,
	/obj/item/multitool, /obj/item/pipe_painter, /obj/item/radio, /obj/item/t_scanner, /obj/item/tool/crowbar, /obj/item/tool/screwdriver,
	/obj/item/weldingtool, /obj/item/tool/wirecutters, /obj/item/tool/wrench, /obj/item/tank/emergency/oxygen, /obj/item/clothing/mask/gas,
	/obj/item/barrier_tape_roll/engineering, /obj/item/rcd, /obj/item/pipe_dispenser)

/obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos
	name = "atmospherics winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs, seems to have burn makes on the inside from a phoron fire."
	icon_state = "coatatmos"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "coatatmos", SLOT_ID_LEFT_HAND = "coatatmos")
	hoodtype = /obj/item/clothing/head/hood/winter/engineering/atmos

/obj/item/clothing/suit/storage/hooded/wintercoat/engineering/ce
	name = "chief engineer's winter coat"
	desc = "A white winter coat with reflective green and yellow stripes. Stuffed with asbestos, treated with fire retardant PBDE, lined with a micro thin sheet of lead foil and snugly fitted to your body's measurements. This baby's ready to save you from anything except the thyroid cancer and systemic fibrosis you'll get from wearing it. The zipper tab is a tiny golden wrench."
	icon_state = "coatce"
	hoodtype = /obj/item/clothing/head/hood/winter/ce

/obj/item/clothing/suit/storage/hooded/wintercoat/hydro
	name = "hydroponics winter coat"
	desc = "A heavy jacket made from synthetic animal furs, there's a small tag that says 'Made in China, Vegan Friendly'."
	icon_state = "coathydro"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "coathydro", SLOT_ID_LEFT_HAND = "coathydro")
	hoodtype = /obj/item/clothing/head/hood/winter/hydro
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit, /obj/item/reagent_containers/spray/plantbgone,
	/obj/item/plant_analyzer, /obj/item/seeds, /obj/item/reagent_containers/glass/bottle, /obj/item/material/minihoe)

/obj/item/clothing/suit/storage/hooded/wintercoat/cargo
	name = "cargo winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs, it seems to be rather rugged, from backbreaking work of pushing crates."
	icon_state = "coatcargo"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "coatcargo", SLOT_ID_LEFT_HAND = "coatcargo")
	hoodtype = /obj/item/clothing/head/hood/winter/cargo

/obj/item/clothing/suit/storage/hooded/wintercoat/miner
	name = "mining winter coat"
	icon_state = "coatminer"
	desc = "A heavy jacket made from real animal furs, the miner who made this must have been through the Underdark."
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "coatminer", SLOT_ID_LEFT_HAND = "coatminer")
	armor_type = /datum/armor/cargo/mining/coat
	hoodtype = /obj/item/clothing/head/hood/winter/miner
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight, /obj/item/storage/fancy/cigarettes, /obj/item/storage/box/matches,
	/obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit, /obj/item/tank, /obj/item/radio, /obj/item/pickaxe, /obj/item/storage/bag/ore)

/obj/item/clothing/suit/storage/hooded/wintercoat/bar
	name = "bartender winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs, it smells of booze."
	icon_state = "coatbar"
	hoodtype = /obj/item/clothing/head/hood/winter/bar

/obj/item/clothing/suit/storage/hooded/wintercoat/cosmic
	name = "cosmic winter coat"
	desc = "A starry winter coat that even glows softly."
	icon_state = "coatcosmic"
	hoodtype = /obj/item/clothing/head/hood/winter/cosmic
	light_power = 1.8
	light_range = 1.2

/obj/item/clothing/suit/storage/hooded/wintercoat/janitor
	name = "janitors winter coat"
	desc = "A purple-and-beige winter coat that smells of space cleaner."
	icon_state = "coatjanitor"
	hoodtype = /obj/item/clothing/head/hood/winter/janitor
/obj/item/clothing/suit/storage/hooded/wintercoat/cargo
	name = "cargo winter coat"
	desc = "A tan-and-grey winter coat that has a crate for its zipper pull tab. It fills you with the warmth of a fierce independence."
	icon_state = "coatcargo"
	hoodtype = /obj/item/clothing/head/hood/winter/cargo

/obj/item/clothing/suit/storage/hooded/wintercoat/qm
	name = "quartermaster's winter coat"
	desc = "A dark brown winter coat that has a golden crate pin for its zipper pully."
	icon_state = "coatqm"
	hoodtype = /obj/item/clothing/head/hood/winter/qm

/obj/item/clothing/suit/storage/hooded/wintercoat/aformal
	name = "assistant's formal winter coat"
	desc = "A black button up winter coat."
	icon_state = "coataformal"
	hoodtype = /obj/item/clothing/head/hood/winter/aformal


/obj/item/clothing/suit/storage/hooded/wintercoat/ratvar
	name = "ratvarian winter coat"
	desc = "A brass-plated button up winter coat. Instead of a zipper tab, it has a brass cog with a tiny red gemstone inset."
	icon_state = "coatratvar"
	armor_type = /datum/armor/cult/coat
	siemens_coefficient = 0.5
	hoodtype = /obj/item/clothing/head/hood/winter/ratvar
	var/real = TRUE

/obj/item/clothing/head/hood/winter/ratvar
	icon_state = "winterhood_ratvar"
	desc = "A brass-plated winter hood that glows softly, hinting at its divinity."
	light_range = 3
	light_power = 1
	light_color = "#B18B25" //clockwork slab background top color

/*
/obj/item/clothing/suit/storage/hooded/wintercoat/ratvar/equipped(mob/living/user,slot)
	..()
	if (slot != SLOT_WEAR_SUIT || !real)
		return
	if (is_servant_of_ratvar(user))
		return
	else
		user.dropItemToGround(src)
		to_chat(user,"<span class='large_brass'>\"Amusing that you think you are fit to wear this.\"</span>")
		to_chat(user,"<span class='userdanger'>Your skin burns where the coat touched your skin!</span>")
		user.adjustFireLoss(rand(10,16))
*/

/obj/item/clothing/suit/storage/hooded/wintercoat/narsie
	name = "narsian winter coat"
	desc = "A somber button-up in tones of grey entropy and a wicked crimson zipper. When pulled all the way up, the zipper looks like a bloody gash. The zipper pull looks like a single drop of blood."
	icon_state = "coatnarsie"
	armor_type = /datum/armor/cult/coat
	siemens_coefficient = 0.5
	hoodtype = /obj/item/clothing/head/hood/winter/narsie
	var/real = TRUE

/*
/obj/item/clothing/suit/storage/hooded/wintercoat/narsie/equipped(mob/living/user,slot)
	..()
	if (slot != SLOT_WEAR_SUIT || !real)
		return
	if (iscultist(user))
		return
	else
		user.dropItemToGround(src)
		to_chat(user,"<span class='cultlarge'>\"You are not fit to wear my follower's coat!\"</span>")
		to_chat(user,"<span class='userdanger'>Sharp spines jab you from within the coat!</span>")
		user.adjustBruteLoss(rand(10,16))
*/

/obj/item/clothing/suit/storage/hooded/wintercoat/ratvar/fake
	name = "brass winter coat"
	desc = "A brass-plated button up winter coat. Instead of a zipper tab, it has a brass cog with a tiny red piece of plastic as an inset."
	icon_state = "coatratvar"
	item_state = "coatratvar"
	armor_type = /datum/armor/none
	real = FALSE

/obj/item/clothing/suit/storage/hooded/wintercoat/narsie/fake
	name = "runed winter coat"
	desc = "A dusty button up winter coat in the tones of oblivion and ash. The zipper pull looks like a single drop of blood."
	icon_state = "coatnarsie"
	item_state = "coatnarsie"
	armor_type = /datum/armor/none
	real = FALSE

/obj/item/clothing/suit/storage/hooded/wintercoat/durathread
	name = "durathread winter coat"
	desc = "The one coat to rule them all. Extremely durable while providing the utmost comfort."
	icon_state = "coatdurathread"
	armor_type = /datum/armor/civilian/coat/durathread
	hoodtype = /obj/item/clothing/head/hood/winter/durathread

//Hazardous Softsuits
/obj/item/clothing/suit/storage/hooded/explorer
	name = "explorer suit"
	desc = "An armoured suit for exploring harsh environments."
	icon_state = "explorer"
	item_state = "explorer"
	atom_flags = PHORONGUARD
	clothing_flags = CLOTHING_THICK_MATERIAL | CLOTHING_INJECTION_PORT
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	cold_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	hoodtype = /obj/item/clothing/head/hood/explorer
	siemens_coefficient = 0.9
	armor_type = /datum/armor/exploration/soft
	allowed = list(
		/obj/item/flashlight,
		/obj/item/gun,
		/obj/item/ammo_magazine,
		/obj/item/melee,
		/obj/item/material/knife,
		/obj/item/tank,
		/obj/item/radio,
		/obj/item/pickaxe,
		/obj/item/gun/ballistic/sec/flash
		)

/obj/item/clothing/suit/storage/hooded/miner
	name = "mining suit"
	desc = "An armoured suit for mining in harsh environments."
	icon = 'icons/clothing/suit/mining.dmi'
	icon_state = "miner"
	atom_flags = PHORONGUARD
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	clothing_flags = CLOTHING_THICK_MATERIAL | CLOTHING_INJECTION_PORT
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	cold_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	hoodtype = /obj/item/clothing/head/hood/miner
	siemens_coefficient = 0.9
	armor_type = /datum/armor/cargo/mining/soft
	allowed = list(
		/obj/item/flashlight,
		/obj/item/material/knife,
		/obj/item/tank,
		/obj/item/radio,
		/obj/item/suit_cooling_unit,
		/obj/item/pickaxe,
		/obj/item/gun/energy/kinetic_accelerator,
		/obj/item/kinetic_crusher,
		/obj/item/resonator,
		/obj/item/gun/energy/gun/miningcarbine,
		/obj/item/gun/magnetic/matfed
		)

// Eldritch suit
/obj/item/clothing/suit/storage/hooded/eldritch
	name = "eldritch garment"
	desc = "A billowing garment that seeps a thick, waxy substance. Upon closer inspection this outfit is crafted out of tanned skin, the ritual icons and spells drawn onto it having been tattooed before removal."
	icon = 'icons/clothing/suit/antag/heretic.dmi'
	icon_state = "eldritcharmor"
	clothing_flags = CLOTHING_THICK_MATERIAL | CLOTHING_INJECTION_PORT
	inv_hide_flags = HIDEHOLSTER
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "brown_jacket", SLOT_ID_LEFT_HAND = "brown_jacket")
	action_button_name = "Toggle Eldritch Hood"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	hoodtype = /obj/item/clothing/head/hood/eldritch
	armor_type = /datum/armor/lavaland/eldritch
	siemens_coefficient = 0.9
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit, /obj/item/material/knife)
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/suit/storage/hooded/cloak/goliath
	name = "goliath cloak"
	desc = "A staunch, practical cape made out of numerous monster materials, it is coveted amongst exiles & hermits."
	icon_state = "goliath_cloak"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "brown_jacket", SLOT_ID_LEFT_HAND = "brown_jacket")
	allowed = list(
		/obj/item/flashlight, /obj/item/tank/emergency/oxygen, /obj/item/pickaxe, /obj/item/material/twohanded/spear, /obj/item/material/twohanded/spear/bone,
		/obj/item/material/knife/tacknife/combatknife/bone, /obj/item/material/knife/tacknife/survival/bone, /obj/item/material/knife/tacknife/survival/bone, /obj/item/melee/ashlander,
		/obj/item/gun/ballistic/musket/pistol
		)
	armor_type = /datum/armor/lavaland/goliath
	hoodtype = /obj/item/clothing/head/hood/goliath
	body_cover_flags = UPPER_TORSO|ARMS|LEGS
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/storage/hooded/cloak/drake
	name = "drake armour"
	icon_state = "dragon"
	desc = "A suit of armour fashioned from the remains of an ash drake."
	allowed = list(/obj/item/flashlight, /obj/item/tank/emergency/oxygen, /obj/item/resonator, /obj/item/mining_scanner, /obj/item/mining_scanner/advanced, /obj/item/gun/energy/kinetic_accelerator, /obj/item/pickaxe, /obj/item/material/twohanded/spear)
	armor_type = /datum/armor/lavaland/drake
	hoodtype = /obj/item/clothing/head/hood/drake
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE

//Vainglorious

/obj/item/clothing/suit/storage/hooded/vainglorious
	name = "Vainglorious hoodie"
	desc = "A sleeveless hoodie produced by AFW. Lightweight and sporty, it doesn't seem to offer much protection from the elements, but it's undeniably stylish."
	icon_state = "vainglorious"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "coatwinter", SLOT_ID_LEFT_HAND = "coatwinter")
	body_cover_flags = UPPER_TORSO|LOWER_TORSO
	inv_hide_flags = HIDEHOLSTER
	hoodtype = /obj/item/clothing/head/hood/vainglorious
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit)

/obj/item/clothing/suit/storage/hooded/raincoat
	name = "raincoat"
	desc = "A thin, opaque coat meant to protect you from all sorts of rain. Preferred by outdoorsmen and janitors alike across the rift. Of course, the only type of fluids you'd like to protect yourself from around this place don't rain down from the sky. Usually. Comes with a hood!"
	icon_state = "raincoat"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "wcoat", SLOT_ID_LEFT_HAND = "wcoat")
	body_cover_flags = UPPER_TORSO|LOWER_TORSO
	inv_hide_flags = HIDEHOLSTER
	hoodtype = /obj/item/clothing/head/hood/raincoat
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit, /obj/item/melee/umbrella)

/obj/item/clothing/suit/storage/hooded/rainponcho
	name = "plastic raincoat"
	desc = "A thin plastic poncho meant to protect you from rain. It's cheap, and it won't keep you dry for long."
	icon_state = "rainponcho"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "wcoat", SLOT_ID_LEFT_HAND = "wcoat")
	body_cover_flags = UPPER_TORSO|LOWER_TORSO
	hoodtype = /obj/item/clothing/head/hood/rainponcho
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit, /obj/item/melee/umbrella)

/obj/item/clothing/suit/storage/hooded/mercy
	name = "Mercy Robe"
	desc = "A pearlescent white, soft robe covered in various anti-bacterial silks. It seems to be preferred by medical professionals. Comes with a hood."
	icon_state = "mercy_hoodie"
	inv_hide_flags = HIDEHOLSTER
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	hoodtype = /obj/item/clothing/head/hood/mercy

//The Covert/Overt Spec Ops Carrier - This is technically armor, but due to how it works I'm putting it here.
/obj/item/clothing/suit/storage/hooded/covertcarrier
	name = "advanced plate carrier"
	desc = "The NT-COV/OV-4 plate carrier is an experimental system first utilized by covert field operatives employed by NanoTrasen. The covert/overt plate carrier is slim enough to be concealed beneath certain types of jackets or coverings. During a crisis, the vest's retractable helmet may be deployed for added protection."
	icon = 'icons/obj/clothing/modular_armor.dmi'
	item_icons = list(SLOT_ID_SUIT = 'icons/mob/clothing/modular_armor.dmi')
	icon_state = "pcarrier"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO
	hoodtype = /obj/item/clothing/head/hood/covertcarrier
	valid_accessory_slots = (\
		ACCESSORY_SLOT_OVER \
		|ACCESSORY_SLOT_INSIGNIA \
		|ACCESSORY_SLOT_ARMOR_C \
		|ACCESSORY_SLOT_ARMOR_A \
		|ACCESSORY_SLOT_ARMOR_L \
		|ACCESSORY_SLOT_ARMOR_S \
		|ACCESSORY_SLOT_ARMOR_M
		)
	restricted_accessory_slots = (\
		ACCESSORY_SLOT_OVER \
		|ACCESSORY_SLOT_INSIGNIA \
		|ACCESSORY_SLOT_ARMOR_C \
		|ACCESSORY_SLOT_ARMOR_A \
		|ACCESSORY_SLOT_ARMOR_L \
		|ACCESSORY_SLOT_ARMOR_S \
		|ACCESSORY_SLOT_ARMOR_M
		)
	blood_overlay_type = "armor"
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit, /obj/item/gun/energy,
	/obj/item/gun/ballistic, /obj/item/ammo_magazine, /obj/item/melee/baton)
	starting_accessories = list(/obj/item/clothing/accessory/armor/armorplate/heavy, /obj/item/clothing/accessory/storage/pouches)

/obj/item/clothing/suit/storage/hooded/covertcarrier/can_equip(mob/M, slot, mob/user, flags)
	. = ..()
	if(!.)
		return

	if(!ishuman(M))
		return

	var/mob/living/carbon/human/H = M

	if(H.gloves)
		if(H.gloves.body_cover_flags & ARMS)
			for(var/obj/item/clothing/accessory/A in src)
				if(A.body_cover_flags & ARMS)
					to_chat(H, "<span class='warning'>You can't wear \the [A] with \the [H.gloves], they're in the way.</span>")
					return FALSE
	if(H.shoes)
		if(H.shoes.body_cover_flags & LEGS)
			for(var/obj/item/clothing/accessory/A in src)
				if(A.body_cover_flags & LEGS)
					to_chat(H, "<span class='warning'>You can't wear \the [A] with \the [H.shoes], they're in the way.</span>")
					return FALSE
	return TRUE

/obj/item/clothing/suit/storage/hooded/covertcarrier/blueshield
	name = "experimental plate carrier"
	desc = "The NT-COV/OV-4a plate carrier is an experimental armor system designed for usage by Blueshields. The covert/overt plate carrier is slim enough to be concealed beneath certain types of jackets or coverings. During a crisis, the vest's retractable helmet may be deployed for added protection. Contains a removable light armor plate for potential upgrading."
	icon_state = "pcarrier"
	hoodtype = /obj/item/clothing/head/hood/covertcarrier/blueshield
	starting_accessories = list(/obj/item/clothing/accessory/armor/tag/ntbs, /obj/item/clothing/accessory/armor/armorplate)

/obj/item/clothing/suit/storage/hooded/covertcarrier/blueshield/alt
	name = "experimental plate carrier"
	desc = "The NT-COV/OV-4a plate carrier is an experimental armor system designed for usage by Blueshields. The covert/overt plate carrier is slim enough to be concealed beneath certain types of jackets or coverings. During a crisis, the vest's retractable helmet may be deployed for added protection. Contains a removable light armor plate for potential upgrading."
	icon_state = "pcarrier_alt"
	hoodtype = /obj/item/clothing/head/hood/covertcarrier/blueshield
	starting_accessories = list(/obj/item/clothing/accessory/armor/tag/ntbs, /obj/item/clothing/accessory/armor/armorplate)

/obj/item/clothing/suit/storage/hooded/covertcarrier/blueshield/navy
	name = "experimental plate carrier"
	desc = "The NT-COV/OV-4a plate carrier is an experimental armor system designed for usage by Blueshields. The covert/overt plate carrier is slim enough to be concealed beneath certain types of jackets or coverings. During a crisis, the vest's retractable helmet may be deployed for added protection. Contains a removable light armor plate for potential upgrading."
	icon_state = "pcarrier_navy"
	hoodtype = /obj/item/clothing/head/hood/covertcarrier/blueshield/navy
	starting_accessories = list(/obj/item/clothing/accessory/armor/tag/ntbs, /obj/item/clothing/accessory/armor/armorplate)
