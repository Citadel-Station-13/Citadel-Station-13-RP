/mob/observer/dead/make_perspective()
	self_perspective.SetSight(SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF)
	self_perspective.SetSeeInvis(SEE_INVISIBLE_OBSERVER)
	self_perspective.set_plane_visible(/atom/movable/screen/plane_master/observer, INNATE_TRAIT)
	self_perspective.set_plane_visible(/atom/movable/screen/plane_master/cloaked, INNATE_TRAIT)
	self_perspective.set_plane_visible(/atom/movable/screen/plane_master/augmented, INNATE_TRAIT)
	if(!seedarkness)
		self_perspective.set_hard_darkvision(0, INNATE_TRAIT)

/mob/observer/dead/proc/update_ghost_sight()
	if(!seedarkness)
		self_perspective.set_hard_darkvision(0, INNATE_TRAIT)
	else
		self_perspective.unset_hard_darkvision(source = INNATE_TRAIT)
	if(ghostvision)
		self_perspective.set_plane_visible(/atom/movable/screen/plane_master/observer, INNATE_TRAIT)
	else
		self_perspective.unset_plane_visible(/atom/movable/screen/plane_master/observer, INNATE_TRAIT)
