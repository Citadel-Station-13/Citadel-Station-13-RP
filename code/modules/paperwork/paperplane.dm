/obj/item/paperplane
	name = "paper plane"
	desc = "Paper, folded in the shape of a plane."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paperplane"
	throw_range = 7
	throw_speed = 1
	throw_force = 0
	w_class = WEIGHT_CLASS_TINY
	integrity_max = 50

	///The chance of hitting a mob in the eye when thrown, in percentage.
	var/hit_probability = 2
	///Reference to the paper that's folded up in this paperplane, which we return when unfolded.
	var/obj/item/paper/internal_paper

/obj/item/paperplane/syndicate
	desc = "Paper, masterfully folded in the shape of a plane."
	throw_force = 20
	hit_probability = 100

/obj/item/paperplane/Initialize(mapload, obj/item/paper/paper_made_of)
	. = ..()
	pixel_x = base_pixel_x + rand(-9, 9)
	pixel_y = base_pixel_y + rand(-8, 8)
	if(paper_made_of)
		internal_paper = paper_made_of
		atom_flags = paper_made_of.atom_flags
		color = paper_made_of.color
		paper_made_of.forceMove(src)
	else
		internal_paper = new(src)
	update_appearance(UPDATE_ICON)

/obj/item/paperplane/Exited(atom/movable/gone, direction)
	. = ..()
	if (internal_paper == gone)
		internal_paper = null
		if(!QDELETED(src))
			qdel(src)

/obj/item/paperplane/Destroy()
	internal_paper = null
	return ..()

/obj/item/paperplane/update_overlays()
	. = ..()
	// we assume stamped contains proper stamp obj ref (hate)
	for(var/obj/item/stamp as anything in internal_paper.stamped)
		. += "[base_icon_state]_[stamp.icon_state]"

/obj/item/paperplane/attack_self(mob/user)
	to_chat(user, "<span class='notice'>You unfold [src].</span>")

	var/atom/location = drop_location()
	// Need to keep a reference to the internal paper
	// when we move it out of the plane, our ref gets set to null
	var/obj/item/paper/released_paper = internal_paper
	released_paper.forceMove(location)
	// This will as a side effect, qdel the paper plane, making the user's hands empty

	user.put_in_hands(released_paper)

/obj/item/paperplane/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/pen))
		to_chat(user, SPAN_WARNING("You should unfold [src] before changing it!"))
		return
	else if(istype(attacking_item, /obj/item/stamp)) //we don't randomize stamps on a paperplane
		internal_paper.attackby(attacking_item, user) //spoofed attack to update internal paper.
		update_appearance()
		add_fingerprint(user)
		return
	else if(is_hot(attacking_item))
		if(user.disabilities & MUTATION_CLUMSY && prob(10))
			user.visible_message("<span class='warning'>[user] accidentally ignites themselves!</span>", \
				"<span class='userdanger'>You miss the [src] and accidentally light yourself on fire!</span>")
			user.drop_item_to_ground(attacking_item)
			if (iscarbon(user))
				var/mob/living/carbon/C = user
				C.adjust_fire_stacks(1)
				C.IgniteMob()
			return

		if(!(in_range(user, src))) //to prevent issues as a result of telepathically lighting a paper
			return
		user.drop_item_to_ground(src)
		user.visible_message("<span class='danger'>[user] lights [src] ablaze with [attacking_item]!</span>", "<span class='danger'>You light [src] on fire!</span>")
		fire_act()
	return ..()

/obj/item/paperplane/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(. || !ishuman(hit_atom)) //if the plane is caught or it hits a nonhuman
		return
	var/mob/living/carbon/human/hit_human = hit_atom
	var/obj/item/organ/internal/eyes/eyes = hit_human.internal_organs_by_name[O_EYES]
	if(!prob(hit_probability))
		return
	visible_message(SPAN_DANGER("\The [src] hits [hit_human] in the eye[eyes ? "" : " socket"]!"))
	hit_human.eye_blurry += 12
	eyes?.take_damage(rand(1, 3))
	hit_human.emote_nosleep("scream")

/obj/item/paper/AltClick(mob/living/carbon/user, obj/item/I)
	if ( istype(user) )
		if( (!in_range(src, user)) || user.stat || user.restrained() )
			return
		to_chat(user, "<span class='notice'>You fold [src] into the shape of a plane!</span>")
		user.temporarily_remove_from_inventory(src, INV_OP_FORCE | INV_OP_SHOULD_NOT_INTERCEPT | INV_OP_SILENT)
		I = new /obj/item/paperplane(user, src)
		user.put_in_hands(I)
	else
		to_chat(user, "<span class='notice'> You lack the dexterity to fold \the [src]. </span>")
