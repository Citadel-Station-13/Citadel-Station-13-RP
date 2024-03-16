/obj/proc/analyze_gases(atom/A, mob/user)
	if(src != A)
		user.visible_message("<span class='notice'>\The [user] has used \an [src] on \the [A]</span>")

	A.add_fingerprint(user)
	var/list/result = A.atmosanalyze(user)
	if(result && result.len)
		to_chat(user, "<span class='notice'>Results of the analysis[src == A ? "" : " of \the [A]"]</span>")
		for(var/line in result)
			to_chat(user, "<span class='notice'>[line]</span>")
		return 1

	to_chat(user, "<span class='warning'>Your [src] flashes a red light as it fails to analyze \the [A].</span>")
	return 0

/obj/proc/analyze_gases_ghost(atom/A, mob/user)
	var/list/result = A.atmosanalyze(user)
	if(result && result.len)
		to_chat(user, "<span class='notice'>Results of the analysis[src == A ? "" : " of \the [A]"]</span>")
		for(var/line in result)
			to_chat(user, "<span class='notice'>[line]</span>")
		return 1

	to_chat(user, "<span class='warning'>That [A] does not contain atmosphere.</span>")
	return 0

/proc/atmosanalyzer_scan(atom/target, datum/gas_mixture/mixture, mob/user)
	return mixture.chat_analyzer_scan(GAS_GROUP_UNKNOWN, TRUE, TRUE)

/turf/atmosanalyze(mob/user)
	return atmosanalyzer_scan(src, src.air, user)

/turf/simulated/atmosanalyze(mob/user)
	if(zone)
		return atmosanalyzer_scan(src, zone.air, user)
	return ..()

/atom/proc/atmosanalyze(mob/user)
	return

/obj/item/tank/atmosanalyze(mob/user)
	return atmosanalyzer_scan(src, src.air_contents, user)

/obj/machinery/portable_atmospherics/atmosanalyze(mob/user)
	return atmosanalyzer_scan(src, src.air_contents, user)

/obj/machinery/atmospherics/pipe/atmosanalyze(mob/user)
	return atmosanalyzer_scan(src, src.parent.air, user)

/obj/machinery/atmospherics/portables_connector/atmosanalyze(mob/user)
	return atmosanalyzer_scan(src, src.network.gases, user)

/obj/machinery/atmospherics/component/unary/atmosanalyze(mob/user)
	return atmosanalyzer_scan(src, src.air_contents, user)

// todo: components should allow each end to be analyzed separately.

/obj/machinery/atmospherics/component/binary/atmosanalyze(mob/user)
	return atmosanalyzer_scan(src, src.air1, user)

/obj/machinery/atmospherics/component/trinary/filter/atmosanalyze(mob/user)
	return atmosanalyzer_scan(src, src.air1, user)

/obj/machinery/atmospherics/component/trinary/mixer/atmosanalyze(mob/user)
	return atmosanalyzer_scan(src, src.air3, user)

/obj/machinery/atmospherics/component/quaternary/atmos_filter/atmosanalyze(mob/user)
	return atmosanalyzer_scan(src, src.input.air, user)

/obj/machinery/atmospherics/component/quaternary/mixer/atmosanalyze(mob/user)
	return atmosanalyzer_scan(src, src.output.air, user)

/obj/machinery/meter/atmosanalyze(mob/user)
	var/datum/gas_mixture/mixture = null
	if(src.target)
		mixture = src.target.parent.air
	return atmosanalyzer_scan(src, mixture, user)

/obj/machinery/power/rad_collector/atmosanalyze(mob/user)
	if(P)	return atmosanalyzer_scan(src, src.P.air_contents, user)

/obj/item/flamethrower/atmosanalyze(mob/user)
	if(ptank)	return atmosanalyzer_scan(src, ptank.air_contents, user)
