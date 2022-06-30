/obj/item/clothing/accessory/vest
	name = "black vest"
	desc = "Slick black suit vest."
	icon_state = "det_vest"
	slot = ACCESSORY_SLOT_OVER

/obj/item/clothing/accessory/jacket
	name = "tan suit jacket"
	desc = "Cozy suit jacket."
	icon_state = "tan_jacket"
	slot = ACCESSORY_SLOT_OVER

/obj/item/clothing/accessory/jacket/charcoal
	name = "charcoal suit jacket"
	desc = "Strict suit jacket."
	icon_state = "charcoal_jacket"

/obj/item/clothing/accessory/jacket/navy
	name = "navy suit jacket"
	desc = "Official suit jacket."
	icon_state = "navy_jacket"

/obj/item/clothing/accessory/jacket/burgundy
	name = "burgundy suit jacket"
	desc = "Expensive suit jacket."
	icon_state = "burgundy_jacket"

/obj/item/clothing/accessory/jacket/checkered
	name = "checkered suit jacket"
	desc = "Lucky suit jacket."
	icon_state = "checkered_jacket"

/obj/item/clothing/accessory/chaps
	name = "brown chaps"
	desc = "A pair of loose, brown leather chaps."
	icon_state = "chaps"

/obj/item/clothing/accessory/chaps/black
	name = "black chaps"
	desc = "A pair of loose, black leather chaps."
	icon_state = "chaps_black"

/*
 * Poncho
 */
/obj/item/clothing/accessory/poncho
	name = "poncho"
	desc = "A simple, comfortable poncho."
	icon_state = "classicponcho"
	item_state = "classicponcho"
	icon_override = 'icons/mob/clothing/ties.dmi'
	var/fire_resist = T0C+100
	allowed = list(/obj/item/tank/emergency/oxygen)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	slot_flags = SLOT_OCLOTHING | SLOT_TIE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	siemens_coefficient = 0.9
	w_class = ITEMSIZE_NORMAL
	slot = ACCESSORY_SLOT_OVER

	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/mob/clothing/species/teshari/suits.dmi'
		)

/obj/item/clothing/accessory/poncho/equipped(mob/user, slot) //Solution for race-specific sprites for an accessory which is also a suit. Suit icons break if you don't use icon override which then also overrides race-specific sprites.
	..()
	var/mob/living/carbon/human/H = loc
	if(istype(H) && H.wear_suit == src)
		if(H.species.name == SPECIES_TESHARI)
			icon_override = 'icons/mob/clothing/species/teshari/suits.dmi'
		else if(H.species.name == SPECIES_VOX)
			icon_override = 'icons/mob/clothing/species/vox/ties.dmi'
		else
			icon_override = 'icons/mob/clothing/ties.dmi'
		update_clothing_icon()

/obj/item/clothing/accessory/poncho/green
	name = "green poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is green."
	icon_state = "greenponcho"
	item_state = "greenponcho"

/obj/item/clothing/accessory/poncho/red
	name = "red poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is red."
	icon_state = "redponcho"
	item_state = "redponcho"

/obj/item/clothing/accessory/poncho/purple
	name = "purple poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is purple."
	icon_state = "purpleponcho"
	item_state = "purpleponcho"

/obj/item/clothing/accessory/poncho/blue
	name = "blue poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is blue."
	icon_state = "blueponcho"
	item_state = "blueponcho"

/obj/item/clothing/accessory/poncho/roles/security
	name = "security poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is black and red, standard NanoTrasen Security colors."
	icon_state = "secponcho"
	item_state = "secponcho"

/obj/item/clothing/accessory/poncho/roles/medical
	name = "medical poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is white with green and blue tint, standard Medical colors."
	icon_state = "medponcho"
	item_state = "medponcho"

/obj/item/clothing/accessory/poncho/roles/engineering
	name = "engineering poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is yellow and orange, standard Engineering colors."
	icon_state = "engiponcho"
	item_state = "engiponcho"

/obj/item/clothing/accessory/poncho/roles/science
	name = "science poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is white with purple trim, standard NanoTrasen Science colors."
	icon_state = "sciponcho"
	item_state = "sciponcho"

