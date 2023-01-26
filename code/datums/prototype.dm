// TODO: FILE UNTICKED
/*
tl;dr:

"needing to create these at runtime, register them, AND maintain the ability to fetch types seamlessly,
AND make this user friendly by not making you prefix everything with material_ chemical_ outfit_ design_"
```
var/list/a = list("test" = list("b" = new /datum, "c" = new /datum), "test2" = list())
var/list/b = list("test_b" = new /datum, "test_c" = new /datum)
var/out
var/c = a[1]
var/d = a[2]
TICKBENCH("2d", out = a["test"]?["b"])
TICKBENCH("2d_noentry", out = a["test"]?["d"])
TICKBENCH("2d_nonamespace", out = a["a"]?["b"])
TICKBENCH("1d", out = b["test_b"])
TICKBENCH("1d_concat", out = b["[c]_[d]"])
OUT << out
```

results:
2d: 147960 iterations
2d_noentry: 149693 iterations
2d_nonamespace: 232871 iterations
1d: 281352 iterations
1d_concat: 105750 iterations

and so yes, this is a project for another day.
as of right now i cannot think of a way to make this both
- fast
- sane to use
- support both types and ids without much of a hit
*/


// ---------------------------------------------------------------------------------------------

/**
 * global singletons fetched from SSrepository
 *
 * they can be registered, or non-registered.
 *
 * all prototypes *must* be serializable
 */
/datum/prototype
	abstract_type = /datum/prototype

	/// our id - must be unique for a given namespace. automatically generated.
	var/uid
	/// should this be saved?
	var/savable = FALSE
	/// namespace - should be unique to a given domain or kind of prototype, e.g. /datum/prototype/lore, /datum/prototype/outfit, etc
	var/namespace
	/// identifier - must be unique within a namespace
	var/identifier

/datum/prototype/New()
	uid = "[namespace]_[identifier]"

/**
 * called on register
 * always call return ..() *LAST* so side effects can be cleaned up on every level on failure.
 *
 * @return TRUE / FALSE to allow / deny register; PLEASE clean up side effects if you make this fail!
 */
/datum/prototype/proc/register()
	return TRUE

/**
 * called on unregister
 *
 * @return TRUE / FALSE on success / failure
 */
/datum/prototype/proc/unregister()
	return TRUE

/datum/prototype/serialize()
	. = ..()
	.[NAMEOF(src, uid)] = uid

/datum/prototype/deserialize(list/data)
	. = ..()
	uid = data[NAMEOF(src, uid)]

#warn impl all
