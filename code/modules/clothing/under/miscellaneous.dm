/obj/item/clothing/under/customs
	name = "customs uniform"
	desc = "A standard OriCon customs uniform.  Complete with epaulettes."
	icon_state = "cu_suit"

/obj/item/clothing/under/customs/khaki
	icon_state = "cu_suit_kh"

/obj/item/clothing/under/space
	name = "\improper NASA jumpsuit"
	desc = "It has a NASA logo on it and is made of space-proofed materials."
	icon_state = "black"
	w_class = WEIGHT_CLASS_BULKY//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	cold_protection_cover = UPPER_TORSO | LOWER_TORSO | LEGS | ARMS //Needs gloves and shoes with cold protection to be fully protected.
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/under/acj
	name = "administrative cybernetic jumpsuit"
	icon_state = "syndicate"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "black", SLOT_ID_LEFT_HAND = "black")
	desc = "it's a cybernetically enhanced jumpsuit used for administrative duties."
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	armor_type = /datum/armor/invulnerable
	cold_protection_cover = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

/obj/item/clothing/under/psysuit
	name = "dark undersuit"
	desc = "A thick, layered grey undersuit lined with power cables. Feels a little like wearing an electrical storm."
	icon_state = "psysuit"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "black", SLOT_ID_LEFT_HAND = "black")
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/under/schoolgirl
	name = "frilly blue skirt" //Citadel change REEEFETISHCONTENT
	desc = "A clean white shirt with a blue collar and skirt. Looks like something out of an anime." //Citadel change REEEFETISHCONTENT
	icon_state = "schoolgirl"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "blue", SLOT_ID_LEFT_HAND = "blue")
	body_cover_flags = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/schoolgirl/red
	name = "frilly red skirt" //Citadel change REEEFETISHCONTENT
	desc = "A clean white shirt with a red collar and skirt. Looks like something out of an anime." //Citadel change REEEFETISHCONTENT
	icon_state = "schoolgirlred"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "red", SLOT_ID_LEFT_HAND = "red")

/obj/item/clothing/under/schoolgirl/green
	name = "frilly green skirt" //Citadel change REEEFETISHCONTENT
	desc = "A clean white shirt with a green collar and skirt. Looks like something out of an anime." //Citadel change REEEFETISHCONTENT
	icon_state = "schoolgirlgreen"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "green", SLOT_ID_LEFT_HAND = "green")
	body_cover_flags = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/schoolgirl/orange
	name = "frilly orange skirt" //Citadel change REEEFETISHCONTENT
	desc = "A clean white shirt with a orange collar and skirt. Looks like something out of an anime." //Citadel change REEEFETISHCONTENT
	icon_state = "schoolgirlorange"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "orange", SLOT_ID_LEFT_HAND = "orange")
	body_cover_flags = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/schoolgirl/pink
	name = "frilly pink skirt" //Citadel change REEEFETISHCONTENT
	desc = "A clean white shirt with a pink collar and skirt. Looks like something out of an anime." //Citadel change REEEFETISHCONTENT
	icon_state = "schoolgirlpink"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "pink", SLOT_ID_LEFT_HAND = "pink")
	body_cover_flags = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/overalls
	name = "laborer's overalls"
	desc = "A set of durable overalls for getting the job done."
	icon_state = "overalls"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "cargo", SLOT_ID_LEFT_HAND = "cargo")

/obj/item/clothing/under/overalls_fem
	name = "laborer's overalls"
	desc = "A set of durable overalls for getting the job done."
	icon_state = "overalls_fem"

/obj/item/clothing/under/overalls/sleek
	name = "sleek overalls"
	desc = "A set of modern pleather reinforced overalls."
	icon_state = "overalls_sleek"

/obj/item/clothing/under/overalls/sleek_fem
	name = "sleek overalls"
	desc = "A set of modern pleather reinforced overalls."
	icon_state = "overalls_sleek_fem"

/obj/item/clothing/under/pirate
	name = "pirate outfit"
	desc = "Yarr."
	icon_state = "pirate"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "sl_suit", SLOT_ID_LEFT_HAND = "sl_suit")
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/under/moderncoat
	name = "modern wrapped coat"
	desc = "The cutting edge of fashion."
	icon_state = "moderncoat"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "red", SLOT_ID_LEFT_HAND = "red")
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/under/dress/black_corset
	name = "black corset and skirt"
	desc = "A black corset and skirt for those fancy nights out."
	icon_state = "black_corset"

/obj/item/clothing/under/serviceoveralls
	name = "workman outfit"
	desc = "The very image of a working man. Not that you're probably doing work."
	icon_state = "mechanic"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "cargo", SLOT_ID_LEFT_HAND = "cargo")

/obj/item/clothing/under/croptop
	name = "crop top"
	desc = "A shirt that has had the top cropped. This one is NT sponsored."
	icon_state = "croptop"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "grey", SLOT_ID_LEFT_HAND = "grey")

