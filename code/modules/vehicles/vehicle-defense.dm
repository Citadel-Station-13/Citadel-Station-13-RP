//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/vehicle/emp_act(severity)
	for(var/obj/item/vehicle_module/module as anything in modules)
		module.on_emp(EMP_LEGACY_SEVERITY_TO_POWER(severity), TRUE)
	for(var/obj/item/vehicle_component/component as anything in components)
		component.on_emp(EMP_LEGACY_SEVERITY_TO_POWER(severity), TRUE)

	#warn handling for everything else

#warn impl
