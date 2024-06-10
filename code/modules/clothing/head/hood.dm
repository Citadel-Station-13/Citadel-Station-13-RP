/obj/item/clothing/head/hood
	name = "hood"
	desc = "A generic hood."
	icon_state = "generic_hood"
	body_cover_flags = HEAD
	cold_protection_cover = HEAD
	inv_hide_flags = HIDEEARS | BLOCKHAIR

// Winter coats
/obj/item/clothing/head/hood/winter
	name = "winter hood"
	desc = "A hood attached to a heavy winter jacket."
	icon_state = "winterhood"
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/head/hood/winter/paramedic
	desc = "A white winter coat hood with blue markings."
	icon_state = "winterhood_paramed"


/obj/item/clothing/head/hood/winter/bar
	desc = "A winter hood that smells faintly of booze."

/obj/item/clothing/head/hood/winter/viro
	desc = "A white winter coat hood with green markings."
	icon_state = "winterhood_viro"

/obj/item/clothing/head/hood/winter/chemistry
	desc = "A white winter coat hood."
	icon_state = "winterhood_chemistry"

/obj/item/clothing/head/hood/winter/cmo
	desc = "A white winter coat hood."
	icon_state = "winterhood_cmo"

/obj/item/clothing/head/hood/winter/medical
	desc = "A white winter coat hood."
	icon_state = "winterhood_medical"

/obj/item/clothing/head/hood/winter/hos
	desc = "A red, armor-padded winter hood, lovingly woven with a Kevlar interleave. Definitely not bulletproof, especially not the part where your face goes."
	icon_state = "winterhood_hos"

/obj/item/clothing/head/hood/winter/security
	desc = "A red, armor-padded winter hood."
	icon_state = "winterhood_security"

/obj/item/clothing/head/hood/winter/hop
	desc = "A cozy winter hood attached to a heavy winter jacket."
	icon_state = "winterhood_hop"

/obj/item/clothing/head/hood/winter/captain
	desc = "A blue and yellow hood attached to a heavy winter jacket."
	icon_state = "winterhood_captain"

/obj/item/clothing/head/hood/winter/centcom
	icon_state = "winterhood_centcom"

/obj/item/clothing/head/hood/winter/science
	desc = "A white winter coat hood. This one will keep your brain warm. About as much as the others, really."
	icon_state = "winterhood_science"

/obj/item/clothing/head/hood/winter/robotics
	desc = "A black winter coat hood. You can pull it down over your eyes and pretend that you're an outdated, late 1980s interpretation of a futuristic mechanized police force. They'll fix you. They fix everything."
	icon_state = "winterhood_robotics"

/obj/item/clothing/head/hood/winter/genetics
	desc = "A white winter coat hood. It's warm."
	icon_state = "winterhood_genetics"

/obj/item/clothing/head/hood/winter/rd
	desc = "A white winter coat hood. It smells faintly of hair gel."
	icon_state = "winterhood_rd"

/obj/item/clothing/head/hood/winter/ce
	desc = "A white winter coat hood. Feels surprisingly heavy. The tag says that it's not child safe."
	icon_state = "winterhood_ce"

/obj/item/clothing/head/hood/winter/engineering
	desc = "A yellow winter coat hood. Definitely not a replacement for a hard hat."
	icon_state = "winterhood_engineer"

/obj/item/clothing/head/hood/winter/engineering/atmos
	desc = "A yellow and blue winter coat hood."
	icon_state = "winterhood_atmos"

/obj/item/clothing/head/hood/winter/hydro
	desc = "A green winter coat hood."
	icon_state = "winterhood_hydro"

/obj/item/clothing/head/hood/winter/cosmic
	desc = "A starry winter hood."
	icon_state = "winterhood_cosmic"

/obj/item/clothing/head/hood/winter/janitor
	desc = "A purple hood that smells of space cleaner."
	icon_state = "winterhood_janitor"

/obj/item/clothing/head/hood/winter/cargo
	desc = "A grey hood for a winter coat."
	icon_state = "winterhood_cargo"
/obj/item/clothing/head/hood/winter/qm
	desc = "A dark brown winter hood"
	icon_state = "winterhood_qm"

/obj/item/clothing/head/hood/winter/aformal
	desc = "A black winter coat hood."
	icon_state = "winterhood_aformal"

/obj/item/clothing/head/hood/winter/miner
	desc = "A dusty winter coat hood."
	icon_state = "winterhood_miner"

/obj/item/clothing/head/hood/winter/ratvar
	icon_state = "winterhood_ratvar"
	desc = "A brass-plated winter hood that glows softly, hinting at its divinity."
	light_range = 3
	light_power = 1
	light_color = "#B18B25" //clockwork slab background top color

/obj/item/clothing/head/hood/winter/narsie
	desc = "A black winter hood full of whispering secrets that only She shall ever know."
	icon_state = "winterhood_narsie"

/obj/item/clothing/head/hood/winter/durathread
	icon_state = "winterhood_durathread"

/obj/item/clothing/head/hood/aureate
	name = "aureate hood"
	desc = "A detached, ornamental hood with gold embellishments. Seems to be made out of insulated fiber."
	icon = 'icons/clothing/head/aureate.dmi'
	icon_state = "aureate_hood"
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

