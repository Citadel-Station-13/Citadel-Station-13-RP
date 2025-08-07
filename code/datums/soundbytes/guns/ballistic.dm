//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/soundbyte/guns/ballistic
	abstract_type = /datum/soundbyte/guns/ballistic

/datum/soundbyte/guns/ballistic/rack_chamber
	abstract_type = /datum/soundbyte/guns/ballistic/rack_chamber
	is_sfx = TRUE

/datum/soundbyte/guns/ballistic/rack_chamber/generic_1
	name = "Rack Chamber A"
	id = "rack_chamber-1"
	path = 'sound/soundbytes/guns/ballistic/rack-1.ogg'

/datum/soundbyte/guns/ballistic/rack_chamber/generic_2
	name = "Rack Chamber B"
	id = "rack_chamber-2"
	path = 'sound/soundbytes/guns/ballistic/rack-2.ogg'

/datum/soundbyte/guns/ballistic/rack_chamber/generic_3
	name = "Rack Chamber C"
	id = "rack_chamber-3"
	path = 'sound/soundbytes/guns/ballistic/rack-3.ogg'

/datum/soundbyte/guns/ballistic/rack_chamber/generic_4
	name = "Rack Chamber D"
	id = "rack_chamber-4"
	path = 'sound/soundbytes/guns/ballistic/rack-4.ogg'

/datum/soundbyte/guns/ballistic/rack_chamber/shotgun_1
	name = "Rack Chamber - Shotgun A"
	id = "rack_chamber-shotgun-1"
	path = list(
		'sound/soundbytes/guns/ballistic/rack-shotgun-a-1.ogg',
		'sound/soundbytes/guns/ballistic/rack-shotgun-a-2.ogg',
	)

/datum/soundbyte/guns/ballistic/rack_chamber/shotgun_2
	name = "Rack Chamber - Shotgun B"
	id = "rack_chamber-shotgun-2"
	path = list(
		'sound/soundbytes/guns/ballistic/rack-shotgun-b.ogg',
	)

/datum/soundbyte/guns/ballistic/rack_chamber/gpmg
	name = "Rack Chamber - GPMG B"
	id = "rack_chamber-gpmg"
	path = list(
		'sound/soundbytes/guns/ballistic/rack-gpmg.ogg',
	)

/datum/soundbyte/guns/ballistic/rack_chamber/jammed
	name = "Rack Chamber - Jammed"
	id = "rack_chamber-jammed"
	path = list(
		'sound/soundbytes/guns/ballistic/rack-jammed-1.ogg',
		'sound/soundbytes/guns/ballistic/rack-jammed-2.ogg',
		'sound/soundbytes/guns/ballistic/rack-jammed-3.ogg',
	)

/datum/soundbyte/guns/ballistic/load_casing
	abstract_type = /datum/soundbyte/guns/ballistic/load_casing
	is_sfx = TRUE

/datum/soundbyte/guns/ballistic/load_casing/generic
	name = "Load Casing - Generic"
	id = "load_casing-generic"
	path = list(
		'sound/soundbytes/guns/ballistic/load-generic-1.ogg',
		'sound/soundbytes/guns/ballistic/load-generic-2.ogg',
		'sound/soundbytes/guns/ballistic/load-generic-3.ogg',
		'sound/soundbytes/guns/ballistic/load-generic-4.ogg',
	)

/datum/soundbyte/guns/ballistic/load_casing/shotgun
	name = "Load Casing - Shotgun"
	id = "load_casing-shotgun"
	path = list(
		'sound/soundbytes/guns/ballistic/load-shotgun.ogg'
	)
