/datum/stack_recipe/railing
	name = "railing"
	product_type = /obj/structure/railing
	cost = 2
	time = 1.25 SECONDS

/datum/stack_recipe/railing/check(atom/where, amount, obj/item/stack/stack, mob/user, silent, use_dir = user?.dir)
	if(isnull(use_dir))
		return FALSE
	if(!no_automatic_sanity_checks)
		if(!isturf(where) || isspaceturf(where))
			if(!silent && !isnull(user))
				user.action_feedback(SPAN_WARNING("Railings must be built on a floor."))
				return FALSE
		for(var/obj/structure/railing/R in where)
				if(R.dir == use_dir)
					if(!silent && !isnull(user))
						user.action_feedback(SPAN_WARNING("There's no room for a railing here facing [dir2text(use_dir)]."))
					return FALSE
	return TRUE

/datum/stack_recipe/railing/make(atom/where, amount, obj/item/stack/stack, mob/user, silent, use_dir = user?.dir)
	if(isnull(use_dir))
		return
	var/obj/structure/railing/built = new(where, TRUE)
	built.setDir(use_dir)
	return built
