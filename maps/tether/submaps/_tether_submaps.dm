
/obj/effect/step_trigger/zlevel_fall //Don't ever use this, only use subtypes.Define a new var/static/target_z on each
	affect_ghosts = 1

/obj/effect/step_trigger/zlevel_fall/Initialize()
	. = ..()

	if(istype(get_turf(src), /turf/simulated/floor))
		src:target_z = z
		return INITIALIZE_HINT_QDEL

/obj/effect/step_trigger/zlevel_fall/Trigger(var/atom/movable/A) //mostly from /obj/effect/step_trigger/teleporter/planetary_fall, step_triggers.dm L160
	if(!src:target_z)
		return

	var/attempts = 100
	var/turf/simulated/T
	while(attempts && !T)
		var/turf/simulated/candidate = locate(rand(5,world.maxx-5),rand(5,world.maxy-5),src:target_z)
		if(candidate.density)
			attempts--
			continue

		T = candidate
		break

	if(!T)
		return

	if(isobserver(A))
		A.forceMove(T) // Harmlessly move ghosts.
		return

	A.forceMove(T)
	if(isliving(A)) // Someday, implement parachutes.  For now, just turbomurder whoever falls.
		message_admins("\The [A] fell out of the sky.")
		var/mob/living/L = A
		L.fall_impact(T, 42, 90, FALSE, TRUE)	//You will not be defibbed from this.

//////////////////////////////////////////////////////////////////////////////
//Overmap ship spawns

#include "../../offmap_vr/om_ships/hybridshuttle.dm"
#include "../../offmap_vr/om_ships/screebarge.dm"
//#include "../../offmap_vr/om_ships/aro.dm"
//#include "../../offmap_vr/om_ships/aro2.dm"
#include "../../offmap_vr/om_ships/bearcat.dm"
#include "../../offmap_vr/om_ships/cruiser.dm"
#include "../../offmap_vr/om_ships/vespa.dm"
#include "../../offmap_vr/om_ships/generic_shuttle.dm"
#include "../../offmap_vr/om_ships/salamander.dm"
#include "../../offmap_vr/om_ships/geckos.dm"
#include "../../offmap_vr/om_ships/mackerels.dm"
#include "../../offmap_vr/om_ships/mercenarybase.dm"
#include "../../offmap_vr/om_ships/mercship.dm"
#include "../../offmap_vr/om_ships/curashuttle.dm"
#include "../../offmap_vr/om_ships/itglight.dm"
#include "../../offmap_vr/om_ships/abductor.dm"

//////////////////////////////////////////////////////////////////////////////
//Capsule deployed ships
#include "../../offmap_vr/om_ships/shelter_5.dm"
#include "../../offmap_vr/om_ships/shelter_6.dm"

//////////////////////////////////////////////////////////////////////////////
//Offmap Spawn Locations
#include "../../offmap_vr/talon/talon.dm"
#include "../../offmap_vr/talon/talon_areas.dm"