//Hazardous Softsuit Hoods
/obj/item/clothing/head/hood/explorer
	name = "explorer hood"
	desc = "An armoured hood for exploring harsh environments."
	icon_state = "explorer"
	clothing_flags = CLOTHING_THICK_MATERIAL | CLOTHING_INJECTION_PORT
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	armor_type = /datum/armor/exploration/soft

/obj/item/clothing/head/hood/miner
	name = "miner hood"
	desc = "An armoured hood for mining in harsh environments."
	icon = 'icons/clothing/suit/mining.dmi'
	icon_state = "minehood"
	clothing_flags = CLOTHING_THICK_MATERIAL | CLOTHING_INJECTION_PORT
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	armor_type = /datum/armor/cargo/mining/soft

// Eldritch suit
/obj/item/clothing/head/hood/eldritch
	name = "eldritch hood"
	desc = "A baggy hood smeared with some kind of waxy substance. Up close, what appeared to be burlap is revealed to actually be tanned skin."
	icon = 'icons/clothing/suit/antag/heretic.dmi'
	icon_state = "eldritchhood"
	clothing_flags = CLOTHING_THICK_MATERIAL | CLOTHING_INJECTION_PORT
	siemens_coefficient = 0.9
	armor_type = /datum/armor/lavaland/eldritch
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

// Costumes
/obj/item/clothing/head/hood/carp_hood
	name = "carp hood"
	desc = "A hood attached to a carp costume."
	icon_state = "carp_casual"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "carp_casual", SLOT_ID_LEFT_HAND = "carp_casual") //Does not exist -S2-
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE	//Space carp like space, so you should too

/obj/item/clothing/head/hood/ian_hood
	name = "corgi hood"
	desc = "A hood that looks just like a corgi's head, it won't guarantee dog biscuits."
	icon_state = "ian"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "ian", SLOT_ID_LEFT_HAND = "ian") //Does not exist -S2-

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

/obj/item/clothing/head/hood/goliath
	name = "goliath cloak hood"
	icon_state = "golhood"
	desc = "A protective & concealing hood."
	armor_type = /datum/armor/lavaland/goliath
	heat_protection_cover = HEAD
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/head/hood/drake
	name = "drake helm"
	icon_state = "dragon"
	desc = "The skull of a dragon."
	armor_type = /datum/armor/lavaland/drake
	heat_protection_cover = HEAD
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

//Vainglorious

/obj/item/clothing/head/hood/vainglorious
	name = "Vainglorious hood"
	desc = "A hood attached to a Vainglorious hoodie."
	icon_state = "vainglorious"

/obj/item/clothing/head/hood/raincoat
	name = "raincoat hood"
	desc = "A hood attached to a raincoat."
	icon_state = "raincoat"

/obj/item/clothing/head/hood/rainponcho
	name = "plastic raincoat hood"
	desc = "A hood attached to a plastic raincoat."
	icon_state = "rainponcho"

/obj/item/clothing/head/hood/pariah
	name = "Springtime Pariah Moto Jacket hood"
	desc = "The internal cooling system of the jacket can be swapped to fire hot air in cold environments."
	icon_state = "empty_hood"
	inv_hide_flags = NONE

/obj/item/clothing/head/hood/mercy
	name = "Mercy Hood"
	desc = "A comfortable, sterile hood covered in Areaian Silk."
	icon_state = "mercy_hood"

//The Covert/Overt Spec Ops Carrier Hood - This is technically a helmet, but due to how it works I'm putting it here.
/obj/item/clothing/head/hood/covertcarrier
	name = "advanced retractable helmet"
	desc = "A heavily modified NT-DDO standard issue combat helmet. Although this configuration is necessarily not spaceworthy, it retains its counterpart's protections."
	icon = 'icons/obj/clothing/spacesuits.dmi'
	icon_state = "deathsquad"
	armor_type = /datum/armor/station/heavy
	clothing_flags = CLOTHING_THICK_MATERIAL | CLOTHING_INJECTION_PORT
	inv_hide_flags = BLOCKHAIR
	siemens_coefficient = 0.7

/obj/item/clothing/head/hood/covertcarrier/blueshield
	name = "experimental retractable helmet"
	desc = "A modified NT standard issue helmet. It has been designed to retract and collapse in on itself without sacrificing protection."
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "helmet"
	valid_accessory_slots = (ACCESSORY_SLOT_HELM_C)
	restricted_accessory_slots = (ACCESSORY_SLOT_HELM_C)
	clothing_flags = CLOTHING_THICK_MATERIAL | CLOTHING_INJECTION_PORT
	armor_type = /datum/armor/station/medium
	siemens_coefficient = 0.7

/obj/item/clothing/head/hood/covertcarrier/blueshield/navy
	name = "experimental retractable helmet"
	desc = "A modified NT standard issue helmet. It has been designed to retract and collapse in on itself without sacrificing protection."
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "helmet"
	valid_accessory_slots = (ACCESSORY_SLOT_HELM_C)
	restricted_accessory_slots = (ACCESSORY_SLOT_HELM_C)
	clothing_flags = CLOTHING_THICK_MATERIAL | CLOTHING_INJECTION_PORT
	armor_type = /datum/armor/station/medium
	siemens_coefficient = 0.7
	starting_accessories = list(/obj/item/clothing/accessory/armor/helmcover/navy)
