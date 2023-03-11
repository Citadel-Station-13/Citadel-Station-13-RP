/*
 * Contains:
 *		Lasertag
 *		Costume
 *		Misc
 */

// -S2-note- Needs categorizing and sorting.

/*
 * Lasertag
 */
/obj/item/clothing/suit/bluetag
	name = "blue laser tag armour"
	desc = "Blue Pride, Station Wide."
	icon_state = "bluetag"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "tdblue", SLOT_ID_LEFT_HAND = "tdblue")
	blood_overlay_type = "armor"
	body_cover_flags = UPPER_TORSO
	allowed = list (/obj/item/gun/energy/lasertag/blue)
	siemens_coefficient = 3.0

/obj/item/clothing/suit/redtag
	name = "red laser tag armour"
	desc = "Reputed to go faster."
	icon_state = "redtag"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "tdred", SLOT_ID_LEFT_HAND = "tdred")
	blood_overlay_type = "armor"
	body_cover_flags = UPPER_TORSO
	allowed = list (/obj/item/gun/energy/lasertag/red)
	siemens_coefficient = 3.0

/*
 * Costume
 */
/obj/item/clothing/suit/pirate
	name = "pirate coat"
	desc = "Yarr."
	icon_state = "pirate"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "greatcoat", SLOT_ID_LEFT_HAND = "greatcoat")
	body_cover_flags = UPPER_TORSO|ARMS

/obj/item/clothing/suit/hgpirate
	name = "pirate captain coat"
	desc = "Yarr."
	icon_state = "hgpirate"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "greatcoat", SLOT_ID_LEFT_HAND = "greatcoat")
	inv_hide_flags = HIDEJUMPSUIT
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS

/obj/item/clothing/suit/cyborg_suit
	name = "cyborg suit"
	desc = "Suit for a cyborg costume."
	icon_state = "death"
	fire_resist = T0C+5200
	inv_hide_flags = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER

/obj/item/clothing/suit/greatcoat
	name = "great coat"
	desc = "A heavy great coat"
	icon_state = "gentlecoat"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "greatcoat", SLOT_ID_LEFT_HAND = "greatcoat")
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/johnny_coat
	name = "johnny~~ coat"
	desc = "Johnny~~"
	icon_state = "gentlecoat"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "johnny_coat", SLOT_ID_LEFT_HAND = "johnny_coat")
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/justice
	name = "justice suit"
	desc = "This pretty much looks ridiculous."
	icon_state = "gentle_coat"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "greatcoat", SLOT_ID_LEFT_HAND = "greatcoat")
	inv_hide_flags = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|LEGS|FEET

/obj/item/clothing/suit/judgerobe
	name = "judge's robe"
	desc = "This robe commands authority."
	icon_state = "judge"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/storage/fancy/cigarettes,/obj/item/spacecash)
	inv_hide_flags = HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER

/obj/item/clothing/suit/storage/apron/overalls
	name = "coveralls"
	desc = "A set of denim overalls."
	icon_state = "overalls"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/suit/syndicatefake
	name = "red space suit replica"
	icon = 'icons/obj/clothing/spacesuits.dmi'
	icon_state = "syndicate"
	desc = "A plastic replica of the syndicate space suit, you'll look just like a real murderous syndicate agent in this! This is a toy, it is not made for use in space!"
	w_class = ITEMSIZE_NORMAL
	allowed = list(/obj/item/flashlight,/obj/item/tank/emergency/oxygen,/obj/item/toy)
	inv_hide_flags = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|LEGS|FEET

/obj/item/clothing/suit/hastur
	name = "Hastur's Robes"
	desc = "Robes not meant to be worn by man"
	icon_state = "hastur"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "rad", SLOT_ID_LEFT_HAND = "rad")
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	inv_hide_flags = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER

/obj/item/clothing/suit/imperium_monk
	name = "Imperium monk"
	desc = "Have YOU killed a xenos today?"
	icon_state = "imperium_monk"
	body_cover_flags = HEAD|UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	inv_hide_flags = HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER

/obj/item/clothing/suit/chickensuit
	name = "Chicken Suit"
	desc = "A suit made long ago by the ancient empire KFC."
	icon_state = "chickensuit"
	body_cover_flags = UPPER_TORSO|ARMS|LOWER_TORSO|LEGS|FEET
	inv_hide_flags = HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	siemens_coefficient = 2.0

/obj/item/clothing/suit/monkeysuit
	name = "Monkey Suit"
	desc = "A suit that looks like a primate"
	icon_state = "monkeysuit"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "brown_jacket", SLOT_ID_LEFT_HAND = "brown_jacket")
	body_cover_flags = UPPER_TORSO|ARMS|LOWER_TORSO|LEGS|FEET|HANDS
	inv_hide_flags = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	siemens_coefficient = 2.0

/obj/item/clothing/suit/holidaypriest
	name = "Holiday Priest"
	desc = "This is a nice holiday my son."
	icon_state = "holidaypriest"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "labcoat", SLOT_ID_LEFT_HAND = "labcoat")
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	inv_hide_flags = HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER

/obj/item/clothing/suit/hevsuit
	name = "Hazardous Environments Suit"
	desc = "Better than a rediculous tie."
	icon_state = "hevsuit"
	body_cover_flags = UPPER_TORSO|ARMS|LOWER_TORSO|LEGS|FEET|HANDS
	inv_hide_flags = HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER

/obj/item/clothing/suit/cardborg
	name = "cardborg suit"
	desc = "An ordinary cardboard box with holes cut in the sides."
	icon_state = "cardborg"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO
	inv_hide_flags = HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER

/obj/item/clothing/suit/skeleton
	name = "skeleton costume"
	desc = "A body-tight costume with the human skeleton lined out on it."
	icon_state = "skelecost"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|FEET|HANDS|EYES|HEAD|FACE
	inv_hide_flags = HIDEJUMPSUIT|HIDESHOES|HIDEGLOVES|HIDETIE|HIDEHOLSTER
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "judge", SLOT_ID_LEFT_HAND = "judge")

/obj/item/clothing/suit/engicost
	name = "sexy engineering voidsuit costume"
	desc = "It's supposed to look like an engineering voidsuit... It doesn't look like it could protect from much radiation."
	icon_state = "engicost"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|FEET
	inv_hide_flags = HIDEJUMPSUIT|HIDESHOES|HIDETIE|HIDEHOLSTER
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "eng_voidsuit", SLOT_ID_LEFT_HAND = "eng_voidsuit")

/obj/item/clothing/suit/maxman
	name = "doctor maxman costume"
	desc = "A costume made to look like Dr. Maxman, the famous male-enhancement salesman. Complete with red do-rag and sleeveless labcoat."
	icon_state = "maxman"
	body_cover_flags = LOWER_TORSO|FEET|LEGS|HEAD
	inv_hide_flags = HIDEJUMPSUIT|HIDESHOES|HIDETIE|HIDEHOLSTER
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "leather_jacket", SLOT_ID_LEFT_HAND = "leather_jacket")

