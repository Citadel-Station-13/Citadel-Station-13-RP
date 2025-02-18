/**
 * managed sound file datums holding filename and specific metadatas
 *
 * todo: autodetect length with rust
 * todo: in hindsight i'm shit at writing sound backend, this works but it could be a lot better.
 * todo: "is_sfx" only works to put typepaths & alias in for compiled in sounds. maybe we can have runtime soundbytes later? if needed.
 *
 * this stuff is obviously expensive and shouldn't be used at a whim
 *
 * todo: refactor soundbytes; they should be resolved via get_sfx global proc
 *
 * currently holds:
 * - path/file - required for preload
 * - name - defaults to filename
 * - length - manual set for now, rust later tm
 * - id - defaults to path for preloaded, otherwise should be made in init
 *
 * Soundbytes are registered into the global sound lookup with:
 * * their typepath
 * * their alias
 */
/datum/soundbyte
	abstract_type = /datum/soundbyte
	/// unique id
	var/id
	/// name
	var/name
	/// path; this is either a single sound or a list of sounds to pick from.
	/// * if this is a list, everything is equally weighted.
	var/list/path
	/// length
	/// * this is an optional field, but helps things that are sequenced to know when to play
	///   the next sound or step.
	var/length
	/// alias - used for std soundbytes - if multiple have the same, it'll be pick()'d with equal probability
	var/alias
	/// is runtime sound - detected from path
	var/runtime_loaded
	/// should we register by type to global lookup? obviously this only works if we're NOT runtime loaded!
	var/is_sfx = FALSE

/datum/soundbyte/proc/get_asset()
	return path

/datum/soundbyte/proc/instance_sound()
	return sound(get_asset())

/**
 * managed sound file groups holding filenames
 * has no runtime load detection
 *
 * todo: obliterate grouped so we can have proper domain'd paths and whatnot.
 */
/datum/soundbyte/grouped
	abstract_type = /datum/soundbyte/grouped
	path = list()
	runtime_loaded = FALSE