/obj/item/clothing/under/croptop/red
	name = "red crop top"
	desc = "A red shirt that has had the top cropped."
	icon_state = "croptop_red"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "red", SLOT_ID_LEFT_HAND = "red")

/obj/item/clothing/under/croptop/grey
	name = "grey crop top"
	desc = "A grey shirt that has had the top cropped."
	icon_state = "croptop_grey"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "grey", SLOT_ID_LEFT_HAND = "grey")

/obj/item/clothing/under/cuttop
	name = "grey cut top"
	desc = "A grey shirt that has had the top cut low."
	icon_state = "cuttop"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "grey", SLOT_ID_LEFT_HAND = "grey")

/obj/item/clothing/under/cuttop/red
	name = "red cut top"
	desc = "A red shirt that has had the top cut low."
	icon_state = "cuttop_red"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "red", SLOT_ID_LEFT_HAND = "red")

/obj/item/clothing/under/frontier
	name = "frontier clothes"
	desc = "A rugged flannel shirt and denim overalls. A popular style among frontier colonists."
	icon_state = "frontier"
	snowflake_worn_state = "frontier"

/obj/item/clothing/under/rank/psych/turtleneck/sweater
	desc = "A warm looking sweater and a pair of dark blue slacks."
	name = "sweater"
	icon_state = "turtleneck"
	snowflake_worn_state = "turtleneck"

/obj/item/clothing/under/rank/psych/turtleneck/sweater
	desc = "A warm looking sweater and a pair of dark blue slacks."
	name = "sweater"
	icon_state = "turtleneck_fem"
	snowflake_worn_state = "turtleneck_fem"

//And this is where the real game begins
/obj/item/clothing/under/future_fashion
	name = "Futuristic Dark Blue-Striped Jumpsuit"
	desc = "Show your love for the fasion of today viewed through the lens of yesterday! All come in black, but this one has dark blue stripes."
	icon = 'icons/clothing/uniform/misc/future.dmi'
	worn_has_rolldown = UNIFORM_HAS_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_NO_RENDER | WORN_RENDER_INHAND_ALLOW_DEFAULT
	worn_bodytypes = BODYTYPE_DEFAULT
	inhand_default_type = INHAND_DEFAULT_ICON_UNIFORMS
	inhand_state = "jensen"
	icon_state = "dark_blue"

/obj/item/clothing/under/future_fashion/green_striped
	name = "Futuristic Green-Striped Jumpsuit"
	desc = "Show your love for the fasion of today viewed through the lens of yesterday! All come in black, but this one has green stripes."
	icon_state = "green"

/obj/item/clothing/under/future_fashion/light_blue_striped
	name = "Futuristic Light Blue-Striped Jumpsuit"
	desc = "Show your love for the fasion of today viewed through the lens of yesterday! All come in black, but this one has light blue stripes."
	icon_state = "light_blue"

/obj/item/clothing/under/future_fashion/orange_striped
	name = "Futuristic Orange-Striped Jumpsuit"
	desc = "Show your love for the fasion of today viewed through the lens of yesterday! All come in black, but this one has orange-brownish stripes."
	icon_state = "orange"

/obj/item/clothing/under/future_fashion/purple_striped
	name = "Futuristic Purple-Striped Jumpsuit"
	desc = "Show your love for the fasion of today viewed through the lens of yesterday! All come in black, but this one has purple stripes."
	icon_state = "purple"

/obj/item/clothing/under/future_fashion/red_striped
	name = "Futuristic Red-Striped Jumpsuit"
	desc = "Show your love for the fasion of today viewed through the lens of yesterday! All come in black, but this one has red stripes."
	icon_state = "red"

/obj/item/clothing/under/explorer
	desc = "A green uniform for operating in hazardous environments."
	name = "explorer's jumpsuit"
	icon_state = "explorer"

/obj/item/clothing/under/explorer_fem
	desc = "A green uniform for operating in hazardous environments."
	name = "explorer's jumpsuit"
	icon_state = "explorer_fem"

/obj/item/clothing/under/cohesion
	name = "black cohesion suit"
	desc = "A plain black cohesion suit intended to assist Prometheans in maintaining their form and prevent direct skin exposure."
	icon_state = "cohesionsuit"
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL // defeats the purpose!!!

/obj/item/clothing/under/cohesion
	name = "black cohesion suit (female)"
	desc = "A plain black cohesion suit intended to assist Prometheans in maintaining their form and prevent direct sken exposure."
	icon_state = "cohesionsuit_fem"

/obj/item/clothing/under/cohesion/striped
	name = "red striped cohesion suit"
	desc = "A black cohesion suit with red stripes intended to assist Prometheans in maintaining their form and prevent direct skin exposure."
	icon_state = "cohesionsuit_striped"

/obj/item/clothing/under/cohesion/striped_fem
	name = "red striped cohesion suit (female)"
	desc = "A black cohesion suit with red striped intended to assist Prometheans in maintaining their form and prevent direct skin exposure."
	icon_state = "cohesionsuit_striped_fem"

