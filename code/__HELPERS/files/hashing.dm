/// Save file as an external file then md5 it.
/// Used because md5ing files stored in the rsc sometimes gives incorrect md5 results.
/// https://www.byond.com/forum/post/2611357
/proc/md5asfile(file)
	var/static/notch = 0
	// its importaint this code can handle md5filepath sleeping instead of hard blocking, if it's converted to use rust_g.
	var/filename = "tmp/md5asfile.[world.realtime].[world.timeofday].[world.time].[world.tick_usage].[notch]"
	notch = WRAP(notch+1, 0, 2**15)
	fcopy(file, filename)
	. = rustg_hash_file(RUSTG_HASH_MD5, filename)
	fdel(filename)

/// Save file as an external file then sha1 it.
/// Used because sha1ing files stored in the rsc sometimes gives incorrect sha1 results.
/proc/sha1asfile(file)
	var/static/notch = 0
	// its importaint this code can handle sha1filepath sleeping instead of hard blocking, if it's converted to use rust_g.
	var/filename = "tmp/sha1asfile.[world.realtime].[world.timeofday].[world.time].[world.tick_usage].[notch]"
	notch = WRAP(notch+1, 0, 2**15)
	fcopy(file, filename)
	. = rustg_hash_file(RUSTG_HASH_SHA1, filename)
	fdel(filename)
