/obj/item/clothing/mask/gas
	name = "gas mask"
	desc = "A face-covering mask that can be connected to an air supply. Filters harmful gases from the air."
	icon_state = "gas_alt"
	item_flags = BLOCK_GAS_SMOKE_EFFECT | AIRTIGHT | ALLOW_SURVIVALFOOD
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE
	body_parts_covered = FACE|EYES
	w_class = ITEMSIZE_NORMAL
	item_state_slots = list(slot_r_hand_str = "gas_alt", slot_l_hand_str = "gas_alt")
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	siemens_coefficient = 0.9
	var/gas_filter_strength = 1			//For gas mask filters
	var/list/filtered_gases = list(/datum/gas/phoron, /datum/gas/nitrous_oxide)
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 75, rad = 0)

/obj/item/clothing/mask/gas/filter_air(datum/gas_mixture/air)
	var/datum/gas_mixture/gas_filtered = new

	for(var/g in filtered_gases)
		if(air.gas[g])
			gas_filtered.gas[g] = air.gas[g] * gas_filter_strength
			air.gas[g] -= gas_filtered.gas[g]

	air.update_values()
	gas_filtered.update_values()

	return gas_filtered

// Our clear gas masks don't hide faces, but changing the var on mask/gas would require un-chaging it on all children. This is nicer.
/obj/item/clothing/mask/gas/New()
	if(type == /obj/item/clothing/mask/gas)
		flags_inv &= ~HIDEFACE
	..()

/obj/item/clothing/mask/gas/clear
	name = "gas mask"
	desc = "A face-covering mask with a transparent faceplate that can be connected to an air supply."
	icon_state = "gas_clear"
	flags_inv = null

/obj/item/clothing/mask/gas/half
	name = "face mask"
	desc = "A compact, durable gas mask that can be connected to an air supply."
	icon_state = "halfgas"
	siemens_coefficient = 0.7
	body_parts_covered = FACE
	w_class = ITEMSIZE_SMALL
	armor = list(melee = 10, bullet = 10, laser = 10, energy = 0, bomb = 0, bio = 55, rad = 0)
	var/hanging = FALSE
	flags_inv = HIDEFACE
	action_button_name = "Adjust Face Mask"

/obj/item/clothing/mask/gas/half/proc/adjust_mask(mob/user)
	if(usr.canmove && !usr.stat)
		src.hanging = !src.hanging
		if (src.hanging)
			gas_transfer_coefficient = 1
			gas_filter_strength = 0
			body_parts_covered = body_parts_covered & ~FACE
			item_flags = item_flags & ~BLOCK_GAS_SMOKE_EFFECT & ~AIRTIGHT
			flags_inv = 0
			armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
			icon_state = "halfgas_up"
			to_chat(usr, "Your mask is now hanging on your neck.")
		else
			gas_transfer_coefficient = initial(gas_transfer_coefficient)
			gas_filter_strength = initial(gas_filter_strength)
			body_parts_covered = initial(body_parts_covered)
			item_flags = initial(item_flags)
			flags_inv = initial(flags_inv)
			armor = initial(armor)
			icon_state = initial(icon_state)
			to_chat(usr, "You pull the mask up to cover your face.")
		update_clothing_icon()

/obj/item/clothing/mask/gas/half/verb/toggle()
	set category = "Object"
	set name = "Adjust mask"
	set src in usr
	adjust_mask(usr)

/obj/item/clothing/mask/gas/half/attack_self(mob/user)
	adjust_mask(user)

//Plague Dr suit can be found in clothing/suits/bio.dm
/obj/item/clothing/mask/gas/plaguedoctor
	name = "plague doctor mask"
	desc = "A modernised version of the classic design, this mask will not only filter out phoron but it can also be connected to an air supply."
	icon_state = "plaguedoctor"
	item_state_slots = list(slot_r_hand_str = "gas", slot_l_hand_str = "gas")
	armor = list(melee = 0, bullet = 0, laser = 2,energy = 2, bomb = 0, bio = 90, rad = 0)
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/gas/swat
	name = "\improper SWAT mask"
	desc = "A close-fitting tactical mask that can be connected to an air supply."
	icon_state = "swat"
	siemens_coefficient = 0.7
	body_parts_covered = FACE|EYES