/obj/item/clothing/suit/iasexy
	name = "sexy internal affairs suit"
	desc = "Now where's your pen?~"
	icon_state = "iacost"
	body_cover_flags = UPPER_TORSO|FEET|LOWER_TORSO|EYES
	inv_hide_flags = HIDEJUMPSUIT|HIDESHOES|HIDETIE|HIDEHOLSTER
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "suit_black", SLOT_ID_LEFT_HAND = "suit_black")

/obj/item/clothing/suit/sexyminer
	name = "sexy miner costume"
	desc = "For when you need to get your rocks off."
	icon_state = "sexyminer"
	body_cover_flags = FEET|LOWER_TORSO|HEAD
	inv_hide_flags = HIDEJUMPSUIT|HIDESHOES|HIDETIE|HIDEHOLSTER
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "miner", SLOT_ID_LEFT_HAND = "miner")

/obj/item/clothing/suit/sumo
	name = "inflatable sumo wrestler costume"
	desc = "An inflated sumo wrestler costume. It's quite hot."
	icon_state = "sumo"
	body_cover_flags = FEET|LOWER_TORSO|UPPER_TORSO|LEGS|ARMS
	inv_hide_flags = HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "classicponcho", SLOT_ID_LEFT_HAND = "classicponcho")
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/hackercost
	name = "classic hacker costume"
	desc = "You would feel insanely cool wearing this."
	icon_state = "hackercost"
	body_cover_flags = FEET|LOWER_TORSO|UPPER_TORSO|LEGS|ARMS|EYES
	inv_hide_flags = HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "leather_coat", SLOT_ID_LEFT_HAND = "leather_coat")

/obj/item/clothing/suit/lumber
	name = "sexy lumberjack costume"
	desc = "Smells of dusky pine. Includes chest hair and beard."
	icon_state = "sexylumber"
	body_cover_flags = FEET|LOWER_TORSO|FEET
	inv_hide_flags = HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "red_labcoat", SLOT_ID_LEFT_HAND = "red_labcoat")

/obj/item/clothing/suit/bunny
	name = "bunny suit"
	desc = "For the authentic bouncing experience."
	icon_state = "bunnysuit"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "labcoat", SLOT_ID_LEFT_HAND = "labcoat")
	inv_hide_flags = HIDEJUMPSUIT
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS

/obj/item/clothing/suit/pharaoh
	name = "pharaoh's garb"
	desc = "Look upon my works, ye mighty, and despair."
	icon_state = "pharaoh"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "leather_coat", SLOT_ID_LEFT_HAND = "leather_coat")
	body_cover_flags = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/suit/drfreeze
	name = "cryogenic scientist coat"
	desc = "A thick coat that cannot keep your heart warm. At least you can say it looks ice."
	icon_state = "drfreeze_coat"

/obj/item/clothing/suit/snowman
	name = "snowman suit"
	desc = "A hollowed out snowman, capable of being worn, if you don't mind the chill."
	icon_state = "snowman"

/obj/item/clothing/suit/storage/toggle/holiday
	name = "holiday coat"
	desc = "A fur lined red coat. Wearing this makes you feel slightly more charitable."
	icon_state = "christmascoatr"

/obj/item/clothing/suit/storage/toggle/holiday/green
	name = "green holiday coat"
	desc = "A fur lined green coat. Wearing this makes you feel slightly more charitable."
	icon_state = "christmascoatg"

/obj/item/clothing/suit/banana
	name = "banana suit"
	desc = "There was a period in Old Earth history where this costume was seen as the peak of comedy."
	icon = 'icons/clothing/suit/costume/banana.dmi'
	icon_state = "bananasuit"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO
	inv_hide_flags = HIDEEARS|BLOCKHEADHAIR|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/suit/assassin
	name = "hashashin costume"
	desc = "Much like their namesake, modern wearers of this outfit tend to overindulge on hashish."
	icon = 'icons/clothing/suit/costume/assassin.dmi'
	icon_state = "assassin"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO
	inv_hide_flags = HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/*
 * Misc
 */
/obj/item/clothing/suit/straight_jacket
	name = "straight jacket"
	desc = "A suit that completely restrains the wearer."
	icon_state = "straight_jacket"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	inv_hide_flags = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER

	var/resist_time = 4 MINUTES

/obj/item/clothing/suit/straight_jacket/can_unequip(mob/M, slot, mob/user, flags)
	if(flags & INV_OP_DISALLOW_DELAY)
		return FALSE
	. = ..()
	if(!.)
		return FALSE
	if(slot != SLOT_ID_SUIT)
		return TRUE
	if(M != user)
		return TRUE
	. = FALSE
	INVOKE_ASYNC(user, /mob/living/carbon/human/proc/escape_straight_jacket)

/obj/item/clothing/suit/straight_jacket/equipped(var/mob/living/user,var/slot)
	. = ..()
	if(slot == SLOT_ID_SUIT)
		user.drop_all_held_items()
		user.drop_item_to_ground(user.item_by_slot(SLOT_ID_HANDCUFFED), INV_OP_FORCE)

/obj/item/clothing/suit/ianshirt
	name = "worn shirt"
	desc = "A worn out, curiously comfortable t-shirt with a picture of Ian. You wouldn't go so far as to say it feels like being hugged when you wear it but it's pretty close. Good for sleeping in."
	icon_state = "ianshirt"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "labcoat", SLOT_ID_LEFT_HAND = "labcoat") //placeholder -S2-
	body_cover_flags = UPPER_TORSO|ARMS
	inv_hide_flags = HIDETIE|HIDEHOLSTER

/obj/item/clothing/suit/nerdshirt
	name = "nerdy shirt"
	desc = "A comfy white t-shirt with a picture of a cartoon hedgehog on it. Although clean, it still seems like the wearer should be embarrassed for owning it."
	icon = 'icons/clothing/suit/misc/nerdshirt.dmi'
	icon_state = "nerdshirt"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "labcoat", SLOT_ID_LEFT_HAND = "labcoat") //placeholder -S2-
	body_cover_flags = UPPER_TORSO|ARMS
	inv_hide_flags = HIDETIE|HIDEHOLSTER
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/suit/kimono
	name = "kimono"
	desc = "A traditional Japanese kimono."
	icon_state = "kimono"
	addblends = "kimono_a"

/obj/item/clothing/suit/kamishimo
	name = "kamishimo"
	desc = "Traditional Japanese menswear."
	icon_state = "kamishimo"

/*
 * coats
 */
