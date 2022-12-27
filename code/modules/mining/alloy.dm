// not on SSmaterials yet because i'm a stubborn goat and
// refuse to invest in nebula materials just yet

// :/ sorry gamers
// todo: for /datum/design redo, maybe we can have fabricators that can auto-alloy some of these?
// todo: would be interesting.

// we really should mat it sometime or find a way to do dynamic alloys tho..

GLOBAL_LIST_INIT(ore_alloy_recipes, ore_alloy_recipes())

/proc/ore_alloy_recipes()
	var/list/recipes = list()
	for(var/path in subtypesof(/datum/alloy))
		var/datum/alloy/A = path
		if(initial(A.abstract_type) == path)
			continue
		recipes += new path
	// why do we sort?
	// so less complex alloys don't prioritize over MORE complex alloys
	// which, duh, would be a problem.
	tim_sort(recipes, /proc/cmp_alloy_complexity)
	return recipes

/proc/cmp_alloy_complexity(datum/alloy/A, datum/alloy/B)
	return length(B.requires) - length(A.requires)

/proc/inject_dynamic_alloy(datum/alloy/injecting)
	for(var/i in 1 to length(GLOB.ore_alloy_recipes))
		var/datum/alloy/other = GLOB.ore_alloy_recipes[i]
		if(length(other.requires) > length(injecting.requires))
			continue
		GLOB.ore_alloy_recipes.Insert(i, injecting)
		return
	GLOB.ore_alloy_recipes += injecting

/**
 * lookup alloy - typepath or id
 */
/proc/alloy_lookup(list/materials)
	#warn impl

// the above procs are shitcode, but it works until proper material recipes
// sue me :/
// no, we don't have ids yet; again, this is shitcode, i apologize.

/datum/alloy
	abstract_type = /datum/alloy
	/// name of alloy
	var/name
	/// product - material typepath or id, sorry no arbitrary items no you can't alloy diamonds into a banana cream pie.
	var/product
	/// requirements - material typepaths or ids; defaults to 1
	var/list/requires
	/// product multiplier of *total*; requires (3 steel + 1 carbon) * mod 1 = 4
	var/multiplier = 1

/datum/alloy/New()
	#warn impl resolve to id & default 1

//? steels

/**
 * relatively common and good alloy
 */
/datum/alloy/steel
	name = "steel"
	requires = list(
		/datum/material/iron = 5,
		/datum/material/carbon = 1,
	)
	product = /datum/material/steel
	// carbon is relatively consumed
	multiplier = 3 / 4

/**
 * semi common and decent alloy
 */
/datum/alloy/plasteel
	name = "plasteel"
	requires = list(
		/datum/material/iron = 4,
		/datum/material/platinum = 1,
		/datum/material/carbon = 1,
	)
	product = /datum/material/plasteel
	// carbon/platinum embedded in lattice
	multiplier = 4 / 6

/**
 * extremely strong and expensive alloy
 */
/datum/alloy/durasteel
	name = "durasteel"
	requires = list(
		/datum/material/iron = 3,
		/datum/material/diamond = 1,
		/datum/material/platinum = 2,
		/datum/material/carbon = 2,
	)
	product = /datum/material/durasteel
	// diamond/platinum/carbon relatively consumed
	multiplier = 3 / 6

//? silicates

/**
 * very strong glass
 */
/datum/alloy/borosilicate
	name = "borosillicate glass"
	requires = list(
		/datum/material/glass = 5,
		/datum/material/platinum = 1,
	)
	product = /datum/material/glass/phoron
	// platinum embedded
	multiplier = 5 / 6

//? tin / copper / zinc

/**
 * brass c:
 */
/datum/alloy/brass
	name = "brass"
	requires = list(
		/datum/material/copper = 1,
		/datum/material/glass = 1,
	)
	product = /datum/material/brass
