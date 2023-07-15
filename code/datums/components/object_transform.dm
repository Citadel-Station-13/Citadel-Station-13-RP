/datum/component/object_transform
	var/obj/transformed_object

/datum/component/object_transform/Initialize(_transformed_object)
	transformed_object = _transformed_object
	put_in_object()

/datum/component/object_transform/proc/swap_object(new_object)
	. = new_object
	var/mob/owner = parent
	if(parent in transformed_object.contents)
		owner.forceMove(transformed_object.loc)
	qdel(transformed_object)
	transformed_object = new_object
	put_in_object()

/datum/component/object_transform/proc/put_in_object()
	var/mob/owner = parent
	transformed_object.forceMove(owner.loc)
	owner.forceMove(transformed_object)

/datum/component/object_transform/proc/put_in_mob()
	var/mob/owner = parent
	owner.forceMove(transformed_object.loc)
	transformed_object.forceMove(parent)
