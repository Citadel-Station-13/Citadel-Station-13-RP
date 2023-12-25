// Base type for cooking machines
// Contributes to a food's cooking timer. That's basically it.
/obj/machinery/cooking
	name = "generic food cooking machine"
	desc = "A food cooking machine that cooks food. Generically. You shouldn't be seeing this!"
	icon = 'icons/obj/cooking_machines.dmi'

	
	density = 1
	anchored = 1
	default_unanchor = 5 SECONDS

	use_power = 0
	idle_power_usage = 5			// Power used when turned on, but not processing anything
	active_power_usage = 1000		// Power used when turned on and actively cooking something

	speed_process = PROCESS_ON_SSPROCESSING

	var/cooker_type = METHOD_OVEN
	var/cooking_power = HEAT_MID

	var/max_contents = 2			// Maximum number of things this appliance can simultaneously cook
	var/on_icon						// Icon state used when cooking.
	var/off_icon					// Icon state used when not cooking.

	var/list/food_containers //what food holders (/obj/item/reagent_containers/food_holder) we are cooking


/obj/machinery/cooking/Initialize(mapload, newdir)
	. = ..()
	component_parts = list()
	component_parts += /obj/item/circuitboard/cooking
	component_parts += /obj/item/stock_parts/capacitor
	component_parts += /obj/item/stock_parts/scanning_module
	component_parts += /obj/item/stock_parts/matter_bin

/obj/machinery/cooking/RefreshParts()
	..()
	var/scan_rating = 0
	var/cap_rating = 0

	for(var/obj/item/stock_parts/P in src.component_parts)
		if(istype(P, /obj/item/stock_parts/scanning_module))
			scan_rating += P.rating
		else if(istype(P, /obj/item/stock_parts/capacitor))
			cap_rating += P.rating

	active_power_usage = initial(active_power_usage) - ((scan_rating + cap_rating) * 5)

/obj/machinery/cooking/process(delta_time)
	if (cooking_power > 0)
		for (var/obj/item/reagent_containers/food_holder/FH in food_containers)
			FH.tick_heat(1 SECOND, cooking_power, cooker_type)
		for (var/obj/item/reagent_containers/food/snacks/ingredient/I in food_containers)
			I.process_cooked(1 SECOND, cooking_power, cooker_type)

/obj/item/circuitboard/machine/cooker
	name = "kitchen appliance circuitry"
	desc = "The circuitboard for many kitchen appliances. Not of much use."
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	req_components = list(
							/obj/item/stock_parts/capacitor = 1,
							/obj/item/stock_parts/scanning_module = 1,
							/obj/item/stock_parts/matter_bin = 1)