/obj/item/clothing/accessory/poncho/roles/cargo
	name = "cargo poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is tan and grey, the colors of Cargo."
	icon_state = "cargoponcho"
	item_state = "cargoponcho"

//Rough Cloaks
/obj/item/clothing/accessory/poncho/rough_cloak
	name = "rough half cloak"
	desc = "The latest fashion innovations by the Nanotrasen Uniform & Fashion Department have provided the brilliant invention of slicing a regular cloak in half! All the ponce, half the cost!"
	icon_state = "roughcloak"
	item_state = "roughcloak"
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit, /obj/item/gun/energy,
	/obj/item/gun/projectile, /obj/item/ammo_magazine, /obj/item/melee/baton)
	action_button_name = "Adjust Cloak"

/obj/item/clothing/accessory/poncho/rough_cloak/attack_self(mob/user as mob)
	if(src.icon_state == initial(icon_state))
		src.icon_state = "[icon_state]_open"
		src.item_state = "[item_state]_open"
		flags_inv = HIDETIE|HIDEHOLSTER
		to_chat(user, "You flip the cloak over your shoulder.")
	else
		src.icon_state = initial(icon_state)
		src.item_state = initial(item_state)
		flags_inv = HIDEHOLSTER
		to_chat(user, "You pull the cloak over your shoulder.")
	update_clothing_icon()	//so our mob-overlays update

/obj/item/clothing/accessory/poncho/rough_cloak/tan
	icon_state = "roughcloak_tan"
	item_state = "roughcloak_tan"

/*
 * Cloak
 */
/obj/item/clothing/accessory/poncho/roles/cloak
	name = "quartermaster's cloak"
	desc = "An elaborate brown and gold cloak."
	icon_state = "qmcloak"
	item_state = "qmcloak"
	body_parts_covered = null

/obj/item/clothing/accessory/poncho/roles/cloak/ce
	name = "chief engineer's cloak"
	desc = "An elaborate cloak worn by the chief engineer."
	icon_state = "cecloak"
	item_state = "cecloak"

/obj/item/clothing/accessory/poncho/roles/cloak/cmo
	name = "chief medical officer's cloak"
	desc = "An elaborate cloak meant to be worn by the chief medical officer."
	icon_state = "cmocloak"
	item_state = "cmocloak"

/obj/item/clothing/accessory/poncho/roles/cloak/hop
	name = "head of personnel's cloak"
	desc = "An elaborate cloak meant to be worn by the head of personnel."
	icon_state = "hopcloak"
	item_state = "hopcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/rd
	name = "research director's cloak"
	desc = "An elaborate cloak meant to be worn by the research director."
	icon_state = "rdcloak"
	item_state = "rdcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/qm
	name = "quartermaster's cloak"
	desc = "An elaborate cloak meant to be worn by the quartermaster."
	icon_state = "qmcloak"
	item_state = "qmcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/hos
	name = "head of security's cloak"
	desc = "An elaborate cloak meant to be worn by the head of security."
	icon_state = "hoscloak"
	item_state = "hoscloak"

/obj/item/clothing/accessory/poncho/roles/cloak/captain
	name = "Facility Director's cloak"
	desc = "An elaborate cloak meant to be worn by the Facility Director."
	icon_state = "capcloak"
	item_state = "capcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/cargo
	name = "brown cloak"
	desc = "A simple brown and black cloak."
	icon_state = "cargocloak"
	item_state = "cargocloak"

/obj/item/clothing/accessory/poncho/roles/cloak/mining
	name = "trimmed purple cloak"
	desc = "A trimmed purple and brown cloak."
	icon_state = "miningcloak"
	item_state = "miningcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/security
	name = "red cloak"
	desc = "A simple red and black cloak."
	icon_state = "seccloak"
	item_state = "seccloak"

/obj/item/clothing/accessory/poncho/roles/cloak/service
	name = "green cloak"
	desc = "A simple green and blue cloak."
	icon_state = "servicecloak"
	item_state = "servicecloak"

/obj/item/clothing/accessory/poncho/roles/cloak/engineer
	name = "gold cloak"
	desc = "A simple gold and brown cloak."
	icon_state = "engicloak"
	item_state = "engicloak"

