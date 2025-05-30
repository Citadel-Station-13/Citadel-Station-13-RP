/obj/item/integrated_circuit/filter
	category_text = "Filter"
	power_draw_per_use = 5
	complexity = 2
	activators = list("compare" = IC_PINTYPE_PULSE_IN, "if valid" = IC_PINTYPE_PULSE_OUT, "if not valid" = IC_PINTYPE_PULSE_OUT)

/obj/item/integrated_circuit/filter/proc/may_pass(var/input)
	return FALSE

/obj/item/integrated_circuit/filter/do_work()
	push_data()

/obj/item/integrated_circuit/filter/ref
	extended_desc = "Uses heuristics and complex algorithms to match incoming data against its filtering parameters and occasionally produces both false positives and negatives."
	var/filter_type
	complexity = 4
	inputs = list( "input" = IC_PINTYPE_REF )
	outputs = list("result" = IC_PINTYPE_BOOLEAN, "self ref" = IC_PINTYPE_SELFREF)

/obj/item/integrated_circuit/filter/ref/may_pass(var/datum/data)
	if(!(filter_type && data))
		return FALSE
	return istype(data, filter_type)

/obj/item/integrated_circuit/filter/ref/do_work()
	var/A = get_pin_data(IC_INPUT, 1)
	get_pin_data(IC_INPUT, 1)
	set_pin_data(IC_OUTPUT, 1, may_pass(A) ? TRUE : FALSE)

	if(get_pin_data(IC_OUTPUT, 1))
		activate_pin(2)
	else
		activate_pin(3)
	..()

/obj/item/integrated_circuit/filter/ref/mob
	name = "life filter"
	desc = "Only allow refs belonging to more complex, currently or formerly, living but not necessarily biological entities through."
	icon_state = "filter_mob"
	filter_type = /mob/living
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/filter/ref/mob/simple_mob
	name = "creature filter"
	desc = "Only allow refs belonging to more simple minded, currently or formerly, living but not necessarily biological entities through."
	icon_state = "filter_mob"
	filter_type = /mob/living/simple_mob
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/filter/ref/mob/simple_animal
	name = "animal filter"
	desc = "Only allow refs belonging to more animalistic, currently or formerly, living but not necessarily biological entities through."
	icon_state = "filter_mob"
	filter_type = /mob/living/simple_animal
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/filter/ref/mob/humanoid
	name = "humanoid filter"
	desc = "Only allow refs belonging to humanoids (dead or alive) through."
	icon_state = "filter_humanoid"
	filter_type = /mob/living/carbon/human
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/filter/ref/obj
	name = "object filter"
	desc = "Allows most kinds of refs to pass, as long as they are not considered (once) living entities."
	icon_state = "filter_obj"
	filter_type = /obj
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/filter/ref/obj/item
	name = "item filter"
	desc = "Only allow refs belonging to minor items through, typically hand-held such."
	icon_state = "filter_item"
	filter_type = /obj/item
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/filter/ref/obj/machinery
	name = "machinery filter"
	desc = "Only allow refs belonging machinery or complex objects through, such as computers and consoles."
	icon_state = "filter_machinery"
	filter_type = /obj/machinery
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/filter/ref/object/structure
	name = "structure filter"
	desc = "Only allow refs belonging larger objects and structures through, such as closets and beds."
	icon_state = "filter_structure"
	filter_type = /obj/structure
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/filter/ref/object/ore
	name = "ore filter"
	desc = "Only allow refs of ores through."
	icon_state = "filter_structure"
	filter_type = /obj/item/stack/ore
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/filter/ref/object/produce
	name = "produce filter"
	desc = "Only allow refs of grown produce through, such as apples and wheat."
	icon_state = "filter_structure"
	filter_type = /obj/item/reagent_containers/food/snacks/grown
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/filter/ref/custom
	name = "custom filter"
	desc = "Allows custom filtering.  It will match type against a stored reference; it will also take a type string."
	icon_state = "filter_custom"
	inputs = list( "input" = IC_PINTYPE_REF, "expected type" = IC_PINTYPE_ANY)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/filter/ref/custom/may_pass(var/datum/data, var/datum/typedata)
	if(!istype(typedata) && !istext(typedata)) return FALSE
	return (data && typedata && (istype(data, typedata)))

/obj/item/integrated_circuit/filter/ref/custom/do_work()
	var/A = get_pin_data(IC_INPUT, 1)
	var/T = get_pin_data(IC_INPUT, 2)
	set_pin_data(IC_OUTPUT, 1, may_pass(A, T) ? TRUE : FALSE)

	if(get_pin_data(IC_OUTPUT, 1))
		activate_pin(2)
	else
		activate_pin(3)
	push_data()

/obj/item/integrated_circuit/filter/string
	name = "string filter"
	desc = "Allows string filtering.  It will match a string against a stored string."
	extended_desc = "Matches incoming data against its filtering parameters and occasionally produces both false positives and negatives."
	icon_state = "filter_string"
	complexity = 2
	inputs = list(
		"input" = IC_PINTYPE_STRING,
		"expected string" = IC_PINTYPE_STRING
		)
	outputs = list("result" = IC_PINTYPE_BOOLEAN)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/filter/string/may_pass(var/datum/integrated_io/A, var/datum/integrated_io/B)
	return A == B

/obj/item/integrated_circuit/filter/string/do_work()
	var/A = get_pin_data(IC_INPUT, 1)
	var/B = get_pin_data(IC_INPUT, 2)
	set_pin_data(IC_OUTPUT, 1, may_pass(A, B) ? TRUE : FALSE)

	if(get_pin_data(IC_OUTPUT, 1))
		activate_pin(2)
	else
		activate_pin(3)
	push_data()
