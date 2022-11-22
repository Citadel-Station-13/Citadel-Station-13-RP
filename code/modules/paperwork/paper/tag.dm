GLOBAL_LIST_INIT(single_paper_tags, single_paper_tags())
GLOBAL_LIST_INIT(paired_paper_tags, paired_paper_tags())
GLOBAL_LIST(paired_paper_tag_lookup)

/proc/single_paper_tags()
	. = list()
	for(var/path in subtypesof(/datum/paper_tag/single))
		var/datum/paper_tag/single/T = path
		if(initial(T.abstract_type) == path)
			continue
		. += new path

/proc/paired_paper_tags()
	. = list()
	GLOB.paired_paper_tag_lookup = list()
	for(var/path in subtypesof(/datum/paper_tag/paired))
		var/datum/paper_tag/paired/T = path
		if(initial(T.abstract_type) == path)
			continue
		T = new path
		. += T
		GLOB.paired_paper_tag_lookup[T.tagname] = T

/obj/item/paper/proc/parse_tags(str, mob/user, obj/item/pen/T)
	. = str
	//? parse single tags
	for(var/datum/paper_tag/single/tag as anything in GLOB.single_paper_tags)
		. = tag.transform_string(., user, src, T)
	//? parse paired tag via regex (uh oh overhead maybe we'll rust it someday)
	// simple parser for paired tags
	var/static/regex/R = regex("(\\\[/?\[a-z\]+=?\[a-z\]*\\\])")
	var/list/parsed = splittext_char(str, R)
	var/parsed_length = length(parsed)
	if(parsed_length == 1)
		return parsed[1]
	var/list/tags = list()
	var/list/params = list()
	for(var/i in 2 to parsed.len step 2)
		var/raw = parsed[i]
		var/closing = raw[2] == "/"
		var/param_index = findtext_char(raw, "=")
		var/found
		var/param
		// ignore param index if closing, don't put params in closing tags idiots
		if(!closing && param_index)
			found = copytext_char(raw, 2, param_index)
			param = copytext_char(raw, param_index + 1, -1)
		else
			found = copytext_char(raw, closing? 3 : 2, -1)
		var/datum/paper_tag/paired/PT = GLOB.paired_paper_tag_lookup[found]
		if(!PT)
			continue
		if(closing)
			var/first = tags.Find(found)
			if(!first)
				continue
			param = params[first]
			tags.Cut(first, first + 1)
			params.Cut(first, first + 1)
			parsed[i] = PT.replace_end(user, src, T, param)
		else
			tags += found
			params += param
			parsed[i] = PT.replace_start(user, src, T, param)
	//? auto close any open tags
	var/tags_length = length(tags)
	for(var/i in tags_length to 1 step -1)
		var/found = tags[i]
		var/param = params[i]
		var/datum/paper_tag/paired/PT = GLOB.paired_paper_tag_lookup[found]
		parsed += PT.replace_auto_close(user, src, T, param)
	return parsed.Join("")


/**
 * datumized paper tag system ~silicons
 *
 * ! And Now, For The Caveats !
 * - This is slow
 * - This is pretty terrible
 * - We're better off doing this in rust
 * - We'd just do markdown if our players wouldn't complain of lacking center tags
 * - We'll have to do javascript anyways for TGUI
 * ? Todo: LaTeX equation support
 * ? Todo: Better stamping
 *
 * For now, this is what you get.
 */
/datum/paper_tag
	var/abstract_type = /datum/paper_tag

/**
 * simple macros
 */
/datum/paper_tag/single
	abstract_type = /datum/paper_tag/single
	var/tagname
	var/cached_replace_query

/datum/paper_tag/single/New()
	cached_replace_query = "\[[tagname]\]"

/**
 * user can be null
 * P can be null
 * T can be null
 */
/datum/paper_tag/single/proc/transform_string(str, mob/user, obj/item/paper/P, obj/item/pen/T)
	return str

/**
 * user can be null
 * P can be null
 * T can be null
 */
/datum/paper_tag/single/proc/replace_with(mob/user, obj/item/paper/P, obj/item/pen/T)
	return ""

/datum/paper_tag/single/transform_string(str, mob/user, obj/item/paper/P, obj/item/pen/T)
	return replacetext(str, cached_replace_query, replace_with(user, P, T))

/datum/paper_tag/single/current_time
	tagname = "time"

/datum/paper_tag/single/current_time/replace_with(mob/user, obj/item/paper/P, obj/item/pen/T)
	return stationtime2text()

/datum/paper_tag/single/current_date
	tagname = "date"

/datum/paper_tag/single/current_date/replace_with(mob/user, obj/item/paper/P, obj/item/pen/T)
	return stationdate2text()

/datum/paper_tag/single/current_map
	tagname = "station"

/datum/paper_tag/single/current_map/replace_with(mob/user, obj/item/paper/P, obj/item/pen/T)
	return GLOB.using_map.station_name

//? todo: [station_controller]

/**
 * paired paper tags
 * supports a single parameter via =
 */
/datum/paper_tag/paired
	abstract_type = /datum/paper_tag/paired
	/// tag name; ending this tag should be a [/tagname].
	var/tagname

/datum/paper_tag/paired/proc/replace_start(mob/user, obj/item/paper/P, obj/item/pen/T, parameter)
	return ""

/datum/paper_tag/paired/proc/replace_end(mob/user, obj/item/paper/P, obj/item/pen/T, parameter)
	return ""

/datum/paper_tag/paired/proc/replace_auto_close(mob/user, obj/item/paper/P, obj/item/pen/T, parameter)
	return replace_end(user, P, T, parameter)

/datum/paper_tag/paired/bold
	tagname = "b"

/datum/paper_tag/paired/bold/replace_start(mob/user, obj/item/paper/P, obj/item/pen/T, parameter)
	return "<b>"

/datum/paper_tag/paired/bold/replace_end(mob/user, obj/item/paper/P, obj/item/pen/T, parameter)
	return "</b>"