/obj/item/clothing/suit/leathercoat
	name = "leather coat"
	desc = "A long, thick black leather coat."
	icon_state = "leathercoat_alt"
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight, /obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes, /obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask)
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "leather_jacket", SLOT_ID_LEFT_HAND = "leather_jacket")
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/leathercoat/sec
	name = "leather coat"
	desc = "A long, thick black leather coat."
	icon_state = "leathercoat_sec"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "leather_jacket", SLOT_ID_LEFT_HAND = "leather_jacket")
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/overcoat
	name = "leather overcoat"
	desc = "A fashionable leather overcoat."
	icon_state = "leathercoat"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "wcoat", SLOT_ID_LEFT_HAND = "wcoat")
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/browncoat
	name = "brown leather coat"
	desc = "A long, brown leather coat."
	icon_state = "browncoat"
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes, /obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask)
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "brown_jacket", SLOT_ID_LEFT_HAND = "brown_jacket")
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/neocoat
	name = "black coat"
	desc = "A flowing, black coat."
	icon_state = "neocoat"
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight, /obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes, /obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask)
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "leather_jacket", SLOT_ID_LEFT_HAND = "leather_jacket")
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/customs
	name = "customs jacket"
	desc = "A standard OriCon Customs formal jacket."
	icon_state = "customs_jacket"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "suit_blue", SLOT_ID_LEFT_HAND = "suit_blue")
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/greyjacket
	name = "grey jacket"
	desc = "A fancy twead grey jacket."
	icon_state = "gentlecoat"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "leather_jacket", SLOT_ID_LEFT_HAND = "leather_jacket")
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/trench
	name = "brown trenchcoat"
	desc = "A rugged canvas trenchcoat, designed and created by TX Fabrication Corp. The coat appears to have its kevlar lining removed."
	icon_state = "detective"
	blood_overlay_type = "coat"
	allowed = list(/obj/item/gun/ballistic/sec/flash, /obj/item/tank/emergency/oxygen, /obj/item/flashlight,/obj/item/gun/energy,/obj/item/gun/ballistic,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/storage/fancy/cigarettes,/obj/item/flame/lighter,/obj/item/tape_recorder,/obj/item/uv_light)
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/trench/grey
	name = "grey trenchcoat"
	icon_state = "detective2"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "leather_jacket", SLOT_ID_LEFT_HAND = "leather_jacket")
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/toggle/peacoat
	name = "peacoat"
	desc = "A well-tailored, stylish peacoat."
	icon_state = "peacoat"
	addblends = "peacoat_a"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "peacoat", SLOT_ID_LEFT_HAND = "peacoat")
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/duster
	name = "cowboy duster"
	desc = "A duster commonly seen on cowboys from Earth's late 1800's."
	icon_state = "duster"
	blood_overlay_type = "coat"
	allowed = list(/obj/item/gun/ballistic/sec/flash, /obj/item/tank/emergency/oxygen, /obj/item/flashlight,/obj/item/gun/energy,/obj/item/gun/ballistic,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/storage/fancy/cigarettes,/obj/item/flame/lighter)
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/toggle/cardigan
	name = "cardigan"
	desc = "A cozy cardigan in a classic style."
	icon_state = "cardigan"
	addblends = "cardigan_a"
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/toggle/slimleather
	name = "slim leather coat"
	desc = "A tailored, brown leather coat."
	icon_state = "slim_leather"
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes, /obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask)
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "brown_jacket", SLOT_ID_LEFT_HAND = "brown_jacket")
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/gothcoat
	name = "gothic coat"
	desc = "A sleek black trenchcoat, paired with a stylish red scarf. Worn either by the coolest, or the weirdest."
	icon_state = "gothcoat"
	blood_overlay_type = "coat"
	allowed = list(/obj/item/gun/ballistic/sec/flash, /obj/item/tank/emergency/oxygen, /obj/item/flashlight,/obj/item/gun/energy,/obj/item/gun/ballistic,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/storage/fancy/cigarettes,/obj/item/flame/lighter,/obj/item/tape_recorder,/obj/item/uv_light)
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/toggle/navy_coat_blue
	name = "blue navy coat"
	desc = "A coat to show off your mandatory enrollment for those sweet, sweet 5% tax savings and stickers. Who sails a boat nowadays, anyway? This one is blue, which is not what the ocean's color is anymore."
	icon_state = "blue_navy_jacket"
	blood_overlay_type = "coat"
	allowed = list(/obj/item/gun/ballistic/sec/flash, /obj/item/tank/emergency/oxygen, /obj/item/flashlight,/obj/item/gun/energy,/obj/item/gun/ballistic,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/storage/fancy/cigarettes,/obj/item/flame/lighter,/obj/item/tape_recorder,/obj/item/uv_light)
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/toggle/navy_coat_brown
	name = "brown navy coat"
	desc = "A coat to show off your mandatory enrollment for those sweet, sweet 5% tax savings and stickers. Who sails a boat nowadays, anyway? This one is brown, which makes you feel like you're back in the rust-colored oceans."
	icon_state = "brown_navy_jacket"
	blood_overlay_type = "coat"
	allowed = list(/obj/item/gun/ballistic/sec/flash, /obj/item/tank/emergency/oxygen, /obj/item/flashlight,/obj/item/gun/energy,/obj/item/gun/ballistic,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/storage/fancy/cigarettes,/obj/item/flame/lighter,/obj/item/tape_recorder,/obj/item/uv_light)
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/toggle/navy_coat_green
	name = "brown navy coat"
	desc = "A coat to show off your mandatory enrollment for those sweet, sweet 5% tax savings and stickers. Who sails a boat nowadays, anyway? This one is green, like the 'vegan rations' you were dared to eat. It was actually bottom-deck gunk. It smelled nicer than this coat."
	icon_state = "green_navy_jacket"
	blood_overlay_type = "coat"
	allowed = list(/obj/item/gun/ballistic/sec/flash, /obj/item/tank/emergency/oxygen, /obj/item/flashlight,/obj/item/gun/energy,/obj/item/gun/ballistic,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/storage/fancy/cigarettes,/obj/item/flame/lighter,/obj/item/tape_recorder,/obj/item/uv_light)
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/stripe_jacket
	name = "striped jacket"
	desc = "A high collar, a gaudy stripe, clasps that don't actually work. All the ingredients to a fashionable clown! Trust me, they are /definitely/ laughing at your jokes, and not you."
	icon_state = "stripe_jacket"
	blood_overlay_type = "coat"
	allowed = list(/obj/item/gun/ballistic/sec/flash, /obj/item/tank/emergency/oxygen, /obj/item/flashlight,/obj/item/gun/energy,/obj/item/gun/ballistic,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/storage/fancy/cigarettes,/obj/item/flame/lighter,/obj/item/tape_recorder,/obj/item/uv_light)
	inv_hide_flags = HIDEHOLSTER
/*
 * stripper
 */
/obj/item/clothing/suit/stripper/stripper_pink
	name = "pink skimpy dress"
	desc = "A rather skimpy pink dress."
	icon_state = "stripper_p_over"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "pink_labcoat", SLOT_ID_LEFT_HAND = "pink_labcoat")
	siemens_coefficient = 1

