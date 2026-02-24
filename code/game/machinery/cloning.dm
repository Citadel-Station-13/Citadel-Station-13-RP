//Cloning revival method.
//The pod handles the actual cloning while the computer manages the clone profiles

//Potential replacement for genetics revives or something I dunno (?)

//Find a dead mob with a brain and client.
/proc/find_dead_player(var/find_key)
	if(isnull(find_key))
		return

	var/mob/selected = null
	for(var/mob/living/M in GLOB.player_list)
		//Dead people only thanks!
		if((M.stat != 2) || (!M.client))
			continue
		//They need a brain!
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(!H.has_brain())
				continue
		if(M.ckey == find_key)
			selected = M
			break
	return selected

// TODO: rest have been moved to resleeving module

/// Health Tracker Implant
/obj/item/implant/health
	name = "health implant"
	var/healthstring = ""

/obj/item/implant/health/proc/sensehealth()
	if(!implanted)
		return "ERROR"
	else
		if(isliving(implanted))
			var/mob/living/L = implanted
			healthstring = "[round(L.getOxyLoss())] - [round(L.getFireLoss())] - [round(L.getToxLoss())] - [round(L.getBruteLoss())]"
		if(!healthstring)
			healthstring = "ERROR"
		return healthstring


/*
 *	Diskette Box
 */

/obj/item/storage/box/disks
	name = "Diskette Box"
	icon_state = "disk_kit"

/obj/item/storage/box/disks/legacy_spawn_contents()
	new /obj/item/disk/data(src)
	new /obj/item/disk/data(src)
	new /obj/item/disk/data(src)
	new /obj/item/disk/data(src)
	new /obj/item/disk/data(src)
	new /obj/item/disk/data(src)
	new /obj/item/disk/data(src)

/*
 *	Manual -- A big ol' manual.
 */

/obj/item/paper/Cloning
	name = "H-87 Cloning Apparatus Manual"
	info = {"<h4>Getting Started</h4>
	Congratulations, your station has purchased the H-87 industrial cloning device!<br>
	Using the H-87 is almost as simple as brain surgery! Simply insert the target humanoid into the scanning chamber and select the scan option to create a new profile!<br>
	<b>That's all there is to it!</b><br>
	<i>Notice, cloning system cannot scan inorganic life or small primates.  Scan may fail if subject has suffered extreme brain damage.</i><br>
	<p>Clone profiles may be viewed through the profiles menu. Scanning implants a complementary HEALTH MONITOR IMPLANT into the subject, which may be viewed from each profile.
	Profile Deletion has been restricted to \[Station Head\] level access.</p>
	<h4>Cloning from a profile</h4>
	Cloning is as simple as pressing the CLONE option at the bottom of the desired profile.<br>
	Per your company's EMPLOYEE PRIVACY RIGHTS agreement, the H-87 has been blocked from cloning crewmembers while they are still alive.<br>
	<br>
	<p>The provided CLONEPOD SYSTEM will produce the desired clone.  Standard clone maturation times (With SPEEDCLONE technology) are roughly 90 seconds.
	The cloning pod may be unlocked early with any \[Medical Researcher\] ID after initial maturation is complete.</p><br>
	<i>Please note that resulting clones may have a small DEVELOPMENTAL DEFECT as a result of genetic drift.</i><br>
	<h4>Profile Management</h4>
	<p>The H-87 (as well as your station's standard genetics machine) can accept STANDARD DATA DISKETTES.
	These diskettes are used to transfer genetic information between machines and profiles.
	A load/save dialog will become available in each profile if a disk is inserted.</p><br>
	<i>A good diskette is a great way to counter aforementioned genetic drift!</i><br>
	<br>
	<font size=1>This technology produced under license from Thinktronic Systems, LTD.</font>"}

//SOME SCRAPS I GUESS
/* EMP grenade/spell effect
		if(istype(A, /obj/machinery/resleeving/body_printer))
			A:malfunction()
*/
