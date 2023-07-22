/mob/observer/dead/make_perspective()
	. = ..()
	self_perspective.SetSight(SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF)
	self_perspective.SetSeeInvis(SEE_INVISIBLE_OBSERVER)
	self_perspective.set_plane_visible(/atom/movable/screen/plane_master/observer, INNATE_TRAIT)
	self_perspective.set_plane_visible(/atom/movable/screen/plane_master/cloaked, INNATE_TRAIT)
	self_perspective.set_plane_visible(/atom/movable/screen/plane_master/augmented, INNATE_TRAIT)
	// just murder darkvision
	// todo: this is so fucking jank??
	var/atom/movable/screen/plane_master/darkvision_holder = self_perspective.planes.by_plane_type(/atom/movable/screen/plane_master/darkvision)
	darkvision_holder.alpha = 0
	// todo: let obsrevers see lightmasked objects?!!

/mob/observer/dead/proc/update_ghost_sight()
	if(ghostvision)
		self_perspective.set_plane_visible(/atom/movable/screen/plane_master/observer, INNATE_TRAIT)
	else
		self_perspective.unset_plane_visible(/atom/movable/screen/plane_master/observer, INNATE_TRAIT)

/datum/vision/augmenting/observer
	hard_alpha = 0

/mob/observer/dead/verb/toggle_darkness()
	set name = "Toggle Darkness"
	set desc = "Toggles your ability to see lighting overlays, and the darkness they create."
	set category = "Ghost"

	var/now
	if(has_vision_modifier(/datum/vision/augmenting/observer))
		now = FALSE
		remove_vision_modifier(/datum/vision/augmenting/observer)
	else
		now = TRUE
		add_vision_modifier(/datum/vision/augmenting/observer)
	to_chat(src,"You [now ? "no longer" : "now"] see darkness.")
