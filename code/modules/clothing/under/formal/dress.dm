/**
 * Dresses
 * Theres probably a better way to seperate these but I'm not knowledgable enough in
 * fashion.
 */

/obj/item/clothing/under/dress
	body_cover_flags = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/dress/cropdress
	name = "cropped dress"
	desc = "A cropped dress to keep you cool, but fashionable."
	icon = 'icons/clothing/uniform/formal/dress/cropdress.dmi'
	icon_state = "cropdress"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/dress/twistdress
	name = "twisted dress"
	desc = "A new take on twisted coffee, this top and skirt keep your robustness at an all-time high."
	icon = 'icons/clothing/uniform/formal/dress/twistfront.dmi'
	icon_state = "twistfront"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/dress/blacktango
	name = "black tango dress"
	desc = "Filled with Latin fire."
	icon = 'icons/clothing/uniform/formal/dress/blacktango.dmi'
	icon_state = "black_tango"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/dress/blacktango/alt
	name = "black tango dress"
	desc = "Filled with Latin fire."
	icon = 'icons/clothing/uniform/formal/dress/blacktango_alt.dmi'
	icon_state = "black_tango_alt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/dress/stripeddress
	name = "striped dress"
	desc = "Fashion in space."
	icon = 'icons/clothing/uniform/formal/dress/striped_dress.dmi'
	icon_state = "striped_dress"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/dress/sailordress
	name = "sailor dress"
	desc = "Formal wear for a leading lady."
	icon = 'icons/clothing/uniform/formal/dress/sailor_dress.dmi'
	icon_state = "sailor_dress"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/dress/redeveninggown
	name = "red evening gown"
	desc = "Fancy dress for space bar singers."
	icon = 'icons/clothing/uniform/formal/dress/red_evening_gown.dmi'
	icon_state = "red_evening_gown"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/dress/dress_fire
	name = "flame dress"
	desc = "A small black dress with blue flames print on it."
	icon = 'icons/clothing/uniform/formal/dress/dress_fire.dmi'
	icon_state = "dress_fire"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/dress/dress_green
	name = "green dress"
	desc = "A simple, tight fitting green dress."
	icon = 'icons/clothing/uniform/formal/dress/dress_green.dmi'
	icon_state = "dress_green"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/dress/dress_orange
	name = "orange dress"
	desc = "A fancy orange gown for those who like to show leg."
	icon = 'icons/clothing/uniform/formal/dress/dress_orange.dmi'
	icon_state = "dress_orange"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/dress/dress_pink
	name = "pink dress"
	desc = "A simple, tight fitting pink dress."
	icon = 'icons/clothing/uniform/formal/dress/dress_pink.dmi'
	icon_state = "dress_pink"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/dress/dress_yellow
	name = "yellow dress"
	desc = "A flirty, little yellow dress."
	icon = 'icons/clothing/uniform/formal/dress/dress_yellow.dmi'
	icon_state = "dress_yellow"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/dress/dress_saloon
	name = "saloon girl dress"
	desc = "A old western inspired gown for the girl who likes to drink."
	icon = 'icons/clothing/uniform/formal/dress/dress_saloon.dmi'
	icon_state = "dress_saloon"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/dress/flower_dress
	name = "flower dress"
	desc = "A beautiful dress with a skirt of flowers."
	icon = 'icons/clothing/uniform/formal/dress/flower_dress.dmi'
	icon_state = "flower_dress"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/dress/red_swept_dress
	name = "red swept dress"
	desc = "A red dress that sweeps to the side."
	icon = 'icons/clothing/uniform/formal/dress/red_swept_dress.dmi'
	icon_state = "red_swept_dress"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/dress/flamenco
	name = "flamenco dress"
	desc = "A Mexican flamenco dress."
	icon = 'icons/clothing/uniform/formal/dress/flamenco.dmi'
	icon_state = "flamenco"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/dress/westernbustle
	name = "western bustle"
	desc = "A western bustle dress from Earth's late 1800's."
	icon = 'icons/clothing/uniform/formal/dress/westernbustle.dmi'
	icon_state = "westernbustle"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/dress/sari
	name = "red sari"
	desc = "A colorful traditional dress originating from India."
	icon = 'icons/clothing/uniform/formal/dress/sari_red.dmi'
	icon_state = "sari_red"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/dress/sari/green
	name = "green sari"
	icon = 'icons/clothing/uniform/formal/dress/sari_green.dmi'
	icon_state = "sari_green"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/dress/lilacdress
	name = "lilac dress"
	desc = "A simple black dress adorned in fake purple lilacs."
	icon = 'icons/clothing/uniform/formal/dress/lilacdress.dmi'
	icon_state = "lilacdress"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/sundress
	name = "sundress"
	desc = "Makes you want to frolic in a field of daisies."
	icon = 'icons/clothing/uniform/formal/dress/sundress.dmi'
	icon_state = "sundress"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/sundress_white
	name = "white sundress"
	desc = "A white sundress decorated with purple lilies."
	icon = 'icons/clothing/uniform/formal/dress/sundress_white.dmi'
	icon_state = "sundress_white"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/pentagramdress
	name = "pentagram dress"
	desc = "A black dress with straps over the chest in the shape of a pentagram."
	icon = 'icons/clothing/uniform/formal/dress/pentagram.dmi'
	icon_state = "pentagram"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/dress/white
	name = "white wedding dress"
	desc = "A fancy white dress with a blue underdress."
	icon = 'icons/clothing/uniform/formal/dress/whitedress1.dmi'
	icon_state = "whitedress1"
	inv_hide_flags = HIDESHOES
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/dress/white2
	name = "long dress"
	desc = "A long dress."
	icon = 'icons/clothing/uniform/formal/dress/whitedress2.dmi'
	icon_state = "whitedress2"
	addblends = "whitedress2_a"
	inv_hide_flags = HIDESHOES
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/dress/white3
	name = "short dress"
	desc = "A short, plain dress."
	icon = 'icons/clothing/uniform/formal/dress/whitedress3.dmi'
	icon_state = "whitedress3"
	addblends = "whitedress3_a"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/dress/white4
	name = "long flared dress"
	desc = "A long white dress that flares out at the bottom."
	icon = 'icons/clothing/uniform/formal/dress/whitedress4.dmi'
	icon_state = "whitedress4"
	addblends = "whitedress4_a"
	inv_hide_flags = HIDESHOES
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/dress/darkred
	name = "fancy dark red dress"
	desc = "A short, red dress with a black belt. Fancy."
	icon = 'icons/clothing/uniform/formal/dress/darkreddress.dmi'
	icon_state = "darkreddress"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/festivedress
	name = "festive dress"
	desc = "A red dress with a fur-like white trim that is associated with the Christmas season."
	icon = 'icons/clothing/uniform/formal/dress/festivedress.dmi'
	icon_state = "festivedress"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/littleblackdress
	name = "little black dress"
	desc = "A small black dress with a red sash."
	icon = 'icons/clothing/uniform/formal/dress/littleblackdress.dmi'
	icon_state = "littleblackdress"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/victorianreddress
	name = "red victorian dress"
	desc = "A little gratitude wouldn't irretrievably damage my ego."
	icon = 'icons/clothing/uniform/formal/dress/victorianreddress.dmi'
	icon_state = "victorianreddress"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/victorianblackdress
	name = "black victorian dress"
	desc = "What's the use of a good quotation if you can't change it?"
	icon = 'icons/clothing/uniform/formal/dress/victorianblackdress.dmi'
	icon_state = "victorianblackdress"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/fienddress
	name = "fiendish dress"
	desc = "A red and black dress befitting someone from the dark pits themselves....Or a thirteen year old."
	icon = 'icons/clothing/uniform/formal/dress/fienddress.dmi'
	icon_state = "fienddress"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tabard_w
	name = "white tabard-dress"
	desc = "A gold-trimmed white tabard-dress with a large V-shaped boob window. For when you want to show off your hips and look classy at the same time."
	icon = 'icons/clothing/uniform/formal/dress/white_tabard.dmi'
	icon_state = "white_tabard"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tabard_b
	name = "black tabard-dress"
	desc = "A gold-trimmed black tabard-dress with a large circular boob window. Useful for showing off your hips while your buddy puts something in the target's drink."
	icon = 'icons/clothing/uniform/formal/dress/black_tabard.dmi'
	icon_state = "black_tabard"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/verglasdress
	name = "verglas dress"
	desc = "The modern twist on a forgotten pattern, the Verglas style utilizes comfortable velvet and silver white satin to create an otherworldly effect evocative of winter, or the void."
	icon = 'icons/clothing/uniform/formal/dress/verglas_dress.dmi'
	icon_state = "verglas_dress"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/simpledress
	name = "White Simple Dress"
	desc = "A very short, plain white dress with a light blue sash."
	icon = 'icons/clothing/uniform/formal/dress/simpledress.dmi'
	icon_state = "simpledress"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/chiming_dress
	name = "chiming dress"
	desc = "This stylish yet rugged dress is inspired by recovered depictions of ancient Surt's native inhabitants. Composed of many integrated panels, it allows for excellent breathability whilst also retaining a strong profile."
	icon = 'icons/clothing/uniform/formal/dress/chiming_dress.dmi'
	icon_state = "chiming_dress"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/countess
	name = "countess dress"
	desc = "This flowing dress radiates a dark authority. Its wide skirt and daring color palette bring to mind the feeling of movement in shadows, or a rush of blood."
	icon = 'icons/clothing/uniform/formal/dress/countess.dmi'
	icon_state = "countess"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/baroness
	name = "baroness dress"
	desc = "With its imposing train and sanguine color palette, this dress aims to menace. Some day the designer sought to evoke the downfall of Vetala in its design."
	icon = 'icons/clothing/uniform/formal/dress/baroness.dmi'
	icon_state = "baroness"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/lilin
	name = "Lilin sash dress"
	desc = "An exotic shoulderless dress that plunges into an open-hipped sash-like silk skirt. Its fading dyework seems to evoke a sense of bleeding. A small tag marks it as belonging to the Lindenoak line."
	icon = 'icons/clothing/uniform/formal/dress/lilin.dmi'
	icon_state = "lilin"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/dress/summer
	name = "summer dress"
	desc = "A light and breezy dress designed to keep its wearer comfortable on hot summer days."
	icon = 'icons/clothing/uniform/formal/dress/summerdress.dmi'
	icon_state = "summerdress"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/dress/summer/blue
	name = "blue summer dress"
	icon = 'icons/clothing/uniform/formal/dress/summerdress2.dmi'
	icon_state = "summerdress2"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/dress/summer/red
	name = "red summer dress"
	icon = 'icons/clothing/uniform/formal/dress/summerdress3.dmi'
	icon_state = "summerdress3"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/dress/summer/gold
	name = "golden summer dress"
	desc = "A light and breezy dress designed to keep its wearer comfortable on hot summer days. This one features an especially daring side cut."
	icon = 'icons/clothing/uniform/formal/dress/summerdress_nt.dmi'
	icon_state = "summerdress_nt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/revealing
	name = "revealing cocktail dress"
	desc = "A dress this daring requires certain amounts of confidence that few possess. Show off what you've got without too much of a scandal."
	icon = 'icons/clothing/uniform/formal/dress/revealingdress.dmi'
	icon_state = "revealingdress"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

