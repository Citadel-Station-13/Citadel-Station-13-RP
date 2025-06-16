/**
 * Pants, Jeans, Long legged shorts
 */

/obj/item/clothing/under/pants/white
	name = "white pants"
	desc = "Plain white pants. Boring."
	icon = 'icons/clothing/uniform/casual/jeans/whitepants.dmi'
	icon_state = "whitepants"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/red
	name = "red pants"
	desc = "Bright red pants. Overflowing with personality."
	icon = 'icons/clothing/uniform/casual/jeans/redpants.dmi'
	icon_state = "redpants"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/black
	name = "black pants"
	desc = "These pants are dark, like your soul."
	icon = 'icons/clothing/uniform/casual/jeans/blackpants.dmi'
	icon_state = "blackpants"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/tan
	name = "tan pants"
	desc = "Some tan pants. You look like a white collar worker with these on."
	icon = 'icons/clothing/uniform/casual/jeans/tanpants.dmi'
	icon_state = "tanpants"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/khaki
	name = "khaki pants"
	desc = "A pair of dust beige khaki pants."
	icon = 'icons/clothing/uniform/casual/jeans/khaki.dmi'
	icon_state = "khaki"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/camo
	name = "camo pants"
	desc = "A pair of woodland camouflage pants. Probably not the best choice for a space station."
	icon = 'icons/clothing/uniform/casual/jeans/camopants.dmi'
	icon_state = "camopants"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/chaps
	name = "sexy brown chaps"
	desc = "A pair of sexy, tight brown leather chaps."
	icon = 'icons/clothing/uniform/casual/jeans/chapsb.dmi'
	icon_state = "chapsb"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/chaps/black
	name = "sexy black chaps"
	desc = "A pair of sexy, tight black leather chaps."
	icon = 'icons/clothing/uniform/casual/jeans/chapsbl.dmi'
	icon_state = "chapsbl"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/yogapants
	name = "yoga pants"
	desc = "A pair of tight-fitting yoga pants for those lazy days."
	icon = 'icons/clothing/uniform/casual/jeans/yogapants.dmi'
	icon_state = "yogapants"
	addblends = "yogapants_a"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

//* Jeans *//

/obj/item/clothing/under/pants
	name = "jeans"
	desc = "A nondescript pair of tough blue jeans."
	icon = 'icons/clothing/uniform/casual/jeans/jeans.dmi'
	icon_state = "jeans"
	gender = PLURAL
	body_cover_flags = LOWER_TORSO|LEGS
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/ripped
	name = "ripped jeans"
	desc = "A nondescript pair of tough blue jeans with holes in them."
	icon = 'icons/clothing/uniform/casual/jeans/jeans.dmi'
	icon_state = "jeansripped"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/classicjeans
	name = "classic jeans"
	desc = "You feel cooler already."
	icon = 'icons/clothing/uniform/casual/jeans/jeans.dmi'
	icon_state = "jeansclassic"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/classicjeans/ripped
	name = "ripped classic jeans"
	desc = "You feel cooler already. These have holes in them."
	icon = 'icons/clothing/uniform/casual/jeans/jeans.dmi'
	icon_state = "jeansclassicripped"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/mustangjeans
	name = "must hang jeans"
	desc = "Made in the finest space jeans factory this side of Alpha Centauri."
	icon = 'icons/clothing/uniform/casual/jeans/jeans.dmi'
	icon_state = "jeansmustang"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/mustangjeans/ripped
	name = "ripped must hang jeans"
	desc = "Made in the finest space jeans factory this side of Alpha Centauri. These have holes in them."
	icon = 'icons/clothing/uniform/casual/jeans/jeans.dmi'
	icon_state = "jeansmustangripped"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/blackjeans
	name = "black jeans"
	desc = "Only for those who can pull it off."
	icon = 'icons/clothing/uniform/casual/jeans/jeans.dmi'
	icon_state = "jeansblack"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/blackjeans/ripped
	name = "ripped black jeans"
	desc = "Only for those who can pull it off. These have holes in them."
	icon = 'icons/clothing/uniform/casual/jeans/jeans.dmi'
	icon_state = "jeansblackripped"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/greyjeans
	name = "grey jeans"
	desc = "Only for those who can pull it off."
	icon = 'icons/clothing/uniform/casual/jeans/jeans.dmi'
	icon_state = "jeansgrey"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/greyjeans/ripped
	name = "ripped grey jeans"
	desc = "Only for those who can pull it off. These have holes in them."
	icon = 'icons/clothing/uniform/casual/jeans/jeans.dmi'
	icon_state = "jeansgreyripped"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/youngfolksjeans
	name = "young folks jeans"
	desc = "For those tired of boring old jeans. Relive the passion of your youth!"
	icon = 'icons/clothing/uniform/casual/jeans/jeans.dmi'
	icon_state = "jeansyoungfolks"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

//* Track Pants *//

