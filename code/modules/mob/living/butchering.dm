/mob/living
	/// These will be yielded from butchering with a probability chance equal to the butcher item's effectiveness
	var/list/butcher_results = null
	/// These will always be yielded from butchering
	var/list/guaranteed_butcher_results = null
	/// Effectiveness prob. is modified negatively by this amount; positive numbers make it more difficult, negative ones make it easier
	var/butcher_difficulty = 0

	/// How much meat to drop from this mob when butchered
	var/meat_amount = 0
	/// The meat object to drop
	var/obj/meat_type
	/// How many bones to drop from this mob when butchered
	var/bone_amount = 0
	/// The bone object to drop
	var/obj/bone_type
	/// How much hide to drop from this mob when butchered
	var/hide_amount = 0
	/// The hide object to drop
	var/obj/hide_type
	/// How many exotics to drop from this mob when butchered
	var/exotic_amount = 0
	/// The exotic object to drop
	var/obj/exotic_type
	/// List containing what type of things can be harvested. I think. -Zan
	var/list/harvest_type = list()

	/// Does it gib when butchered?
	var/gib_on_butchery = FALSE
	/// Does it drop or spawn in organs to drop when butchered?
	var/butchery_drops_organs = TRUE
	/// Associated list, path = number.
	var/list/butchery_loot

/// Harvest an animal's delicious byproducts
/mob/living/proc/harvest(var/mob/user, var/obj/item/I)
	if(meat_type && meat_amount>0 && (stat == DEAD))
		while(meat_amount > 0 && do_after(user, 0.5 SECONDS * (mob_size / 10), src))
			var/obj/item/meat = new meat_type(get_turf(src))
			meat.name = "[src.name] [meat.name]"
			new /obj/effect/debris/cleanable/blood/splatter(get_turf(src))
			meat_amount--

	if(!meat_amount)
		handle_butcher(user, I)

/// Override for special butchering checks.
/mob/living/proc/can_butcher(var/mob/user, var/obj/item/I)
	if(((meat_type && meat_amount) || LAZYLEN(butchery_loot)) && stat == DEAD)
		return TRUE

	return FALSE

/mob/living/proc/handle_butcher(var/mob/user, var/obj/item/I)
	if(!user || do_after(user, 2 SECONDS * mob_size / 10, src))
		if(LAZYLEN(butchery_loot))
			if(LAZYLEN(butchery_loot))
				for(var/path in butchery_loot)
					while(butchery_loot[path])
						butchery_loot[path] -= 1
						var/obj/item/loot = new path(get_turf(src))
						loot.pixel_x = rand(-12, 12)
						loot.pixel_y = rand(-12, 12)

				butchery_loot.Cut()
				butchery_loot = null

		if(LAZYLEN(organs)&& butchery_drops_organs)
			organs_by_name.Cut()

			for(var/path in organs)
				if(ispath(path))
					var/obj/item/organ/external/neworg = new path(src)
					neworg.name = "[name] [neworg.name]"
					neworg.meat_type = meat_type

					if(istype(src, /mob/living/simple_mob))
						var/mob/living/simple_mob/SM = src
						if(SM.limb_icon)
							neworg.force_icon = SM.limb_icon
							neworg.force_icon_key = SM.limb_icon_key

					organs |= neworg
					organs -= path

			for(var/obj/item/organ/OR in organs)
				OR.removed()
				organs -= OR

		if(LAZYLEN(internal_organs)&& butchery_drops_organs)
			internal_organs_by_name.Cut()

			for(var/path in internal_organs)
				if(ispath(path))
					var/obj/item/organ/neworg = new path(src, TRUE)
					neworg.name = "[name] [neworg.name]"
					neworg.meat_type = meat_type
					internal_organs |= neworg
					internal_organs -= path

			for(var/obj/item/organ/OR in internal_organs)
				OR.removed()
				internal_organs -= OR

		if(!ckey)
			if(issmall(src))
				user?.visible_message(SPAN_DANGER("[user] chops up \the [src]!"))
				new /obj/effect/debris/cleanable/blood/splatter(get_turf(src))
				if(gib_on_butchery)
					qdel(src)
			else
				user?.visible_message(SPAN_DANGER("[user] butchers \the [src] messily!"))
				if(gib_on_butchery)
					gib()
