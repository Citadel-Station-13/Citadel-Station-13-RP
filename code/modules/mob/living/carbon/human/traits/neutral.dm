/datum/trait/neutral/metabolism_up
	name = "Fast Metabolism"
	desc = "You process ingested and injected reagents faster, but get hungry faster (Teshari speed)."
	cost = 0
	var_changes = list("metabolic_rate" = 1.2, "hunger_factor" = 0.2, "metabolism" = 0.06) // +20% rate and 4x hunger (Teshari level)
	excludes = list(/datum/trait/neutral/metabolism_down, /datum/trait/neutral/metabolism_apex)
	extra_id_info = "Employee has a faster-than-average metabolism."

	group = /datum/trait_group/metabolism
	group_short_name = "Fast"
	sort_key = "5-Fast"

/datum/trait/neutral/metabolism_down
	name = "Slow Metabolism"
	desc = "You process ingested and injected reagents slower, but get hungry slower."
	cost = 0
	var_changes = list("metabolic_rate" = 0.8, "hunger_factor" = 0.04, "metabolism" = 0.0012) // -20% of default.
	excludes = list(/datum/trait/neutral/metabolism_up, /datum/trait/neutral/metabolism_apex)
	extra_id_info = "Employee has a slower-than-average metabolism."

	group = /datum/trait_group/metabolism
	group_short_name = "Slow"
	sort_key = "4-Slow"

/datum/trait/neutral/metabolism_apex
	name = "Apex Metabolism"
	desc = "Finally a proper excuse for your predatory actions. Essentially doubles the fast trait rates. Good for characters with big appetites."
	cost = 0
	var_changes = list("metabolic_rate" = 1.4, "hunger_factor" = 0.4, "metabolism" = 0.012) // +40% rate and 8x hunger (Double Teshari)
	excludes = list(/datum/trait/neutral/metabolism_up, /datum/trait/neutral/metabolism_down)
	extra_id_info = "Employee has an unusually fast metabolism."

	group = /datum/trait_group/metabolism
	group_short_name = "Apex"
	sort_key = "6-Apex"

/datum/trait/neutral/cold_discomfort
	name = "Hot-Blooded"
	desc = "You are too hot at the standard 20C. 18C is more suitable. Rolling down your jumpsuit or being unclothed helps."
	cost = 0
	var_changes = list("heat_discomfort_level" = T0C+19)
	excludes = list(/datum/trait/neutral/hot_discomfort)
	extra_id_info = "Employee is acclimated to colder temperatures."

	group = /datum/trait_group/temperature
	group_short_name = "Hot-Blooded"

/datum/trait/neutral/hot_discomfort
	name = "Cold-Blooded"
	desc = "You are too cold at the standard 20C. 22C is more suitable. Wearing clothing that covers your legs and torso helps."
	cost = 0
	var_changes = list("cold_discomfort_level" = T0C+21)
	excludes = list(/datum/trait/neutral/cold_discomfort)
	extra_id_info = "Employee is acclimated to warmer temperatures."

	group = /datum/trait_group/temperature
	group_short_name = "Cold-Blooded"

/datum/trait/neutral/bloodsucker
	name = "Bloodsucker"
	desc = "Only blood provides nutrition. Sharp fangs included. No other features."
	cost = 0
	var_changes = list("is_vampire" = TRUE) //The verb is given in human.dm
	custom_only = FALSE
	extra_id_info = "Employee's diet is exclusively <b>blood</b>. Employee has tested negative for vetalism."

	group = /datum/trait_group/vampirism
	group_short_name = "Lite"
	sort_key = "2-Lite"

/datum/trait/neutral/bloodsucker/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	add_verb(H, /mob/living/carbon/human/proc/bloodsuck)

/datum/trait/neutral/succubus_drain
	name = "Succubus Drain"
	desc = "Makes you able to gain nutrition from draining prey in your grasp."
	cost = 0

/datum/trait/neutral/succubus_drain/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	add_verb(H, /mob/living/carbon/human/proc/succubus_drain)
	add_verb(H, /mob/living/carbon/human/proc/succubus_drain_finalize)
	add_verb(H, /mob/living/carbon/human/proc/succubus_drain_lethal)

