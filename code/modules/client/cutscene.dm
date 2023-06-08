/client/proc/init_cutscene_system()
	set waitfor = FALSE
	__init_cutscene_system()

/client/proc/__init_cutscene_system()
	PRIVATE_PROC(TRUE)
	sleep(1 SECONDS)
	src << output(null, "[SKIN_BROWSER_ID_CUTSCENE]:reviveWindow")

/client/proc/cleanup_cutscene_system()
	end_cutscene()

/client/verb/__declare_cutscene_ready()
	set name = ".scenepanel_ready"
	set hidden = TRUE
	set instant = TRUE

	cutscene_ready = TRUE

/client/proc/block_on_cutscene_browser_ready()
	UNTIL(cutscene_ready)

/client/proc/__start_cutscene(datum/cutscene/scene)
	PRIVATE_PROC(TRUE)
	if(cutscene)
		end_cutscene()
	cutscene = scene
	cutscene.setup(src)

/client/proc/start_cutscene(datum/cutscene/scene)
	set waitfor = FALSE
	if(isnull(scene))
		return
	__start_cutscene(scene)

/client/proc/end_cutscene()
	if(isnull(cutscene))
		return
	cutscene.cleanup(src)
	cutscene = null

/**
 * dynamic cutscene system with synchronization of state.
 */
/datum/cutscene
	/// viewing clients
	var/list/client/viewing
	/// immediate start on init()
	var/start_immediately = FALSE
	/// started?
	var/started = FALSE

/datum/cutscene/Destroy()
	for(var/client/C as anything in viewing)
		C.end_cutscene()
	return ..()

/**
 * initial state
 */
/datum/cutscene/proc/init()
	if(start_immediately)
		auto_start()

/**
 * sends / enables all assets to client
 *
 * blocking proc
 */
/datum/cutscene/proc/setup(client/C)
	var/had_clients = length(viewing)
	LAZYINITLIST(viewing)
	viewing += C
	if(!had_clients)
		auto_start()
	return TRUE

/**
 * removes / disables all assets from client
 */
/datum/cutscene/proc/cleanup(client/C)
	viewing -= C
	return TRUE

/**
 * called when the first client starts viewing
 * or immediately if start_immediately is set
 *
 * useful for synchronized state
 */
/datum/cutscene/proc/start()

/datum/cutscene/proc/auto_start()
	if(started)
		return
	start()

/**
 * renders in cutscene browser
 */
/datum/cutscene/browser

/**
 * this should be cheap, cache results yourself if you need caching.
 * this isn't done by default for memory reasons.
 *
 * assume that there's no polyfills other than:
 * - PROP_ADD_EVENT_LISTENER
 * - PROP_TEXT_CONTENT
 * - window.setTimeout()
 * - array.includes()
 * - string.trim()
 *
 * returned HTML should be IE8 compatible.
 */
/datum/cutscene/browser/proc/build_inner_html(client/C)
	return ""

/datum/cutscene/browser/setup(client/C)
	. = ..()
	src << output(build_inner_html(C), "[SKIN_BROWSER_ID_CUTSCENE]:build")
	winset(src, SKIN_BROWSER_ID_CUTSCENE, "is-visible=0")

/datum/cutscene/browser/cleanup(client/C)
	. = ..()
	src << output(null, "[SKIN_BROWSER_ID_CUTSCENE]:dispose")
	winset(src, SKIN_BROWSER_ID_CUTSCENE, "is-visible=0")

/**
 * simple cutscene that's just one asset that goes in an <img> tag
 */
/datum/cutscene/browser/simple
	/// image file path
	var/image_path
	/// cached html
	var/cached_html
	/// what to fcopy the image as
	var/use_fname
	/// icon in question
	var/icon/cached_icon

/datum/cutscene/browser/simple/init()
	. = ..()
	if(isicon(image_path))
		cached_icon = icon(image_path)
	else if(fexists(image_path)) // fails on URLs
		cached_icon = icon(image_path)
	/// good enough
	var/mutated_path = "[ref(src)]_[rand(1, 1000)]"
	cached_html = "<img id=\"primaryImage\" src=\"[isnull(cached_icon)? image_path : mutated_path]\">"
	use_fname = mutated_path

/datum/cutscene/browser/simple/build_inner_html(client/C)
	return cached_html

/datum/cutscene/browser/simple/setup(client/C)
	if(!isnull(cached_icon))
		C << browse_rsc(cached_icon, use_fname)
	return ..()

/**
 * renders on game map
 */
/datum/cutscene/native
	/// screen objects to send over. deleted on Destroy().
	var/list/atom/movable/screens

/datum/cutscene/native/Destroy()
	QDEL_NULL_LIST(screens)
	return ..()

/datum/cutscene/native/setup(client/C)
	if(!isnull(screens))
		C.screen += screens
	C.screen += GLOB.cutscene_backdrop

/datum/cutscene/native/cleanup(client/C)
	if(!isnull(screens))
		C.screen -= screens
	C.screen -= GLOB.cutscene_backdrop

/**
 * simple cutscene that loads a single icon
 */
/datum/cutscene/native/simple
	/// icon path
	var/icon_path
	/// icon width
	var/icon_width = WORLD_ICON_SIZE * 15
	/// icon height
	var/icon_height = WORLD_ICON_SIZE * 15
	/// screen object
	var/atom/movable/screen/cutscene_simple/object

/datum/cutscene/native/simple/Destroy()
	QDEL_NULL(object)
	return ..()

/datum/cutscene/native/simple/init()
	object = new(icon_path, icon_width, icon_height)

/datum/cutscene/native/simple/setup(client/C)
	. = ..()
	C.screen += object

/datum/cutscene/native/simple/cleanup(client/C)
	. = ..()
	C.screen -= object

GLOBAL_DATUM_INIT(cutscene_backdrop, /atom/movable/screen/cutscene_backdrop, new)

/atom/movable/screen/cutscene_backdrop
	plane = CUTSCENE_PLANE
	layer = CUTSCENE_LAYER_BACKDROP
	mouse_opacity = MOUSE_OPACITY_ICON
	screen_loc = "SOUTHWEST to NORTHEAST"
	icon = 'icons/screen/fullscreen/fullscreen_tiled.dmi'
	icon_state = "white"
	color = "#000000"

INITIALIZE_IMMEDIATE(/atom/movable/screen/cutscene_simple)
/atom/movable/screen/cutscene_simple
	plane = CUTSCENE_PLANE
	layer = CUTSCENE_LAYER_MAIN

/atom/movable/screen/cutscene_simple/Initialize(mapload, path, width, height)
	. = ..()
	icon = isicon(path)? path : icon(path)
	screen_loc = "CENTER:-[width / 2 + WORLD_ICON_SIZE / 2],CENTER:-[height / 2 + WORLD_ICON_SIZE / 2]"

