/**
 * manager for everything involving the lobby, including the title screen
 */
SUBSYSTEM_DEF(lobby)
	name = "Lobby Manager"
	subsystem_flags = SS_NO_FIRE
	init_order = INIT_ORDER_LOBBY

	/// our titlescreen
	var/datum/cutscene/titlescreen

/datum/controller/subsystem/lobby/Initialize()
	initialize_title_scene()
	return ..()

/datum/controller/subsystem/lobby/proc/initialize_title_scene()
	refresh_title_scene()
	for(var/client/C as anything in GLOB.clients)
		if(!isnewplayer(C.mob))
			continue
		C.start_cutscene(titlescreen)

/datum/controller/subsystem/lobby/proc/refresh_title_scene()
	set_title_scene(make_title_scene())

/datum/controller/subsystem/lobby/proc/make_title_scene()
	var/picked = pickweight(GLOB.using_map.titlescreens.Copy())
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

/datum/controller/subsystem/lobby/proc/set_title_scene(datum/cutscene/scene)
	var/list/client/old_viewing
	if(!isnull(titlescreen))
		old_viewing = titlescreen.viewing?.Copy()
		QDEL_NULL(titlescreen)
	titlescreen = scene
	for(var/client/C as anything in old_viewing)
		C.start_cutscene(titlescreen)