/datum/trait/neutral/vampire
	name = "Vetalan / Vampiric"
	desc = "Standard Vetalan features."
	cost = 0
	extra_id_info = "Employee is a carrier of <b>Vetalism</b>, and needs to consume blood to survive. Additionally, employee's saliva carries antiseptic properties."
	custom_only = FALSE
	var_changes = list(
		"is_vampire" = TRUE,
		vision_innate = /datum/vision/baseline/species_tier_2, // As per Silicons' suggestion
		"flash_mod" = 2,
		"flash_burn" = 5,
		"burn_mod" = 1.25,
		"unarmed_types" = list(/datum/melee_attack/unarmed/stomp, /datum/melee_attack/unarmed/kick, /datum/melee_attack/unarmed/claws, /datum/melee_attack/unarmed/bite/sharp, /datum/melee_attack/unarmed/bite/sharp/numbing))

	group = /datum/trait_group/vampirism
	group_short_name = "Standard"
	sort_key = "1-Standard"

/datum/trait/neutral/vampire/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.add_vision_modifier(/datum/vision/augmenting/vetalan)
	add_verb(H, /mob/living/carbon/human/proc/bloodsuck)
	add_verb(H, /mob/living/carbon/human/proc/lick_wounds)

/datum/trait/neutral/hard_vore
	name = "Brutal Predation"
	desc = "Allows you to tear off limbs & tear out internal organs."
	cost = 0
	custom_only = FALSE

/datum/trait/neutral/hard_vore/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	add_verb(H, /mob/living/proc/shred_limb)

/datum/trait/neutral/trashcan
	name = "Trash Can"
	desc = "Allows you to dispose of some garbage on the go instead of having to look for a bin or littering like an animal."
	cost = 0
	custom_only = FALSE
	var_changes = list("trashcan" = 1)

/datum/trait/neutral/trashcan/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	add_verb(H, /mob/living/proc/eat_trash)

/datum/trait/neutral/glowing_eyes
	name = "Glowing Eyes"
	desc = "Your eyes show up above darkness. SPOOKY! And kinda edgy too."
	cost = 0
	custom_only = FALSE
	var_changes = list("has_glowing_eyes" = 1)

	group = /datum/trait_group/bioluminescence
	group_short_name = "Eyes"
	sort_key = "1-Eyes"

/datum/trait/neutral/glowing_body
	name = "Glowing Body"
	desc = "Your body glows about as much as a PDA light! Settable color and toggle in Abilities tab ingame."
	cost = 0
	custom_only = FALSE

	group = /datum/trait_group/bioluminescence
	group_short_name = "Body"
	sort_key = "1-Body"

/datum/trait/neutral/glowing_body/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	add_verb(H, /mob/living/proc/glow_toggle)
	add_verb(H, /mob/living/proc/glow_color)

//! ## Body shape traits
/datum/trait/neutral/taller
	name = "Taller"
	desc = "Even taller."
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_y" = 1.09)
	excludes = list(/datum/trait/neutral/tall, /datum/trait/neutral/short, /datum/trait/neutral/shorter)

	group = /datum/trait_group/height
	group_short_name = "Taller"
	sort_key = "6-Taller"

/datum/trait/neutral/taller/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.update_transform()

/datum/trait/neutral/tall
	name = "Tall"
	desc = "A bit taller than average."
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_y" = 1.05)
	excludes = list(/datum/trait/neutral/taller, /datum/trait/neutral/short, /datum/trait/neutral/shorter)

	group = /datum/trait_group/height
	group_short_name = "Tall"
	sort_key = "5-Tall"

/datum/trait/neutral/tall/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.update_transform()

/datum/trait/neutral/short
	name = "Short"
	desc = "A bit shorter than average."
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_y" = 0.95)
	excludes = list(/datum/trait/neutral/taller, /datum/trait/neutral/tall, /datum/trait/neutral/shorter)

	group = /datum/trait_group/height
	group_short_name = "Short"
	sort_key = "4-Short"

/datum/trait/neutral/short/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.update_transform()

