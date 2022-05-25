//wrapper
/proc/do_teleport(ateleatom, adestination, aprecision=0, afteleport=1, aeffectin=null, aeffectout=null, asoundin=null, asoundout=null, local=TRUE, bohsafe=FALSE)
	new /datum/teleport/instant/science(arglist(args))
	return

/datum/teleport
	var/atom/movable/teleatom //Atom to teleport
	var/atom/destination //Destination to teleport to
	var/precision = 0 //Teleport precision
	var/datum/effect_system/effectin //Effect to show right before teleportation
	var/datum/effect_system/effectout //Effect to show right after teleportation
	var/soundin //Soundfile to play before teleportation
	var/soundout //Soundfile to play after teleportation
	var/force_teleport = 1 //If false, teleport will use Move() proc (dense objects will prevent teleportation)
	var/local = TRUE //If false, can teleport from/to any z-level
	var/bohsafe = FALSE //If true, can teleport safely with a BoH


/datum/teleport/New(ateleatom, adestination, aprecision=0, afteleport=1, aeffectin=null, aeffectout=null, asoundin=null, asoundout=null, local=TRUE, bohsafe=FALSE)
	..()
	if(!initTeleport(arglist(args)))
		return FALSE
	return TRUE

/datum/teleport/proc/initTeleport(ateleatom,adestination,aprecision,afteleport,aeffectin,aeffectout,asoundin,asoundout,local,bohsafe)
	if(!setTeleatom(ateleatom))
		return FALSE
	if(!setDestination(adestination))
		return FALSE
	src.bohsafe = bohsafe
	if(!setPrecision(aprecision))
		return FALSE
	setEffects(aeffectin,aeffectout)
	setForceTeleport(afteleport)
	setSounds(asoundin,asoundout)
	src.local = local
	return TRUE

//must succeed
/datum/teleport/proc/setPrecision(aprecision)
	if(isnum(aprecision))
		precision = aprecision
		return TRUE
	return FALSE

//must succeed
/datum/teleport/proc/setDestination(atom/adestination)
	if(istype(adestination))
		destination = adestination
		return TRUE
	return FALSE

//must succeed in most cases
/datum/teleport/proc/setTeleatom(atom/movable/ateleatom)
	if(istype(ateleatom, /obj/effect) && !istype(ateleatom, /obj/effect/dummy/chameleon))
		qdel(ateleatom)
		return FALSE
	if(istype(ateleatom))
		teleatom = ateleatom
		return TRUE
	return FALSE

//custom effects must be properly set up first for instant-type teleports
//optional
/datum/teleport/proc/setEffects(datum/effect_system/aeffectin=null,datum/effect_system/aeffectout=null)
	effectin = istype(aeffectin) ? aeffectin : null
	effectout = istype(aeffectout) ? aeffectout : null
	return TRUE

//optional
/datum/teleport/proc/setForceTeleport(afteleport)
		force_teleport = afteleport
		return TRUE

//optional
/datum/teleport/proc/setSounds(asoundin=null,asoundout=null)
		soundin = isfile(asoundin) ? asoundin : null
		soundout = isfile(asoundout) ? asoundout : null
		return TRUE

//placeholder
/datum/teleport/proc/teleportChecks()
		return TRUE

/datum/teleport/proc/playSpecials(atom/location,datum/effect_system/effect,sound)
	if(location)
		if(effect)
			spawn(-1)
				src = null
				effect.attach(location)
				effect.start()
		if(sound)
			spawn(-1)
				src = null
				playsound(location,sound,60,1)
	return

//Do the monkey dance
/datum/teleport/proc/doTeleport()

	var/turf/destturf
	var/turf/curturf = get_turf(teleatom)
	var/area/destarea = get_area(destination)
	if(precision)
		var/list/posturfs = circlerangeturfs(destination,precision)
		destturf = SAFEPICK(posturfs)
	else
		destturf = get_turf(destination)

	if(!destturf || !curturf)
		return FALSE

	playSpecials(curturf,effectin,soundin)


	var/obj/structure/bed/chair/C = null
	if(isliving(teleatom))
		var/mob/living/L = teleatom
		if(L.buckled)
			C = L.buckled
	if(attempt_vr(src,"try_televore",args)) return //Sigh...
	if(force_teleport)
		teleatom.forceMove(destturf)
		playSpecials(destturf,effectout,soundout)
	else
		if(teleatom.Move(destturf))
			playSpecials(destturf,effectout,soundout)
	if(C)
		C.forceMove(destturf)

	destarea.Entered(teleatom)

	return TRUE