/obj/item/clothing/under/cohesion/decal
	name = "purple decaled cohesion suit"
	desc = "A white cohesion suit with purple decals intended to assist Prometheans in maintaining their form and prevent direct skin exposure."
	icon_state = "cohesionsuit_decal"

/obj/item/clothing/under/cohesion/decal_fem
	name = "purple decaled cohesion suit (female)"
	desc = "A white cohesion suit with purple decals intended to assist Prometheans in maintaining their form and prevent direct skin exposure."
	icon_state = "cohesionsuit_decal_fem"

/obj/item/clothing/under/cohesion/pattern
	name = "blue patterned cohesion suit"
	desc = "A white cohesion suit with blue patterns intended to assist Prometheans in maintaining their form and prevent direct skin exposure."
	icon_state = "cohesionsuit_pattern"

/obj/item/clothing/under/cohesion/pattern_fem
	name = "blue patterned cohesion suit (female)"
	desc = "A white cohesion suit with blue patterns intended to assist Prometheans in maintaining their form and prevent direct skin exposure."
	icon_state = "cohesionsuit_pattern_fem"

/obj/item/clothing/under/cohesion/hazard
	name = "hazard cohesion suit"
	desc = "An orange cohesion suit with yellow hazard stripes intended to assist Prometheans in maintaining their form and prevent direct skin exposure."
	icon_state = "cohesionsuit_hazard"

/obj/item/clothing/under/cohesion/hazard_fem
	name = "hazard cohesion suit (female)"
	desc = "An orange cohesion suit with yellow hazard stripes intended to assist Prometheans in maintaining their form and prevent direct skin exposure."
	icon_state = "cohesionsuit_hazard_fem"

//Uniforms

/obj/item/clothing/under/haltertop
	name = "halter top"
	desc = "A black halter top with denim jean shorts."
	icon_state = "haltertop"

/obj/item/clothing/under/btcbartender
	name = "BTC Bartender"
	desc = "For the classy bartender who converts their paychecks into Spesscoin."
	icon_state = "btc_bartender"

/obj/item/clothing/under/leotard
	name = "black leotard"
	desc = "A black leotard with a piece of semi-transparent cloth near the bust. Perfect for showing off cleavage. Bunny ears not included."
	icon_state = "leotard"

/obj/item/clothing/under/leotardcolor
	name = "colored leotard"
	desc = "A colorable leotard with a piece of semi-transparent cloth near the bust. Perfect for showing off cleavage. Bunny ears not included."
	icon_state = "leotard_color"

/obj/item/clothing/under/leotardwindow
	name = "side-window leotard"
	desc = "A revealing leotard with a window that exposes your sides."
	icon_state = "leotard_window"

/obj/item/clothing/under/bunnysuit_f
	name = "bunny leotard (f)"
	desc = "A black leotard, commonly used by casino workers to drive up tips. Bunny ears and tail sold separately."
	icon_state = "bunny_f"

/obj/item/clothing/under/bunnysuit_m
	name = "bunny leotard (m)"
	desc = "A black leotard, commonly used by casino workers to drive up tips. Bunny ears and tail sold separately."
	icon_state = "bunny_m"

/obj/item/clothing/under/fashionminiskirt
    name = "fashionable miniskirt"
    desc = "An impractically short miniskirt allegedly making waves through the local fashion scene."
    icon_state = "miniskirt_fashion"

/obj/item/clothing/under/bodysuit
	name = "standard bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This basic version is a sleek onyx grey comes with the standard induction ports."
	icon_state = "bodysuit"

/obj/item/clothing/under/bodysuit_fem
	name = "standard bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This basic version is a sleek onyx grey comes with the standard induction ports."
	icon_state = "bodysuit_fem"

/obj/item/clothing/under/bodysuit/bodysuiteva
	name = "\improper EVA bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one has bright white plating for easy visibility and thick cuffs to lock into your thrust controls."
	icon_state = "bodysuit_eva"

/obj/item/clothing/under/bodysuit/bodysuiteva_fem
	name = "\improper EVA bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one has bright white plating for easy visibility and thick cuffs to lock into your thrust controls."
	icon_state = "bodysuit_eva_fem"

/obj/item/clothing/under/bodysuit/bodysuitemt
	name = "\improper EMT bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a deep blue base with white and blue coloration."
	icon_state = "bodysuit_emt"

/obj/item/clothing/under/bodysuit/bodysuitemt_fem
	name = "\improper EMT bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a deep blue base with white and blue colouration."
	icon_state = "bodysuit_emt_fem"

/obj/item/clothing/under/bodysuit/bodysuithazard
	name = "hazard bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a black base with striking orange plating and reflective stripes."
	icon_state = "bodysuit_hazard"

/obj/item/clothing/under/bodysuit/bodysuithazard_fem
	name = "hazard bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a black base with striking orange plating and reflective stripes."
	icon_state = "bodysuit_hazard_fem"