// Vox mask, has special code for eating
/obj/item/clothing/mask/gas/swat/vox
	name = "\improper alien mask"
	desc = "Clearly not designed for a human face."
	flags = PHORONGUARD
	item_flags = BLOCK_GAS_SMOKE_EFFECT | AIRTIGHT
	species_restricted = list(SPECIES_VOX)
	filtered_gases = list(/datum/gas/oxygen, /datum/gas/nitrous_oxide)
	var/mask_open = FALSE	// Controls if the Vox can eat through this mask
	action_button_name = "Toggle Feeding Port"

/obj/item/clothing/mask/gas/swat/vox/proc/feeding_port(mob/user)
	if(user.canmove && !user.stat)
		mask_open = !mask_open
		if(mask_open)
			body_parts_covered = EYES
			to_chat(user, "Your mask moves to allow you to eat.")
		else
			body_parts_covered = FACE|EYES
			to_chat(user, "Your mask moves to cover your mouth.")
	return

/obj/item/clothing/mask/gas/swat/vox/attack_self(mob/user)
	feeding_port(user)
	..()

/obj/item/clothing/mask/gas/zaddat
	name = "Zaddat Veil"
	desc = "A clear survival mask used by the Zaddat to filter out harmful nitrogen. Can be connected to an air supply and reconfigured to allow for safe eating."
	icon_state = "zaddat_mask"
	item_state = "vax_mask"
	//body_parts_covered = 0
	species_restricted = list(SPECIES_ZADDAT)
	flags_inv = HIDEEARS //semi-transparent
	filtered_gases = list(/datum/gas/phoron, /datum/gas/nitrous_oxide, /datum/gas/nitrogen)

/obj/item/clothing/mask/gas/syndicate
	name = "tactical mask"
	desc = "A close-fitting tactical mask that can be connected to an air supply."
	icon_state = "swat"
	siemens_coefficient = 0.7

