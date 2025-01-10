/obj/item/robot_upgrade/language
	name = "adaptive translation module"
	desc = "Upgrades a cyborg's language processing unit with an adaptive translation module."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"

/obj/item/robot_upgrade/language/action(var/mob/living/silicon/robot/R)
	if(..())
		return FALSE

	R.create_translation_context(/datum/translation_context/variable/learning/silicons)

	return TRUE