/obj/item/clothing/suit/stripper/stripper_green
	name = "green skimpy dress"
	desc = "A rather skimpy green dress."
	icon_state = "stripper_g_over"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "green_labcoat", SLOT_ID_LEFT_HAND = "green_labcoat")
	siemens_coefficient = 1

/obj/item/clothing/suit/xenos
	name = "xenos suit"
	desc = "A suit made out of chitinous alien hide."
	icon_state = "xenos"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "black_suit", SLOT_ID_LEFT_HAND = "black_suit")
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	inv_hide_flags = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	siemens_coefficient = 2.0

/obj/item/clothing/suit/jacket/puffer
	name = "puffer jacket"
	desc = "A thick jacket with a rubbery, water-resistant shell."
	icon_state = "pufferjacket"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "chainmail", SLOT_ID_LEFT_HAND = "chainmail")
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/jacket/puffer/vest
	name = "puffer vest"
	desc = "A thick vest with a rubbery, water-resistant shell."
	icon_state = "puffervest"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "chainmail", SLOT_ID_LEFT_HAND = "chainmail")
	body_cover_flags = UPPER_TORSO|LOWER_TORSO
	cold_protection = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/suit/storage/miljacket
	name = "military jacket"
	desc = "A canvas jacket styled after classical American military garb. Feels sturdy, yet comfortable."
	icon_state = "militaryjacket_nobadge"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "suit_olive", SLOT_ID_LEFT_HAND = "suit_olive")
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/miljacket/tan
	name = "tan military jacket"
	desc = "A canvas jacket styled after classical American military garb. Feels sturdy, yet comfortable. Now in sandy tans for desert fans."
	icon_state = "militaryjacket_tan"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "suit_orange", SLOT_ID_LEFT_HAND = "suit_orange")
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/miljacket/grey
	name = "grey military jacket"
	desc = "A canvas jacket styled after classical American military garb. Feels sturdy, yet comfortable. This one's in urban grey."
	icon_state = "militaryjacket_grey"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "suit_grey", SLOT_ID_LEFT_HAND = "suit_grey")
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/miljacket/navy
	name = "navy military jacket"
	desc = "A canvas jacket styled after classical American military garb. Feels sturdy, yet comfortable. Dark navy, this one is."
	icon_state = "militaryjacket_navy"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "suit_navy", SLOT_ID_LEFT_HAND = "suit_navy")
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/miljacket/black
	name = "black military jacket"
	desc = "A canvas jacket styled after classical American military garb. Feels sturdy, yet comfortable. Now in tactical black."
	icon_state = "militaryjacket_black"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "suit_black", SLOT_ID_LEFT_HAND = "suit_black")
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/miljacket/alt
	name = "military jacket, alternate"
	desc = "A canvas jacket styled after classical American military garb. Feels sturdy, yet comfortable. This one has a badge on the front."
	icon_state = "militaryjacket_badge"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "suit_olive", SLOT_ID_LEFT_HAND = "suit_olive")
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/miljacket/green
	name = "dark green military jacket"
	desc = "A dark green canvas jacket. Feels sturdy, yet comfortable."
	icon_state = "militaryjacket_green"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "suit_olive", SLOT_ID_LEFT_HAND = "suit_olive")
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/miljacket/white
	name = "white military jacket"
	desc = "A white canvas jacket. Don't wear this for walks in the snow, it won't keep you warm."
	icon_state = "militaryjacket_white"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "med_dep_jacket", SLOT_ID_LEFT_HAND = "med_dep_jacket")
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/toggle/bomber
	name = "bomber jacket"
	desc = "A thick, well-worn WW2 leather bomber jacket."
	icon_state = "bomber"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "brown_jacket", SLOT_ID_LEFT_HAND = "brown_jacket")
	allowed = list (/obj/item/gun/ballistic/sec/flash, /obj/item/pen, /obj/item/paper, /obj/item/flashlight, /obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes, /obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask)
	body_cover_flags = UPPER_TORSO|ARMS
	inv_hide_flags = HIDEHOLSTER
	cold_protection = UPPER_TORSO|ARMS
	min_cold_protection_temperature = T0C - 20
	siemens_coefficient = 0.7

/obj/item/clothing/suit/storage/bomber/alt
	name = "bomber jacket"
	desc = "A thick, well-worn WW2 leather bomber jacket."
	icon_state = "bomberjacket_new"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "brown_jacket", SLOT_ID_LEFT_HAND = "brown_jacket")
	body_cover_flags = UPPER_TORSO|ARMS
	inv_hide_flags = HIDEHOLSTER
	cold_protection = UPPER_TORSO|ARMS
	min_cold_protection_temperature = T0C - 20
	siemens_coefficient = 0.7

/obj/item/clothing/suit/storage/toggle/leather_jacket
	name = "leather jacket"
	desc = "A black leather coat."
	icon_state = "leather_jacket"
	allowed = list (/obj/item/gun/ballistic/sec/flash, /obj/item/pen, /obj/item/paper, /obj/item/flashlight, /obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes, /obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask)
	body_cover_flags = UPPER_TORSO|ARMS
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/toggle/leather_jacket/sleeveless
	name = "leather vest"
	desc = "A black leather vest."
	icon_state = "leather_jacket_sleeveless"
	body_cover_flags = UPPER_TORSO
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "leather_jacket", SLOT_ID_LEFT_HAND = "leather_jacket")

/obj/item/clothing/suit/storage/leather_jacket_alt
	name = "leather vest"
	desc = "A black leather vest."
	icon_state = "leather_jacket_alt"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "leather_jacket", SLOT_ID_LEFT_HAND = "leather_jacket")
	body_cover_flags = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen
	desc = "A black leather coat. A corporate logo is proudly displayed on the back."
	icon_state = "leather_jacket_nt"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "leather_jacket", SLOT_ID_LEFT_HAND = "leather_jacket")

/obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen/sleeveless
	name = "leather vest"
	desc = "A black leather vest. A corporate logo is proudly displayed on the back."
	icon_state = "leather_jacket_nt_sleeveless"
	body_cover_flags = UPPER_TORSO
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "leather_jacket", SLOT_ID_LEFT_HAND = "leather_jacket")

//This one has buttons for some reason
/obj/item/clothing/suit/storage/toggle/brown_jacket
	name = "brown jacket"
	desc = "A brown leather coat."
	icon_state = "brown_jacket"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "brown_jacket", SLOT_ID_LEFT_HAND = "brown_jacket")
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes, /obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask)
	body_cover_flags = UPPER_TORSO|ARMS
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/toggle/brown_jacket/sleeveless
	name = "brown vest"
	desc = "A brown leather vest."
	icon_state = "brown_jacket_sleeveless"
	body_cover_flags = UPPER_TORSO
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "brown_jacket", SLOT_ID_LEFT_HAND = "brown_jacket")

/obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen
	desc = "A brown leather coat. A corporate logo is proudly displayed on the back."
	icon_state = "brown_jacket_nt"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "brown_jacket", SLOT_ID_LEFT_HAND = "brown_jacket")

/obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen/sleeveless
	name = "brown vest"
	desc = "A brown leather vest. A corporate logo is proudly displayed on the back."
	icon_state = "brown_jacket_nt_sleeveless"
	body_cover_flags = UPPER_TORSO
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "brown_jacket", SLOT_ID_LEFT_HAND = "brown_jacket")

/obj/item/clothing/suit/storage/toggle/denim_jacket
	name = "denim jacket"
	desc = "A denim coat."
	icon_state = "denim_jacket"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "denim_jacket", SLOT_ID_LEFT_HAND = "denim_jacket")
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes, /obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask)
	body_cover_flags = UPPER_TORSO|ARMS
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/toggle/denim_jacket/sleeveless
	name = "denim vest"
	desc = "A denim vest."
	icon_state = "denim_jacket_sleeveless"
	body_cover_flags = UPPER_TORSO
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "denim_jacket", SLOT_ID_LEFT_HAND = "denim_jacket")

/obj/item/clothing/suit/storage/toggle/denim_jacket/nanotrasen
	desc = "A denim coat. A corporate logo is proudly displayed on the back."
	icon_state = "denim_jacket_nt"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "denim_jacket", SLOT_ID_LEFT_HAND = "denim_jacket")

/obj/item/clothing/suit/storage/toggle/denim_jacket/nanotrasen/sleeveless
	name = "denim vest"
	desc = "A denim vest. A corporate logo is proudly displayed on the back."
	icon_state = "denim_jacket_nt_sleeveless"
	body_cover_flags = UPPER_TORSO
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "denim_jacket", SLOT_ID_LEFT_HAND = "denim_jacket")

/obj/item/clothing/suit/storage/toggle/hoodie
	name = "grey hoodie"
	desc = "A warm, grey sweatshirt."
	icon_state = "grey_hoodie"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "suit_grey", SLOT_ID_LEFT_HAND = "suit_grey")
	min_cold_protection_temperature = T0C - 20
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/toggle/hoodie/black
	name = "black hoodie"
	desc = "A warm, black sweatshirt."
	icon_state = "black_hoodie"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "suit_black", SLOT_ID_LEFT_HAND = "suit_black")

/obj/item/clothing/suit/storage/toggle/hoodie/red
	name = "red hoodie"
	desc = "A warm, red sweatshirt."
	icon_state = "red_hoodie"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "suit_red", SLOT_ID_LEFT_HAND = "suit_red")

/obj/item/clothing/suit/storage/toggle/hoodie/blue
	name = "blue hoodie"
	desc = "A warm, blue sweatshirt."
	icon_state = "blue_hoodie"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "suit_blue", SLOT_ID_LEFT_HAND = "suit_blue")

/obj/item/clothing/suit/storage/toggle/hoodie/green
	name = "green hoodie"
	desc = "A warm, green sweatshirt."
	icon_state = "green_hoodie"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "suit_olive", SLOT_ID_LEFT_HAND = "suit_olive")

/obj/item/clothing/suit/storage/toggle/hoodie/orange
	name = "orange hoodie"
	desc = "A warm, orange sweatshirt."
	icon_state = "orange_hoodie"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "suit_orange", SLOT_ID_LEFT_HAND = "suit_orange")

/obj/item/clothing/suit/storage/toggle/hoodie/yellow
	name = "yellow hoodie"
	desc = "A warm, yellow sweatshirt."
	icon_state = "yellow_hoodie"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "suit_yellow", SLOT_ID_LEFT_HAND = "suit_yellow")

/obj/item/clothing/suit/storage/toggle/hoodie/white
	name = "white hoodie"
	desc = "A warm, white sweatshirt."
	icon_state = "white_hoodie"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "suit_white", SLOT_ID_LEFT_HAND = "suit_white")

/obj/item/clothing/suit/storage/toggle/hoodie/cti
	name = "CTI hoodie"
	desc = "A warm, black sweatshirt.  It bears the letters CTI on the back, a lettering to the prestigious university in Tau Ceti, Ceti Technical Institute.  There is a blue supernova embroidered on the front, the emblem of CTI."
	icon_state = "cti_hoodie"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "suit_black", SLOT_ID_LEFT_HAND = "suit_black")

/obj/item/clothing/suit/storage/toggle/hoodie/mu
	name = "mojave university hoodie"
	desc = "A warm, gray sweatshirt.  It bears the letters MU on the front, a lettering to the well-known public college, Mojave University."
	icon_state = "mu_hoodie"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "suit_grey", SLOT_ID_LEFT_HAND = "suit_grey")

/obj/item/clothing/suit/storage/toggle/hoodie/nt
	name = "NT hoodie"
	desc = "A warm, blue sweatshirt.  It proudly bears the silver NanoTrasen insignia lettering on the back.  The edges are trimmed with silver."
	icon_state = "nt_hoodie"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "suit_blue", SLOT_ID_LEFT_HAND = "suit_blue")

/obj/item/clothing/suit/storage/toggle/hoodie/smw
	name = "Space Mountain Wind hoodie"
	desc = "A warm, black sweatshirt.  It has the logo for the popular softdrink Space Mountain Wind on both the front and the back."
	icon_state = "smw_hoodie"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "suit_black", SLOT_ID_LEFT_HAND = "suit_black")

/obj/item/clothing/suit/storage/toggle/hoodie/nrti
	name = "New Reykjavik Technical Institute hoodie"
	desc = "A warm, gray sweatshirt. It bears the letters NRT on the back, in reference to Sif's premiere technical institute."
	icon_state = "nrti_hoodie"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "suit_grey", SLOT_ID_LEFT_HAND = "suit_grey")

/obj/item/clothing/suit/whitedress
	name = "white dress"
	desc = "A fancy dress."
	icon_state = "white_dress"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "white_dress", SLOT_ID_LEFT_HAND = "white_dress")
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS
	inv_hide_flags = HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER

/obj/item/clothing/suit/varsity
	name = "black varsity jacket"
	desc = "A favorite of jocks everywhere from Sol to Nyx."
	icon_state = "varsity"
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes, /obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask)
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "suit_black", SLOT_ID_LEFT_HAND = "suit_black")
	inv_hide_flags = HIDETIE|HIDEHOLSTER

/obj/item/clothing/suit/varsity/red
	name = "red varsity jacket"
	icon_state = "varsity_red"

/obj/item/clothing/suit/varsity/purple
	name = "purple varsity jacket"
	icon_state = "varsity_purple"

/obj/item/clothing/suit/varsity/green
	name = "green varsity jacket"
	icon_state = "varsity_green"

/obj/item/clothing/suit/varsity/blue
	name = "blue varsity jacket"
	icon_state = "varsity_blue"

/obj/item/clothing/suit/varsity/brown
	name = "brown varsity jacket"
	icon_state = "varsity_brown"