/obj/item/clothing/accessory/poncho/roles/cloak/atmos
	name = "yellow cloak"
	desc = "A trimmed yellow and blue cloak."
	icon_state = "atmoscloak"
	item_state = "atmoscloak"

/obj/item/clothing/accessory/poncho/roles/cloak/research
	name = "purple cloak"
	desc = "A simple purple and white cloak."
	icon_state = "scicloak"
	item_state = "scicloak"

/obj/item/clothing/accessory/poncho/roles/cloak/medical
	name = "blue cloak"
	desc = "A simple blue and white cloak."
	icon_state = "medcloak"
	item_state = "medcloak"


/obj/item/clothing/accessory/poncho/roles/cloak/custom //A colorable cloak
	name = "cloak"
	desc = "A simple, bland cloak."
	icon_state = "cloak"
	item_state = "cloak"

/obj/item/clothing/accessory/poncho/roles/cloak/glowing
	name = "glowing cloak"
	desc = "A fancy cloak with a RGB LED color strip along the trim, cycling through the colors of the rainbow."
	icon_state = "cloakglowing"
	item_state = "cloakglowing"

/obj/item/clothing/accessory/poncho/roles/cloak/glowingdark
	name = "dark glowing cloak"
	desc = "A fancy, dark cloak with a RGB LED color strip along the trim, cycling through the colors of the rainbow."
	icon_state = "cloakglowingdark"
	item_state = "cloakglowingdark"

/obj/item/clothing/accessory/hawaii
	name = "flower-pattern shirt"
	desc = "You probably need some welder googles to look at this."
	icon_state = "hawaii"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	slot_flags = SLOT_OCLOTHING | SLOT_TIE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	siemens_coefficient = 0.9
	w_class = ITEMSIZE_NORMAL
	slot = ACCESSORY_SLOT_OVER

/obj/item/clothing/accessory/hawaii/red
	icon_state = "hawaii2"

/obj/item/clothing/accessory/hawaii/random
	name = "flower-pattern shirt"

/obj/item/clothing/accessory/hawaii/random/Initialize(mapload)
	. = ..()
	if(prob(50))
		icon_state = "hawaii2"
	color = color_matrix_rotate_hue(rand(-11,12)*15)