/datum/teleport/proc/teleport()
	if(teleportChecks())
		return doTeleport()
	return FALSE

/datum/teleport/instant //Teleports when datum is created

/datum/teleport/instant/New(ateleatom, adestination, aprecision=0, afteleport=1, bohsafe=0, aeffectin=null, aeffectout=null, asoundin=null, asoundout=null)
	if(..())
		teleport()
	return


/datum/teleport/instant/science/setEffects(datum/effect_system/aeffectin,datum/effect_system/aeffectout)
	if(!aeffectin || !aeffectout)
		var/datum/effect_system/spark_spread/aeffect = new
		aeffect.set_up(5, 1, teleatom)
		var/datum/effect_system/spark_spread/aeffect2 = new
		aeffect2.set_up(5, 1, teleatom)		//This looks stupid, but it doesn't work unless I do
		effectin = effectin || aeffect
		effectout = effectout || aeffect2
		return TRUE
	else
		return ..()

/datum/teleport/instant/science/setPrecision(aprecision)
	..()
	if(bohsafe)
		return TRUE
	if(istype(teleatom, /obj/item/storage/backpack/holding))
		precision = rand(1,100)

	var/list/bagholding = teleatom.search_contents_for(/obj/item/storage/backpack/holding)
	if(bagholding.len)
		precision = max(rand(1,100)*bagholding.len,100)
		if(istype(teleatom, /mob/living))
			var/mob/living/MM = teleatom
			to_chat(MM, SPAN_DANGER("The Bluespace interface on your [teleatom] interferes with the teleport!"))
	return TRUE

/datum/teleport/instant/science/teleportChecks()
	if(istype(teleatom, /obj/item/disk/nuclear)) // Don't let nuke disks get teleported --NeoFite
		teleatom.visible_message(SPAN_DANGER("\The [teleatom] bounces off of the portal!"))
		return FALSE

	if(!!length(teleatom.search_contents_for(/obj/item/disk/nuclear)))
		if(istype(teleatom, /mob/living))
			var/mob/living/MM = teleatom
			MM.visible_message(SPAN_DANGER("\The [MM] bounces off of the portal!"), SPAN_WARNING("Something you are carrying seems to be unable to pass through the portal. Better drop it if you want to go through."))
		else
			teleatom.visible_message(SPAN_DANGER("\The [teleatom] bounces off of the portal!"))
		return FALSE
	var/obstructed = 0
	var/turf/dest_turf = get_turf(destination)
	if(local && !(dest_turf.z in GLOB.using_map.player_levels))
		if(istype(teleatom, /mob/living))
			to_chat(teleatom, SPAN_WARNING("The portal refuses to carry you that far away!"))
		return FALSE
	else if(istype(destination.loc, /obj/belly))
		var/obj/belly/destination_belly = destination.loc
		var/mob/living/telenommer = destination_belly.owner
		if(istype(telenommer))
			if(!isliving(teleatom))
				return TRUE
			else
				var/mob/living/telemob = teleatom
				if(telemob.can_be_drop_prey && telenommer.can_be_drop_pred)
					return TRUE
		obstructed = 1
	else if(!((isturf(destination) && !destination.density) || (isturf(destination.loc) && !destination.loc.density)) || !destination.x || !destination.y || !destination.z)	//If we're inside something or outside universe
		obstructed = 1
		to_chat(teleatom, SPAN_WARNING("Something is blocking way on the other side!"))
	if(obstructed)
		return FALSE
	else
		return TRUE

//! ## VR FILE MERGE ## !//

//wrapper
/proc/do_noeffect_teleport(ateleatom, adestination, aprecision=0, afteleport=1, aeffectin=null, aeffectout=null, asoundin=null, asoundout=null, local=FALSE)
	new /datum/teleport/instant/science/noeffect(arglist(args))
	return

/datum/teleport/instant/science/noeffect/setEffects(datum/effect_system/aeffectin,datum/effect_system/aeffectout)
	return TRUE

/datum/teleport/proc/try_televore()
	//Destination is in a belly
	if(isbelly(destination.loc))
		var/obj/belly/B = destination.loc

		teleatom.forceMove(get_turf(B)) //So we can splash the sound and sparks and everything.
		playSpecials(destination,effectout,soundout)
		teleatom.forceMove(B)
		return TRUE

	//No fun!
	return FALSE