/*
 * Department Jackets
 */
/obj/item/clothing/suit/storage/toggle/sec_dep_jacket
	name = "department jacket, security"
	desc = "A cozy jacket in security's colors. Show your department pride!"
	icon_state = "sec_dep_jacket"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "sec_dep_jacket", SLOT_ID_LEFT_HAND = "sec_dep_jacket")
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/toggle/engi_dep_jacket
	name = "department jacket, engineering"
	desc = "A cozy jacket in engineering's colors. Show your department pride!"
	icon_state = "engi_dep_jacket"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "engi_dep_jacket", SLOT_ID_LEFT_HAND = "engi_dep_jacket")
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/toggle/supply_dep_jacket
	name = "department jacket, supply"
	desc = "A cozy jacket in supply's colors. Show your department pride!"
	icon_state = "supply_dep_jacket"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "supply_dep_jacket", SLOT_ID_LEFT_HAND = "supply_dep_jacket")
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/toggle/sci_dep_jacket
	name = "department jacket, science"
	desc = "A cozy jacket in science's colors. Show your department pride!"
	icon_state = "sci_dep_jacket"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "sci_dep_jacket", SLOT_ID_LEFT_HAND = "sci_dep_jacket")
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/toggle/med_dep_jacket
	name = "department jacket, medical"
	desc = "A cozy jacket in medical's colors. Show your department pride!"
	icon_state = "med_dep_jacket"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "med_dep_jacket", SLOT_ID_LEFT_HAND = "med_dep_jacket")
	inv_hide_flags = HIDEHOLSTER

/*
 * Track Jackets
 */
/obj/item/clothing/suit/storage/toggle/track
	name = "track jacket"
	desc = "A track jacket, for the athletic."
	icon_state = "trackjacket"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "black_labcoat", SLOT_ID_LEFT_HAND = "black_labcoat")
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes, /obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask)

/obj/item/clothing/suit/storage/toggle/track/blue
	name = "blue track jacket"
	icon_state = "trackjacketblue"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "blue_labcoat", SLOT_ID_LEFT_HAND = "blue_labcoat")


/obj/item/clothing/suit/storage/toggle/track/green
	name = "green track jacket"
	icon_state = "trackjacketgreen"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "green_labcoat", SLOT_ID_LEFT_HAND = "green_labcoat")

/obj/item/clothing/suit/storage/toggle/track/red
	name = "red track jacket"
	icon_state = "trackjacketred"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "red_labcoat", SLOT_ID_LEFT_HAND = "red_labcoat")

/obj/item/clothing/suit/storage/toggle/track/white
	name = "white track jacket"
	icon_state = "trackjacketwhite"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "labcoat", SLOT_ID_LEFT_HAND = "labcoat")

//Flannels

/obj/item/clothing/suit/storage/flannel
	name = "Flannel shirt"
	desc = "A comfy, grey flannel shirt.  Unleash your inner hipster."
	icon_state = "flannel"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "black_labcoat", SLOT_ID_LEFT_HAND = "black_labcoat")
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes, /obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask)
	inv_hide_flags = HIDEHOLSTER
	var/rolled = 0
	var/tucked = 0
	var/buttoned = 0

/obj/item/clothing/suit/storage/flannel/verb/roll_sleeves()
	set name = "Roll Sleeves"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living))
		return
	if(usr.stat)
		return

	if(rolled == 0)
		rolled = 1
		body_cover_flags &= ~(ARMS)
		to_chat(usr, "<span class='notice'>You roll up the sleeves of your [src].</span>")
	else
		rolled = 0
		body_cover_flags = initial(body_cover_flags)
		to_chat(usr, "<span class='notice'>You roll down the sleeves of your [src].</span>")
	update_icon()

/obj/item/clothing/suit/storage/flannel/verb/tuck()
	set name = "Toggle Shirt Tucking"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)||usr.stat)
		return

	if(tucked == 0)
		tucked = 1
		to_chat(usr, "<span class='notice'>You tuck in your your [src].</span>")
	else
		tucked = 0
		to_chat(usr, "<span class='notice'>You untuck your [src].</span>")
	update_icon()

/obj/item/clothing/suit/storage/flannel/verb/button()
	set name = "Toggle Shirt Buttons"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)||usr.stat)
		return

	if(buttoned == 0)
		buttoned = 1
		inv_hide_flags = HIDETIE|HIDEHOLSTER
		to_chat(usr, "<span class='notice'>You button your [src].</span>")
	else
		buttoned = 0
		inv_hide_flags = HIDEHOLSTER
		to_chat(usr, "<span class='notice'>You unbutton your [src].</span>")
	update_icon()

/obj/item/clothing/suit/storage/flannel/update_icon()
	icon_state = initial(icon_state)
	if(rolled)
		icon_state += "r"
	if(tucked)
		icon_state += "t"
	if(buttoned)
		icon_state += "b"
	update_worn_icon()

/obj/item/clothing/suit/storage/flannel/red
	desc = "A comfy, red flannel shirt.  Unleash your inner hipster."
	icon_state = "flannel_red"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "red_labcoat", SLOT_ID_LEFT_HAND = "red_labcoat")

/obj/item/clothing/suit/storage/flannel/aqua
	desc = "A comfy, aqua flannel shirt.  Unleash your inner hipster."
	icon_state = "flannel_aqua"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "blue_labcoat", SLOT_ID_LEFT_HAND = "blue_labcoat")

/obj/item/clothing/suit/storage/flannel/brown
	desc = "A comfy, brown flannel shirt.  Unleash your inner hipster."
	icon_state = "flannel_brown"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "johnny", SLOT_ID_LEFT_HAND = "johnny")

//Green Uniform

/obj/item/clothing/suit/storage/toggle/greengov
	name = "green formal jacket"
	desc = "A sleek proper formal jacket with gold buttons."
	icon_state = "suitjacket_green"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "suit_olive", SLOT_ID_LEFT_HAND = "suit_olive")
	blood_overlay_type = "coat"
	body_cover_flags = UPPER_TORSO|ARMS
	inv_hide_flags = HIDEHOLSTER

/obj/item/clothing/suit/storage/snowsuit
	name = "snowsuit"
	desc = "A suit made to keep you nice and toasty on cold winter days. Or at least alive."
	icon_state = "snowsuit"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "labcoat", SLOT_ID_LEFT_HAND = "labcoat")
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS
	inv_hide_flags = HIDEHOLSTER
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	allowed = list (/obj/item/gun/ballistic/sec/flash, /obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes, /obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask)

/obj/item/clothing/suit/storage/snowsuit/command
	name = "command snowsuit"
	icon_state = "snowsuit_command"

/obj/item/clothing/suit/storage/snowsuit/security
	name = "security snowsuit"
	icon_state = "snowsuit_security"

/obj/item/clothing/suit/storage/snowsuit/medical
	name = "medical snowsuit"
	icon_state = "snowsuit_medical"