/obj/item/clothing/under/bodysuit/bodysuitexplocom
	name = "exploration command bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a black base with striking purple plating and eyecatching golden stripes."
	icon_state = "bodysuit_pathfinder"

/obj/item/clothing/under/bodysuit/bodysuitexplocom_fem
	name = "exploration command bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a black base with striking purple plating and eyecatching golden stripes."
	icon_state = "bodysuit_pathfinder_fem"

/obj/item/clothing/under/bodysuit/bodysuitexplo
	name = "exploration bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a black base with striking purple plating."
	icon_state = "bodysuit_explo"

/obj/item/clothing/under/bodysuit/bodysuitexplo_fem
	name = "exploration bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a black base with striking purple plating."
	icon_state = "bodysuit_explo_fem"

/obj/item/clothing/under/bodysuit/bodysuitminer
	name = "mining bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a dark grey base with tan and purple coloration."
	icon_state = "bodysuit_miner"

/obj/item/clothing/under/bodysuit/bodysuitminer_fem
	name = "mining bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a dark grey base with tan and purple colouration."
	icon_state = "bodysuit_miner_fem"

/obj/item/clothing/under/bodysuit/bodysuitsec
	name = "security bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a dark grey base with red and yellow coloration."
	icon_state = "bodysuit_security"

/obj/item/clothing/under/bodysuit/bodysuitsec_fem
	name = "security bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a dark grey base with red and yellow colouration."
	icon_state = "bodysuit_security_fem"

/obj/item/clothing/under/bodysuit/bodysuitsecweewoo
	name = "advanced security bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a dark grey base with red and yellow coloration. The flashing lights fill you with confidence."
	icon_state = "bodysuit_secweewoo"

/obj/item/clothing/under/bodysuit/bodysuitsecweewoo_fem
	name = "advanced security bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a dark grey base with red and yellow colouration. The flashing lights fill you with confidence."
	icon_state = "bodysuit_secweewoo_fem"

/obj/item/clothing/under/bodysuit/bodysuitseccom
	name = "security command bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a dark grey base with striking red plating and eyecatching golden stripes."
	icon_state = "bodysuit_seccom"

/obj/item/clothing/under/bodysuit/bodysuitseccom_fem
	name = "security command bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a dark grey base with striking red plating and eyecatching golden stripes."
	icon_state = "bodysuit_seccom_fem"

/obj/item/clothing/under/bodysuit/bodysuitcommand
	name = "command bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a flashy blue base with white plating and eyecatching golden stripes."
	icon_state = "bodysuit_command"

/obj/item/clothing/under/bodysuit/bodysuitcommand_fem
	name = "command bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a flashy blue base with white plating and eyecatching golden stripes."
	icon_state = "bodysuit_command_fem"

/obj/item/clothing/under/bodysuit/bodysuitcentcom
	name = "central command bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a sleek black base with an elegant golden trim and grey plating. It fits your corporate badges nicely."
	icon_state = "bodysuit_centcom"

/obj/item/clothing/under/bodysuit/bodysuitcentcom_fem
	name = "central command bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a sleek black base with an elegant golden trim and grey plating. It fits your corporate badges nicely."
	icon_state = "bodysuit_centcom"

/obj/item/clothing/under/bodysuit/blueskirt
	name = "blue skirt"
	desc = "A comfy blue sweater paired with a stylish charcoal skirt!"
	icon_state = "blueskirt"

/obj/item/clothing/under/bodysuit/redskirt
	name = "red skirt"
	desc = "A comfy red sweater paired with a stylish charcoal skirt!"
	icon_state = "redskirt"

/obj/item/clothing/under/para
	name = "PARA tactical uniform"
	desc = "A standard grey jumpsuit, emblazoned with the Icon of the PMD. Close inspection of the embroidery reveals a complex web of glyphs written in an unknown language."
	icon_state = "para_ert_uniform"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "black", SLOT_ID_LEFT_HAND = "black")

/obj/item/clothing/under/blueshortskirt
	name = "Short Skirt"
	desc = "A light blue sweater with a black skirt."
	icon_state = "blueshortskirt_female"

/obj/item/clothing/under/greyskirt_female
	name = "Grey Skirt"
	desc = "A medium length, grey skirt with a long-sleeve, black sweater on top."
	icon_state = "greyskirt_female"

/obj/item/clothing/under/businessskirt_female
	name = "Business Skirt"
	desc = "A professional black jacket with a mundane brown skirt. Perfect for the office."
	icon_state = "businessskirt_female"

/obj/item/clothing/under/bsing
	name = "blue performer's outfit"
	desc = "A truly iconic outfit, still worn by enthusiasts and fans of Old Earth digital media."
	icon_state = "bsing"

/obj/item/clothing/under/ysing
	name = "yellow performer's outfit"
	desc = "Inspired by the original, this outfit is still stylish, although derivative."
	icon_state = "ysing"

