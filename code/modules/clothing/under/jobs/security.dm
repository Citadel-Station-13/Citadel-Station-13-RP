/*
 * Contains:
 *		Security
 *		Detective
 *		Head of Security
 */

/*
 * Security
 */
/obj/item/clothing/under/rank/warden
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for more robust protection. It has the word \"Warden\" written on the shoulders."
	name = "warden's jumpsuit"
	icon_state = "warden"
	item_state_slots = list(slot_r_hand_str = "red", slot_l_hand_str = "red")
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	rolled_sleeves = 0

/obj/item/clothing/under/rank/warden_fem
	name = "warden's jumpsuit"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for more robust protection. It has the word \"Warden\" written on the shoulders."
	icon_state = "warden_fem"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/under/rank/warden/skirt_pleated
	name = "warden's pleated skirt"
	desc = "A pleated skirt made up of a slightly sturdier material than your average jumpsuit. It has the word 'Warden' writton on the shoulders."
	icon_state = "rwarden_skirt"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/under/rank/security
	name = "security officer's jumpsuit"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for robust protection."
	icon_state = "security"
	item_state_slots = list(slot_r_hand_str = "red", slot_l_hand_str = "red")
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	rolled_sleeves = 0

/obj/item/clothing/under/rank/security_fem
	name = "security officer's jumpsuit"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for robust protection."
	icon_state = "security_fem"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/under/rank/security/skirt_pleated
	name = "security officer's pleated skirt"
	desc = "A pleated skirt made up of a slightly sturdier material than most jumpsuits, allowing more robust protection."
	icon_state = "sec_skirt"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/under/rank/security/turtleneck
	name = "security turtleneck"
	desc = "It's a stylish turtleneck made of a robust nanoweave. Nobody said the Law couldn't be fashionable."
	icon_state = "turtle_sec"
	rolled_down = -1
	rolled_sleeves = -1

/obj/item/clothing/under/rank/security/turtleneck_fem
	name = "security turtleneck"
	desc = "It's a stylish turtleneckf made of a robust nanoweave. Nobody said the Law couldn't be fashionable."
	icon_state = "turtle_sec_fem"

/obj/item/clothing/under/rank/dispatch
	name = "dispatcher's uniform"
	desc = "A dress shirt and khakis with a security patch sewn on."
	icon_state = "dispatch"
	item_state_slots = list(slot_r_hand_str = "detective", slot_l_hand_str = "detective")
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS
	siemens_coefficient = 0.9

/obj/item/clothing/under/rank/security2
	name = "security officer's uniform"
	desc = "It's made of a slightly sturdier material, to allow for robust protection."
	icon_state = "redshirt2"
	item_state_slots = list(slot_r_hand_str = "red", slot_l_hand_str = "red")
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	rolled_sleeves = 0

/obj/item/clothing/under/rank/security2_fem
	name = "security officer's uniform"
	desc = "It's made of a slightly sturdier material, to allow for robust protection."
	icon_state = "redshirt2_fem"

/obj/item/clothing/under/rank/security/corp
	icon_state = "sec_corporate"
	name = "security officer's corporate uniform"
	desc = "A corporate standard uniform made of a slightly sturdier material, to allow for robust protection."
	item_state_slots = list(slot_r_hand_str = "black", slot_l_hand_str = "black")
	rolled_sleeves = 0

/obj/item/clothing/under/rank/security/corp_fem
	name = "security officer's corporate uniform"
	desc = "A corporate standard uniform made of a slightly sturdier material, to allow for robust protection."
	icon_state = "sec_corporate_fem"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/under/rank/warden/corp
	icon_state = "warden_corporate"
	name = "warden's corporate uniform"
	desc = "A corporate standard uniform made of a slightly sturdier material, to allow for robust protection. It has the word \"Warden\" on the shoulders."
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	item_state_slots = list(slot_r_hand_str = "black", slot_l_hand_str = "black")
	rolled_sleeves = 0