/obj/item/clothing/suit/storage/snowsuit/engineering
	name = "engineering snowsuit"
	icon_state = "snowsuit_engineering"

/obj/item/clothing/suit/storage/snowsuit/cargo
	name = "cargo snowsuit"
	icon_state = "snowsuit_cargo"

/obj/item/clothing/suit/storage/snowsuit/science
	name = "science snowsuit"
	icon_state = "snowsuit_science"

/obj/item/clothing/suit/storage/bridgeofficer
	name = "bridge officer dress jacket"
	desc = "A dress jacket for those ranked high enough to stand at the bridge, but not high enough to touch any buttons."
	icon_state = "bridgeofficer_jacket"

/obj/item/clothing/suit/storage/dutchcoat
	name = "western coat"
	desc = "When I'm gone, they'll just find another coat. They have to. Because they have to justify their wages."
	icon_state = "DutchJacket"

/obj/item/clothing/suit/storage/tailcoat
	name = "tailcoat"
	desc = "Even the clown wouldn't wear this, you can, if you really want to."
	icon_state = "tailcoat"

/obj/item/clothing/suit/storage/ladiesvictoriancoat
	name = "ladies victorian coat"
	desc = "I'm in no hurry, I've got all day. And I'm not going to kill you until you say..something...nice."
	icon_state = "ladiesvictoriancoat"

/obj/item/clothing/suit/storage/redladiesvictoriancoat
	name = "ladies red victorian coat"
	desc = "Give a good man firepower, and he'll never run out of people to kill."
	icon_state = "ladiesredvictoriancoat"

/obj/item/clothing/suit/storage/ecdress_ofcr
	name = "bridge officer parade jacket"
	desc = "For those times when you need to properly look like you aren't a glorified assistant."
	icon_state = "ecdress_ofcr"

/obj/item/clothing/suit/mr_snuggles
	name = "Mr. Snuggles Suit"
	desc = "A padded suit for restraining patients without bumming everyone out!"
	icon_state = "mr_snuggles"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	inv_hide_flags = HIDEEARS|BLOCKHEADHAIR|HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER

	var/resist_time = 4800	// Eight minutes.

/obj/item/clothing/suit/mrs_snuggles
	name = "Mrs. Snuggles Suit"
	desc = "A padded suit for restraining patients without bumming everyone out!"
	icon_state = "mrs_snuggles"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	inv_hide_flags = HIDEEARS|BLOCKHEADHAIR|HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER

	var/resist_time = 4800	// Eight minutes.



/obj/item/clothing/suit/storage/toggle/operations_coat
	name = "Security Operations Jacket"
	desc = "A uniform jacket from the United Federation. Starfleet still uses this uniform and there are variations of it. Set phasers to awesome."
	icon_state = "fedcoat"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS
	allowed = list(
				/obj/item/tank/emergency/oxygen,
				/obj/item/flashlight,
				/obj/item/gun/energy,
				/obj/item/gun/ballistic,
				/obj/item/ammo_magazine,
				/obj/item/ammo_casing,
//				/obj/item/storage/fancy/shotgun_ammo,
				/obj/item/melee/baton,
				/obj/item/handcuffs,
//				/obj/item/detective_scanner,
				/obj/item/tape_recorder)
	var/unbuttoned = 0

/*
/obj/item/clothing/suit/storage/toggle/operations_coat/verb/toggle()
	set name = "Toggle coat buttons"
	set category = "Object"
	set src in usr

	if(!usr.canmove || usr.stat || usr.restrained())
		return 0

	switch(unbuttoned)
		if(0)
			icon_state = "[initial(icon_state)]_open"
			item_state = "[initial(item_state)]_open"
			unbuttoned = 1
			to_chat(usr, "You unbutton the coat.")
		if(1)
			icon_state = "[initial(icon_state)]"
			item_state = "[initial(item_state)]"
			unbuttoned = 0
			to_chat(usr, "You button up the coat.")
	usr.update_inv_wear_suit()
*/


/obj/item/clothing/suit/storage/toggle/operations_coat/medsci
	name = "Medical/Science Operations Jacket"
	desc = "A jacket issued to Medical and Science staff on NT vessels.."
	icon_state = "fedblue"

/obj/item/clothing/suit/storage/toggle/operations_coat/engineering
	name = "Engineering Operations Jacket"
	desc = "A jacket issued to Engineering staff on NT vessels."
	icon_state = "fedeng"

/obj/item/clothing/suit/storage/toggle/operations_coat/command
	name = "Command Operations Jacket"
	desc = "A jacket issued to Command staff on NT vessels."
	icon_state = "fedcapt"

/obj/item/clothing/suit/storage/modern_operations_coat
	name = "Modern Command Operations Jacket"
	desc = "A jacket issued to Command staff on NT vessels. This one is modern."
	icon_state = "fedmodern"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS
	allowed = list(
				/obj/item/tank/emergency/oxygen,
				/obj/item/flashlight,
				/obj/item/gun/energy,
				/obj/item/gun/ballistic,
				/obj/item/ammo_magazine,
				/obj/item/ammo_casing,
//				/obj/item/storage/fancy/shotgun_ammo,
				/obj/item/melee/baton,
				/obj/item/handcuffs,
//				/obj/item/detective_scanner,
				/obj/item/tape_recorder)

/obj/item/clothing/suit/storage/modern_operations_coat/medsci
	name = "Modern Medical/Science Operations Jacket"
	desc = "A jacket issued to Medical and Science staff on NT vessels. This one is modern."
	icon_state = "fedmodernblue"

/obj/item/clothing/suit/storage/modern_operations_coat/engineering
	name = "Modern Engineering Operations Jacket"
	desc = "A jacket issued to Engineering staff on NT vessels. This one is modern."
	icon_state = "fedmoderneng"

/obj/item/clothing/suit/storage/modern_operations_coat/security
	name = "Modern Security Operations Jacket"
	desc = "A jacket issued to Security staff on NT vessels. This one is modern."
	icon_state = "fedmodernsec"

/obj/item/clothing/suit/highwayman_jacket
	name = "Civilian Highwayman Jacket"
	desc = "A black jacket with a white, fur lined neck. For dashing rogues who dare to plunder the deepest dungeons."
	icon_state = "highwayman_jacket"

/obj/item/clothing/suit/colonial_redcoat
	name = "Colonial Red Coat"
	desc = "A thick cotton long coat, adorned with antique buttons. Dyed a brilliant red, it's hard not to be seen in this."
	icon_state = "pineapple_trench"

/obj/item/clothing/suit/samurai_replica
	name = "replica karuta-gane"
	desc = "An utterly ancient suit of Earth armor, reverently maintained and restored over the years. This appears less sturdy than the authentic article."
	icon_state = "samurai_colorable"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "leather_coat", SLOT_ID_LEFT_HAND = "leather_coat")
	w_class = ITEMSIZE_LARGE
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	inv_hide_flags = HIDETIE|HIDEHOLSTER

