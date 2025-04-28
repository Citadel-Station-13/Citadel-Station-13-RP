/*
*	Mens Suits, Women Suits, Skeleton Suits
*/

/obj/item/clothing/under/scratch
	name = "white suit"
	desc = "A white suit, suitable for an excellent host"
	icon = 'icons/clothing/uniform/formal/suits/scratch.dmi'
	icon_state = "scratch"

/obj/item/clothing/under/scratch/skirt
	name = "white skirt suit"
	icon = 'icons/clothing/uniform/formal/suits/scratch_skirt.dmi'
	icon_state = "scratch_skirt"

/obj/item/clothing/under/sl_suit
	desc = "It's a very amish looking suit."
	name = "amish suit"
	icon = 'icons/clothing/uniform/formal/suits/sl_suit.dmi'
	icon_state = "sl_suit"

/obj/item/clothing/under/gentlesuit
	name = "gentlemans suit"
	desc = "A silk black shirt with matching gray slacks. Feels proper."
	icon = 'icons/clothing/uniform/formal/suits/gentlesuit.dmi'
	icon_state = "gentlesuit"
	starting_accessories = list(/obj/item/clothing/accessory/tie/white, /obj/item/clothing/accessory/wcoat/gentleman)

/obj/item/clothing/under/gentlesuit/skirt
	name = "lady's suit"
	desc = "A silk black blouse with a matching gray skirt. Feels proper."
	icon = 'icons/clothing/uniform/formal/suits/gentlesuit_skirt.dmi'
	icon_state = "gentlesuit_skirt"

/obj/item/clothing/under/suit_jacket
	name = "black suit"
	desc = "A black suit and red tie. Very formal."
	icon = 'icons/clothing/uniform/formal/suits/black_suit.dmi'
	icon_state = "black_suit"

/obj/item/clothing/under/suit_jacket/really_black
	name = "executive suit"
	desc = "A formal black suit and red tie, intended for the station's finest."
	icon = 'icons/clothing/uniform/formal/suits/really_black_suit.dmi'
	icon_state = "really_black_suit"

/obj/item/clothing/under/suit_jacket/really_black/skirt
	name = "executive skirt suit"
	desc = "A formal black suit and red necktie, intended for the station's finest."
	icon = 'icons/clothing/uniform/formal/suits/really_black_suit_skirt.dmi'
	icon_state = "really_black_suit_skirt"

/obj/item/clothing/under/suit_jacket/female
	name = "female executive suit"
	desc = "A formal trouser suit for women, intended for the station's finest."
	icon_state = "black_suit_fem"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "lawyer_black", SLOT_ID_LEFT_HAND = "lawyer_black")

/obj/item/clothing/under/suit_jacket/female/skirt
	name = "executive skirt"
	desc = "A formal suit skirt  for women, intended for the station's finest."
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS
	icon_state = "black_suit_fem"
	item_state = "black_formal_skirt"

/obj/item/clothing/under/suit_jacket/female/pleated_skirt
	name = "executive pleated skirt"
	icon_state = "black_suit_fem_skirt"

/obj/item/clothing/under/suit_jacket/red
	name = "red suit"
	desc = "A red suit and blue tie. Somewhat formal."
	icon_state = "red_suit"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "lawyer_red", SLOT_ID_LEFT_HAND = "lawyer_red")

/obj/item/clothing/under/suit_jacket/red/skirt
	name = "red skirt suit"
	desc = "A red suit and blue necktie. Somewhat formal."
	icon_state = "red_suit_skirt"

/obj/item/clothing/under/suit_jacket/charcoal
	name = "charcoal suit"
	desc = "A charcoal suit and red tie. Very professional."
	icon_state = "charcoal_suit"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "lawyer_black", SLOT_ID_LEFT_HAND = "lawyer_black")
	starting_accessories = list(/obj/item/clothing/accessory/tie/navy, /obj/item/clothing/accessory/jacket/charcoal)

/obj/item/clothing/under/suit_jacket/charcoal/skirt
	name = "charcoal skirt"
	icon_state = "charcoal_suit_skirt"

/obj/item/clothing/under/suit_jacket/navy
	name = "navy suit"
	desc = "A navy suit and red tie, intended for the station's finest."
	icon_state = "navy_suit"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "lawyer_blue", SLOT_ID_LEFT_HAND = "lawyer_blue")
	starting_accessories = list(/obj/item/clothing/accessory/tie/red, /obj/item/clothing/accessory/jacket/navy)

/obj/item/clothing/under/suit_jacket/navy/skirt
	name = "navy skirt"
	icon_state = "navy_suit_skirt"