/obj/item/clothing/under/rank/warden/corp_fem
	name = "warden's corporate uniform"
	desc = "A corporate standard uniform made of a slightly sturdier material, to allow for robust protection. It has the word \"Warden\" on the shoulders."
	icon_state = "warden_corporate_fem"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/under/tactical
	name = "tactical jumpsuit"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for robust protection."
	icon_state = "swatunder"
	item_state_slots = list(slot_r_hand_str = "green", slot_l_hand_str = "green")
	armor = list(melee = 10, bullet = 5, laser = 5,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	rolled_sleeves = -1

/*
 * Detective
 */
/obj/item/clothing/under/det
	name = "detective's suit"
	desc = "A rumpled white dress shirt paired with well-worn grey slacks."
	icon_state = "detective"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	rolled_sleeves = 0
	starting_accessories = list(/obj/item/clothing/accessory/tie/blue_clip)

/obj/item/clothing/under/det_fem
	name = "detective's suit"
	desc = "A rumpled white dress shirt paired with well-worn grey slacks."
	icon_state = "detective_fem"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

/*
/obj/item/clothing/under/det/verb/rollup()
	set name = "Roll Suit Sleeves"
	set category = "Object"
	set src in usr
	var/unrolled = item_state_slots[/datum/inventory_slot_meta/inventory/uniform] == initial(worn_state)
	item_state_slots[/datum/inventory_slot_meta/inventory/uniform] = unrolled ? "[worn_state]_r" : initial(worn_state)
	var/mob/living/carbon/human/H = loc
	H.update_inv_w_uniform(1)
	to_chat(H, "<span class='notice'>You roll the sleeves of your shirt [unrolled ? "up" : "down"]</span>")
*/
/obj/item/clothing/under/det/grey
	name = "detective's tan suit"
	icon_state = "detective2"
	desc = "A serious-looking tan dress shirt paired with freshly-pressed black slacks."
	starting_accessories = list(/obj/item/clothing/accessory/tie/red_long)

/obj/item/clothing/under/det/grey_fem
	name = "detective's tan suit"
	desc = "A serious-looking tan dress shirt paired with freshly-pressed black slacks."
	icon_state = "detective2_fem"
	starting_accessories = list(/obj/item/clothing/accessory/tie/red_long)

/obj/item/clothing/under/det/grey/skirt_pleated
	name = "detective's grey pleated skirt"
	desc = "A sertous-looking pleated skirt paired with a freshly-pressed white shirt and a gold-clipped tie."
	icon_state = "greydet_skirt"

/obj/item/clothing/under/det/black
	name = "detective's spiffy suit"
	icon_state = "detective3"
	item_state_slots = list(slot_r_hand_str = "sl_suit", slot_l_hand_str = "sl_suit")
	desc = "An immaculate white dress shirt, paired with a pair of dark grey dress pants, a red tie, and a charcoal vest."
	starting_accessories = list(/obj/item/clothing/accessory/tie/red_long, /obj/item/clothing/accessory/vest)

/obj/item/clothing/under/det/black_fem
	name = "detective's spiffy suit"
	desc = "An immaculate white dress shirt, paired with a pair of dark grey dress pants, a red tie, and a charcoal vest."
	icon_state = "detective3_fem"
	starting_accessories = list(/obj/item/clothing/accessory/tie/red_long, /obj/item/clothing/accessory/vest)

/obj/item/clothing/under/det/corporate
	name = "detective's corporate jumpsuit"
	icon_state = "det_corporate"
	item_state_slots = list(slot_r_hand_str = "black", slot_l_hand_str = "black")
	desc = "A more modern uniform for corporate investigators."

/obj/item/clothing/under/det/corporate_fem
	name = "detective's corporate jumpsuit"
	desc = "A more modern uniform for coroprate investigators."
	icon_state = "det_corporate_fem"

/obj/item/clothing/under/det/waistcoat
	icon_state = "detective"
	name = "detective's semi-tidy suit"
	desc = "A rumpled white dress shirt paired with well-worn grey slacks, complete with a blue striped tie, faux-gold tie clip, and waistcoat."
	starting_accessories = list(/obj/item/clothing/accessory/tie/blue_clip, /obj/item/clothing/accessory/wcoat)

/obj/item/clothing/under/det/waistcoat_fem
	name = "detective's semi-tidy suit"
	desc = "A rumpled white dress shirt paired with well-worn grey slacks, complete with a blue striped tie, faux-gold tie clip, and waistcoat."
	icon_state = "detective_fem"
	starting_accessories = list(/obj/item/clothing/accessory/tie/blue_clip, /obj/item/clothing/accessory/wcoat)

/obj/item/clothing/under/det/grey/waistcoat
	icon_state = "detective2"
	name = "detective's serious suit"
	desc = "A serious-looking tan dress shirt paired with freshly-pressed black slacks, complete with a red striped tie and waistcoat."
	starting_accessories = list(/obj/item/clothing/accessory/tie/red_long, /obj/item/clothing/accessory/wcoat)

/obj/item/clothing/under/det/grey/waistcoat_fem
	name = "detective's serious suit"
	desc = "A serious-looking tan dress shirt paired with freshly-pressed black slacks, complete with a red striped tie and waistcoat."
	icon_state = "detective2_fem"
	starting_accessories = list(/obj/item/clothing/accessory/tie/red_long, /obj/item/clothing/accessory/wcoat)

/obj/item/clothing/under/det/skirt
	name = "detective's skirt"
	icon_state = "detective_skirt"
	desc = "A serious-looking white blouse paired with a formal black pencil skirt."
	item_state_slots = list(slot_r_hand_str = "sl_suit", slot_l_hand_str = "sl_suit")

/*
 * Head of Security
 */
/obj/item/clothing/under/rank/head_of_security
	desc = "It's a jumpsuit worn by those few with the dedication to achieve the position of \"Head of Security\". It has additional armor to protect the wearer."
	name = "head of security's jumpsuit"
	icon_state = "hos"
	item_state_slots = list(slot_r_hand_str = "red", slot_l_hand_str = "red")
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	rolled_sleeves = 0

/obj/item/clothing/under/rank/head_of_security_fem
	name = "head of security's jumpsuit"
	desc = "It's a jumpsuit worn by those few with the dedication to achieve the position of \"Head of Security\". It has additional armour to protect the wearer."
	icon_state = "hos_fem"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/under/rank/head_of_security/skirt_pleated
	name = "head of security's pleated skirt"
	desc = "A pleated skirt worn by those few with the dedication to achieve the position of 'Head of Security'. It bears additional armour to protect the wearer."
	icon_state = "rhos_skirt"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/under/rank/head_of_security/skirt_pleated/alt
	name = "dark head of security's pleated skirt"
	desc = "A pleated skirt worn by those few with the dedication to achieve the position of 'Head of Security'. It bears additional armour to protect the wearer."
	icon_state = "hosalt_skirt"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/under/rank/head_of_security/corp
	name = "head of security's corporate jumpsuit"
	desc = "A clean jumpsuit to corporate standard, worn by those few with the dedication to achieve the position of \"Head of Security\"."
	icon_state = "hos_corporate"
	item_state_slots = list(slot_r_hand_str = "black", slot_l_hand_str = "black")
	rolled_sleeves = 0

/obj/item/clothing/under/rank/head_of_security/corp_fem
	name = "head of security's corporate jumpsuit"
	desc = "A clean jumpsuit to corporate standard, worn by those few with the dedication to achieve the position of \"Head of Security\""
	icon_state = "hos_corporate_fem"

/obj/item/clothing/under/rank/head_of_security/turtleneck
	name = "head of security's turtleneck"
	desc = "A stylish alternative to the normal head of security jumpsuit, complete with tactical pants."
	icon_state = "hosturtle"
	item_state_slots = list(slot_r_hand_str = "black", slot_l_hand_str = "black")
	rolled_sleeves = 0

//Jensen cosplay gear
/obj/item/clothing/under/rank/head_of_security/jensen
	desc = "You never asked for anything that stylish."
	name = "head of security's jumpsuit"
	icon_state = "jensen"
	rolled_sleeves = -1

/*
 * Navy uniforms
 */
/obj/item/clothing/under/rank/security/navyblue
	name = "security officer's uniform"
	desc = "The latest in fashionable security outfits."
	icon_state = "officerblueclothes"
	item_state_slots = list(slot_r_hand_str = "ba_suit", slot_l_hand_str = "ba_suit")
	rolled_sleeves = 0

/obj/item/clothing/under/rank/security/navyblue_fem
	name = "security officer's uniform"
	desc = "The latest in fashionable security outfits."
	icon_state = "officerblueclothes_fem"

/obj/item/clothing/under/rank/head_of_security/navyblue
	desc = "The insignia on this uniform tells you that this uniform belongs to the Head of Security."
	name = "head of security's uniform"
	icon_state = "hosblueclothes"
	item_state_slots = list(slot_r_hand_str = "ba_suit", slot_l_hand_str = "ba_suit")
	rolled_sleeves = 0

/obj/item/clothing/under/rank/head_of_security/navyblue_fem
	name = "head of security's uniform"
	desc = "The insignia on this uniform tells you that this uniform belongs to the Head of Security."
	icon_state = "hosblueclothes_fem"

/obj/item/clothing/under/rank/warden/navyblue
	desc = "The insignia on this uniform tells you that this uniform belongs to the Warden."
	name = "warden's uniform"
	icon_state = "wardenblueclothes"
	item_state_slots = list(slot_r_hand_str = "ba_suit", slot_l_hand_str = "ba_suit")
	rolled_sleeves = 0

/obj/item/clothing/under/rank/warden/navyblue_fem
	name = "warden's uniform"
	desc = "The insignia on this uniform tells you that this uniform belongs to the Warden."
	icon_state = "wardenblueclothes_fem"