/obj/item/clothing/suit/laconic
	name = "laconic field coat"
	desc = "A hardy coat designed to protect its wearer as much in the lab as on an expedition."
	icon_state = "laconic"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "labcoat", SLOT_ID_LEFT_HAND = "labcoat")
	body_cover_flags = UPPER_TORSO|ARMS
	valid_accessory_slots = (\
		ACCESSORY_SLOT_OVER\
		|ACCESSORY_SLOT_UTILITY)

/obj/item/clothing/suit/imperial_replica
	name = "replica imperial soldier armor"
	desc = "Made out of an especially light metal, it lets you conquer in style. This appears less sturdy than the authentic article."
	icon_state = "ge_armor"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/suit/imperial/officer_replica
	name = "replica imperial officer armor"
	desc = "Not all heroes wear capes, but it'd be cooler if they did. This appears less sturdy than the authentic article."
	icon_state = "ge_armorcent"

/obj/item/clothing/suit/darkfur
	name = "vexatious coat"
	desc = "A sleek jacket with a dark fur lining around the collar. All the rage on Infernum."
	icon_state = "darkfur_jacket"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "coatwinter", SLOT_ID_LEFT_HAND = "coatwinter")
	body_cover_flags = UPPER_TORSO|ARMS
	valid_accessory_slots = (\
		ACCESSORY_SLOT_OVER\
		|ACCESSORY_SLOT_UTILITY)

/obj/item/clothing/suit/ashen_vestment
	name = "ashen vestments"
	desc = "These flowing red robes mark the wearer as a member of the Scori Priesthood. Lightweight and well ventilated, the edges of the fabric are stained with ash."
	icon = 'icons/clothing/suit/ashlander.dmi'
	icon_state = "archon_robe"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/suit/ashen_tabard
	name = "ashen tabard"
	desc = "This style of tabard is sometimes worn by Scori Guardians when not on duty. Other unidentified Scori have been seen wearing them, making the tabard's true significance unclear."
	icon = 'icons/clothing/suit/ashlander.dmi'
	icon_state = "crimson_tabard"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

//Main's Formal Coats
/obj/item/clothing/suit/storage/parade_coat
	name = "captain's formal jerkin"
	desc = "A stylish jerkin made out of a fine, yet durable, felt. Gold embroidery and polished buttons make this gleam elegantly."
	icon_state = "capformal"

/obj/item/clothing/suit/storage/parade_coat/fem
	name = "captain's formal jerkin"
	desc = "A stylish jerkin made out of a fine, yet durable, felt. Gold embroidery and polished buttons make this gleam elegantly."
	icon_state = "capformal_f"

/obj/item/clothing/suit/storage/parade_coat/hos
	name = "head of security's formal jerkin"
	desc = "A stylish jerkin made out of a fine, yet durable, felt. Gold embroidery and polished buttons make this gleam elegantly."
	icon_state = "hosformal"

/obj/item/clothing/suit/storage/parade_coat/hos_fem
	name = "head of security's formal jerkin"
	desc = "A stylish jerkin made out of a fine, yet durable, felt. Gold embroidery and polished buttons make this gleam elegantly."
	icon_state = "hosformal_f"

/obj/item/clothing/suit/storage/parade_coat/centcom
	name = "head of security's formal jerkin"
	desc = "A stylish jerkin made out of a fine, yet durable, felt. Gold embroidery and polished buttons make this gleam elegantly."
	icon_state = "centcomformal"

/obj/item/clothing/suit/storage/parade_coat/centcom_fem
	name = "central command officer's formal jerkin"
	desc = "A stylish jerkin made out of a fine, yet durable, felt. Gold embroidery and polished buttons make this gleam elegantly."
	icon_state = "centcomformal_f"

//Someone's on the line.
/obj/item/clothing/suit/storage/toggle/letterman
	name = "worn letterman jacket"
	desc = "A worn varsity letterman jacket. Some of the faded stains around the cuffs are rather suspicious."
	icon_state = "varsity_letterman"

/obj/item/clothing/suit/storage/pullover
	name = "pullover hoodie"
	desc = "A plain-colored hoodie with no zipper to speak of. The exonet debate on whether it's hotter to watch one get pulled off or zipped open still rages on. You could prove one of the sides right today!"
	icon_state = "hoodie_pullover"

/obj/item/clothing/suit/storage/pullover/nt
	name = "pullover hoodie (NT)"
	desc = "A plain-colored hoodie with no zipper to speak of. The exonet debate on whether it's hotter to watch one get pulled off or zipped open still rages on. You could prove one of the sides right today! This one is dyed in NT colors and has the trademark NanoTrasen logo!"
	icon_state = "hoodie_pullover_NT"

/obj/item/clothing/suit/storage/umbral
	name = "Umbral Duster"
	desc = "This thick duster, constructed out of black leather and red suede, presents an utterly demonic profile. Adorned with chased silver chains, anchored into the very fabric itself in the device of an esoteric skull, this jacket will fit in anywhere. As long as it's a leather club or metal concert."
	icon_state = "umbral"

/obj/item/clothing/suit/storage/mekkyaku
	name = "Mekkyaku hoodie"
	desc = "This crisp white hoodie bears a strange manufacturer's mark. The colorful red accents stand out against the snowy white cloth with evocative flair."
	icon_state = "mekkyaku"

/obj/item/clothing/suit/storage/utility_fur_coat
	name = "Utility Fur Coat"
	desc = "A form fitting utilitarion coat with straps around the shoulders and holding a sash around the waist. The collar is lined with fur to help stay warm."
	icon_state = "fur_utility"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit)

/obj/item/clothing/suit/storage/mindelectric
	name = "「 The Mind Electric 」"
	desc = "A set of cybernetic upgrades of an alien origin, this peculiar jacket reads the user's nerver in order to control a set of drones as if they were an additional set of less dexterous hands. Attached terminals buzz with bizarre symbols that appear to form an incomprehensibly complex pattern."
	item_state = "mindelectric_w"
	icon_state = "mindelectric"

//The Chippin' In Set -Cap
/obj/item/clothing/suit/storage/runner/half_moon
	name = "Half Moon Jacket"
	desc = "Lightweight and fashionable, this low-profile jacket blends in while still making a statement. Its stark coloration is reminiscent of Luna."
	icon_state = "half_moon"

/obj/item/clothing/suit/storage/hobo
	name = "ragged coat"
	desc = "Although hopping trains is no longer en vogue, the Frontier has its fill of vagabonds and drifters. Many are stuck wearing the clothes they first brought with them."
	icon = 'icons/clothing/suit/misc/hobo.dmi'
	icon_state = "hobocoat"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/suit/storage/kamina
	name = "spiral hero cloak"
	desc = "Don't believe in yourself. Believe in the me that believes in you."
	icon = 'icons/clothing/uniform/costume/spiral.dmi'
	icon_state = "kaminacape"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
