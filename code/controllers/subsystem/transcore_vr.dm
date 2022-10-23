#define SSTRANSCORE_IMPLANTS 1
#define SSTRANSCORE_BACKUPS 2

////////////////////////////////
//// Mind/body data storage system
//// for the resleeving tech
////////////////////////////////

SUBSYSTEM_DEF(transcore)
	name = "Transcore"
	priority = 20
	wait = 3 MINUTES
	subsystem_flags = SS_BACKGROUND|SS_NO_INIT
	runlevels = RUNLEVEL_GAME

	// THINGS
	var/overdue_time = 15 MINUTES
	var/static/core_dumped = FALSE			// Core has been dumped!  Also set can_fire = 0 when you set this.

	var/current_step = SSTRANSCORE_IMPLANTS

	var/cost_backups = 0
	var/cost_implants = 0

	var/static/list/datum/transhuman/mind_record/backed_up = list()	// All known mind records, indexed by MR.mindname/mind.name
	var/static/list/datum/transhuman/mind_record/has_left = list()		// Why do we even have this?
	var/static/list/datum/transhuman/body_record/body_scans = list()	// All known body records, indexed by BR.mydna.name
	var/static/list/obj/item/implant/backup/implants = list()	// All OPERATING implants that are being ticked

	var/list/current_run = list()

/datum/controller/subsystem/transcore/fire(resumed = 0)
	var/timer = TICK_USAGE

	INTERNAL_PROCESS_STEP(SSTRANSCORE_IMPLANTS,TRUE,process_implants,cost_implants,SSTRANSCORE_BACKUPS)
//	INTERNAL_PROCESS_STEP(SSTRANSCORE_BACKUPS,FALSE,process_backups,cost_backups,SSTRANSCORE_IMPLANTS)

/datum/controller/subsystem/transcore/proc/process_implants(resumed = 0)
	if (!resumed)
		src.current_run = implants.Copy()

	var/list/current_run = src.current_run
	while(current_run.len)
		var/obj/item/implant/backup/imp = current_run[current_run.len]
		current_run.len--

		//Remove if not in a human anymore.
		if(!imp || !isorgan(imp.loc))
			implants -= imp
			continue

		//We're in an organ, at least.
		var/obj/item/organ/external/EO = imp.loc
		var/mob/living/carbon/human/H = EO.owner
		if(!H)
			implants -= imp
			continue

		//In a human
		if(H == imp.imp_in && H.mind && H.stat < DEAD)
			SStranscore.m_backup(H.mind,H.nif)
			persist_nif_data(H)

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/transcore/proc/process_backups(resumed = 0)
	if (!resumed)
		src.current_run = backed_up.Copy()

	var/list/current_run = src.current_run
	while(current_run.len)
		var/name = current_run[current_run.len]
		var/datum/transhuman/mind_record/curr_MR = current_run[name]
		current_run -= name

		//Invalid record
		if(!curr_MR)
			subsystem_log("Tried to process [name] in transcore w/o a record!")
			backed_up -= name
			continue

		//Onetimes do not get processing or notifications
		if(curr_MR.one_time)
			continue

		//Timing check
		var/since_backup = world.time - curr_MR.last_update
		if(since_backup < overdue_time)
			curr_MR.dead_state = MR_NORMAL
		else
			if(curr_MR.dead_state != MR_DEAD) //First time switching to dead
				notify(name)
				curr_MR.last_notification = world.time
			curr_MR.dead_state = MR_DEAD

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/transcore/stat_entry()
	var/msg = list()
	if(core_dumped)
		msg += "CORE DUMPED | "
	msg += "$:{"
	msg += "IM:[round(cost_implants,1)]|"
	msg += "BK:[round(cost_backups,1)]"
	msg += "} "
	msg += "#:{"
	msg += "IM:[implants.len]|"
	msg += "BK:[backed_up.len]"
	msg += "} "
	..(jointext(msg, null))