/obj/item/clothing/under/redcoatformal
	name = "formal red coat"
	desc = "Raise the taxes on their tea. What can go wrong?"
	icon_state = "redcoatformal"

/obj/item/clothing/under/tracksuit_blue
	name = "blue tracksuit"
	desc = "A dark blue tracksuit. It calls to mind images of excercise, particularly squats."
	icon_state = "tracksuit_blue"

/obj/item/clothing/under/skirt/pleated
	name = "pleated skirt"
	icon_state = "pleated"


/obj/item/clothing/var/hides_bulges = FALSE // OwO wats this?

/obj/item/clothing/under/permit
	name = "public nudity permit"
	desc = "This permit entitles the bearer to conduct their duties without a uniform. Normally issued to furred crewmembers or those with nothing to hide."
	icon = 'icons/obj/card_cit.dmi'
	icon_state = "permit-civilian"
	body_cover_flags = 0
	equip_sound = null

	item_state = "golem"  //This is dumb and hacky but was here when I got here.
	snowflake_worn_state = "golem"  //It's basically just a coincidentally black iconstate in the file.

/obj/item/clothing/under/bluespace
	name = "bluespace jumpsuit"
	icon_state = "lingchameleon"
	item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_uniforms.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_uniforms.dmi',
			)
	item_state = "lingchameleon"
	snowflake_worn_state = "lingchameleon"
	desc = "Do you feel like warping spacetime today? Because it seems like that's on the agenda, now. \
			Allows one to resize themselves at will, and conceals their true weight."
	hides_bulges = TRUE
	var/original_size

/obj/item/clothing/under/bluespace/verb/toggle_fibers()
	set category = VERB_CATEGORY_OBJECT
	set name = "Adjust fibers"
	set desc = "Adjust your suit fibers. This makes it so your stomach(s) will show or not."
	set src in usr

	adjust_fibers(usr)

/obj/item/clothing/under/bluespace/proc/adjust_fibers(mob/user)
	if(hides_bulges == FALSE)
		hides_bulges = TRUE
		to_chat(user, "You tense the suit fibers, hiding your stomach(s).")
	else
		hides_bulges = FALSE
		to_chat(user, "You relax the suit fibers, showing your stomach(s).")

/obj/item/clothing/under/bluespace/verb/resize()
	set name = "Adjust Size"
	set category = VERB_CATEGORY_OBJECT
	set src in usr
	bluespace_size(usr)

/obj/item/clothing/under/bluespace/proc/bluespace_size(mob/usr as mob)
	if (!ishuman(usr))
		return

	var/mob/living/carbon/human/H = usr

	if (H.stat || H.restrained())
		return

	if (src != H.w_uniform)
		to_chat(H,"<span class='warning'>You must be WEARING the uniform to change your size.</span>")
		return

	var/new_size = input("Put the desired size (25-200%)", "Set Size", 200) as num|null

	//Check AGAIN because we accepted user input which is blocking.
	if (src != H.w_uniform)
		to_chat(H,"<span class='warning'>You must be WEARING the uniform to change your size.</span>")
		return

	if (H.stat || H.restrained())
		return

	if (isnull(H.size_multiplier))
		to_chat(H,"<span class='warning'>The uniform panics and corrects your apparently microscopic size.</span>")
		H.resize(RESIZE_NORMAL)
		H.update_icons() //Just want the matrix transform
		return

	if (!ISINRANGE(new_size,25,200))
		to_chat(H,"<span class='notice'>The safety features of the uniform prevent you from choosing this size.</span>")
		return

	else if(new_size)
		if(new_size != H.size_multiplier)
			if(!original_size)
				original_size = H.size_multiplier
			H.resize(new_size/100)
			H.visible_message("<span class='warning'>The space around [H] distorts as they change size!</span>","<span class='notice'>The space around you distorts as you change size!</span>")
		else //They chose their current size.
			return

/obj/item/clothing/under/bluespace/unequipped(mob/user, slot, flags)
	. = ..()
	if(. && ishuman(user) && original_size)
		var/mob/living/carbon/human/H = user
		H.resize(original_size)
		original_size = null
		H.visible_message("<span class='warning'>The space around [H] distorts as they return to their original size!</span>","<span class='notice'>The space around you distorts as you return to your original size!</span>")

//Same as Nanotrasen Security Uniforms
/obj/item/clothing/under/ert
	armor_type = /datum/armor/centcom/jumpsuit

/obj/item/clothing/under/laconic
	name = "laconic field suit"
	desc = "A lightweight black turtleneck with padded gray slacks. It seems comfortable, but practical."
	icon_state = "laconic"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "grey", SLOT_ID_LEFT_HAND = "grey")

/obj/item/clothing/under/smooth_gray
	name = "smooth gray jumpsuit"
	desc = "An ironed version of the famous, bold, and bald apparel. As smooth as it looks, it does not guarantee being able to slip away."
	icon_state = "gray_smooth_jumpsuit"