/obj/item/clothing/under/pants/track
	name = "track pants"
	desc = "A pair of track pants, for the athletic."
	icon = 'icons/clothing/uniform/casual/jeans/trackpants.dmi'
	icon_state = "trackpants"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/track/blue
	name = "blue track pants"
	icon = 'icons/clothing/uniform/casual/jeans/trackpants.dmi'
	icon_state = "trackpantsblue"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/track/green
	name = "green track pants"
	icon = 'icons/clothing/uniform/casual/jeans/trackpants.dmi'
	icon_state = "trackpantsgreen"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/track/white
	name = "white track pants"
	icon = 'icons/clothing/uniform/casual/jeans/trackpants.dmi'
	icon_state = "trackpantswhite"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/track/red
	name = "red track pants"
	icon = 'icons/clothing/uniform/casual/jeans/trackpants.dmi'
	icon_state = "trackpantsred"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

//* Baggy Jeans *//

/obj/item/clothing/under/pants/baggy
	name = "baggy jeans"
	desc = "A nondescript pair of tough baggy blue jeans."
	icon = 'icons/clothing/uniform/casual/jeans/baggy_jeans.dmi'
	icon_state = "baggy_jeans"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/baggy/classicjeans
	name = "baggy classic jeans"
	desc = "You feel cooler already."
	icon = 'icons/clothing/uniform/casual/jeans/baggy_jeans.dmi'
	icon_state = "baggy_jeansclassic"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/baggy/mustangjeans
	name = "maggy must hang jeans"
	desc = "Made in the finest space jeans factory this side of Alpha Centauri."
	icon = 'icons/clothing/uniform/casual/jeans/baggy_jeans.dmi'
	icon_state = "baggy_jeansmustang"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/baggy/blackjeans
	name = "baggy black jeans"
	desc = "Only for those who can pull it off."
	icon = 'icons/clothing/uniform/casual/jeans/baggy_jeans.dmi'
	icon_state = "baggy_jeansblack"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/baggy/greyjeans
	name = "baggy grey jeans"
	desc = "Only for those who can pull it off."
	icon = 'icons/clothing/uniform/casual/jeans/baggy_jeans.dmi'
	icon_state = "baggy_jeansgrey"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/baggy/youngfolksjeans
	name = "baggy young folks jeans"
	desc = "For those tired of boring old jeans. Relive the passion of your youth!"
	icon = 'icons/clothing/uniform/casual/jeans/baggy_jeans.dmi'
	icon_state = "baggy_jeansyoungfolks"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

//* Baggy Pants *//

/obj/item/clothing/under/pants/baggy/white
	name = "baggy white pants"
	desc = "Plain white pants. Boring."
	icon = 'icons/clothing/uniform/casual/jeans/baggy_pants.dmi'
	icon_state = "baggy_whitepants"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/baggy/red
	name = "baggy red pants"
	desc = "Bright red pants. Overflowing with personality."
	icon = 'icons/clothing/uniform/casual/jeans/baggy_pants.dmi'
	icon_state = "baggy_redpants"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/baggy/black
	name = "baggy black pants"
	desc = "These pants are dark, like your soul."
	icon = 'icons/clothing/uniform/casual/jeans/baggy_pants.dmi'
	icon_state = "baggy_blackpants"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/baggy/tan
	name = "baggy tan pants"
	desc = "Some tan pants. You look like a white collar worker with these on."
	icon = 'icons/clothing/uniform/casual/jeans/baggy_pants.dmi'
	icon_state = "baggy_tanpants"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/baggy/track
	name = "baggy track pants"
	desc = "A pair of track pants, for the athletic."
	icon = 'icons/clothing/uniform/casual/jeans/baggy_pants.dmi'
	icon_state = "baggy_trackpants"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/baggy/khaki
	name = "baggy khaki pants"
	desc = "A pair of dust beige khaki pants."
	icon = 'icons/clothing/uniform/casual/jeans/baggy_pants.dmi'
	icon_state = "baggy_khaki"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/baggy/camo
	name = "baggy camo pants"
	desc = "A pair of woodland camouflage pants. Probably not the best choice for a space station."
	icon = 'icons/clothing/uniform/casual/jeans/baggy_pants.dmi'
	icon_state = "baggy_camopants"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

//* Utility Pants *//

/obj/item/clothing/under/pants/utility
	name = "green utility pants"
	desc = "A pair of pleather reinforced green work pants."
	icon = 'icons/clothing/uniform/casual/jeans/workpants.dmi'
	icon_state = "workpants_green"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/utility/orange
	name = "orange utility pants"
	desc = "A pair of pleather reinforced orange work pants."
	icon = 'icons/clothing/uniform/casual/jeans/workpants.dmi'
	icon_state = "workpants_orange"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/utility/blue
	name = "blue utility pants"
	desc = "A pair of pleather reinforced blue work pants."
	icon = 'icons/clothing/uniform/casual/jeans/workpants.dmi'
	icon_state = "workpants_blue"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/utility/white
	name = "white utility pants"
	desc = "A pair of pleather reinforced white work pants."
	icon = 'icons/clothing/uniform/casual/jeans/workpants.dmi'
	icon_state = "workpants_white"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pants/utility/red
	name = "red utility pants"
	desc = "A pair of pleather reinforced red work pants."
	icon = 'icons/clothing/uniform/casual/jeans/workpants.dmi'
	icon_state = "workpants_red"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"