/datum/controller/subsystem/transcore/proc/m_backup(var/datum/mind/mind, var/obj/item/nif/nif, var/one_time = FALSE)
	ASSERT(mind)
	if(!mind.name || core_dumped)
		return 0

	var/datum/transhuman/mind_record/MR

	if(mind.name in backed_up)
		MR = backed_up[mind.name]
		MR.last_update = world.time
		MR.one_time = one_time

		//Pass a 0 to not change NIF status (because the elseif is checking for null)
		if(nif)
			MR.nif_path = nif.type
			MR.nif_durability = nif.durability
			var/list/nifsofts = list()
			for(var/N in nif.nifsofts)
				if(N)
					var/datum/nifsoft/nifsoft = N
					nifsofts += nifsoft.type
			MR.nif_software = nifsofts
			MR.nif_savedata = nif.save_data.Copy()
		else if(isnull(nif)) //Didn't pass anything, so no NIF
			MR.nif_path = null
			MR.nif_durability = null
			MR.nif_software = null
			MR.nif_savedata = null


	MR = new(mind, mind.current, add_to_db = FALSE, one_time = one_time)

	return MR

/datum/controller/subsystem/transcore/proc/m_backupE(var/datum/mind/mind, var/obj/item/nif/nif, var/one_time = FALSE)
	ASSERT(mind)
	if(!mind.name || core_dumped)
		return 0

	var/datum/transhuman/mind_record/MRE

	MRE = new(mind, mind.current, add_to_db = FALSE, one_time = one_time)

	return MRE

// Send a past-due notification to the medical radio channel.
/datum/controller/subsystem/transcore/proc/notify(var/name, var/repeated = FALSE)
	ASSERT(name)
	if(repeated)
		GLOB.global_announcer.autosay("This is a repeat notification that [name] is past-due for a mind backup.", "TransCore Oversight", "Medical")
	else
		GLOB.global_announcer.autosay("[name] is past-due for a mind backup.", "TransCore Oversight", "Medical")

// Called from mind_record to add itself to the transcore.
/datum/controller/subsystem/transcore/proc/add_backup(datum/transhuman/mind_record/MR)
	ASSERT(MR)
	backed_up[MR.mindname] = MR
	backed_up = tim_sort(backed_up, /proc/cmp_text_asc, TRUE)
	subsystem_log("Added [MR.mindname] to transcore DB.")

// Remove a mind_record from the backup-checking list.  Keeps track of it in has_left // Why do we do that? ~Leshana
/datum/controller/subsystem/transcore/proc/stop_backup(datum/transhuman/mind_record/MR)
	ASSERT(MR)
	has_left[MR.mindname] = MR
	backed_up.Remove("[MR.mindname]")
	MR.cryo_at = world.time
	subsystem_log("Put [MR.mindname] in transcore suspended DB.")

// Called from body_record to add itself to the transcore.
/datum/controller/subsystem/transcore/proc/add_body(datum/transhuman/body_record/BR)
	ASSERT(BR)
	body_scans[BR.mydna.name] = BR
	body_scans = tim_sort(body_scans, /proc/cmp_text_asc, TRUE)
	subsystem_log("Added [BR.mydna.name] to transcore body DB.")

// Remove a body record from the database (Usually done when someone cryos)  // Why? ~Leshana
/datum/controller/subsystem/transcore/proc/remove_body(datum/transhuman/body_record/BR)
	ASSERT(BR)
	body_scans.Remove("[BR.mydna.name]")
	subsystem_log("Removed [BR.mydna.name] from transcore body DB.")

// Moves all mind records from the databaes into the disk and shuts down all backup canary processing.
/datum/controller/subsystem/transcore/proc/core_dump(obj/item/disk/transcore/disk)
	ASSERT(disk)
	GLOB.global_announcer.autosay("An emergency core dump has been initiated!", "TransCore Oversight", "Command")
	GLOB.global_announcer.autosay("An emergency core dump has been initiated!", "TransCore Oversight", "Medical")

	disk.stored += backed_up
	backed_up.Cut()
	core_dumped = TRUE
	can_fire = FALSE
	return disk.stored.len

#undef SSTRANSCORE_BACKUPS
#undef SSTRANSCORE_IMPLANTS