/obj/item/clothing/under/navy_gray
	name = "navy gray jumpsuit"
	desc = "A light grey-blue jumpsuit resembling those worn in the Navy, without any of the traditional markings."
	icon = 'icons/clothing/uniform/rank/utility.dmi'
	icon_state = "lightnavy"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_ROLL
	worn_bodytypes = BODYTYPE_DEFAULT

/obj/item/clothing/under/hasie
	name = "Hasie skirt"
	desc = "A daring combination of dark charcoals and vibrant reds and whites, the Hasie skirt/vest combo knows what it's doing. Sporting a low cut charcoal miniskirt and matching midriff button-up, this ensemble wows with the incredible color contrast of its two-tone vest."
	icon_state = "hasie"

/obj/item/clothing/under/utility_fur_pants
	name = "Utility Fur Pants"
	desc = "A pair of pants designed to match the Utility Fur coat."
	icon_state = "furup"

/obj/item/clothing/under/half_moon
	name = "Half Moon outfit"
	desc = "This eminently fashionable outfit evokes memories of Luna. It consists of a tailored latex leotard and daringly cut white shorts. Paired with plunging off-color stockings, it's to die for."
	icon_state = "half_moon"

//Military Surplus
/obj/item/clothing/under/surplus
	name = "surplus fatigues"
	desc = "Old military fatigues like these are very common across the Frontier. Sturdy and somewhat comfortable, they hold up to the harsh working environments many colonists face, while also adding a little flair - regardless of prior military service."
	icon_state = "bdu_olive"

/obj/item/clothing/under/surplus/desert
	icon_state = "bdu_desert"

/obj/item/clothing/under/surplus/russoblue
	icon_state = "bdu_russoblue"

//Lindenoak Line
/obj/item/clothing/under/sitri
	name = "Sitri striped sweater"
	desc = "A comfortable, fashionable pair of high waisted shorts paired with a striped grey and white turtleneck. The Goetic seal of Sitri is embroidered on the left breast pocket in soft grey thread. A tag on the inside of the sweater bears the name 'Lindenoak' in both Common and Daemonic."
	icon = 'icons/clothing/uniform/misc/lindenoak.dmi'
	icon_state = "sitri"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/belial
	name = "Belial striped shirt and shorts"
	desc = "A comfortable cotton shirt in a mix of blazing red, white and blue hues, combined with a pair of white shorts and accompanying, crisscrossing black lace along it's sides. Its tag marks it as belonging to the Lindenoak clothing line."
	icon = 'icons/clothing/uniform/misc/lindenoak.dmi'
	icon_state = "belial"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/asmodai
	name = "Asmodai laced blouse"
	desc = "An open chest blouse held together by black lacing and coupled with a pair side pre-ripped jeans. It's an outfit that's as much comfortable as it is fashionable. A small tag marks it as belonging to the Lindenoak line."
	icon = 'icons/clothing/uniform/misc/lindenoak.dmi'
	icon_state = "asmodai"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/skirt/highwaisted
	name = "high-waisted business skirt"
	desc = "A well tailored skirt matched with a form fitting blouse, perfect for all those paper pushing needs."
	icon = 'icons/clothing/uniform/misc/lindenoak.dmi'
	icon_state = "hueyskirt"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

//Had to split these into two paths to avoid bloating the loadout.
/obj/item/clothing/under/skinsuit
	name = "skinsuit"
	desc = "Similar to other form-fitting latex bodysuits in design and function, skinsuits typically feature integrated hardpoints around common wear areas."
	icon = 'icons/clothing/uniform/misc/skinsuit.dmi'
	icon_state = "skinsuit"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/skinsuit/gray
	name = "gray skinsuit"
	icon_state = "skinsuit_g"

/obj/item/clothing/under/skinsuit/leotard
	name = "leotard skinsuit"
	desc = "The skinsuit's leotard variant has long since eclipsed its initial function as a breathable undersuit for submersible hardsuits. Although still utilized in this role, it has become rather fashionable to wear outside of deep water operations."
	icon_state = "skinsuitleo"

/obj/item/clothing/under/skinsuit/leotard/gray
	name = "gray leotard skinsuit"
	icon_state = "skinsuitleo_g"

//As with the above.
/obj/item/clothing/under/skinsuit_fem
	name = "skinsuit"
	desc = "Similar to other form-fitting latex bodysuits in design and function, skinsuits typically feature integrated hardpoints around common wear areas."
	icon = 'icons/clothing/uniform/misc/skinsuit.dmi'
	icon_state = "skinsuitfem"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/skinsuit_fem/gray
	name = "gray skinsuit"
	icon_state = "skinsuitfem_g"

/obj/item/clothing/under/skinsuit_fem/leotard
	name = "leotard skinsuit"
	desc = "The skinsuit's leotard variant has long since eclipsed its initial function as a breathable undersuit for submersible hardsuits. Although still utilized in this role, it has become rather fashionable to wear outside of deep water operations."
	icon_state = "skinsuitfemleo"

