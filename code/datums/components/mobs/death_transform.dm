/datum/component/death_transform
	registered_type = /datum/component/death_transform

	var/duration_transformed = 10 SECONDS
	var/transform_message = ""
	var/obj/transformed_object

/datum/component/death_transform/Initialize(duration_transformed, transform_message, obj/transformed_object)
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	src.duration_transformed = duration_transformed
	src.transform_message = transform_message
	src.transformed_object = transformed_object
	src.transformed_object.forceMove(parent)
	. = ..()

/datum/component/death_transform/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_HUMAN_DEATH, PROC_REF(on_death))

/datum/component/death_transform/proc/on_death()
	var/mob/living/carbon/human/H = parent
	to_chat(H, transform_message)
	transformed_object.forceMove(get_turf(H))
	H.forceMove(transformed_object)
	sleep(duration_transformed)
	H.forceMove(get_turf(transformed_object))
	transformed_object.forceMove(H)
