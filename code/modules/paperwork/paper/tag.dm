GLOBAL_LIST_INIT(paper_tags, paper_tags())

/proc/paper_tags()
	. = list()
	for(var/path in subtypesof(/datum/paper_tag))
		var/datum/paper_tag/T = path
		if(initial(T.abstract_type) == path)
			continue
		. += new path

/obj/item/paper/proc/parse_tags(str, mob/user, obj/item/pen/T)
	. = str
	for(var/datum/paper_tag/tag as anything in GLOB.paper_tags)
		. = tag.transform_string(., user, src, T)

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
 * user can be null
 * P can be null
 * T can be null
 */
/datum/paper_tag/proc/transform_string(str, mob/user, obj/item/paper/P, obj/item/pen/T)
	return str

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

/datum/paper_tag/single/current_date/replace_with(mob/user, obj/item/paper/P, obj/item/pen/T)
	return GLOB.using_map.name
