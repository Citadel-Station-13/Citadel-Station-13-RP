/datum/component/object_transform
	var/obj/transformed_object
	var/to_object_text
	var/to_mob_text

/datum/component/object_transform/Initialize(_transformed_object, _to_object_text, _to_mob_text)
	transformed_object = _transformed_object
	to_object_text = _to_object_text
	to_mob_text = _to_mob_text
	put_in_object(TRUE)

/datum/component/object_transform/proc/swap_object(new_object)
	. = transformed_object
	var/mob/owner = parent
	if(parent in transformed_object.contents)
		owner.forceMove(transformed_object.loc)
	transformed_object = new_object
	put_in_object()

/datum/component/object_transform/proc/put_in_object(silent = FALSE)
	var/mob/owner = parent
	transformed_object.forceMove(owner.loc)
	owner.forceMove(transformed_object)
	if(!silent && length(to_object_text))
		owner.visible_message("<b>[owner]</b> [to_object_text]")

/datum/component/object_transform/proc/put_in_mob(silent = FALSE)
	var/mob/owner = parent
	owner.forceMove(transformed_object.loc)
	transformed_object.forceMove(parent)
	if(!silent && length(to_mob_text))
		owner.visible_message("<b>[owner]</b> [to_mob_text]")