/obj/item/clothing/under/skinsuit_fem/leotard/gray
	name = "gray leotard skinsuit"
	icon_state = "skinsuitfemleo_g"

/obj/item/clothing/under/skinsuit_striped
	name = "skinsuit striped"
	desc = "A dark skinsuit with white stripe embellishments, covering the contours. The latest in the line of skintight outfits that this crew in particular greatly prefers, to the point they now take up 30% of the sector's demands among NT's facilities."
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	icon = 'icons/clothing/uniform/misc/skin_taped.dmi'
	icon_state = "skinsuit_taped"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

//Alt Bodysuits
/obj/item/clothing/under/bodysuit/alt
	name = "alternate bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This basic version is a sleek onyx grey comes with the standard induction ports."
	icon = 'icons/clothing/uniform/misc/bodysuit_alt.dmi'
	icon_state = "altbodysuit"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/bodysuit/alt/sleeveless
	name = "sleeveless alternate bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one is designed to stop at the mid-bicep, allowing total freedom to the wearer's forearms."
	icon_state = "altbodysuit_sleeves"

/obj/item/clothing/under/bodysuit/alt/pants
	name = "alternate bodysuit pants"
	desc = "Following complaints that bodysuits were too tight to roll down to the waist, production of bodysuit pants as singular items grew in popularity."
	icon_state = "altbodysuit_pants"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/bodysuit/alt_fem
	name = "alternate bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This basic version is a sleek onyx grey comes with the standard induction ports."
	icon = 'icons/clothing/uniform/misc/bodysuit_alt.dmi'
	icon_state = "altbodysuitfem"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/bodysuit/alt_fem/sleeveless
	name = "sleeveless alternate bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one is designed to stop at the mid-bicep, allowing total freedom to the wearer's forearms."
	icon_state = "altbodysuitfem_sleeves"

/obj/item/clothing/under/bodysuit/alt_fem/pants
	name = "bodysuit pants"
	desc = "Following complaints that bodysuits were too tight to roll down to the waist, production of bodysuit pants as singular items grew in popularity."
	icon_state = "altbodysuitfem_pants"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/ballet
	name = "\improper Antheia tutu"
	desc = "A gossamer thin tutu from the boutique Antheia line. Famed for their flexibility and ease of motion, these outfits originate from Old Earth dance traditions."
	icon = 'icons/clothing/uniform/misc/ballet.dmi'
	icon_state = "tutu"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "white", SLOT_ID_LEFT_HAND = "white")
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/blackshortsripped
	name = "ripped black shorts"
	desc = "A pair of torn up black shorts, for those who know better."
	icon_state = "black_shorts_ripped"

