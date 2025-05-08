/**
 * Body suits, Skin suits, etc
 * Supposedly these are for 'use under hardsuits' however NT studies show this is rarely the actual usecase.
 */

/**
 * Skinsuits
 */

/obj/item/clothing/under/skinsuit
	name = "skinsuit"
	desc = "Similar to other form-fitting latex bodysuits in design and function, skinsuits typically feature integrated hardpoints around common wear areas."
	icon = 'icons/clothing/uniform/workwear/bodysuit/skinsuit.dmi'
	icon_state = "skinsuit"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/skinsuit/gray
	name = "gray skinsuit"
	icon = 'icons/clothing/uniform/workwear/bodysuit/skinsuit_g.dmi'
	icon_state = "skinsuit_g"

/obj/item/clothing/under/skinsuit/leotard
	name = "leotard skinsuit"
	desc = "The skinsuit's leotard variant has long since eclipsed its initial function as a breathable undersuit for submersible hardsuits. Although still utilized in this role, it has become rather fashionable to wear outside of deep water operations."
	icon = 'icons/clothing/uniform/workwear/bodysuit/skinsuitleo.dmi'
	icon_state = "skinsuitleo"

/obj/item/clothing/under/skinsuit/leotard/gray
	name = "gray leotard skinsuit"
	icon = 'icons/clothing/uniform/workwear/bodysuit/skinsuitleo_g.dmi'
	icon_state = "skinsuitleo_g"

/obj/item/clothing/under/skinsuit_fem
	name = "skinsuit"
	desc = "Similar to other form-fitting latex bodysuits in design and function, skinsuits typically feature integrated hardpoints around common wear areas."
	icon = 'icons/clothing/uniform/workwear/bodysuit/skinsuitfem.dmi'
	icon_state = "skinsuitfem"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/skinsuit_fem/gray
	name = "gray skinsuit"
	icon = 'icons/clothing/uniform/workwear/bodysuit/skinsuitfem_g.dmi'
	icon_state = "skinsuitfem_g"

/obj/item/clothing/under/skinsuit_fem/leotard
	name = "leotard skinsuit"
	desc = "The skinsuit's leotard variant has long since eclipsed its initial function as a breathable undersuit for submersible hardsuits. Although still utilized in this role, it has become rather fashionable to wear outside of deep water operations."
	icon = 'icons/clothing/uniform/workwear/bodysuit/skinsuitfemleo.dmi'
	icon_state = "skinsuitfemleo"

/obj/item/clothing/under/skinsuit_fem/leotard/gray
	name = "gray leotard skinsuit"
	icon = 'icons/clothing/uniform/workwear/bodysuit/skinsuitfemleo_g.dmi'
	icon_state = "skinsuitfemleo_g"

/obj/item/clothing/under/skinsuit_striped
	name = "skinsuit striped"
	desc = "A dark skinsuit with white stripe embellishments, covering the contours. The latest in the line of skintight outfits that this crew in particular greatly prefers, to the point they now take up 30% of the sector's demands among NT's facilities."
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	icon = 'icons/clothing/uniform/workwear/bodysuit/skinsuit_taped.dmi'
	icon_state = "skinsuit_taped"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/**
 * Alt Bodysuits
 */

/obj/item/clothing/under/bodysuit/alt
	name = "alternate bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This basic version is a sleek onyx grey comes with the standard induction ports."
	icon = 'icons/clothing/uniform/workwear/bodysuit/altbodysuit.dmi'
	icon_state = "altbodysuit"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/bodysuit/alt/sleeveless
	name = "sleeveless alternate bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one is designed to stop at the mid-bicep, allowing total freedom to the wearer's forearms."
	icon = 'icons/clothing/uniform/workwear/bodysuit/altbodysuit_sleeves.dmi'
	icon_state = "altbodysuit_sleeves"

