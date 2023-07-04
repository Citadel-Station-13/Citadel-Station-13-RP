/**
 * managed sound file datums holding filename and specific metadatas
 *
 * WARNING WARNING: If you use /grouped, you better stick with it, because probabilities for pick()
 * get messed up if you have one grouped and one normal soundbyte (the normal will get it 50% of the time),
 * because for Speed and Efficiency(tm) we are not going to distinguish between the two in the list pick()!
 *
 * todo: autodetect length with rust
 * todo: in hindsight i'm shit at writing sound backend, this works but it could be a lot better.
 * todo: "is_sfx" only works to put typepaths & alias in for compiled in sounds. maybe we can have runtime soundbytes later? if needed.
 *
 * this stuff is obviously expensive and shouldn't be used at a whim
 *
 * todo: refactor soundbytes; they should be resolved via get_sfx global proc
 * todo: and automatically register their sounds in global list by id
 * todo: have var/direct_access for this; global list lookup for sound asset is WAY cheaper than
 * todo: subsystem resolve, use that in cases of short sounds like terminal clicks.
 *
 * currently holds:
 * - path/file - required for preload
 * - name - defaults to filename
 * - length - manual set for now, rust later tm
 * - id - defaults to path for preloaded, otherwise should be made in init
 */
/datum/soundbyte
	/// unique id
	var/id
	/// name
	var/name
	/// path - set for preload - this is a list on /grouped
	var/path
	/// length - required for preload
	var/length
	/// alias - used for std soundbytes - if multiple have the same, it'll be pick()'d with equal probability
	var/alias
	/// is runtime sound - detected from path
	var/runtime_loaded
	/// should we register by type to global lookup? obviously this only works if we're NOT runtime loaded!
	var/is_sfx = FALSE

/datum/soundbyte/Destroy()
	// it's okay
	// let go.
	path = null
	return ..()

/datum/soundbyte/proc/get_asset()
	return path

/datum/soundbyte/proc/instance_sound()
	return sound(get_asset())

/datum/soundbyte/proc/get_length()
	return length? length : 10 SECONDS		// screw you when do we get rustg for this

/**
 * managed sound file groups holding filenames
 * has no runtime load detection
 */
/datum/soundbyte/grouped
	path = list()
	runtime_loaded = FALSE

/datum/soundbyte/grouped/get_asset()
	return pick(path)

/datum/soundbyte/grouped/get_length()
	return length