/obj/item/clothing/accessory/wcoat
	name = "waistcoat"
	desc = "For some classy, murderous fun."
	icon_state = "vest"
	item_state = "vest"
	icon_override = 'icons/mob/clothing/ties.dmi'
	item_state_slots = list(slot_r_hand_str = "wcoat", slot_l_hand_str = "wcoat")
	allowed = list(/obj/item/pen, /obj/item/paper, /obj/item/flashlight, /obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes, /obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	slot_flags = SLOT_OCLOTHING | SLOT_TIE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	siemens_coefficient = 0.9
	w_class = ITEMSIZE_NORMAL
	slot = ACCESSORY_SLOT_OVER

/obj/item/clothing/accessory/wcoat/red
	name = "red waistcoat"
	icon_state = "red_waistcoat"
	item_state = "red_waistcoat"

/obj/item/clothing/accessory/wcoat/grey
	name = "grey waistcoat"
	icon_state = "grey_waistcoat"
	item_state = "grey_waistcoat"

/obj/item/clothing/accessory/wcoat/brown
	name = "brown waistcoat"
	icon_state = "brown_waistcoat"
	item_state = "brown_waistcoat"

/obj/item/clothing/accessory/wcoat/gentleman
	name = "elegant waistcoat"
	icon_state = "elegant_waistcoat"
	item_state = "elegant_waistcoat"

/obj/item/clothing/accessory/wcoat/swvest
	name = "black sweatervest"
	desc = "A sleeveless sweater. Wear this if you don't want your arms to be warm, or if you're a nerd."
	icon_state = "sweatervest"
	item_state = "sweatervest"

/obj/item/clothing/accessory/wcoat/swvest/blue
	name = "blue sweatervest"
	icon_state = "sweatervest_blue"
	item_state = "sweatervest_blue"

/obj/item/clothing/accessory/wcoat/swvest/red
	name = "red sweatervest"
	icon_state = "sweatervest_red"
	item_state = "sweatervest_red"

//Button-up Shirts.
/obj/item/clothing/accessory/buttonup
	name = "button up shirt"
	desc = "The standard dress shirt. Simple, versatile, clean."
	icon_state = "button_tucked"
	item_state = "button_tucked"
	icon_override = 'icons/mob/clothing/ties.dmi'
	item_state_slots = list(slot_r_hand_str = "labcoat", slot_l_hand_str = "labcoat")
	allowed = list(/obj/item/pen, /obj/item/paper, /obj/item/flashlight, /obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes, /obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	slot_flags = SLOT_OCLOTHING | SLOT_TIE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	siemens_coefficient = 0.9
	w_class = ITEMSIZE_NORMAL
	slot = ACCESSORY_SLOT_DECOR

/obj/item/clothing/accessory/buttonup/untucked
	name = "button up shirt (untucked)"
	icon_state = "button_untucked"
	item_state = "button_untucked"

//Sweaters.

/obj/item/clothing/accessory/sweater
	name = "sweater"
	desc = "A warm knit sweater."
	icon_override = 'icons/mob/clothing/ties.dmi'
	icon_state = "sweater"
	slot_flags = SLOT_OCLOTHING | SLOT_TIE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	siemens_coefficient = 0.9
	w_class = ITEMSIZE_NORMAL
	slot = ACCESSORY_SLOT_OVER

	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/mob/clothing/species/teshari/ties.dmi'
		)

/obj/item/clothing/accessory/sweater/equipped(mob/user, slot) // Solution for race-specific sprites for an accessory which is also a suit. Suit icons break if you don't use icon override which then also overrides race-specific sprites.
	..()
	var/mob/living/carbon/human/H = loc
	if(istype(H) && H.wear_suit == src)
		if(H.species.name == SPECIES_TESHARI)
			icon_override = 'icons/mob/clothing/species/teshari/ties.dmi'
		else if(H.species.name == SPECIES_VOX)
			icon_override = 'icons/mob/clothing/species/vox/ties.dmi'
		else
			icon_override = 'icons/mob/clothing/ties.dmi'
		update_clothing_icon()

/obj/item/clothing/accessory/sweater/pink
	name = "pink sweater"
	desc = "A warm knit sweater. This one's pink in color."
	icon_state = "sweater_pink"

/obj/item/clothing/accessory/sweater/mint
	name = "mint sweater"
	desc = "A warm knit sweater. This one has a minty tint to it."
	icon_state = "sweater_mint"

/obj/item/clothing/accessory/sweater/blue
	name = "blue sweater"
	desc = "A warm knit sweater. This one's colored in a lighter blue."
	icon_state = "sweater_blue"

/obj/item/clothing/accessory/sweater/heart
	name = "heart sweater"
	desc = "A warm knit sweater. This one's colored in a lighter blue, and has a big pink heart right in the center!"
	icon_state = "sweater_blueheart"

/obj/item/clothing/accessory/sweater/nt
	name = "dark blue sweater"
	desc = "A warm knit sweater. This one's a darker blue."
	icon_state = "sweater_nt"

/obj/item/clothing/accessory/sweater/keyhole
	name = "keyhole sweater"
	desc = "A lavender sweater with an open chest."
	icon_state = "keyholesweater"

/obj/item/clothing/accessory/sweater/blackneck
	name = "black turtleneck"
	desc = "A tight turtleneck, entirely black in coloration."
	icon_state = "turtleneck_black"

/obj/item/clothing/accessory/sweater/winterneck
	name = "Christmas turtleneck"
	desc = "A really cheesy holiday sweater, it actually kinda itches."
	icon_state = "turtleneck_winterred"

/obj/item/clothing/accessory/sweater/uglyxmas
	name = "ugly Christmas sweater"
	desc = "A gift that probably should've stayed in the back of the closet."
	icon_state = "uglyxmas"

/obj/item/clothing/accessory/sweater/flowersweater
	name = "flowery sweater"
	desc =  "An oversized and flowery pink sweater."
	icon_state = "flowersweater"

/obj/item/clothing/accessory/sweater/redneck
	name = "red turtleneck"
	desc = "A comfortable turtleneck in a dark red."
	icon_state = "turtleneck_red"

/obj/item/clothing/accessory/sweater/combat
	name = "green combat sweater"
	desc = "Look like an off duty soldier with this green sweater!"
	icon_state = "combatsweater"

/obj/item/clothing/accessory/sweater/combatblack
	name = "black combat sweater"
	desc = "Look like an off duty soldier with this black sweater!"
	icon_state = "ubacblack"

/obj/item/clothing/accessory/sweater/combatblue
	name = "blue combat sweater"
	desc = "Look like an off duty soldier with this bue sweater!"
	icon_state = "ubacblue"

/obj/item/clothing/accessory/sweater/syndi
	name = "slim fit sweater"
	desc = "A slim fit sweater! It seems robust."
	icon_state = "syndicatesweater"

/obj/item/clothing/accessory/sweater/shoulderless
	name = "Shoulderless Sweater"
	desc = "A plush sweater that doesn't cover the shoulders."
	icon_state = "sweater_shoulderless"

/obj/item/clothing/accessory/sweater/star
	name = "Star Sweater"
	desc = "A white long sweater with a big yellow star at the chest. It seems like it's made of a soft material."
	icon_state = "star_sweater"

/obj/item/clothing/accessory/sweater/virgin
	name = "Virgin Killer Sweater"
	desc = "A white long sweater with a modest string to keep the otherwise immodest front piece from falling off. Compatible with a variety of chest sizes. It seems like it's made of a soft material."
	icon_state = "virgin_sweater"

//***
// End of sweaters
//***

/obj/item/clothing/accessory/cowledvest
	name = "cowled vest"
	desc = "A body warmer for the 26th century."
	icon_state = "cowled_vest"

/obj/item/clothing/accessory/asymmetric
	name = "blue asymmetrical jacket"
	desc = "Insultingly avant-garde in prussian blue."
	icon_state = "asym_blue"

/obj/item/clothing/accessory/asymmetric/purple
	name = "purple asymmetrical jacket"
	desc = "Insultingly avant-garde in mauve."
	icon_state = "asym_purple"

/obj/item/clothing/accessory/asymmetric/green
	name = "green asymmetrical jacket"
	desc = "Insultingly avant-garde in aqua."
	icon_state = "asym_green"

//Antediluvian

/obj/item/clothing/accessory/poncho/antediluvian
	name = "Antediluvian cloak"
	desc = "An off white cloak with a golden lining, held on by a golden clasp. The back of the cloak bears an unfamiliar device, which seems to have served as a significator of social status."
	icon_state = "antediluvian_cloak"
	item_state = "antediluvian_cloak"

/obj/item/clothing/accessory/antediluvian
	name = "Antediluvian loincloth"
	desc = "A narrow black loincloth. Based on its cut and the multitude of connection points, it seems this cloth served a decorative purpose, rather than providing utility."
	icon_state = "antediluvian_loin"
	slot = ACCESSORY_SLOT_DECOR

/obj/item/clothing/accessory/antediluvian_gloves
	name = "Antediluvian bracers"
	desc = "Short metallic bracers worked out of a dark metal and inlaid with gold. They appear to have been ceremonial, as all surviving models offer negligible protection."
	icon_state = "antediluvian"
	//body_parts_covered = HANDS|ARMS

/obj/item/clothing/accessory/mekkyaku
	name = "Mekkyaku turtleneck"
	desc = "A sleek black turtleneck sweater with a bright red stripe knit into the fabric."
	icon_state = "mekkyaku"

/obj/item/clothing/accessory/armsocks
	name = "Stirrup Sleeves"
	desc = "A pair of fingerless, full arm sleeves. Perfect for winter."
	icon_state = "armsock"

/obj/item/clothing/accessory/armsock_left
	name = "Stirrup Sleeve"
	desc = "A single of fingerless, full arm sleeves. Perfect for winter. This one is for the left arm."
	icon_state = "armsock_left"

/obj/item/clothing/accessory/armsock_right
	name = "Stirrup Sleeve"
	desc = "A single of fingerless, full arm sleeves. Perfect for winter. This one is for the right arm."
	icon_state = "armsock_right"
