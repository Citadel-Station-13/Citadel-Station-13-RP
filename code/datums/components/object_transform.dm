/datum/component/object_transform
	var/transformed_object

/datum/component/object_transform/Initialize(_transformed_object)
	transformed_object = _transformed_object
	put_in_object()

/datum/component/object_transform/proc/swap_object(new_object)
	. = new_object
	if(parent in transformed_object.contents)
		parent.forceMove(transformed_object.loc)
	qdel(transformed_object)
	transformed_object = new_object
	put_in_object()

/datum/component/object_transform/proc/put_in_object
	transformed_object.forceMove(parent.loc)
	parent.forceMove(transformed_object)

/datum/component/object_transform/proc/put_in_mob
	parent.forceMove(transformed_object.loc)
	transformed_object.forceMove(parent)