/obj/item/clothing/under/suit_jacket/burgundy
	name = "burgundy suit"
	desc = "A burgundy suit and black tie. Somewhat formal."
	icon_state = "burgundy_suit"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "lawyer_red", SLOT_ID_LEFT_HAND = "lawyer_red")
	starting_accessories = list(/obj/item/clothing/accessory/tie/black, /obj/item/clothing/accessory/jacket/burgundy)

/obj/item/clothing/under/suit_jacket/burgundy/skirt
	name = "burgundy skirt"
	icon_state = "burgundy_suit_skirt"

/obj/item/clothing/under/suit_jacket/checkered
	name = "checkered suit"
	desc = "That's a very nice suit you have there. Shame if something were to happen to it, eh?"
	icon_state = "checkered_suit"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "lawyer_black", SLOT_ID_LEFT_HAND = "lawyer_black")
	starting_accessories = list(/obj/item/clothing/accessory/tie/black, /obj/item/clothing/accessory/jacket/checkered)

/obj/item/clothing/under/suit_jacket/checkered/skirt
	name = "checkered skirt"
	icon_state = "checkered_suit_skirt"

/obj/item/clothing/under/suit_jacket/tan
	name = "tan suit"
	desc = "A tan suit. Smart, but casual."
	icon_state = "tan_suit"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "tan_suit", SLOT_ID_LEFT_HAND = "tan_suit")
	starting_accessories = list(/obj/item/clothing/accessory/tie/yellow, /obj/item/clothing/accessory/jacket)

/obj/item/clothing/under/suit_jacket/tan/skirt
	name = "tan skirt"
	icon_state = "tan_suit_skirt"

/obj/item/clothing/under/dutchuniform
	name = "\improper Western suit"
	desc = "We can't always fight nature. We can't fight change, we can't fight gravity, we can't fight nothing."
	icon_state = "dutchuniform"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS

/obj/item/clothing/under/victorianblred
    name = "red shirted victorian suit"
    desc = "Don't you see? I have thirteen lives."
    icon_state = "victorianblred"

/obj/item/clothing/under/fem_victorianblred
	name = "red shirted victorian suit"
	desc = "Don't you see? I have thirteen lives."
	icon_state = "victorianblred-fem"

/obj/item/clothing/under/victorianredvest
    name = "red vested victorian suit"
    desc = "Why are we going to the back of the ship? Because the front crashes first. Think it through."
    icon_state = "victorianredvest"

/obj/item/clothing/under/fem_victorianredvest
	name = "red vested victorian suit"
	desc = "Why are we going to the back of the ship? Because the front crashes first. Think it through."
	icon_state = "victorianredvest-fem"

/obj/item/clothing/under/victorianvest
    name = "victorian suit"
    desc = "Four minutes? That's ages. What if I get bored, or need a television, couple of books? Anyone for chess? Bring me knitting."
    icon_state = "victorianvest"

/obj/item/clothing/under/fem_victorianvest
	name = "victorian suit"
	desc = "Four minutes? That's ages. What if I get bored, or need a television, couple of books? Anyone for chess? Bring me knitting."
	icon_state = "victorianvest-fem"

/obj/item/clothing/under/victorianlightfire
    name = "light blue shirted victorian suit"
    desc = "Have you ever thought about what it's like to be wanderers in the Fourth Dimension? Yes, I'm asking you."
    icon_state = "victorianlightfire"

/obj/item/clothing/under/fem_victorianlightfire
	name = "light blue shirted victorian suit"
	desc = "Have you ever thought about what it's like to be wanderers in the Fourth Dimension? Yes, I'm asking you."
	icon_state = "victorianlightfire-fem"

/obj/item/clothing/under/fiendsuit
	name = "fiendish suit"
	desc = "A red and black suit befitting someone from the dark pits themselves....Or a thirteen year old."
	icon_state = "fiendsuit"

/obj/item/clothing/under/hawaiian
	name = "pink hawaiian suit"
	desc = "A suit consisting of bright white pants and a pink hawaiian shirt. Makes it feel like it's casual friday."
	icon_state = "hawaiianpink"

/obj/item/clothing/under/blueshift
	name = "light blue suit"
	desc = "A casual suit consisting of a light blue dress shirt, navy pants, and a black tie. Makes you think of a security officer in over his head."
	icon_state = "blueshift"

/obj/item/clothing/under/office_worker
	name = "officer worker suit"
	desc = "A suit consisting of a white dress shirt, white pants, black belt, and red-and-black tie."
	icon_state = "hlsuit"

