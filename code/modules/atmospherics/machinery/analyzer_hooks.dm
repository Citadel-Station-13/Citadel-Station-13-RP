/obj/proc/analyze_gases(var/atom/A, var/mob/user)
	if(src != A)
		user.visible_message(SPAN_NOTICE("\The [user] has used \an [src] on \the [A]"))

	A.add_fingerprint(user)
	var/list/result = A.atmosanalyze(user)
	if(result && result.len)
		to_chat(user, SPAN_NOTICE("Results of the analysis[src == A ? "" : " of \the [A]"]"))
		for(var/line in result)
			to_chat(user, SPAN_NOTICE("[line]"))
		return 1

	to_chat(user, SPAN_WARNING("Your [src] flashes a red light as it fails to analyze \the [A]."))
	return 0

/obj/proc/analyze_gases_ghost(var/atom/A, var/mob/user)
	var/list/result = A.atmosanalyze(user)
	if(result && result.len)
		to_chat(user, SPAN_NOTICE("Results of the analysis[src == A ? "" : " of \the [A]"]"))
		for(var/line in result)
			to_chat(user, SPAN_NOTICE("[line]"))
		return 1

	to_chat(user, SPAN_WARNING("That [A] does not contain atmosphere."))
	return 0

/proc/atmosanalyzer_scan(var/atom/target, var/datum/gas_mixture/mixture, var/mob/user)
	var/list/results = list()

	if (mixture && mixture.total_moles > 0)
		var/pressure = mixture.return_pressure()
		var/total_moles = mixture.total_moles
		results += SPAN_NOTICE("Pressure: [QUANTIZE(pressure)] kPa")
		for(var/mix in mixture.gas)
			results += SPAN_NOTICE("[GLOB.meta_gas_names[mix]]: [QUANTIZE((mixture.gas[mix] / total_moles) * 100)]%")
		results += SPAN_NOTICE("Temperature: [QUANTIZE(mixture.temperature-T0C)]&deg;C")
		results += SPAN_NOTICE("Total Moles: [QUANTIZE(total_moles)]")
	else
		results += SPAN_NOTICE("\The [target] is empty!")

	return results

/turf/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air, user)

/turf/simulated/atmosanalyze(mob/user)
	if(zone)
		return atmosanalyzer_scan(src, zone.air, user)
	return ..()

/atom/proc/atmosanalyze(var/mob/user)
	return

/obj/item/tank/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air_contents, user)

/obj/machinery/portable_atmospherics/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air_contents, user)

/obj/machinery/atmospherics/pipe/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.parent.air, user)

/obj/machinery/atmospherics/portables_connector/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.network.gases, user)

/obj/machinery/atmospherics/component/unary/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air_contents, user)

/obj/machinery/atmospherics/component/binary/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air1, user)

/obj/machinery/atmospherics/component/trinary/atmos_filter/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air1, user)

/obj/machinery/atmospherics/component/trinary/mixer/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air3, user)

/obj/machinery/atmospherics/component/quaternary/atmos_filter/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.input.air, user)

/obj/machinery/atmospherics/component/quaternary/mixer/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.output.air, user)

/obj/machinery/meter/atmosanalyze(var/mob/user)
	var/datum/gas_mixture/mixture = null
	if(src.target)
		mixture = src.target.parent.air
	return atmosanalyzer_scan(src, mixture, user)

/obj/machinery/power/rad_collector/atmosanalyze(var/mob/user)
	if(P)	return atmosanalyzer_scan(src, src.P.air_contents, user)

/obj/item/flamethrower/atmosanalyze(var/mob/user)
	if(ptank)	return atmosanalyzer_scan(src, ptank.air_contents, user)
