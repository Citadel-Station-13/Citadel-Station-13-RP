DECLARE_SHUTTLE_TEMPLATE(/factions/independent/salamander)
	id = "independent-salamander"
	name = "ITV Salamander-class Corvette"

	descriptor = /datum/shuttle_descriptor{
		preferred_orientation = EAST;
		mass = 12500;
		overmap_icon_color = "#00AA00";
		overmap_legacy_name = "Salamander-class Corvette";
		overmap_legacy_desc = "A medium multirole spacecraft, commonly used by independent operators.";
	}

	display_name = "Salamander-class Corvette"
	facing_dir = EAST

DECLARE_SHUTTLE_TEMPLATE(/factions/independent/salamander_wreck)
	id = "independent-salamander_wreck"
	name = "ITV Salamander-class Corvette (Wrecked)"

	descriptor = /datum/shuttle_descriptor{
		preferred_orientation = EAST;
		mass = 12500;
		overmap_icon_color = "#008800";
		overmap_legacy_name = "Wrecked Salamander-class Corvette";
		overmap_legacy_desc = "A medium multirole spacecraft, or at least what's left of it.";
	}

	display_name = "Salamander-class Corvette"
	facing_dir = EAST

#warn impl

DECLARE_SHUTTLE_AREA(/salamander)
	icon = 'icons/turf/areas_vr_talon.dmi'
	has_gravity = FALSE

DECLARE_SHUTTLE_AREA(/salamander/cabin)
	name = "\improper Salamander Cabin"
	icon_state = "gray"

DECLARE_SHUTTLE_AREA(/salamander/engineering)
	name = "\improper Salamander Engineering"
	icon_state = "yellow"

DECLARE_SHUTTLE_AREA(/salamander/cockpit)
	name = "\improper Salamander Cockpit"
	icon_state = "blue"

DECLARE_SHUTTLE_AREA(/salamander/q1)
	name = "\improper Salamander Quarters 1"
	icon_state = "gray-p"

DECLARE_SHUTTLE_AREA(/salamander/q2)
	name = "\improper Salamander Quarters 2"
	icon_state = "gray-p"

DECLARE_SHUTTLE_AREA(/salamander/galley)
	name = "\improper Salamander Galley"
	icon_state = "dark-s"

DECLARE_SHUTTLE_AREA(/salamander/head)
	name = "\improper Salamander Head"
	icon_state = "dark-p"

#warn below
/obj/effect/shuttle_landmark/shuttle_initializer/salamander
/obj/overmap/entity/visitable/ship/landable/salamander
/obj/effect/shuttle_landmark/shuttle_initializer/salamander_wreck
/obj/overmap/entity/visitable/ship/landable/salamander_wreck

// todo: move this somewhere else or maybe just varedit it on map?
/obj/item/paper/unity_notice
	name = "hastily-scrawled missive"
	info = {"<i>The writing on this scrap of paper is barely legible. Whoever wrote it was clearly in a hurry.</i><br>\
<br>\
to who(m)ever finds this,<br>\
whatever they tell (told?) you, this kinda job is never worth the pay<br>\
i swear they packed some bullshit amongst the rest of the cargo when we werent looking<br>\
like they wanted us to get caught by port authorities or something!<br>\
so we are bailing on the whole contract, captains orders<br>\
dont bother looking for that 'bullshit' i mentioned, we made sure nobody is gonna find it<br>\
sent it out into the black<br>\
or maybe the sun<br>\
one of the two<br>\
<br>\
stay safe out there and always double check who you sign with<br>\
<br>\
rest of the cargo is covered by insurance anyway, so help yourself/ves i guess<br>\
<br>\
-M"}

#warn map
