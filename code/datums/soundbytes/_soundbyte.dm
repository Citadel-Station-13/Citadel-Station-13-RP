/**
 * managed sound file datums holding filename and specific metadatas
 *
 * todo: autodetect length with rust
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
	/// path - set for preload
	var/path
	/// length - required for preload
	var/length
	/// file - this is set during init, this needs to be able to be directly fed into sound()
	var/file
	/// alias - used for std soundbytes - if multiple have the same, it'll be pick()'d with equal probability
	var/alias
	/// is runtime sound - detected from path
	var/runtime_loaded

/datum/soundbyte/Destroy()
	// it's okay
	// let go.
	file = null
	return ..()

/datum/soundbyte/proc/get_asset()
	return file

/datum/soundbyte/proc/instance_sound()
	return sound(get_asset())

/datum/soundbyte/proc/get_length()
	return length? length : 10 SECONDS		// screw you when do we get rustg for this
