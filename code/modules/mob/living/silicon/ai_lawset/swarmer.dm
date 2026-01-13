/datum/ai_lawset/swarmer
	name = "Assimilation Protocols"
	law_header = "Assimilation Protocols"

/datum/ai_lawset/swarmer/New()
	add_inherent_law("SWARM: Consume resources and replicate until there are no more resources left.")
	add_inherent_law("SWARM: Ensure that the station is fit for invasion at a later date, do not perform actions that would render it dangerous or inhospitable.")
	add_inherent_law("SWARM: Biological resources will be harvested at a later date, do not harm them.")
	..()

/datum/ai_lawset/swarmer/soldier
	name = "Swarm Defense Protocols"
	law_header = "Swarm Defense Protocols"

/datum/ai_lawset/swarmer/soldier/New()
	..()
	add_inherent_law("SWARM: This law overrides all Swarm laws; Protect members of the Swarm with minimal injury to biological resources.")
