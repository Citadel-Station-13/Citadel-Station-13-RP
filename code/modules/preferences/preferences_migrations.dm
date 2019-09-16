//Attempt to automatically migrate a savefile to latest version
//S must be a savefile or a path to one
/proc/do_savefile_migration(savefile/S)
	if(!istype(S))		//assume it's a path if not
		if(!fexists(S))
			return SAVEFILE_MIGRATION_NULLFILE_FAIL
		S = savefile(S)
	S.cd = SAVEFILE_PATH_METAINF
	var/current_version = 0
	current_version << S[SAVEFILE_KEY_METAINF_VERSION]
	if(current_version < LOWEST_SUPPORTED_SAVEFILE_VERSION)
		return SAVEFILE_MIGRATION_CATASTROPHIC_FAIL
	if(current_version >= SAVEFILE_VERSION_CURRENT)
		return SAVEFILE_MIGRATION_NOT_NEEDED
	var/versions_left = SAVEFILE_VERSION_CURRENT - current_version
	var/errors = 0
	while(versions_left && (current_version < SAVEFILE_VERSION_CURRENT))
		var/new_version = _sf_migration_do_call("/proc/_sf_migration_[current_version]_to_[current_version + 1]", S)
		if(isnum(new_version))		//just incase some chucklefuck memes on this
			current_version = new_version
		else
			errors++
			current_version++		//Try for the next version's migration.
	return errors? SAVEFILE_MIGRATION_FAIL : SAVEFILE_MIGRATION_SUCCESSFUL

//This is so if something runtimes, the main loop doesn't shit itself, as I don't believe there's a hascall() for global procs.
/proc/_sf_migration_do_call(path, savefile/S)
	return call(path)(S)

//These two calls change and get savefile versions without changing current directory.
/proc/_sf_migration_change_savefile_version(savefile/S, new_version)
	var/old_cd = S.cd
	S.cd = SAVEFILE_PATH_METAINF
	S[SAVEFILE_KEY_METAINF_VERSION] << new_version
	S.cd = old_cd

/proc/_sf_mmigration_get_savefile_version(savefile/S, new_version)
	var/old_cd = S.cd
	S.cd = SAVEFILE_PATH_METAINF
	. << S[SAVEFILE_KEY_METAINF_VERSION]
	S.cd = old_cd

//When we (eventually) get a lot of these, we'll probably have to start moving them to their own files.
//This one is kind of a template.
/proc/_sf_migration_11_to_12(savefile/S)
	//Do things here
	ASSERT(_sf_migration_get_savefile_version(S) == 11)		//This isn't necessary but this does help ensure we're operating on the right version/changeset.

	//We don't actually do anything, as this is just an example/something to push versions up

	//If anything goes wrong, return NULL.

	//Now we update version.
	_sf_migration_change_savefile_version(S, 12)
	return 12			//Changed to version 12.
