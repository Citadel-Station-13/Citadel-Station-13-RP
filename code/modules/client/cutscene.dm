/**
 * dynamic cutscene system with synchronization of state.
 */
/datum/cutscene
	/// viewing clients
	var/list/client/viewing

/**
 * initial state
 */
/datum/cutscene/proc/init()
	return

/**
 * sends / enables all assets to client
 *
 * blocking proc
 */
/datum/cutscene/proc/setup(client/C)
	return TRUE

/**
 * removes / disables all assets from client
 */
/datum/cutscene/proc/cleanup(client/C)
	return TRUE

/**
 * called when the first client starts viewing
 *
 * useful for synchronized state
 */
/datum/cutscene/proc/first_client_join()

#warn impl all

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

/**
 * simple cutscene that's just one asset that goes in an <img> tag
 */
/datum/cutscene/browser/simple
	/// image file path
	var/image_path

#warn impl all

/datum/cutscene/browser/simple/init()

/datum/cutscene/browser/simple/build_inner_html(client/C)

/datum/cutscene/browser/simple/setup(client/C)


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

INITIALIZE_IMMEDIATE(/atom/movable/screen/cutscene_simple)
/atom/movable/screen/cutscene_simple
	plane = CUTSCENE_PLANE
	layer = CUTSCENE_LAYER_MAIN

/atom/movable/screen/cutscene_simple/Initialize(mapload, path, width, height)
	. = ..()
	icon = icon(path)
	screen_loc = "CENTER:-[width / 2 + WORLD_ICON_SIZE / 2],CENTER:-[height / 2 + WORLD_ICON_SIZE / 2]"