/obj/item/clothing/under/tourist
	name = "tourist liesurewear"
	desc = "This loud shirt is made of mid-grade cashmere. This premier liesurewear pairs well with a nice pair of khaki shorts that stop uncomfortably above the knee."
	icon = 'icons/clothing/uniform/misc/tourist.dmi'
	icon_state = "tourist"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/under/replika/arar
	name = "repair-worker replikant bodysuit"
	desc = "A skin-tight bodysuit designed for 2nd generation biosynthetics of the engineering variety. Comes with multiple interfacing ports, arm protectors, and a conspicuous lack of leg coverage."
	description_fluff = "These purpose-made interfacing bodysuits are designed and produced by the Singheim Bureau of Biosynthetic Development for their long-running second generation of Biosynthetics, commonly known by the term Replikant. Although anyone could wear these, their overall cut and metallic ports along the spine make it rather uncomfortable to most."
	icon = 'icons/clothing/uniform/misc/replika.dmi'
	icon_state = "arar"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/replika/lstr
	name = "land-survey replikant bodysuit"
	desc = "A skin-tight bodysuit designed for 2nd generation biosynthetics of the exploration variety. Comes with several interfacing ports and a conspicuous lack of leg coverage."
	description_fluff = "These purpose-made interfacing bodysuits are designed and produced by the Singheim Bureau of Biosynthetic Development for their long-running second generation of Biosynthetics, commonly known by the term Replikant. Although anyone could wear these, their overall cut and metallic ports along the spine make it rather uncomfortable to most."
	icon = 'icons/clothing/uniform/misc/replika.dmi'
	icon_state = "lstr"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/replika/sakr
	name = "medical replikant bodysuit"
	desc = "A skin-tight bodysuit designed for 2nd generation biosynthetics of the medical variety. Comes with default interfacing ports and a conspicuous lack of leg coverage."
	description_fluff = "These purpose-made interfacing bodysuits are designed and produced by the Singheim Bureau of Biosynthetic Development for their long-running second generation of Biosynthetics, commonly known by the term Replikant. Although anyone could wear these, their overall cut and metallic ports along the spine make it rather uncomfortable to most."
	icon = 'icons/clothing/uniform/misc/replika.dmi'
	icon_state = "sakr"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/replika/fklr
	name = "command replikant bodysuit"
	desc = "A skin-tight bodysuit designed for 2nd generation biosynthetics of the command variety. Comes with interfacing ports, an air of formality, and a conspicuous lack of leg coverage."
	description_fluff = "These purpose-made interfacing bodysuits are designed and produced by the Singheim Bureau of Biosynthetic Development for their long-running second generation of Biosynthetics, commonly known by the term Replikant. Although anyone could wear these, their overall cut and metallic ports along the spine make it rather uncomfortable to most."
	icon = 'icons/clothing/uniform/misc/replika.dmi'
	icon_state = "fklr"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/replika/eulr
	name = "general-purpose replikant bodysuit"
	desc = "A skin-tight bodysuit designed for 2nd generation biosynthetics of multipurpose variety. Comes with default interfacing ports and a conspicuous lack of leg coverage."
	description_fluff = "These purpose-made interfacing bodysuits are designed and produced by the Singheim Bureau of Biosynthetic Development for their long-running second generation of Biosynthetics, commonly known by the term Replikant. Although anyone could wear these, their overall cut and metallic ports along the spine make it rather uncomfortable to most."
	icon = 'icons/clothing/uniform/misc/replika.dmi'
	icon_state = "eulr"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/replika/klbr
	name = "controller replikant bodysuit"
	desc = "A skin-tight bodysuit designed for 2nd generation biosynthetics of the controller variety. Comes with several interfacing ports and a conspicuous lack of leg coverage."
	description_fluff = "These purpose-made interfacing bodysuits are designed and produced by the Singheim Bureau of Biosynthetic Development for their long-running second generation of Biosynthetics, commonly known by the term Replikant. Although anyone could wear these, their overall cut and metallic ports along the spine make it rather uncomfortable to most."
	icon = 'icons/clothing/uniform/misc/replika.dmi'
	icon_state = "klbr"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/replika/stcr
	name = "security-technician replikant bodysuit"
	desc = "A skin-tight bodysuit designed for 2nd generation biosynthetics of the security variety. Comes with multiple interfacing ports and a conspicuous lack of leg coverage."
	description_fluff = "These purpose-made interfacing bodysuits are designed and produced by the Singheim Bureau of Biosynthetic Development for their long-running second generation of Biosynthetics, commonly known by the term Replikant. Although anyone could wear these, their overall cut and metallic ports along the spine make it rather uncomfortable to most."
	icon = 'icons/clothing/uniform/misc/replika.dmi'
	icon_state = "stcr"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/replika/adlr
	name = "administration replikant bodysuit"
	desc = "A skin-tight bodysuit designed for 2nd generation biosynthetics of the administrative variety. Comes with several interfacing ports and a conspicuous lack of leg coverage."
	description_fluff = "These purpose-made interfacing bodysuits are designed and produced by the Singheim Bureau of Biosynthetic Development for their long-running second generation of Biosynthetics, commonly known by the term Replikant. Although anyone could wear these, their overall cut and metallic ports along the spine make it rather uncomfortable to most."
	icon = 'icons/clothing/uniform/misc/replika.dmi'
	icon_state = "adlr"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/replika/lstr_alt
	name = "combat-engineer replikant bodysuit"
	desc = "A skin-tight bodysuit designed for 2nd generation biosynthetics of the exploration variety. Comes with extra interfacing ports, white armpads, and a familiar lack of leg coverage."
	description_fluff = "These purpose-made interfacing bodysuits are designed and produced by the Singheim Bureau of Biosynthetic Development for their long-running second generation of Biosynthetics, commonly known by the term Replikant. Although anyone could wear these, their overall cut and metallic ports along the spine make it rather uncomfortable to most."
	icon = 'icons/clothing/uniform/misc/replika.dmi'
	icon_state = "lstr_alt"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/gestalt/sleek_skirt
	name = "sleek crew skirt"
	desc = "A tight-fitting black uniform with a narrow skirt and striking crimson trim."
	icon = 'icons/clothing/uniform/misc/replika.dmi'
	icon_state = "gestalt_skirt"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/gestalt/sleek
	name = "sleek crew uniform"
	desc = "A tight-fitting black uniform with striking crimson trim."
	icon = 'icons/clothing/uniform/misc/replika.dmi'
	icon_state = "gestalt"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/gestalt/sleek_fem
	name = "sleek female crew uniform"
	desc = "A tight-fitting black uniform with striking crimson trim."
	icon = 'icons/clothing/uniform/misc/replika.dmi'
	icon_state = "gestalt_fem"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL


/obj/item/clothing/under/gestalt/sleeveless
	name = "sleeveless sleek crew uniform"
	desc = "A tight-fitting, sleeveless single-piece black uniform with striking crimson trim."
	icon = 'icons/clothing/uniform/misc/replika.dmi'
	icon_state = "gestalt_sleeveless"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
