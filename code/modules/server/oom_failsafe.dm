/client/verb/OOM_failsafe()
	set hidden = TRUE
	set name = ".oom_failsafe"

	if(!world.OOM_check())
		to_chat(src, "<span class='danger'>Liar.</span>")
		return
	world.OOM_recovery()

/client/verb/OOM_reboot()
	set hidden = TRUE
	set name = ".oom_reboot"
	if(!world.OOM_check())
		to_chat(src, "<span class='danger'>Liar.</span>")
		return
	if(!OOM_recovery_finished)
		to_chat(src, "<span class='danger'>It is not time yet.</span>")
		return
	DIRECT_OUTPUT(world, "<span class='danger'>SERVER RECOVERY: REBOOT FORCED BY [ckey]</span>")
	world.OOM_force_reboot()

GLOBAL_REAL_VAR(OOM_recovery_in_progress)
GLOBAL_REAL_VAR(OOM_recovery_finished)

/datum/controller/master/proc/OOM_check()
	return islist(subsystems)

/world/proc/OOM_check()
	to_chat(usr, "[Master]")
	if(Master)
		to_chat(usr, "[Master.type]")
		to_chat(usr, "[Master.OOM_check()]")
	to_chat(usr, "[istype(Master)]")
	return !Master || !istype(Master) || !Master.OOM_check()

#define OOM_RECOVERY_STEP(proc, text) DIRECT_OUTPUT(world, "<span class='danger'>SERVER RECOVERY: [text]... [world.##proc()? "SUCCESS" : "FAILED"]</span>")

/world/proc/OOM_recovery()
	if(OOM_recovery_in_progress || !OOM_check())
		return
	OOM_recovery_in_progress = TRUE
	if(do_OOM_recovery() != TRUE)
		OOM_force_reboot()

/world/proc/do_OOM_recovery()
	DIRECT_OUTPUT(world, "<span class='danger'>SERVER RECOVERY STARTED-------- Triggered by [usr? usr.ckey : "UNKNOWN"]</span>")
	OOM_RECOVERY_STEP(OOM_rebuild_clients, "Rebuilding clients")
	OOM_RECOVERY_STEP(OOM_kill_goonchat, "Killing goonchat")
	OOM_RECOVERY_STEP(OOM_rebuild_globals, "Rebuilding globals")
	OOM_RECOVERY_STEP(OOM_rebuild_config, "Rebuilding configuration")
	OOM_RECOVERY_STEP(OOM_rebuild_master, "Rebuilding master controller")
	OOM_RECOVERY_STEP(OOM_rebuild_tgs, "Rebuilding server interface")
	OOM_RECOVERY_STEP(OOM_rebuild_db, "Rebuilding database connection")
	OOM_RECOVERY_STEP(OOM_rebuild_admins, "Rebuilding admin list")
	if(!length(admins))
		DIRECT_OUTPUT(world, "<span class='danger'>No administrators detected after rebuild. Rebooting in 60 seconds.</span>")
		spawn(60 SECONDS)
			if(!length(admins))
				OOM_force_reboot()
			else
				DIRECT_OUTPUT(world, "<span class='danger'>An admin has connected. Reboot cancelled.</span>")
	OOM_recovery_finished = TRUE
	return TRUE

/world/proc/OOM_force_reboot()
	DIRECT_OUTPUT(world, "<span class='danger'>Attempting force reboot.</span>")

	OOM_RECOVERY_STEP(OOM_tgs_reboot, "Attempting TGS reboot")

	OOM_RECOVERY_STEP(OOM_byond_reboot, "Attempting BYOND reboot")

	DIRECT_OUTPUT(world, "<span class='danger'>Reboot failed!</span>")

/world/proc/OOM_rebuild_tgs()
	TgsNew()
	return tgs

/world/proc/OOM_byond_reboot()
	Reboot(1)
	sleep(50)
	return FALSE		//If we aren't dead by now..

/world/proc/OOM_tgs_reboot()
	var/datum/tgs_api/tgs = global.tgs
	tgs.EndProcess()
	sleep(50)
	return FALSE		//If we aren't dead by now..

/world/proc/OOM_rebuild_master()
	Master = new
	processScheduler = new

/world/proc/OOM_rebuild_globals()
	GLOB = new
	return GLOB

/world/proc/OOM_rebuild_db()
	dbcon = new
	dbcon_old = new
	establish_db_connection()
	return dbcon.IsConnected()

/world/proc/OOM_rebuild_config()
	load_configuration()
	return config

/world/proc/OOM_rebuild_admins()
	admins = list()
	admin_datums = list()
	load_admins()
	return admin_datums.len

/world/proc/OOM_rebuild_clients()
	clients = list()
	for(var/client/C in world)
		clients += C
		directory[C.ckey] = C
	return clients.len

/world/proc/OOM_kill_goonchat()
	for(var/client/C in clients)
		var/mob/owner = C.mob
		winset(owner, "output", "is-visible=true")
		winset(owner, "browseroutput", "is-disabled=true;is-visible=false")
	return clients.len

GLOBAL_REAL_VAR(OOM_R_US) = 1
/proc/OOM_R_US()
	var/list/ayy = list()
	while(OOM_R_US)
		ayy += new /mob/living/carbon/human
		CHECK_TICK
