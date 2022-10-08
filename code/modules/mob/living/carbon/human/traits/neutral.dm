/datum/trait/neutral/metabolism_up
	name = "Fast Metabolism"
	desc = "You process ingested and injected reagents faster, but get hungry faster (Teshari speed)."
	cost = 0
	var_changes = list("metabolic_rate" = 1.2, "hunger_factor" = 0.2, "metabolism" = 0.06) // +20% rate and 4x hunger (Teshari level)
	excludes = list(/datum/trait/neutral/metabolism_down, /datum/trait/neutral/metabolism_apex)

/datum/trait/neutral/metabolism_down
	name = "Slow Metabolism"
	desc = "You process ingested and injected reagents slower, but get hungry slower."
	cost = 0
	var_changes = list("metabolic_rate" = 0.8, "hunger_factor" = 0.04, "metabolism" = 0.0012) // -20% of default.
	excludes = list(/datum/trait/neutral/metabolism_up, /datum/trait/neutral/metabolism_apex)

/datum/trait/neutral/metabolism_apex
	name = "Apex Metabolism"
	desc = "Finally a proper excuse for your predatory actions. Essentially doubles the fast trait rates. Good for characters with big appetites."
	cost = 0
	var_changes = list("metabolic_rate" = 1.4, "hunger_factor" = 0.4, "metabolism" = 0.012) // +40% rate and 8x hunger (Double Teshari)
	excludes = list(/datum/trait/neutral/metabolism_up, /datum/trait/neutral/metabolism_down)

/datum/trait/neutral/cold_discomfort
	name = "Hot-Blooded"
	desc = "You are too hot at the standard 20C. 18C is more suitable. Rolling down your jumpsuit or being unclothed helps."
	cost = 0
	var_changes = list("heat_discomfort_level" = T0C+19)
	excludes = list(/datum/trait/neutral/hot_discomfort)

/datum/trait/neutral/hot_discomfort
	name = "Cold-Blooded"
	desc = "You are too cold at the standard 20C. 22C is more suitable. Wearing clothing that covers your legs and torso helps."
	cost = 0
	var_changes = list("cold_discomfort_level" = T0C+21)
	excludes = list(/datum/trait/neutral/cold_discomfort)

/datum/trait/neutral/autohiss_unathi
	name = "Autohiss (Unathi)"
	desc = "You roll your S's and x's"
	cost = 0
	custom_only = FALSE
	var_changes = list(
	autohiss_basic_map = list(
			"s" = list("ss", "sss", "ssss")
		),
	autohiss_extra_map = list(
			"x" = list("ks", "kss", "ksss")
		),
	autohiss_exempt = list("Sinta'unathi"))

	excludes = list(/datum/trait/neutral/autohiss_tajaran)

/datum/trait/neutral/autohiss_tajaran
	name = "Autohiss (Tajaran)"
	desc = "You roll your R's."
	cost = 0
	custom_only = FALSE
	var_changes = list(
	autohiss_basic_map = list(
			"r" = list("rr", "rrr", "rrrr")
		),
	autohiss_exempt = list("Siik"))
	excludes = list(/datum/trait/neutral/autohiss_unathi)

/datum/trait/neutral/bloodsucker
	name = "Bloodsucker"
	desc = "Makes you unable to gain nutrition from anything but blood. To compenstate, you get fangs that can be used to drain blood from prey."
	cost = 0
	var_changes = list("is_vampire" = TRUE) //The verb is given in human.dm
	custom_only = FALSE

/datum/trait/neutral/bloodsucker/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.verbs |= /mob/living/carbon/human/proc/bloodsuck

/datum/trait/neutral/succubus_drain
	name = "Succubus Drain"
	desc = "Makes you able to gain nutrition from draining prey in your grasp."
	cost = 0

/datum/trait/neutral/succubus_drain/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.verbs |= /mob/living/carbon/human/proc/succubus_drain
	H.verbs |= /mob/living/carbon/human/proc/succubus_drain_finalize
	H.verbs |= /mob/living/carbon/human/proc/succubus_drain_lethal

/datum/trait/neutral/vampire
	name = "Vetalan / Vampiric"
	desc = "Vampires, officially known as the Vetalan, are weaker to burns, bright lights, and must consume blood to survive. To this end, they can see near-perfectly in the darkness, possess sharp, numbing fangs, and anti-septic saliva."
	cost = 0
	custom_only = FALSE
	var_changes = list(
		"is_vampire" = TRUE,
		"darksight" = 7,
		"flash_mod" = 2,
		"flash_burn" = 5,
		"burn_mod" = 1.25,
		"unarmed_types" = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp, /datum/unarmed_attack/bite/sharp/numbing))

/datum/trait/neutral/vampire/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.verbs |= /mob/living/carbon/human/proc/bloodsuck
	H.verbs |= /mob/living/carbon/human/proc/lick_wounds