/datum/trait/neutral/shorter
	name = "Shorter"
	desc = "Short."
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_y" = 0.915)
	excludes = list(/datum/trait/neutral/taller, /datum/trait/neutral/tall, /datum/trait/neutral/short)

	group = /datum/trait_group/height
	group_short_name = "Shorter"
	sort_key = "3-Short"

/datum/trait/neutral/shorter/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.update_transform()

/datum/trait/neutral/fat
	name = "Overweight"
	desc = "Heavier than average."
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_x" = 1.054)
	excludes = list(/datum/trait/neutral/obese, /datum/trait/neutral/thin, /datum/trait/neutral/thinner)

	group = /datum/trait_group/weight
	group_short_name = "Overweight"
	sort_key = "5-Overweight"

/datum/trait/neutral/fat/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.update_transform()

/datum/trait/neutral/obese
	name = "Obese"
	desc = "Even heavier."
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_x" = 1.095)
	excludes = list(/datum/trait/neutral/fat, /datum/trait/neutral/thin, /datum/trait/neutral/thinner)

	group = /datum/trait_group/weight
	group_short_name = "Obese"
	sort_key = "6-Obese"

/datum/trait/neutral/obese/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.update_transform()

/datum/trait/neutral/thin
	name = "Thin"
	desc = "Skinnier than average."
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_x" = 0.945)
	excludes = list(/datum/trait/neutral/fat, /datum/trait/neutral/obese, /datum/trait/neutral/thinner)

	group = /datum/trait_group/weight
	group_short_name = "Thin"
	sort_key = "4-Thin"

/datum/trait/neutral/thin/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.update_transform()

/datum/trait/neutral/thinner
	name = "Very Thin"
	desc = "Very skinny."
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_x" = 0.905)
	excludes = list(/datum/trait/neutral/fat, /datum/trait/neutral/obese, /datum/trait/neutral/thin)

	group = /datum/trait_group/weight
	group_short_name = "Very Thin"
	sort_key = "3-Very Thin"

/datum/trait/neutral/thinner/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.update_transform()

/datum/trait/neutral/antiseptic_saliva
	name = "Antiseptic Saliva"
	desc = "Your saliva has especially strong antiseptic properties that can be used to heal small wounds."
	cost = 0
	custom_only = FALSE
	extra_id_info = "Employee's saliva carries antiseptic properties."

	group = /datum/trait_group/vampirism
	group_short_name = "Saliva"
	sort_key = "8-Saliva"

/datum/trait/neutral/antiseptic_saliva/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	add_verb(H, /mob/living/carbon/human/proc/lick_wounds)

/datum/trait/neutral/size_change
	name = "Sizeshift"
	desc = "Lets you shift sizes by yourself. Remember that abusing size mechanics is against the rules!"
	cost = 0

/datum/trait/neutral/size_change/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	add_verb(H, /mob/living/proc/set_size)

/datum/trait/neutral/nitrogen_breathing
	name = "Nitrogen Breathing"
	desc = "You require Nitrogen instead of Oxygen to breathe, be it through genetic modification or evolution."
	cost = 0
	custom_only = FALSE
	var_changes = list(
		"breath_type" = GAS_ID_NITROGEN
	)
	extra_id_info = "Employee requires <b>Nitrogen</b> to breathe."

/datum/trait/neutral/cyberpsycho
	name = "Cybernetic Rejection Syndrome"
	desc = "In a transhuman society there are always those few who lack the ability to interface safely with cybernetics. Whether it exhibits itself as an allergy during their first implant, or as gradual mental degradation, those who are poorly adapted to cybernetics have only two futures to look forward to."
	cost = 0
	custom_only = FALSE
	var_changes = list(
		"is_cyberpsycho" = TRUE
	)
	extra_id_info = "Employee's body exhibits violent rejection of cybernetics."

/datum/trait/neutral/cyberpsycho/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.AddComponent(/datum/component/cyberpsychosis)

/datum/trait/neutral/alcohol_intolerance
	name = "Alcohol Intolerance"
	desc = "You cannot metabolize alcohol; ingesting it will cause vomiting, toxin build-up, liver damage, pain and other unpleasantness."
	cost = 0
	custom_only = FALSE
	traits = list(TRAIT_ALCOHOL_INTOLERANT)
	extra_id_info = "Employee's body is violently intolerant of alcohol."
