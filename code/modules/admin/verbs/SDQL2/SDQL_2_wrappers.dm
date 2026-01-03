// Wrappers for BYOND default procs which can't directly be called by call().

/proc/_abs(A)
	return abs(A)

/proc/_animate(atom/target, set_vars, time = 10, loop = 1, easing = LINEAR_EASING, flags = null)
	var/mutable_appearance/MA = new()
	// mutable appearance is not FLOAT_PLANE by default
	MA.plane = FLOAT_PLANE
	for(var/v in set_vars)
		MA.vars[v] = set_vars[v]

	if(target)
		animate(target, appearance = MA, time, loop, easing, flags)
	else
		animate(appearance = MA, time, easing = easing, flags)

/proc/_arccos(A)
	return arccos(A)

/proc/_arcsin(A)
	return arcsin(A)

/proc/_ascii2text(A)
	return ascii2text(A)

/proc/_block(Start, End)
	return block(Start, End)

/proc/_ckey(Key)
	return ckey(Key)

/proc/_ckeyEx(Key)
	return ckeyEx(Key)

/proc/_copytext(T, Start = 1, End = 0)
	return copytext(T, Start, End)

/proc/_cos(X)
	return cos(X)

/proc/_findtext(Haystack, Needle, Start = 1, End = 0)
	return findtext(Haystack, Needle, Start, End)

/proc/_findtextEx(Haystack, Needle, Start = 1, End = 0)
	return findtextEx(Haystack, Needle, Start, End)

/proc/_flick(Icon, Object)
	flick(Icon, Object)

/proc/_get_dir(Loc1, Loc2)
	return get_dir(Loc1, Loc2)

/proc/_get_dist(Loc1, Loc2)
	return get_dist(Loc1, Loc2)

/proc/_get_step(Ref, Dir)
	return get_step(Ref, Dir)

/proc/_hascall(object, procname)
	return hascall(object, procname)

/proc/_hearers(Depth = world.view, Center = usr)
	return hearers(Depth, Center)

/proc/_image(icon, loc, icon_state, layer, dir)
	return image(icon, loc, icon_state, layer, dir)

/proc/_istype(object, type)
	return istype(object, type)

/proc/_ispath(path, type)
	if(isnull(type))
		return ispath(path)
	return ispath(path, type)

/proc/_json_encode(list/L)
	return json_encode(L)

/proc/_json_decode(json)
	return json_decode(json)

/proc/_length(E)
	return length(E)

/proc/_link(thing, url)
	thing << link(url)

/proc/_locate(X, Y, Z)
	if (isnull(Y)) // Assuming that it's only a single-argument call.
		// direct ref locate
		var/datum/D = locate(X)
		// &&'s to last value
		return istype(D) && D.can_vv_mark() && D

	return locate(X, Y, Z)

/proc/_log(X, Y)
	return log(X, Y)

/proc/_uppertext(T)
	return uppertext(T)

/proc/_LOWER_TEXT(T)
	return LOWER_TEXT(T)

/proc/_matrix(a, b, c, d, e, f)
	return matrix(a, b, c, d, e, f)

/proc/_max(...)
	return max(arglist(args))

/proc/_md5(T)
	return md5(T)

/proc/_min(...)
	return min(arglist(args))

/proc/_new(type, arguments)
	var/datum/result

	if(!length(arguments))
		result = new type()
	else
		result = new type(arglist(arguments))

	if(istype(result))
		result.datum_flags |= DF_VAR_EDITED
	return result

/proc/_num2text(N, SigFig = 6)
	return num2text(N, SigFig)

/proc/_text2num(T)
	return text2num(T)

/proc/_ohearers(Dist, Center = usr)
	return ohearers(Dist, Center)

/proc/_orange(Dist, Center = usr)
	return orange(Dist, Center)

/proc/_output(thing, msg, control)
	thing << output(msg, control)

/proc/_oview(Dist, Center = usr)
	return oview(Dist, Center)

/proc/_oviewers(Dist, Center = usr)
	return oviewers(Dist, Center)

/proc/_params2list(Params)
	return params2list(Params)

/proc/_pick(...)
	return pick(arglist(args))

/// Allow me to explain
/// for some reason, if pick() is passed arglist(args) directly and args contains only one list
/// it considers it to be a list of lists
/// this means something like _pick(list) would fail
/// need to do this instead
///
/// I hate this timeline
/proc/_pick_list(list/pick_from)
	return pick(pick_from)

/proc/_prob(P)
	return prob(P)

/proc/_rand(L = 0, H = 1)
	return rand(L, H)

/proc/_range(Dist, Center = usr)
	return range(Dist, Center)

/proc/_rect_turfs(H_Radius = 0, V_Radius = 0, atom/Center)
	return RECT_TURFS(H_Radius, V_Radius, Center)

/proc/_regex(pattern, flags)
	return regex(pattern, flags)

/proc/_REGEX_QUOTE(text)
	return REGEX_QUOTE(text)

/proc/_REGEX_QUOTE_REPLACEMENT(text)
	return REGEX_QUOTE_REPLACEMENT(text)

