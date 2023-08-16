/proc/generate_wiki_markup_for_reagents()
	var/list/built = list()
	// gather
	var/list/reagents_by_category = list()
	var/list/recipes_by_id = list()
	for(var/datum/chemical_reaction/reaction as anything in subtypesof(/datum/chemical_reaction))
		LAZYADD(recipes_by_id[reaction.result], new reaction)
	for(var/datum/reagent/path as anything in subtypesof(/datum/reagent))
		if(initial(path.abstract_type) == path)
			continue
		// todo: skip flag?
		LAZYADD(reagents_by_category[initial(path.wiki_category)], new path)
	// todo: styling for tables
	for(var/category in reagents_by_category)
		tim_sort(reagents_by_category[category], GLOBAL_PROC_REF(cmp_reagents_wiki))
		var/list/sub_built = list()
		sub_built += {"
			{| class="wikitable" style="margin: auto"
			|+ [category]
			|-
			! Name !! Desc !! Overdose / Addiction !!
		"}
		for(var/datum/reagent/R as anything in reagents_by_category[category])
			var/list/recipes = recipes_by_id[R.id]
			if(!length(recipes))
				// todo: flag check
				continue
			// todo: recipes :agony:
			var/overdose_text = R.overdose? "Overdose: [R.overdose]u" : "None"
			var/recipes_text = "WIP"
			sub_built += {"
				|-
				| [R.wiki_name || R.name] || [R.wiki_desc || R.description] || [overdose_text] || [recipes_text]
			"}
			// todo: handle recipes
		built += "## [category] <br><br>[jointext(sub_built, "")]"

	return "<pre>[jointext(built, "<br><br>")]</pre>"

/proc/browse_wiki_markup_for_reagents(mob/user = usr)
	user << browse("<html><head><title>Chemistry Wiki Generation</title></head><body>[generate_wiki_markup_for_reagents()]</body></html>", "window=chemwiki;display=1;size=600x600;can_close=1;can_resize=1;can_minimize=0;titlebar=1")

/proc/cmp_reagents_wiki(datum/reagent/A, datum/reagent/B)
	return (A.wiki_sort == B.wiki_sort)? (sorttext(B.name, A.name)) : (B.wiki_sort - A.wiki_sort)

// for reference below

/*
	{| class="wikitable" style="margin:auto"
	|+ Caption text
	|-
	! Header text !! Header text !! Header text
	|-
	| Example || Example || Example
	|-
	| Example || Example || Example
	|-
	| Example || Example || Example
|}
*/
