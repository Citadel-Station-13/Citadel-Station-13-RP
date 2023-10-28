//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

VV_VERB_DECLARE(/client/proc/introspect_vv_rightclick, "View Variables")
/client/proc/introspect_vv_rightclick(datum/D in world)
	set category = "Debug"
	set name = "View Variables"
	introspect_vv(D)

/client/proc/introspect_vv(datum/D)

VV_VERB_DECLARE(/client/proc/introspect_call_rightclick, "Atom Proccall")
/client/proc/introspect_call_rightclick(datum/D in world)
	set category = "Debug"
	set name = "Atom Proccall"
	introspect_call(D)

VV_VERB_DECLARE(/client/proc/introspect_call_advanced, "Advanced Proccall")
/client/proc/introspect_call_advanced()
	set category = "Debug"
	set name = "Advanced Proccall"
	introspect_call()

/client/proc/introspect_call(datum/D)

VV_VERB_DECLARE(/client/proc/introspect_delete_rightclick, "Delete Entity")
/client/proc/introspect_delete_rightclick(datum/D in world)
	set category = "Debug"
	set name = "Delete Entity"
	introspect_delete(D)

/client/proc/introspect_delete(datum/D)

VV_VERB_DECLARE(/client/proc/introspect_mark_rightclick, "Mark Entity")
/client/proc/introspect_mark_rightclick(datum/D in world)
	set category = "Debug"
	set name = "Mark Entity"
	introspect_mark(D)

/client/proc/introspect_mark(datum/D)

#warn impl all
