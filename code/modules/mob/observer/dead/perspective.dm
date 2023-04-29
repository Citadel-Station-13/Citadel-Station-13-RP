/mob/observer/dead/make_perspective()
	assert_innate_darksight()
	darksight_innate.hard_darksight = seedarkness? 255 : 0
	. = ..()
	self_perspective.SetSight(SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF)
	self_perspective.SetSeeInvis(SEE_INVISIBLE_OBSERVER)
	self_perspective.set_plane_visible(/atom/movable/screen/plane_master/observer, INNATE_TRAIT)
	self_perspective.set_plane_visible(/atom/movable/screen/plane_master/cloaked, INNATE_TRAIT)
	self_perspective.set_plane_visible(/atom/movable/screen/plane_master/augmented, INNATE_TRAIT)

/mob/observer/dead/proc/update_ghost_sight()
	assert_innate_darksight()
	var/old = darksight_innate.hard_darksight
	darksight_innate.hard_darksight = seedarkness? 255 : 0
	if(old != darksight_innate.hard_darksight)
		update_darksight()
	if(ghostvision)
		self_perspective.set_plane_visible(/atom/movable/screen/plane_master/observer, INNATE_TRAIT)
	else
		self_perspective.unset_plane_visible(/atom/movable/screen/plane_master/observer, INNATE_TRAIT)
