/**
 * Manages the lobby's titlescreen.
 */
SUBSYSTEM_DEF(titlescreen)
	name = "Titlescreens"
	subsystem_flags = SS_NO_FIRE
	init_order = INIT_ORDER_TITLESCREEN
	init_stage = INIT_STAGE_LATE

	/// our titlescreen
	var/datum/cutscene/titlescreen

/datum/controller/subsystem/titlescreen/Initialize()
	initialize_title_scene()
	return SS_INIT_NO_MESSAGE

/datum/controller/subsystem/titlescreen/proc/initialize_title_scene()
	refresh_title_scene()
	for(var/client/C as anything in GLOB.clients)
		if(!isnewplayer(C.mob))
			continue
		C.start_cutscene(titlescreen)

/datum/controller/subsystem/titlescreen/proc/refresh_title_scene()
	set_title_scene(make_title_scene())

/datum/controller/subsystem/titlescreen/proc/make_title_scene()
	var/picked = pickweight((LEGACY_MAP_DATUM).titlescreens.Copy())
	if(isnull(picked))
		return
	var/datum/cutscene/built
	if(ispath(picked))
		built = new picked
	if(islist(picked))
		var/list/arr = picked
		var/icon/I = icon(arr[1], arr[2])
		var/datum/cutscene/native/simple/scene = new
		scene.icon_path = I
		scene.icon_width = I.Width()
		scene.icon_height = I.Height()
		built = scene
	built.init()
	return built

/datum/controller/subsystem/titlescreen/proc/set_title_scene(datum/cutscene/scene)
	var/list/client/old_viewing
	if(!isnull(titlescreen))
		old_viewing = titlescreen.viewing?.Copy()
		QDEL_NULL(titlescreen)
	titlescreen = scene
	for(var/client/C as anything in old_viewing)
		C.start_cutscene(titlescreen)
