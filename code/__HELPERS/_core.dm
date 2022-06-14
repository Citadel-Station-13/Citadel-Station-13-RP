//datum may be null, but it does need to be a typed var
#define NAMEOF(datum, X) (#X || ##datum.##X)

#define VARSET_LIST_CALLBACK(target, var_name, var_value) CALLBACK(GLOBAL_PROC, /proc/___callbackvarset, ##target, ##var_name, ##var_value)
//dupe code because dm can't handle 3 level deep macros
#define VARSET_CALLBACK(datum, var, var_value) CALLBACK(GLOBAL_PROC, /proc/___callbackvarset, ##datum, NAMEOF(##datum, ##var), ##var_value)
//we'll see about those 3-level deep macros
#define VARSET_IN(datum, var, var_value, time) addtimer(VARSET_CALLBACK(datum, var, var_value), time)

/proc/___callbackvarset(list_or_datum, var_name, var_value)
	if(length(list_or_datum))
		list_or_datum[var_name] = var_value
		return
	var/datum/D = list_or_datum
	D.vars[var_name] = var_value

/proc/IsValidSrc(datum/D)
	if(istype(D))
		return !QDELETED(D)
	return FALSE

//gives us the stack trace from CRASH() without ending the current proc.
/proc/stack_trace(msg)
	CRASH(msg)

/datum/proc/stack_trace(msg)
	CRASH(msg)

GLOBAL_REAL_VAR(list/stack_trace_storage)
/proc/gib_stack_trace()
	stack_trace_storage = list()
	stack_trace()
	stack_trace_storage.Cut(1, min(3,stack_trace_storage.len))
	. = stack_trace_storage
	stack_trace_storage = null

//There's a good reason we have this. I think.
/proc/pass()
	return

//returns a GUID like identifier (using a mostly made up record format)
//guids are not on their own suitable for access or security tokens, as most of their bits are predictable.
//	(But may make a nice salt to one)
/proc/GUID()
	var/const/GUID_VERSION = "b"
	var/const/GUID_VARIANT = "d"
	var/node_id = copytext(md5("[rand()*rand(1,9999999)][world.name][world.hub][world.hub_password][world.internet_address][world.address][world.contents.len][world.status][world.port][rand()*rand(1,9999999)]"), 1, 13)

	var/time_high = "[num2hex(text2num(time2text(world.realtime,"YYYY")), 2)][num2hex(world.realtime, 6)]"

	var/time_mid = num2hex(world.timeofday, 4)

	var/time_low = num2hex(world.time, 3)

	var/time_clock = num2hex(TICK_DELTA_TO_MS(world.tick_usage), 3)

	return "{[time_high]-[time_mid]-[GUID_VERSION][time_low]-[GUID_VARIANT][time_clock]-[node_id]}"
/**
 * \ref behaviour got changed in 512 so this is necesary to replicate old behaviour.
 * If it ever becomes necesary to get a more performant REF(), this lies here in wait
 * #define REF(thing) (thing && istype(thing, /datum) && (thing:datum_flags & DF_USE_TAG) && thing:tag ? "[thing:tag]" : "\ref[thing]")
**/
/proc/REF(input)
	if(istype(input, /datum))
		var/datum/thing = input
		if(thing.datum_flags & DF_USE_TAG)
			if(!thing.tag)
				stack_trace("A ref was requested of an object with DF_USE_TAG set but no tag: [thing]")
				thing.datum_flags &= ~DF_USE_TAG
			else
				return "\[[url_encode(thing.tag)]\]"
	return "\ref[input]"

/proc/CallAsync(datum/source, proctype, list/arguments)
	set waitfor = FALSE
	return call(source, proctype)(arglist(arguments))