/proc/_replacetext(Haystack, Needle, Replacement, Start = 1,End = 0)
	return replacetext(Haystack, Needle, Replacement, Start, End)

/proc/_replacetextEx(Haystack, Needle, Replacement, Start = 1,End = 0)
	return replacetextEx(Haystack, Needle, Replacement, Start, End)

/proc/_rgb(R, G, B)
	return rgb(R, G, B)

/proc/_rgba(R, G, B, A)
	return rgb(R, G, B, A)

/proc/_roll(dice)
	return roll(dice)

/proc/_round(A, B = 1)
	return round(A, B)

/proc/_sin(X)
	return sin(X)

/proc/_list2params(L)
	return list2params(L)

/proc/_list_construct(...)
	. = args.Copy()

/proc/_list_construct_assoc(...)
	. = list()
	for(var/i in 1 to (args.len - 1) step 2)
		.[args[i]] = args[i+1]

/proc/_list_add(list/L, ...)
	if (args.len < 2)
		return
	L += args.Copy(2)

/proc/_list_copy(list/L, Start = 1, End = 0)
	return L.Copy(Start, End)

/proc/_list_cut(list/L, Start = 1, End = 0)
	L.Cut(Start, End)

/proc/_list_find(list/L, Elem, Start = 1, End = 0)
	return L.Find(Elem, Start, End)

/proc/_list_insert(list/L, Index, Item)
	return L.Insert(Index, Item)

/proc/_list_join(list/L, Glue, Start = 0, End = 1)
	return L.Join(Glue, Start, End)

/proc/_list_remove(list/L, ...)
	if (args.len < 2)
		return
	L -= args.Copy(2)

/proc/_list_set(list/L, key, value)
	L[key] = value

/proc/_list_get(list/L, key)
	return L[key]

/proc/_list_numerical_add(L, key, num)
	L[key] += num

/proc/_list_swap(list/L, Index1, Index2)
	L.Swap(Index1, Index2)

/proc/_walk(ref, dir, lag)
	walk(ref, dir, lag)

/proc/_walk_towards(ref, trg, lag)
	walk_towards(ref, trg, lag)

/proc/_walk_to(ref, trg, min, lag)
	walk_to(ref, trg, min, lag)

/proc/_walk_away(ref, trg, max, lag)
	walk_away(ref, trg, max, lag)

/proc/_walk_rand(ref, lag)
	walk_rand(ref, lag)

/proc/_step(ref, dir)
	step(ref, dir)

/proc/_step_rand(ref)
	step_rand(ref)

/proc/_step_to(ref, trg, min)
	step_to(ref, trg, min)

/proc/_step_towards(ref, trg)
	step_towards(ref, trg)

/proc/_step_away(ref, trg, max)
	step_away(ref, trg, max)

/// Locating turfs
/proc/_turf_in_offset(s = usr, x = 0, y = 0, z = 0)
	var/turf/T = get_turf(s)
	return locate(clamp(T.x + x, 1, world.maxx), clamp(T.y + y, 1, world.maxy), clamp(T.z + z, 1, world.maxz))

/proc/_random_turf_in_range(s = usr, r = 7)
	return _turf_in_offset(s, rand(-r, r), rand(-r, r))

/proc/_random_turf_in_view(s = usr, r = 7)
	var/list/v = view(s, r)
	. = list()
	for(var/turf/T in v)
		. += T
	return pick(.)

/proc/_has_trait(datum/thing, trait)
	return HAS_TRAIT(thing, trait)

/proc/_add_trait(datum/thing, trait, source)
	ADD_TRAIT(thing, trait, source)

/proc/_remove_trait(datum/thing, trait, source)
	REMOVE_TRAIT(thing, trait, source)

/proc/_winset(player, control_id, params)
	winset(player, control_id, params)

/proc/_winget(player, control_id, params)
	return winget(player, control_id, params)

/proc/_text2path(text)
	return text2path(text)

/proc/_turn(dir, angle)
	return turn(dir, angle)

/proc/_view(Dist, Center = usr)
	return view(Dist, Center)

/proc/_viewers(Dist, Center = usr)
	return viewers(Dist, Center)

/proc/_filter(...)
	return filter(arglist(args))

/proc/_generator(type = "num", A = 0, B = 1, rand = UNIFORM_RAND)
	return generator(type, A, B, rand)

/proc/_is_type_in_typecache(thing_to_check, typecache)
	return is_type_in_typecache(thing_to_check, typecache)

/proc/_floor(a)
	return floor(a)

/proc/_ceil(a)
	return ceil(a)

/proc/_typesof(a, subtypes_only = FALSE)
	. = typesof(a)
	if(subtypes_only)
		. -= a

/proc/_html_encode(text)
	return html_encode(text)

/proc/_html_decode(text)
	return html_decode(text)

/proc/_url_encode(text)
	return url_encode(text)

/proc/_url_decode(text)
	return url_decode(text)

/proc/__nan()
	var/list/L = json_decode("{\"value\":NaN}")
	return L["value"]

/**
 * Wrapper to return a copy of contents, as SDQL2 can't tell an internal list from a normal list.
 */
/atom/proc/_contents()
	return contents.Copy()
