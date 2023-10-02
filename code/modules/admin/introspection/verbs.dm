//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/client/proc/introspect_vv_rightclick(datum/D in world)
	set category = "Debug"
	set name = "View Variables"
	introspect_vv(D)

/client/proc/introspect_vv(datum/D)

/client/proc/introspect_call_rightclick(datum/D in world)
	set category = "Debug"
	set name = "Call Proc"
	introspect_call(D)

/client/proc/introspect_call(datum/D)

/client/proc/introspect_delete_rightclick(datum/D in world)
	set category = "Debug"
	set name = "Delete Entity"
	introspect_delete(D)

/client/proc/introspect_delete(datum/D)

/client/proc/introspect_mark_rightclick(datum/D in world)
	set category = "Debug"
	set name = "Mark Entity"
	introspect_mark(D)

/client/proc/introspect_mark(datum/D)

#warn impl all
