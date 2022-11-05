//! This file is WIP and currently unused.
/**
 * yaml prototype loader, now with blackjack and hookers
 *
 * someone from ss14 come put me out of my misery please
 */
SUBSYSTEM_DEF(prototypes)
	name = "Prototypes"
	init_order = INIT_ORDER_PROTOTYPES
	subsystem_flags = SS_NO_FIRE

	/// prototype cache
	var/list/prototypes

/datum/controller/subsystem/prototypes/Initialize()
	Reload()
	return ..()

/datum/controller/subsystem/prototypes/Recover()
	Reload()
	return ..()

/datum/controller/subsystem/prototypes/proc/Reload()
	subsystem_log("reloading...")
	prototypes = list()
	var/list/walking = list("prototypes/")
	for(var/dir in walking)
		var/list/files = flist(dir)
		for(var/path in files)
			if(path[length(path)] == "/")
				walking += dir + path
			else
				Load(dir + path)

/datum/controller/subsystem/prototypes/proc/Load(fname)
	if(!fexists(fname))
		CRASH("failed to load filename [fname]")
	var/yaml = file2text(file(fname))
	var/list/L = yaml_decode(yaml)
	subsystem_log("loading [fname]")

/datum/controller/subsystem/prototypes/proc/Type(t)
	switch(t)
		if(YAML_PROTOTYPE_LORE)
			return /datum/prototype/lore
		if(YAML_PROTOTYPE_DUD)
			return /datum/prototype/dud

/datum/controller/subsystem/prototypes/proc/Resolve(domain, id)
	return prototypes[domain]?[id]
