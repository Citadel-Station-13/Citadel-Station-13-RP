/obj/item/clothing/under/color/blackf
	name = "feminine black jumpsuit"
	desc = "It's very smart and in a ladies size!"
	icon_state = "black"
	snowflake_worn_state = "blackf"

/obj/item/clothing/under/color/blackjumpskirt
	name = "black jumpskirt"
	desc = "A slimming black jumpskirt."
	icon_state = "blackjumpskirt"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "black", SLOT_ID_LEFT_HAND = "black")

//TFF 5/8/19 - add a non perma-set orange jumpsuit, splits prison into its own obj with override var settings.
//TFF 5/9/19 - add a different icon_state to both jumpsuits, orange and prison. Refactors orange and prison jumpsuit slightly.

/obj/item/clothing/under/color/prison
	name = "prison jumpsuit"
	desc = "It's standardized prisoner-wear. Its suit sensors are permanently set to the \"Tracking\" position."
	icon = 'icons/clothing/uniform/job/jumpsuit_prision.dmi'
	icon_state = "orange"
	has_sensors = UNIFORM_HAS_LOCKED_SENSORS
	sensor_mode = 3
	worn_bodytypes = BODYTYPE_DEFAULT | BODYTYPE_TESHARI | BODYTYPE_UNATHI_DIGI | BODYTYPE_VOX

/obj/item/clothing/under/color/prison/skirt
	name = "prison pleated skirt"
	icon_state = "prisoner_skirt"
	icon_state = "orange"

/obj/item/clothing/under/psyche
	name = "psychedelic jumpsuit"
	desc = "Groovy!"
	icon_state = "psyche"

//Colored Skirts
/obj/item/clothing/under/color/black_skirt
	name = "black pleated skirt"
	desc = "A pleated skirt, available in a variety of colors."
	icon_state = "black_skirt"

/obj/item/clothing/under/color/grey_skirt
	name = "grey pleated skirt"
	icon_state = "grey_skirt"

/obj/item/clothing/under/color/white_skirt
	name = "white pleated skirt"
	icon_state = "white_skirt"

/obj/item/clothing/under/color/lbrown_skirt
	name = "light brown pleated skirt"
	icon_state = "lightbrown_skirt"

/obj/item/clothing/under/color/brown_skirt
	name = "brown pleated skirt"
	icon_state = "brown_skirt"

/obj/item/clothing/under/color/red_skirt
	name = "red pleated skirt"
	icon_state = "red_skirt"

/obj/item/clothing/under/color/orange_skirt
	name = "orange pleated skirt"
	icon_state = "orange_skirt"

/obj/item/clothing/under/color/yellow_skirt
	name = "yellow pleated skirt"
	icon_state = "yellow_skirt"

/obj/item/clothing/under/color/lgreen_skirt
	name = "light green pleated skirt"
	icon_state = "lightgreen_skirt"

/obj/item/clothing/under/color/green_skirt
	name = "green pleated skirt"
	icon_state = "green_skirt"

/obj/item/clothing/under/color/teal_skirt
	name = "teal pleated skirt"
	icon_state = "teal_skirt"

/obj/item/clothing/under/color/lblue_skirt
	name = "light blue pleated skirt"
	icon_state = "lightblue_skirt"

/obj/item/clothing/under/color/blue_skirt
	name = "blue pleated skirt"
	icon_state = "blue_skirt"

/obj/item/clothing/under/color/lpurple_skirt
	name = "light purple pleated skirt"
	icon_state = "lightpurple_skirt"

/obj/item/clothing/under/color/maroon_skirt
	name = "maroon pleated skirt"
	icon_state = "maroon_skirt"

/obj/item/clothing/under/color/pink_skirt
	name = "pink pleated skirt"
	icon_state = "pink_skirt"

/obj/item/clothing/under/color/rainbow_skirt
	name = "rainbow pleated skirt"
	icon_state = "rainbow_skirt"

