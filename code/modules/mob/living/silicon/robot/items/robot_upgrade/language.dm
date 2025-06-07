/obj/item/robot_upgrade/language
	name = "adaptive translation module"
	desc = "Upgrades a cyborg's language processing unit with an adaptive translation module."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"

/obj/item/robot_upgrade/language/can_install(mob/living/silicon/robot/target, robot_opinion, datum/event_args/actor/actor, silent)
	if(target.translation_context?.type == /datum/translation_context/variable/learning/silicons)
		if(!silent)
			actor?.chat_feedback(
				SPAN_WARNING("[target] already has an adaptive translation unit installed."),
				target = target,
			)
		return FALSE
	return ..()

/obj/item/robot_upgrade/language/being_installed(mob/living/silicon/robot/target)
	target.create_translation_context(/datum/translation_context/variable/learning/silicons)
	qdel(src)
