/**
 * Mens Suits, Women Suits, Skeleton Suits
 */

/obj/item/clothing/under/scratch
	name = "white suit"
	desc = "A white suit, suitable for an excellent host"
	icon = 'icons/clothing/uniform/formal/suits/scratch.dmi'
	icon_state = "scratch"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/scratch/skirt
	name = "white skirt suit"
	icon = 'icons/clothing/uniform/formal/suits/scratch_skirt.dmi'
	icon_state = "scratch_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/sl_suit
	desc = "It's a very amish looking suit."
	name = "amish suit"
	icon = 'icons/clothing/uniform/formal/suits/sl_suit.dmi'
	icon_state = "sl_suit"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/gentlesuit
	name = "gentlemans suit"
	desc = "A silk black shirt with matching gray slacks. Feels proper."
	icon = 'icons/clothing/uniform/formal/suits/gentlesuit.dmi'
	icon_state = "gentlesuit"
	starting_accessories = list(/obj/item/clothing/accessory/tie/white, /obj/item/clothing/accessory/wcoat/gentleman)
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/gentlesuit/skirt
	name = "lady's suit"
	desc = "A silk black blouse with a matching gray skirt. Feels proper."
	icon = 'icons/clothing/uniform/formal/suits/gentlesuit_skirt.dmi'
	icon_state = "gentlesuit_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/suit_jacket
	name = "black suit"
	desc = "A black suit and red tie. Very formal."
	icon = 'icons/clothing/uniform/formal/suits/black_suit.dmi'
	icon_state = "black_suit"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/suit_jacket/really_black
	name = "executive suit"
	desc = "A formal black suit and red tie, intended for the station's finest."
	icon = 'icons/clothing/uniform/formal/suits/really_black_suit.dmi'
	icon_state = "really_black_suit"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/suit_jacket/really_black/skirt
	name = "executive skirt suit"
	desc = "A formal black suit and red necktie, intended for the station's finest."
	icon = 'icons/clothing/uniform/formal/suits/really_black_suit_skirt.dmi'
	icon_state = "really_black_suit_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "black"

/obj/item/clothing/under/suit_jacket/female
	name = "female executive suit"
	desc = "A formal trouser suit for women, intended for the station's finest."
	icon = 'icons/clothing/uniform/formal/suits/black_suit_fem.dmi'
	icon_state = "black_suit_fem"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/suit_jacket/female/skirt
	name = "executive skirt"
	desc = "A formal suit skirt for women, intended for the station's finest."
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS
	icon = 'icons/clothing/uniform/formal/suits/black_formal_skirt.dmi'
	icon_state = "black_formal_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/suit_jacket/female/pleated_skirt
	name = "executive pleated skirt"
	icon = 'icons/clothing/uniform/formal/suits/black_suit_fem_skirt.dmi'
	icon_state = "black_suit_fem_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/suit_jacket/red
	name = "red suit"
	desc = "A red suit and blue tie. Somewhat formal."
	icon = 'icons/clothing/uniform/formal/suits/red_suit.dmi'
	icon_state = "red_suit"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/suit_jacket/red/skirt
	name = "red skirt suit"
	desc = "A red suit and blue necktie. Somewhat formal."
	icon = 'icons/clothing/uniform/formal/suits/red_suit_skirt.dmi'
	icon_state = "red_suit_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/suit_jacket/charcoal
	name = "charcoal suit"
	desc = "A charcoal suit and red tie. Very professional."
	icon = 'icons/clothing/uniform/formal/suits/charcoal_suit.dmi'
	icon_state = "charcoal_suit"
	starting_accessories = list(/obj/item/clothing/accessory/tie/navy, /obj/item/clothing/accessory/jacket/charcoal)
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/suit_jacket/charcoal/skirt
	name = "charcoal skirt"
	icon = 'icons/clothing/uniform/formal/suits/charcoal_suit_skirt.dmi'
	icon_state = "charcoal_suit_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/suit_jacket/navy
	name = "navy suit"
	desc = "A navy suit and red tie, intended for the station's finest."
	icon = 'icons/clothing/uniform/formal/suits/navy_suit.dmi'
	icon_state = "navy_suit"
	starting_accessories = list(/obj/item/clothing/accessory/tie/red, /obj/item/clothing/accessory/jacket/navy)
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/suit_jacket/navy/skirt
	name = "navy skirt"
	icon = 'icons/clothing/uniform/formal/suits/navy_suit_skirt.dmi'
	icon_state = "navy_suit_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/suit_jacket/burgundy
	name = "burgundy suit"
	desc = "A burgundy suit and black tie. Somewhat formal."
	icon = 'icons/clothing/uniform/formal/suits/burgundy_suit.dmi'
	icon_state = "burgundy_suit"
	starting_accessories = list(/obj/item/clothing/accessory/tie/black, /obj/item/clothing/accessory/jacket/burgundy)
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/suit_jacket/burgundy/skirt
	name = "burgundy skirt"
	icon = 'icons/clothing/uniform/formal/suits/burgundy_suit_skirt.dmi'
	icon_state = "burgundy_suit_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

//Reuses spritesheet
/obj/item/clothing/under/suit_jacket/checkered
	name = "checkered suit"
	desc = "That's a very nice suit you have there. Shame if something were to happen to it, eh?"
	icon = 'icons/clothing/uniform/workwear/dept_security/detective3.dmi'
	icon_state = "detective3"
	starting_accessories = list(/obj/item/clothing/accessory/tie/black, /obj/item/clothing/accessory/jacket/checkered)
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_VOX)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)

