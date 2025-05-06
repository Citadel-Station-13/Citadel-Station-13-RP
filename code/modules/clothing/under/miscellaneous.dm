/obj/item/clothing/under/psysuit
	name = "dark undersuit"
	desc = "A thick, layered grey undersuit lined with power cables. Feels a little like wearing an electrical storm."
	icon_state = "psysuit"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "black", SLOT_ID_LEFT_HAND = "black")
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS

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

/obj/item/clothing/under/bodysuit/blueskirt
	name = "blue skirt"
	desc = "A comfy blue sweater paired with a stylish charcoal skirt!"
	icon_state = "blueskirt"

/obj/item/clothing/under/bodysuit/redskirt
	name = "red skirt"
	desc = "A comfy red sweater paired with a stylish charcoal skirt!"
	icon_state = "redskirt"

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

/obj/item/clothing/under/laconic
	name = "laconic field suit"
	desc = "A lightweight black turtleneck with padded gray slacks. It seems comfortable, but practical."
	icon_state = "laconic"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "grey", SLOT_ID_LEFT_HAND = "grey")

/obj/item/clothing/under/smooth_gray
	name = "smooth gray jumpsuit"
	desc = "An ironed version of the famous, bold, and bald apparel. As smooth as it looks, it does not guarantee being able to slip away."
	icon_state = "gray_smooth_jumpsuit"

/obj/item/clothing/under/hasie
	name = "Hasie skirt"
	desc = "A daring combination of dark charcoals and vibrant reds and whites, the Hasie skirt/vest combo knows what it's doing. Sporting a low cut charcoal miniskirt and matching midriff button-up, this ensemble wows with the incredible color contrast of its two-tone vest."
	icon_state = "hasie"

/obj/item/clothing/under/half_moon
	name = "Half Moon outfit"
	desc = "This eminently fashionable outfit evokes memories of Luna. It consists of a tailored latex leotard and daringly cut white shorts. Paired with plunging off-color stockings, it's to die for."
	icon_state = "half_moon"

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
