//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/inventory/robot/get_slot_single(datum/inventory_slot/type_or_id)
	switch(type_or_id)
		if(SLOT_ID_ROBOT_MODULE_ACTIVE)

		if(SLOT_ID_ROBOT_MODULE_INACTIVE)
	return ..()

/datum/inventory/robot/get_slot(datum/inventory_slot/type_or_id) as /list
	switch(type_or_id)
		if(SLOT_ID_ROBOT_MODULE_ACTIVE)

		if(SLOT_ID_ROBOT_MODULE_INACTIVE)
	return ..()

#warn um...