/obj/item/clothing/under/suit_jacket/checkered/skirt
	name = "checkered skirt"
	icon = 'icons/clothing/uniform/formal/suits/checkered_suit_skirt.dmi'
	icon_state = "checkered_suit_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/suit_jacket/tan
	name = "tan suit"
	desc = "A tan suit. Smart, but casual."
	icon = 'icons/clothing/uniform/formal/suits/tan_suit.dmi'
	icon_state = "tan_suit"
	starting_accessories = list(/obj/item/clothing/accessory/tie/yellow, /obj/item/clothing/accessory/jacket)
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/suit_jacket/tan/skirt
	name = "tan skirt"
	icon = 'icons/clothing/uniform/formal/suits/tan_suit_skirt.dmi'
	icon_state = "tan_suit_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/dutchuniform
	name = "\improper Western suit"
	desc = "We can't always fight nature. We can't fight change, we can't fight gravity, we can't fight nothing."
	icon = 'icons/clothing/uniform/formal/suits/dutchuniform.dmi'
	icon_state = "dutchuniform"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/victorianblred
	name = "red shirted victorian suit"
	desc = "Don't you see? I have thirteen lives."
	icon = 'icons/clothing/uniform/formal/suits/victorianblred.dmi'
	icon_state = "victorianblred"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/fem_victorianblred
	name = "red shirted victorian suit"
	desc = "Don't you see? I have thirteen lives."
	icon = 'icons/clothing/uniform/formal/suits/victorianblred-fem.dmi'
	icon_state = "victorianblred-fem"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/victorianredvest
	name = "red vested victorian suit"
	desc = "Why are we going to the back of the ship? Because the front crashes first. Think it through."
	icon = 'icons/clothing/uniform/formal/suits/victorianredvest.dmi'
	icon_state = "victorianredvest"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/fem_victorianredvest
	name = "red vested victorian suit"
	desc = "Why are we going to the back of the ship? Because the front crashes first. Think it through."
	icon = 'icons/clothing/uniform/formal/suits/victorianredvest-fem.dmi'
	icon_state = "victorianredvest-fem"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/victorianvest
	name = "victorian suit"
	desc = "Four minutes? That's ages. What if I get bored, or need a television, couple of books? Anyone for chess? Bring me knitting."
	icon = 'icons/clothing/uniform/formal/suits/victorianvest.dmi'
	icon_state = "victorianvest"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/fem_victorianvest
	name = "victorian suit"
	desc = "Four minutes? That's ages. What if I get bored, or need a television, couple of books? Anyone for chess? Bring me knitting."
	icon = 'icons/clothing/uniform/formal/suits/victorianvest-fem.dmi'
	icon_state = "victorianvest-fem"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/victorianlightfire
	name = "light blue shirted victorian suit"
	desc = "Have you ever thought about what it's like to be wanderers in the Fourth Dimension? Yes, I'm asking you."
	icon = 'icons/clothing/uniform/formal/suits/victorianlightfire.dmi'
	icon_state = "victorianlightfire"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/fem_victorianlightfire
	name = "light blue shirted victorian suit"
	desc = "Have you ever thought about what it's like to be wanderers in the Fourth Dimension? Yes, I'm asking you."
	icon = 'icons/clothing/uniform/formal/suits/victorianlightfire-fem.dmi'
	icon_state = "victorianlightfire-fem"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/fiendsuit
	name = "fiendish suit"
	desc = "A red and black suit befitting someone from the dark pits themselves....Or a thirteen year old."
	icon = 'icons/clothing/uniform/formal/suits/fiendsuit.dmi'
	icon_state = "fiendsuit"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/hawaiian
	name = "pink hawaiian suit"
	desc = "A suit consisting of bright white pants and a pink hawaiian shirt. Makes it feel like it's casual friday."
	icon = 'icons/clothing/uniform/formal/suits/hawaiianpink.dmi'
	icon_state = "hawaiianpink"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/blueshift
	name = "light blue suit"
	desc = "A casual suit consisting of a light blue dress shirt, navy pants, and a black tie. Makes you think of a security officer in over his head."
	icon = 'icons/clothing/uniform/formal/suits/blueshift.dmi'
	icon_state = "blueshift"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/office_worker
	name = "officer worker suit"
	desc = "A suit consisting of a white dress shirt, white pants, black belt, and red-and-black tie."
	icon = 'icons/clothing/uniform/formal/suits/hlsuit.dmi'
	icon_state = "hlsuit"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/blazer
	name = "blue blazer"
	desc = "A bold but yet conservative outfit, red corduroys, navy blazer and a tie."
	icon = 'icons/clothing/uniform/formal/suits/blue_blazer.dmi'
	icon_state = "blue_blazer"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/blazer/skirt
	name = "ladies blue blazer"
	desc = "A bold but yet conservative outfit, a red pencil skirt and a navy blazer."
	icon = 'icons/clothing/uniform/formal/suits/blue_blazer_skirt.dmi'
	icon_state = "blue_blazer_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

//Reuses spritesheet
/obj/item/clothing/under/redcoatformal
	name = "formal red coat"
	desc = "Raise the taxes on their tea. What can go wrong?"
	icon = 'icons/clothing/uniform/costume/historical/redcoatformal.dmi'
	icon_state = "redcoatformal"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/businessskirt_female
	name = "Business Skirt"
	desc = "A professional black jacket with a mundane brown skirt. Perfect for the office."
	icon = 'icons/clothing/uniform/formal/suits/businessskirt_female.dmi'
	icon_state = "businessskirt_female"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"
