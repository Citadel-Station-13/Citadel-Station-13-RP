/obj/item/clothing/head/hood
	name = "hood"
	desc = "A generic hood."
	icon_state = "generic_hood"
	body_parts_covered = HEAD
	cold_protection = HEAD
	flags_inv = HIDEEARS | BLOCKHAIR

// Winter coats
/obj/item/clothing/head/hood/winter
	name = "winter hood"
	desc = "A hood attached to a heavy winter jacket."
	icon_state = "winterhood"
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/head/hooded/winterhood/paramedic
	desc = "A white winter coat hood with blue markings."
	icon_state = "winterhood_paramed"

/obj/item/clothing/head/hooded/winterhood/viro
	desc = "A white winter coat hood with green markings."
	icon_state = "winterhood_viro"

/obj/item/clothing/head/hooded/winterhood/chemistry
	desc = "A white winter coat hood."
	icon_state = "winterhood_chemistry"

/obj/item/clothing/head/hooded/winterhood/cmo
	desc = "A white winter coat hood."
	icon_state = "winterhood_cmo"

/obj/item/clothing/head/hooded/winterhood/medical
	desc = "A white winter coat hood."
	icon_state = "winterhood_medical"

/obj/item/clothing/head/hooded/winterhood/hos
	desc = "A red, armor-padded winter hood, lovingly woven with a Kevlar interleave. Definitely not bulletproof, especially not the part where your face goes."
	icon_state = "winterhood_hos"

/obj/item/clothing/head/hooded/winterhood/security
	desc = "A red, armor-padded winter hood."
	icon_state = "winterhood_security"

/obj/item/clothing/head/hooded/winterhood/hop
	desc = "A cozy winter hood attached to a heavy winter jacket."
	icon_state = "winterhood_hop"

/obj/item/clothing/head/hooded/winterhood/captain
	desc = "A blue and yellow hood attached to a heavy winter jacket."
	icon_state = "winterhood_captain"

/obj/item/clothing/head/hooded/winterhood/centcom
	icon_state = "winterhood_centcom"

/obj/item/clothing/head/hooded/winterhood/science
	desc = "A white winter coat hood. This one will keep your brain warm. About as much as the others, really."
	icon_state = "winterhood_science"

/obj/item/clothing/head/hooded/winterhood/robotics
	desc = "A black winter coat hood. You can pull it down over your eyes and pretend that you're an outdated, late 1980s interpretation of a futuristic mechanized police force. They'll fix you. They fix everything."
	icon_state = "winterhood_robotics"

/obj/item/clothing/head/hooded/winterhood/genetics
	desc = "A white winter coat hood. It's warm."
	icon_state = "winterhood_genetics"

/obj/item/clothing/head/hooded/winterhood/rd
	desc = "A white winter coat hood. It smells faintly of hair gel."
	icon_state = "winterhood_rd"

/obj/item/clothing/head/hooded/winterhood/ce
	desc = "A white winter coat hood. Feels surprisingly heavy. The tag says that it's not child safe."
	icon_state = "winterhood_ce"

/obj/item/clothing/head/hooded/winterhood/engineering
	desc = "A yellow winter coat hood. Definitely not a replacement for a hard hat."
	icon_state = "winterhood_engineer"

/obj/item/clothing/head/hooded/winterhood/engineering/atmos
	desc = "A yellow and blue winter coat hood."
	icon_state = "winterhood_atmos"

/obj/item/clothing/head/hooded/winterhood/hydro
	desc = "A green winter coat hood."
	icon_state = "winterhood_hydro"

/obj/item/clothing/head/hooded/winterhood/cosmic
	desc = "A starry winter hood."
	icon_state = "winterhood_cosmic"

/obj/item/clothing/head/hooded/winterhood/janitor
	desc = "A purple hood that smells of space cleaner."
	icon_state = "winterhood_janitor"

/obj/item/clothing/head/hooded/winterhood/cargo
	desc = "A grey hood for a winter coat."
	icon_state = "winterhood_cargo"
/obj/item/clothing/head/hooded/winterhood/qm
	desc = "A dark brown winter hood"
	icon_state = "winterhood_qm"

/obj/item/clothing/head/hooded/winterhood/aformal
	desc = "A black winter coat hood."
	icon_state = "winterhood_aformal"

/obj/item/clothing/head/hooded/winterhood/miner
	desc = "A dusty winter coat hood."
	icon_state = "winterhood_miner"

/obj/item/clothing/head/hooded/winterhood/ratvar
	icon_state = "winterhood_ratvar"
	desc = "A brass-plated winter hood that glows softly, hinting at its divinity."
	light_range = 3
	light_power = 1
	light_color = "#B18B25" //clockwork slab background top color

/obj/item/clothing/head/hooded/winterhood/narsie
	desc = "A black winter hood full of whispering secrets that only She shall ever know."
	icon_state = "winterhood_narsie"

/obj/item/clothing/head/hooded/winterhood/durathread
	icon_state = "winterhood_durathread"

// Explorer gear
/obj/item/clothing/head/hood/explorer
	name = "explorer hood"
	desc = "An armoured hood for exploring harsh environments."
	icon_state = "explorer"
	flags = THICKMATERIAL
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	armor = list(melee = 30, bullet = 20, laser = 20, energy = 20, bomb = 35, bio = 75, rad = 35)

// Eldritch suit
/obj/item/clothing/head/hood/eldritch
	name = "eldritch hood"
	desc = "A baggy hood smeared with some kind of waxy substance. Up close, what appeared to be burlap is revealed to actually be tanned skin."
	icon_state = "eldritch"
	flags = THICKMATERIAL
	siemens_coefficient = 0.9
	armor = list(melee = 20, bullet = 0, laser = 40, energy = 40, bomb = 20, bio = 30, rad = 20)

// Costumes
/obj/item/clothing/head/hood/carp_hood
	name = "carp hood"
	desc = "A hood attached to a carp costume."
	icon_state = "carp_casual"
	item_state_slots = list(slot_r_hand_str = "carp_casual", slot_l_hand_str = "carp_casual") //Does not exist -S2-
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE	//Space carp like space, so you should too

/obj/item/clothing/head/hood/ian_hood
	name = "corgi hood"
	desc = "A hood that looks just like a corgi's head, it won't guarantee dog biscuits."
	icon_state = "ian"
	item_state_slots = list(slot_r_hand_str = "ian", slot_l_hand_str = "ian") //Does not exist -S2-

/obj/item/clothing/head/hood/bee_hood
	name = "bee hood"
	desc = "A hood that looks just like a bee's."
	icon_state = "bee"

/obj/item/clothing/head/hood/flash_hood
	name = "flash top"
	desc = "A plastic dome that resembles the button on a flash."
	icon_state = "flashsuit"

/obj/item/clothing/head/hood/techpriest
	name = "tech priest hood"
	icon_state = "techpriesth"