/obj/item/clothing/under/bodysuit/alt/pants
	name = "alternate bodysuit pants"
	desc = "Following complaints that bodysuits were too tight to roll down to the waist, production of bodysuit pants as singular items grew in popularity."
	icon = 'icons/clothing/uniform/workwear/bodysuit/altbodysuit_pants.dmi'
	icon_state = "altbodysuit_pants"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/bodysuit/alt_fem
	name = "alternate bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This basic version is a sleek onyx grey comes with the standard induction ports."
	icon = 'icons/clothing/uniform/workwear/bodysuit/altbodysuitfem.dmi'
	icon_state = "altbodysuitfem"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/bodysuit/alt_fem/sleeveless
	name = "sleeveless alternate bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one is designed to stop at the mid-bicep, allowing total freedom to the wearer's forearms."
	icon = 'icons/clothing/uniform/workwear/bodysuit/altbodysuitfem_sleeves.dmi'
	icon_state = "altbodysuitfem_sleeves"

/obj/item/clothing/under/bodysuit/alt_fem/pants
	name = "bodysuit pants"
	desc = "Following complaints that bodysuits were too tight to roll down to the waist, production of bodysuit pants as singular items grew in popularity."
	icon = 'icons/clothing/uniform/workwear/bodysuit/altbodysuitfem_pants.dmi'
	icon_state = "altbodysuitfem_pants"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/**
 * Bodysuits
 */

/obj/item/clothing/under/bodysuit
	name = "standard bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This basic version is a sleek onyx grey comes with the standard induction ports."
	icon = 'icons/clothing/uniform/workwear/bodysuit/bodysuit.dmi'
	icon_state = "bodysuit"

/obj/item/clothing/under/bodysuit_fem
	name = "standard bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This basic version is a sleek onyx grey comes with the standard induction ports."
	icon = 'icons/clothing/uniform/workwear/bodysuit/bodysuit_fem.dmi'
	icon_state = "bodysuit_fem"

/obj/item/clothing/under/bodysuit/bodysuiteva
	name = "\improper EVA bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one has bright white plating for easy visibility and thick cuffs to lock into your thrust controls."
	icon = 'icons/clothing/uniform/workwear/bodysuit/bodysuit_eva.dmi'
	icon_state = "bodysuit_eva"

/obj/item/clothing/under/bodysuit/bodysuiteva_fem
	name = "\improper EVA bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one has bright white plating for easy visibility and thick cuffs to lock into your thrust controls."
	icon = 'icons/clothing/uniform/workwear/bodysuit/bodysuit_eva_fem.dmi'
	icon_state = "bodysuit_eva_fem"

/obj/item/clothing/under/bodysuit/bodysuitemt
	name = "\improper EMT bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a deep blue base with white and blue coloration."
	icon = 'icons/clothing/uniform/workwear/bodysuit/bodysuit_emt.dmi'
	icon_state = "bodysuit_emt"

/obj/item/clothing/under/bodysuit/bodysuitemt_fem
	name = "\improper EMT bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a deep blue base with white and blue colouration."
	icon = 'icons/clothing/uniform/workwear/bodysuit/bodysuit_emt_fem.dmi'
	icon_state = "bodysuit_emt_fem"

/obj/item/clothing/under/bodysuit/bodysuithazard
	name = "hazard bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a black base with striking orange plating and reflective stripes."
	icon = 'icons/clothing/uniform/workwear/bodysuit/bodysuit_hazard.dmi'
	icon_state = "bodysuit_hazard"

/obj/item/clothing/under/bodysuit/bodysuithazard_fem
	name = "hazard bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a black base with striking orange plating and reflective stripes."
	icon = 'icons/clothing/uniform/workwear/bodysuit/bodysuit_hazard_fem.dmi'
	icon_state = "bodysuit_hazard_fem"

/obj/item/clothing/under/bodysuit/bodysuitexplocom
	name = "exploration command bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a black base with striking purple plating and eyecatching golden stripes."
	icon = 'icons/clothing/uniform/workwear/bodysuit/bodysuit_pathfinder.dmi'
	icon_state = "bodysuit_pathfinder"

/obj/item/clothing/under/bodysuit/bodysuitexplocom_fem
	name = "exploration command bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a black base with striking purple plating and eyecatching golden stripes."
	icon = 'icons/clothing/uniform/workwear/bodysuit/bodysuit_pathfinder_fem.dmi'
	icon_state = "bodysuit_pathfinder_fem"

