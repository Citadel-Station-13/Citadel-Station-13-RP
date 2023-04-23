/client/verb/toggle_verticality_visibility()
	set name = "Verticality Overlay"
	set desc = "Toggle if you see ceiling overlays and similar."

	var/atom/movable/screen/plane_master/plane = global_planes.by_type(/atom/movable/screen/plane_master/verticality)
	plane.alpha = plane.alpha == 255? 0 : 255
	to_chat(src, SPAN_NOTICE("You now [plane.alpha == 255? "see" : "no longer see"] verticality overlays."))