/obj/item/clothing/mask/gas/explorer
	name = "explorer gas mask"
	desc = "A military-grade gas mask that can be connected to an air supply."
	icon_state = "explorer"
	item_state_slots = list(slot_r_hand_str = "gas", slot_l_hand_str = "gas")
	armor = list(melee = 10, bullet = 5, laser = 5,energy = 5, bomb = 0, bio = 50, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/mask/gas/commando
	name = "commando mask"
	icon_state = "fullgas"
	item_state_slots = list(slot_r_hand_str = "swat", slot_l_hand_str = "swat")
	siemens_coefficient = 0.2

/obj/item/clothing/mask/gas/cyborg
	name = "cyborg visor"
	desc = "Beep boop"
	icon_state = "death"

/obj/item/clothing/mask/gas/old
	icon_state = "gas_mask"

/obj/item/clothing/mask/gas/imperial
	name = "imperial soldier facemask"
	desc = "A close-fitting tactical mask that can be connected to an air supply."
	icon_state = "ge_visor"

//Costume Gas Masks
/obj/item/clothing/mask/gas/clown_hat
	name = "clown wig and mask"
	desc = "A true prankster's facial attire. A clown is incomplete without their wig and mask."
	icon_state = "clown"
	item_state_slots = list(slot_r_hand_str = "clown_hat", slot_l_hand_str = "clown_hat")

/obj/item/clothing/mask/gas/sexyclown
	name = "sexy-clown wig and mask"
	desc = "A feminine clown mask for the dabbling crossdressers or female entertainers."
	icon_state = "sexyclown"
	item_state_slots = list(slot_r_hand_str = "clown_hat", slot_l_hand_str = "clown_hat")

/obj/item/clothing/mask/gas/mime
	name = "mime mask"
	desc = "The traditional mime's mask. It has an eerie facial posture."
	icon_state = "mime"
	item_state_slots = list(slot_r_hand_str = "mime", slot_l_hand_str = "mime")

/obj/item/clothing/mask/gas/sexymime
	name = "sexy mime mask"
	desc = "A traditional female mime's mask."
	icon_state = "sexymime"
	item_state_slots = list(slot_r_hand_str = "mime", slot_l_hand_str = "mime")

/obj/item/clothing/mask/gas/guy
	name = "guy fawkes mask"
	desc = "A mask stylised to depict Guy Fawkes."
	icon_state = "guyfawkes"
	flags_inv = HIDEEARS|HIDEFACE
	item_state_slots = list(slot_r_hand_str = "mime", slot_l_hand_str = "mime")

/obj/item/clothing/mask/gas/goblin
	name = "goblin mask"
	desc = "A professionally crafted goblin mask. Do you crave fast food?"
	icon_state = "goblin"
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/gas/demon
	name = "demon mask"
	desc = "A professionally crafted demon mask. Its retro daemonic style is always trendy."
	icon_state = "demon"
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/gas/monkeymask
	name = "monkey mask"
	desc = "A mask used when acting as a monkey."
	icon_state = "monkeymask"
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/gas/owl_mask
	name = "owl mask"
	desc = "Twoooo!"
	icon_state = "owl"
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/gas/pig
	name = "pig mask"
	desc = "A professionally crafted pig mask. For the ballistics connoisseur."
	icon_state = "pig"
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/gas/shark
	name = "shark mask"
	desc = "A professionally crafted shark mask. You can smell blood from a mile away."
	icon_state = "shark"
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/gas/dolphin
	name = "dolphin mask"
	desc = "A professionally crafted dolphin mask. Can you balance balls on your nose?"
	icon_state = "dolphin"
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/gas/horsehead
	name = "horse head mask"
	desc = "A mask made of soft vinyl and latex, representing the head of a horse."
	icon_state = "horsehead"
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/gas/frog
	name = "frog mask"
	desc = "A professionally crafted frog mask. Take your time."
	icon_state = "frog"
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/gas/rat
	name = "rat mask"
	desc = "A professionally crafted rat mask. Shhh."
	icon_state = "rat"
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/gas/fox
	name = "fox mask"
	desc = "A professionally crafted fox mask. Waiting for the perfect shot."
	icon_state = "fox"
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/gas/bee
	name = "bee mask"
	desc = "A professionally crafted bee mask. Even a drone can fly away."
	icon_state = "bee"
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/gas/bear
	name = "bear mask"
	desc = "A professionally crafted bear mask. For those who believe in the right to bear arms."
	icon_state = "bear"
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/gas/bat
	name = "bat mask"
	desc = "A professionally crafted bat mask. We just love hanging around."
	icon_state = "bat"
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/gas/raven
	name = "raven mask"
	desc = "A professionally crafted raven mask. Nevermore."
	icon_state = "raven"
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/gas/jackal
	name = "jackal mask"
	desc = "A professionally crafted jackal mask. A favorite of the Pharaoh."
	icon_state = "jackal"
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/gas/bumba
	name = "smug tribal mask"
	desc = "A hand carved wooden mask representing a now forgotten god who chose speed over strength."
	icon_state = "bumba"
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/gas/joy
	name = "joyful mask"
	desc = "A hard plastic mask designed after a popular emoticon. You can't tell if it's ironic or not."
	icon_state = ""
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/gas/scarecrow
	name = "scarecrow mask"
	desc = "A ominous gas mask covered in ragged burlap. Use it to hide from your fears."
	icon_state = "scarecrow_sack"
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/gas/mummy
	name = "mummy head wraps"
	desc = "A musty strip of ancient cloth wraps. How can you stand the smell?"
	icon_state = "mummy_mask"
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/gas/skeleton
	name = "skeleton mask"
	desc = "A crude plastic skull mask that is somehow still airtight."
	icon_state = "death"