/obj/item/clothing/under/bodysuit/bodysuitexplo
	name = "exploration bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a black base with striking purple plating."
	icon = 'icons/clothing/uniform/workwear/bodysuit/bodysuit_explo.dmi'
	icon_state = "bodysuit_explo"

/obj/item/clothing/under/bodysuit/bodysuitexplo_fem
	name = "exploration bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a black base with striking purple plating."
	icon = 'icons/clothing/uniform/workwear/bodysuit/bodysuit_explo_fem.dmi'
	icon_state = "bodysuit_explo_fem"

/obj/item/clothing/under/bodysuit/bodysuitminer
	name = "mining bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a dark grey base with tan and purple coloration."
	icon = 'icons/clothing/uniform/workwear/bodysuit/bodysuit_miner.dmi'
	icon_state = "bodysuit_miner"

/obj/item/clothing/under/bodysuit/bodysuitminer_fem
	name = "mining bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a dark grey base with tan and purple colouration."
	icon = 'icons/clothing/uniform/workwear/bodysuit/bodysuit_miner_fem.dmi'
	icon_state = "bodysuit_miner_fem"

/obj/item/clothing/under/bodysuit/bodysuitsec
	name = "security bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a dark grey base with red and yellow coloration."
	icon = 'icons/clothing/uniform/workwear/bodysuit/bodysuit_security.dmi'
	icon_state = "bodysuit_security"

/obj/item/clothing/under/bodysuit/bodysuitsec_fem
	name = "security bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a dark grey base with red and yellow colouration."
	icon = 'icons/clothing/uniform/workwear/bodysuit/bodysuit_security_fem.dmi'
	icon_state = "bodysuit_security_fem"

/obj/item/clothing/under/bodysuit/bodysuitsecweewoo
	name = "advanced security bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a dark grey base with red and yellow coloration. The flashing lights fill you with confidence."
	icon = 'icons/clothing/uniform/workwear/bodysuit/bodysuit_secweewoo.dmi'
	icon_state = "bodysuit_secweewoo"

/obj/item/clothing/under/bodysuit/bodysuitsecweewoo_fem
	name = "advanced security bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a dark grey base with red and yellow colouration. The flashing lights fill you with confidence."
	icon = 'icons/clothing/uniform/workwear/bodysuit/bodysuit_secweewoo_fem.dmi'
	icon_state = "bodysuit_secweewoo_fem"

/obj/item/clothing/under/bodysuit/bodysuitseccom
	name = "security command bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a dark grey base with striking red plating and eyecatching golden stripes."
	icon = 'icons/clothing/uniform/workwear/bodysuit/bodysuit_seccom.dmi'
	icon_state = "bodysuit_seccom"

/obj/item/clothing/under/bodysuit/bodysuitseccom_fem
	name = "security command bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a dark grey base with striking red plating and eyecatching golden stripes."
	icon = 'icons/clothing/uniform/workwear/bodysuit/bodysuit_seccom_fem.dmi'
	icon_state = "bodysuit_seccom_fem"

/obj/item/clothing/under/bodysuit/bodysuitcommand
	name = "command bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a flashy blue base with white plating and eyecatching golden stripes."
	icon = 'icons/clothing/uniform/workwear/bodysuit/bodysuit_command.dmi'
	icon_state = "bodysuit_command"

/obj/item/clothing/under/bodysuit/bodysuitcommand_fem
	name = "command bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a flashy blue base with white plating and eyecatching golden stripes."
	icon = 'icons/clothing/uniform/workwear/bodysuit/bodysuit_command_fem.dmi'
	icon_state = "bodysuit_command_fem"

/obj/item/clothing/under/bodysuit/bodysuitcentcom
	name = "central command bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a sleek black base with an elegant golden trim and grey plating. It fits your corporate badges nicely."
	icon = 'icons/clothing/uniform/workwear/bodysuit/bodysuit_centcom.dmi'
	icon_state = "bodysuit_centcom"

/obj/item/clothing/under/bodysuit/bodysuitcentcom_fem
	name = "central command bodysuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one sports a sleek black base with an elegant golden trim and grey plating. It fits your corporate badges nicely."
	icon = 'icons/clothing/uniform/workwear/bodysuit/bodysuit_centcom_fem.dmi'
	icon_state = "bodysuit_centcom"