/datum/trait/neutral/hard_vore
	name = "Brutal Predation"
	desc = "Allows you to tear off limbs & tear out internal organs."
	cost = 0
	custom_only = FALSE

/datum/trait/neutral/hard_vore/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.verbs |= /mob/living/proc/shred_limb

/datum/trait/neutral/trashcan
	name = "Trash Can"
	desc = "Allows you to dispose of some garbage on the go instead of having to look for a bin or littering like an animal."
	cost = 0
	custom_only = FALSE
	var_changes = list("trashcan" = 1)

/datum/trait/neutral/trashcan/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.verbs |= /mob/living/proc/eat_trash

/datum/trait/neutral/glowing_eyes
	name = "Glowing Eyes"
	desc = "Your eyes show up above darkness. SPOOKY! And kinda edgy too."
	cost = 0
	custom_only = FALSE
	var_changes = list("has_glowing_eyes" = 1)

/datum/trait/neutral/glowing_body
	name = "Glowing Body"
	desc = "Your body glows about as much as a PDA light! Settable color and toggle in Abilities tab ingame."
	cost = 0
	custom_only = FALSE

/datum/trait/neutral/glowing_body/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.verbs |= /mob/living/proc/glow_toggle
	H.verbs |= /mob/living/proc/glow_color

//! ## Body shape traits
/datum/trait/neutral/taller
	name = "Taller"
	desc = "Your body is taller than average."
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_y" = 1.09)
	excludes = list(/datum/trait/neutral/tall, /datum/trait/neutral/short, /datum/trait/neutral/shorter)

/datum/trait/neutral/taller/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.update_transform()

/datum/trait/neutral/tall
	name = "Tall"
	desc = "Your body is a bit taller than average."
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_y" = 1.05)
	excludes = list(/datum/trait/neutral/taller, /datum/trait/neutral/short, /datum/trait/neutral/shorter)

/datum/trait/neutral/tall/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.update_transform()

/datum/trait/neutral/short
	name = "Short"
	desc = "Your body is a bit shorter than average."
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_y" = 0.95)
	excludes = list(/datum/trait/neutral/taller, /datum/trait/neutral/tall, /datum/trait/neutral/shorter)

/datum/trait/neutral/short/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.update_transform()

/datum/trait/neutral/shorter
	name = "Shorter"
	desc = "You are shorter than average."
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_y" = 0.915)
	excludes = list(/datum/trait/neutral/taller, /datum/trait/neutral/tall, /datum/trait/neutral/short)

/datum/trait/neutral/shorter/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.update_transform()

/datum/trait/neutral/fat
	name = "Overweight"
	desc = "You are heavier than average."
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_x" = 1.054)
	excludes = list(/datum/trait/neutral/obese, /datum/trait/neutral/thin, /datum/trait/neutral/thinner)

/datum/trait/neutral/fat/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.update_transform()

/datum/trait/neutral/obese
	name = "Obese"
	desc = "You are much heavier than average."
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_x" = 1.095)
	excludes = list(/datum/trait/neutral/fat, /datum/trait/neutral/thin, /datum/trait/neutral/thinner)

/datum/trait/neutral/obese/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.update_transform()

/datum/trait/neutral/thin
	name = "Thin"
	desc = "You are skinnier than average."
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_x" = 0.945)
	excludes = list(/datum/trait/neutral/fat, /datum/trait/neutral/obese, /datum/trait/neutral/thinner)

/datum/trait/neutral/thin/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.update_transform()

/datum/trait/neutral/thinner
	name = "Very Thin"
	desc = "You are much skinnier than average."
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_x" = 0.905)
	excludes = list(/datum/trait/neutral/fat, /datum/trait/neutral/obese, /datum/trait/neutral/thin)

/datum/trait/neutral/thinner/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.update_transform()

/datum/trait/neutral/antiseptic_saliva
	name = "Antiseptic Saliva"
	desc = "Your saliva has especially strong antiseptic properties that can be used to heal small wounds."
	cost = 0
	custom_only = FALSE

/datum/trait/neutral/antiseptic_saliva/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.verbs |= /mob/living/carbon/human/proc/lick_wounds

/datum/trait/neutral/size_change
	name = "Sizeshift"
	desc = "Lets you shift sizes by yourself. Remember that abusing size mechanics is against the rules!"
	cost = 0

/datum/trait/neutral/size_change/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.verbs |= /mob/living/proc/set_size

/datum/trait/neutral/cyberpsycho
	name = "Cybernetic Rejection Syndrome"
	desc = "In a transhuman society there are always those few who lack the ability to interface safely with cybernetics. Whether it exhibits itself as an allergy during their first implant, or as gradual mental degradation, those who are poorly adapted to cybernetics have only two futures to look forward to."
	cost = 0
	custom_only = FALSE
	var_changes = list(
		"is_cyberpsycho" = TRUE
	)

/datum/trait/neutral/cyberpsycho/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.AddComponent(/datum/component/cyberpsychosis)
